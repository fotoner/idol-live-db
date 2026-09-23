"""tools/test の共通の下ごしらえ。

    python3 -m unittest discover -s tools/test -p 'test_*.py'

テストは一時ディレクトリと一時 DB だけを触る。手元の master.sqlite・db/master.sql・
data/ は読むだけで、書き換えない。外部への通信もしない。
"""

import os
import sqlite3
import sys
from pathlib import Path

TOOLS = Path(__file__).resolve().parent.parent
REPO = TOOLS.parent
MASTER_SQL = REPO / "db" / "master.sql"

if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

_master_text = None


def master_sql_text():
    global _master_text
    if _master_text is None:
        _master_text = MASTER_SQL.read_text(encoding="utf-8")
    return _master_text


def restore_master(path):
    """db/master.sql を丸ごと入れた DB を path に作る。"""
    conn = sqlite3.connect(str(path))
    conn.executescript(master_sql_text())
    conn.close()


def schema_only(path):
    """db/master.sql と同じ表と索引だけを持つ、空の DB を path に作る。"""
    src = sqlite3.connect(":memory:")
    src.executescript(master_sql_text())
    ddl = [sql for (sql,) in src.execute(
        "SELECT sql FROM sqlite_master WHERE sql IS NOT NULL"
        " ORDER BY CASE type WHEN 'table' THEN 0 ELSE 1 END, rowid")]
    src.close()
    conn = sqlite3.connect(str(path))
    for sql in ddl:
        conn.execute(sql)
    conn.commit()
    conn.close()


def write_json(path, obj):
    import json
    os.makedirs(os.path.dirname(str(path)), exist_ok=True)
    with open(str(path), "w", encoding="utf-8") as f:
        json.dump(obj, f, ensure_ascii=False)
