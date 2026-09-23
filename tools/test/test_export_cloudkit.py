"""export_cloudkit.py の refresh_table のテスト (CloudKit の読み取りは偽物に差し替える)。

    python3 -m unittest discover -s tools/test -p 'test_*.py'
"""

import contextlib
import io
import sqlite3
import tempfile
import unittest
from pathlib import Path

import support
import export_cloudkit


def brand_record(i, name=True):
    fields = {"shortName": {"value": "B%d" % i}, "sortOrder": {"value": i}}
    if name:
        fields["name"] = {"value": "ブランド%d" % i}
    return {"recordName": "b%02d" % i, "recordType": "Brand", "fields": fields}


class RefreshTableTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        path = Path(self.tmp.name) / "m.sqlite"
        support.schema_only(path)
        self.conn = sqlite3.connect(str(path))
        self.cloudkit = {}
        saved = export_cloudkit.query_all
        self.addCleanup(setattr, export_cloudkit, "query_all", saved)
        export_cloudkit.query_all = lambda record_type: self.cloudkit.get(record_type, [])

    def tearDown(self):
        self.conn.close()
        self.tmp.cleanup()

    def given_local_brands(self, n):
        self.conn.executemany(
            "INSERT INTO brands (id, name, short_name, sort_order) VALUES (?, ?, ?, ?)",
            [("b%02d" % i, "ブランド%d" % i, "B%d" % i, i) for i in range(n)])

    def refresh(self):
        with contextlib.redirect_stdout(io.StringIO()) as out, \
                contextlib.redirect_stderr(io.StringIO()) as err:
            inserted = export_cloudkit.refresh_table(self.conn, "brands")
        return inserted, out.getvalue() + err.getvalue()

    def brand_ids(self):
        return [r[0] for r in self.conn.execute("SELECT id FROM brands ORDER BY id")]

    def test_every_dropped_row_is_listed(self):
        # name が無いレコードは NOT NULL で入らない。先頭 5 件だけでなく全部を出す。
        self.cloudkit["Brand"] = [brand_record(i, name=(i >= 7)) for i in range(9)]
        inserted, log = self.refresh()
        self.assertEqual(inserted, 2)
        for i in range(7):
            self.assertIn("b%02d" % i, log)

    def test_warns_when_a_table_empties(self):
        self.given_local_brands(3)
        inserted, log = self.refresh()
        self.assertEqual(inserted, 0)
        self.assertIn("brands: 3 行 → 0 行", log)

    def test_warns_when_a_table_shrinks_a_lot(self):
        self.given_local_brands(20)
        self.cloudkit["Brand"] = [brand_record(i) for i in range(17)]
        _, log = self.refresh()
        self.assertIn("brands: 20 行 → 17 行", log)

    def test_small_shrink_is_not_warned(self):
        self.given_local_brands(20)
        self.cloudkit["Brand"] = [brand_record(i) for i in range(19)]
        _, log = self.refresh()
        self.assertNotIn("行 → ", log)

    def test_replaces_the_table_with_cloudkit(self):
        # 書き込み先と中身の入れ替え方は変えない (表を丸ごと CloudKit の分に置き換える)。
        self.given_local_brands(2)
        self.cloudkit["Brand"] = [brand_record(i) for i in range(1, 4)]
        inserted, _ = self.refresh()
        self.assertEqual(inserted, 3)
        self.assertEqual(self.brand_ids(), ["b01", "b02", "b03"])


if __name__ == "__main__":
    unittest.main()
