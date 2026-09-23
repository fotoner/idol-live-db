#!/usr/bin/env python3
"""tools/cloudkit_schema.ckdb の変更が「CloudKit へ安全に流せる形か」を確かめる。

    python3 tools/check_ckdb_schema.py                       # 構文だけ見る
    python3 tools/check_ckdb_schema.py --base origin/develop # 基準との差分も見る

CloudKit の Production スキーマは**足すことしかできない** (型や列は一度昇格すると消せない)。
だから PR の段階で「消す・型を変える」を落とし、オーナーが Dashboard で昇格するときに
迷わないようにする。鍵も cktool も要らないので、コントリビューターの手元と CI の両方で回る。

見ること:
  - RECORD TYPE の二重定義が無い (2026-09-13 まで validate も import も通らない状態が放置された)
  - 基準から record type / 列が消えていない、列の型が変わっていない
  - 既存列のインデックス (QUERYABLE 等) が外れていない (差分同期が全件失敗する)
  - 新しい record type が modifiedAt / deletedAt を正しいインデックスで持つ
    (ImasLiveDB/Services/README_CloudKit_Schema.md)

`--summary <path>` を付けると、オーナーがマージ後にやる手順を Markdown で書き出す
(GitHub Actions の job summary 用)。
"""

import argparse
import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, NamedTuple, Optional, Tuple

REPO = Path(__file__).resolve().parent.parent
CKDB_REL = "tools/cloudkit_schema.ckdb"

# 全 record type が持つべき運用列とインデックス (差分同期・soft delete に要る)。
REQUIRED_FIELDS = {
    "modifiedAt": ("TIMESTAMP", {"QUERYABLE", "SORTABLE"}),
    "deletedAt": ("TIMESTAMP", {"QUERYABLE"}),
}
# アプリが自前で持たない、CloudKit 標準の型 (必須列の検査から外す)。
SYSTEM_TYPES = {"Users"}

_TYPE_RE = re.compile(r"^\s*RECORD TYPE\s+(\w+)\s*\((.*?)\n\s*\);", re.S | re.M)
_FIELD_RE = re.compile(r'^\s*("?[\w]+"?)\s+([A-Z0-9_]+(?:<[A-Z0-9_]+>)?)((?:\s+[A-Z]+)*)\s*,?\s*$')


class Field(NamedTuple):
    type: str
    indexes: frozenset


Schema = Dict[str, Dict[str, Field]]


def parse(text: str) -> Tuple[Schema, List[str]]:
    """ckdb の本文から {record type: {列名: Field}} と、二重定義された型名を返す。"""
    schema: Schema = {}
    duplicates: List[str] = []
    for m in _TYPE_RE.finditer(text):
        name, body = m.group(1), m.group(2)
        if name in schema:
            duplicates.append(name)
        fields: Dict[str, Field] = {}
        for line in body.splitlines():
            if not line.strip() or line.strip().startswith("GRANT"):
                continue
            fm = _FIELD_RE.match(line)
            if not fm:
                continue
            col = fm.group(1).strip('"')
            fields[col] = Field(fm.group(2), frozenset(fm.group(3).split()))
        schema[name] = fields
    return schema, duplicates


def check(new: Schema, duplicates: List[str], base: Optional[Schema]) -> Tuple[List[str], List[str]]:
    """(エラー, 追加された項目) を返す。エラーが空なら安全に流せる。"""
    errors: List[str] = []
    added: List[str] = []

    for name in duplicates:
        errors.append(f"RECORD TYPE {name} が 2 回定義されている (cktool の validate / import が通らない)")

    for name, fields in new.items():
        if name in SYSTEM_TYPES or (base is not None and name in base):
            continue
        for col, (typ, need) in REQUIRED_FIELDS.items():
            f = fields.get(col)
            if f is None or f.type != typ or not need <= f.indexes:
                errors.append(
                    f"新しい RECORD TYPE {name} に `{col} {typ} {' '.join(sorted(need))}` が無い"
                    " (差分同期が全件失敗する)"
                )

    if base is None:
        return errors, added

    for name, base_fields in base.items():
        if name not in new:
            errors.append(f"RECORD TYPE {name} が消えている (Production では型を消せない)")
            continue
        for col, bf in base_fields.items():
            nf = new[name].get(col)
            if nf is None:
                errors.append(f"{name}.{col} が消えている (Production では列を消せない)")
            elif nf.type != bf.type:
                errors.append(f"{name}.{col} の型が {bf.type} → {nf.type} に変わっている (型は変えられない。別名で列を足す)")
            elif not bf.indexes <= nf.indexes:
                lost = " ".join(sorted(bf.indexes - nf.indexes))
                errors.append(f"{name}.{col} から {lost} が外れている (既存の検索・同期が壊れる)")

    for name, fields in new.items():
        if name not in base:
            added.append(f"RECORD TYPE `{name}` (新規)")
            continue
        for col, f in fields.items():
            bf = base[name].get(col)
            if bf is None:
                idx = " ".join(sorted(f.indexes))
                added.append(f"`{name}.{col}` {f.type} {idx}".rstrip())
            elif f.indexes != bf.indexes:
                idx = " ".join(sorted(f.indexes - bf.indexes))
                added.append(f"`{name}.{col}` にインデックス {idx} を追加")
    return errors, added


def read_base(ref: str) -> Optional[str]:
    """git の ref から ckdb を読む。その ref に無ければ None (新規ファイル扱い)。"""
    r = subprocess.run(
        ["git", "show", f"{ref}:{CKDB_REL}"], cwd=REPO, capture_output=True, text=True
    )
    if r.returncode != 0:
        if "does not exist" in r.stderr or "exists on disk, but not in" in r.stderr:
            return None
        raise SystemExit(f"Error: {ref} の {CKDB_REL} を読めない: {r.stderr.strip()}")
    return r.stdout


def summary_markdown(errors: List[str], added: List[str]) -> str:
    lines = ["## CloudKit スキーマの変更", ""]
    if errors:
        lines += ["### ❌ このままでは CloudKit へ流せません", ""]
        lines += [f"- {e}" for e in errors]
        lines += ["", "Production のスキーマは**足すことしかできません**。消したい列は残したまま使わなくし、"
                  "型を変えたいときは別名の列を足してください。", ""]
    if added:
        lines += ["### 追加される項目", ""] + [f"- {a}" for a in added] + [""]
        lines += [
            "### マージ後にオーナーがやること",
            "",
            "1. `xcrun cktool export-schema` で Development の現状を取り、PR 版の ckdb との差がこの PR の追加分だけか確かめる"
            " (Development 側にしか無い変更を import で落とさないため)",
            "2. `xcrun cktool validate-schema --file tools/cloudkit_schema.ckdb`",
            "3. `xcrun cktool import-schema --file tools/cloudkit_schema.ckdb` (Development)",
            "4. CloudKit Dashboard → **Deploy Schema Changes** で Production へ昇格",
            "5. そのあとで新しい列を使うデータを `apply_data.py --push` する (昇格前だと弾かれる)",
            "",
            "詳しくは `docs/DATA_PIPELINE.md` の「スキーマを足した場合」。",
        ]
    elif not errors:
        lines += ["CloudKit 側でやることはありません (追加項目なし)。"]
    return "\n".join(lines) + "\n"


def main(argv: Optional[List[str]] = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--base", help="比べる git ref (例: origin/develop)。省略時は構文だけ見る")
    ap.add_argument("--file", default=str(REPO / CKDB_REL), help="検査する ckdb")
    ap.add_argument("--summary", help="Markdown の要約を追記するファイル ($GITHUB_STEP_SUMMARY など)")
    args = ap.parse_args(argv)

    new, dups = parse(Path(args.file).read_text(encoding="utf-8"))
    base = None
    if args.base:
        base_text = read_base(args.base)
        base = parse(base_text)[0] if base_text is not None else None

    errors, added = check(new, dups, base)

    for a in added:
        print(f"+ {a}")
    for e in errors:
        print(f"✗ {e}", file=sys.stderr)
    if not errors:
        print(f"OK: {len(new)} record types" + (f", 追加 {len(added)} 件" if added else ""))

    if args.summary:
        with open(args.summary, "a", encoding="utf-8") as fh:
            fh.write(summary_markdown(errors, added))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
