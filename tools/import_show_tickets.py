#!/usr/bin/env python3
"""集めたチケット価格 (TSV) を db/master.sql と同梱 DB に入れる。

`data/tickets/README.md` の形式で書かれた TSV を読み、検査してから流す。
**検査に落ちた行は 1 行も入れない** — 価格表は「どんな券があったか」を答える
マスタなので、桁の打ち間違いが 1 件混ざると価格帯がまるごと嘘になる。

使い方:
    python3 tools/import_show_tickets.py data/tickets/prices_*.tsv          # 検査だけ
    python3 tools/import_show_tickets.py --apply data/tickets/prices_*.tsv  # 反映
"""

from __future__ import annotations

import argparse
import re
import sqlite3
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUNDLE_DB = ROOT / "ImasLiveDB/Resources/master.sqlite"
MASTER_SQL = ROOT / "db/master.sql"

KINDS = {"live", "stream", "live_viewing"}
# 1 枚 100 万円を超える券は無い (コアの validate_ticket と同じ上限)。
MAX_PRICE = 1_000_000


def slug(text: str) -> str:
    """id に使える形へ。日本語の券種名はそのままでは id に向かないので畳む。"""
    table = {
        "全席指定": "seat", "指定席": "seat", "アリーナ": "arena", "スタンド": "stand",
        "立見": "standing", "ステージサイド": "stageside", "見切れ": "restricted",
        "配信": "stream", "アーカイブ": "archive", "ライブビューイング": "lv",
        "一般": "general", "特典": "bonus", "前方": "front", "後方": "back",
    }
    out = text
    for ja, en in table.items():
        out = out.replace(ja, f"_{en}_")
    out = re.sub(r"[^A-Za-z0-9_]+", "_", out).strip("_").lower()
    return re.sub(r"_+", "_", out) or "ticket"


def load(paths: list[Path], known_shows: set[str]) -> tuple[list[tuple], list[str]]:
    rows: list[tuple] = []
    errors: list[str] = []
    seen: set[tuple[str, str, str]] = set()
    order: dict[tuple[str, str], int] = {}

    for path in paths:
        for lineno, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            line = raw.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split("\t")
            if len(parts) != 7:
                errors.append(f"{path.name}:{lineno} 列が {len(parts)} 個 (7 個必要)")
                continue
            show_id, kind, name, price_s, estimate_s, note, source = (p.strip() for p in parts)

            if show_id not in known_shows:
                errors.append(f"{path.name}:{lineno} 知らない公演 id: {show_id}")
                continue
            if kind not in KINDS:
                errors.append(f"{path.name}:{lineno} kind が {kind} ({'/'.join(sorted(KINDS))} のどれか)")
                continue
            if not name:
                errors.append(f"{path.name}:{lineno} 券種名が空")
                continue
            if not price_s.isdigit() or not (0 < int(price_s) <= MAX_PRICE):
                errors.append(f"{path.name}:{lineno} 価格が変: {price_s}")
                continue
            if estimate_s not in {"0", "1"}:
                errors.append(f"{path.name}:{lineno} is_estimate は 0 か 1: {estimate_s}")
                continue
            if not source.startswith("http"):
                errors.append(f"{path.name}:{lineno} 出典 URL が無い")
                continue

            key = (show_id, kind, name)
            if key in seen:
                errors.append(f"{path.name}:{lineno} 同じ公演に同じ券種が 2 回: {name}")
                continue
            seen.add(key)

            # 並び順は「公式の表記順 = ファイルに書かれた順」を形態ごとに振る。
            seq = order.get((show_id, kind), 0) + 1
            order[(show_id, kind)] = seq

            note_full = note if not source else (f"{note} / 出典: {source}" if note else f"出典: {source}")
            rows.append((
                f"tkt_{show_id}_{kind}_{slug(name)}"[:120],
                show_id, kind, name, int(price_s), int(estimate_s), note_full, seq,
            ))
    return rows, errors


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("paths", nargs="+", type=Path)
    ap.add_argument("--apply", action="store_true", help="検査を通ったら実際に入れる")
    args = ap.parse_args()

    with sqlite3.connect(BUNDLE_DB) as db:
        known = {r[0] for r in db.execute("SELECT id FROM shows")}

    rows, errors = load(args.paths, known)
    for e in errors:
        print(f"NG {e}", file=sys.stderr)
    print(f"読めた行: {len(rows)} / はじいた行: {len(errors)}")
    if errors:
        # 1 行でも変なら入れない。直してから通すこと。
        return 1
    if not args.apply:
        print("(--apply を付けると反映する)")
        return 0

    with sqlite3.connect(BUNDLE_DB) as db:
        db.executemany(
            "INSERT OR REPLACE INTO show_tickets "
            "(id, show_id, kind, name, price, is_estimate, note, sort_order) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            rows,
        )
    print(f"同梱 DB に {len(rows)} 行")

    def sql_literal(value) -> str:
        if isinstance(value, int):
            return str(value)
        return "'" + str(value).replace("'", "''") + "'"

    statements = "\n".join(
        "INSERT INTO show_tickets (id, show_id, kind, name, price, is_estimate, note, sort_order) "
        f"VALUES ({', '.join(sql_literal(v) for v in row)});"
        for row in rows
    )
    text = MASTER_SQL.read_text(encoding="utf-8")
    marker = "CREATE INDEX idx_show_tickets_show ON show_tickets(show_id);\n"
    head, sep, tail = text.partition(marker)
    # 既に入っている同じ id の行は書き換える (追記だけだと重複が増える)。
    kept = [l for l in tail.splitlines(keepends=True)
            if not any(l.startswith(f"INSERT INTO show_tickets (id, show_id, kind, name, price, is_estimate, note, sort_order) VALUES ('{r[0]}'") for r in rows)]
    MASTER_SQL.write_text(head + sep + statements + "\n" + "".join(kept), encoding="utf-8")
    print(f"db/master.sql に {len(rows)} 行")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
