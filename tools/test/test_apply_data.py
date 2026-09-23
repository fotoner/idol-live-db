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


COSTUME_POST = {"costumes": [{
    "id": "cos_t", "name": "テスト衣装", "brand_id": "ml",
    "source_url": "https://example.com/costume",
    "wears": [
        {"show_id": "sh_t", "setlist_item_id": "sh_t_0007", "idol_id": "ml_t"},
        {"show_id": "sh_t"},
    ],
}]}


class ApplyCostumesTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        root = Path(self.tmp.name)
        self.db = root / "m.sqlite"
        fixture_db(self.db)
        self.data = root / "data"
        support.write_json(self.data / "costumes" / "t.json", COSTUME_POST)
        self._saved = (apply_data.DATA_DIR, apply_data.ONLY_FILE)
        apply_data.DATA_DIR, apply_data.ONLY_FILE = self.data, None

    def tearDown(self):
        apply_data.DATA_DIR, apply_data.ONLY_FILE = self._saved
        self.tmp.cleanup()

    def connect(self):
        conn = sqlite3.connect(str(self.db))
        conn.execute("PRAGMA foreign_keys = ON")
        return conn

    def test_the_post_is_valid(self):
        conn = self.connect()
        self.assertEqual(apply_data.validate(conn), [])
        conn.close()

    def test_costumes_are_applied(self):
        conn = self.connect()
        affected = apply_data.apply_all(conn)
        wears = conn.execute(
            "SELECT setlist_item_id, idol_id, sort_order FROM costume_wears"
            " WHERE costume_id = 'cos_t' ORDER BY sort_order").fetchall()
        conn.close()
        # 曲の分かる記録はセトリの位置、分からない記録は末尾 (9999)。
        self.assertEqual(wears, [("sh_t_0007", "ml_t", 7), (None, None, 9999)])
        # 衣装の表は id で絞れないので、両方とも全件 push (空集合) になる。
        self.assertEqual(affected["costumes"], set())
        self.assertEqual(affected["costume_wears"], set())


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
