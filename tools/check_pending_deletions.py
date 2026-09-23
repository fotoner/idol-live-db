#!/usr/bin/env python3
"""CloudKit の削除待ち TSV が消化済みかを、読み取りだけで確かめる。

    CLOUDKIT_KEY_ID=... python3 tools/check_pending_deletions.py              # 全部 (Production)
    CLOUDKIT_KEY_ID=... python3 tools/check_pending_deletions.py tools/pending_cloudkit_deletions_x.tsv

TSV (tools/pending_cloudkit_deletions*.tsv) ごとに、レコードを CloudKit の records/lookup で
引き、生きている / soft delete 済み / 消えている (NOT_FOUND) の件数を数えて、台帳
(tools/cloudkit_deletion_ledger.tsv) の状態と比べる。**レコードは消さない。** 消すのは
seed_cloudkit.py --delete-file で、オーナーが行う。

鍵の ID は環境変数 CLOUDKIT_KEY_ID から読む (鍵のファイルは --key-file)。

終了コード: 台帳と合っていれば 0、食い違い (台帳に無い TSV・状態の違い) があれば 1、
鍵が無ければ 2。
"""
from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

from lib import cloudkit
from seed_cloudkit import DEFAULT_KEY_FILE, parse_delete_file

TOOLS_DIR = Path(__file__).resolve().parent
LEDGER = TOOLS_DIR / "cloudkit_deletion_ledger.tsv"
TSV_GLOB = "pending_cloudkit_deletions*.tsv"


def read_ledger(path: Path) -> dict:
    """ファイル名 → 台帳の 1 行 (列名 → 値)。"""
    lines = [ln for ln in path.read_text(encoding="utf-8").splitlines()
             if ln.strip() and not ln.startswith("#")]
    header = lines[0].split("\t")
    return {row["file"]: row for row in (dict(zip(header, ln.split("\t"))) for ln in lines[1:])}


def count(pairs: list, found: dict) -> dict:
    """TSV の 1 本ぶんを、生きている / soft delete 済み / 消えている に分けて数える。"""
    alive = soft = 0
    for _, name in pairs:
        record = found.get(name)
        if record is None or "serverErrorCode" in record:
            continue
        if cloudkit.is_soft_deleted(record):
            soft += 1
        else:
            alive += 1
    return {"total": len(pairs), "alive": alive, "soft_deleted": soft,
            "gone": len(pairs) - alive - soft}


def compare(name: str, counts: dict, ledger: dict) -> str | None:
    """台帳との食い違いを 1 行で返す (合っていれば None)。"""
    row = ledger.get(name)
    if row is None:
        return "台帳に無い (tools/cloudkit_deletion_ledger.tsv に 1 行足す)"
    if row["status"] == "done" and counts["alive"]:
        return f"台帳は done だが {counts['alive']} 件が生きている"
    if row["status"] == "pending" and not counts["alive"]:
        return "生きているものは無い。台帳を done にする"
    if row["status"] not in ("done", "pending"):
        return f"台帳の status が不正: {row['status']}"
    return None


def check(tsv_paths: list, ledger: dict, post, env: str) -> list:
    """TSV ごとの (名前, 件数, 食い違い) を返す。"""
    url = cloudkit.BASE_URL + cloudkit.records_path(env, "lookup")
    results = []
    for path in tsv_paths:
        pairs = parse_delete_file(path)
        found = cloudkit.lookup(url, [n for _, n in pairs], post, desired_keys=["deletedAt"])
        counts = count(pairs, found)
        results.append((path.name, counts, compare(path.name, counts, ledger)))
    return results


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="削除待ち TSV の消化状況を CloudKit から読み取りで数える")
    ap.add_argument("tsv", nargs="*", type=Path, help=f"見る TSV (既定: tools/{TSV_GLOB} の全部)")
    ap.add_argument("--environment", default="production", choices=["development", "production"])
    ap.add_argument("--key-file", type=Path, default=DEFAULT_KEY_FILE)
    ap.add_argument("--ledger", type=Path, default=LEDGER)
    args = ap.parse_args(argv)

    key_id = os.environ.get("CLOUDKIT_KEY_ID", "")
    if not key_id:
        print("Error: 環境変数 CLOUDKIT_KEY_ID が無い", file=sys.stderr)
        return 2
    signer = cloudkit.load_signer(key_id, args.key_file)
    tsv_paths = args.tsv or sorted(TOOLS_DIR.glob(TSV_GLOB))
    ledger = read_ledger(args.ledger)

    results = check(tsv_paths, ledger, lambda u, p: cloudkit.post_json(u, p, signer), args.environment)
    print(f"{'TSV':<66} {'件数':>6} {'生存':>6} {'soft':>5} {'消滅':>6}  台帳")
    for name, c, problem in results:
        status = ledger.get(name, {}).get("status", "-")
        print(f"{name:<66} {c['total']:>6} {c['alive']:>6} {c['soft_deleted']:>5} {c['gone']:>6}  {status}")
    names = {name for name, _, _ in results}
    missing = [] if args.tsv else sorted(set(ledger) - names)
    problems = [(name, p) for name, _, p in results if p] + [(n, "台帳にあるのに TSV が無い") for n in missing]
    for name, problem in problems:
        print(f"✗ {name}: {problem}", file=sys.stderr)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
