"""apply_data.py のテスト (一時 DB と一時の data/ だけを使う)。

    python3 -m unittest discover -s tools/test -p 'test_*.py'
"""

import sqlite3
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import support
import apply_data


def fixture_db(path):
    """衣装の投稿が指せる公演・曲・アイドルを 1 つずつ持つ空の DB。"""
    support.schema_only(path)
    conn = sqlite3.connect(str(path))
    conn.executescript("""
        INSERT INTO brands (id, name, short_name, sort_order) VALUES ('ml', 'ML', 'ML', 3);
        INSERT INTO idols (id, brand_id, name, sort_order) VALUES ('ml_t', 'ml', 'テスト', 3001);
        INSERT INTO songs (id, title, brand_id, song_type) VALUES ('song_t', '曲', 'ml', 'unit');
        INSERT INTO events (id, brand_id, name, event_type) VALUES ('ev_t', 'ml', '公演', 'live');
        INSERT INTO shows (id, event_id, name, date, sort_order) VALUES ('sh_t', 'ev_t', 'DAY1', '2026-01-01', 0);
        INSERT INTO setlist_items (id, show_id, song_id, position) VALUES ('sh_t_0007', 'sh_t', 'song_t', 7);
    """)
    conn.commit()
    conn.close()


class CheckWithoutThirdPartyModulesTest(unittest.TestCase):
    """--check は鍵も外部のライブラリも要らない (貢献者が手元で回す口)。"""

    def test_check_runs_under_python_dash_S(self):
        with tempfile.TemporaryDirectory() as tmp:
            db = Path(tmp) / "m.sqlite"
            fixture_db(db)
            # -S: site-packages を読まない (requests / ecdsa が無い環境と同じ)。
            proc = subprocess.run(
                [sys.executable, "-S", str(support.TOOLS / "apply_data.py"), "--check",
                 "--db", str(db), "--only", "no_such_file.json"],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        self.assertEqual(proc.returncode, 0, proc.stderr)
        self.assertIn("投入対象なし", proc.stdout)


if __name__ == "__main__":
    unittest.main()
