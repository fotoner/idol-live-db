"""check_ckdb_schema.py のテスト (git も CloudKit も触らない)。

    python3 -m unittest discover -s tools/test -p 'test_*.py'
"""

import unittest

import support  # noqa: F401  (tools/ を import パスに入れる)
import check_ckdb_schema as ccs

HEAD = "DEFINE SCHEMA\n\n"
BRAND = """
    RECORD TYPE Brand (
        "___createTime" TIMESTAMP,
        deletedAt       TIMESTAMP QUERYABLE SORTABLE,
        modifiedAt      TIMESTAMP QUERYABLE SORTABLE,
        name            STRING QUERYABLE SEARCHABLE SORTABLE,
        ids             LIST<INT64>,
        GRANT READ TO "_world"
    );
"""


def run(new_text, base_text=None):
    new, dups = ccs.parse(new_text)
    base = ccs.parse(base_text)[0] if base_text is not None else None
    return ccs.check(new, dups, base)


class ParseTest(unittest.TestCase):
    def test_reads_fields_types_and_indexes(self):
        schema, dups = ccs.parse(HEAD + BRAND)
        self.assertEqual(dups, [])
        self.assertEqual(schema["Brand"]["name"].indexes, {"QUERYABLE", "SEARCHABLE", "SORTABLE"})
        self.assertEqual(schema["Brand"]["ids"].type, "LIST<INT64>")
        self.assertIn("___createTime", schema["Brand"])

    def test_real_schema_is_clean(self):
        text = (support.REPO / ccs.CKDB_REL).read_text(encoding="utf-8")
        self.assertEqual(run(text), ([], []))


class CheckTest(unittest.TestCase):
    def test_duplicate_type_is_an_error(self):
        errors, _ = run(HEAD + BRAND + BRAND)
        self.assertTrue(any("2 回定義" in e for e in errors), errors)

    def test_adding_a_column_is_fine_and_reported(self):
        new = BRAND.replace("ids ", "nameKo          STRING QUERYABLE SEARCHABLE SORTABLE,\n        ids ")
        errors, added = run(HEAD + new, HEAD + BRAND)
        self.assertEqual(errors, [])
        self.assertEqual(added, ["`Brand.nameKo` STRING QUERYABLE SEARCHABLE SORTABLE"])

    def test_removing_a_column_is_an_error(self):
        new = BRAND.replace("        name            STRING QUERYABLE SEARCHABLE SORTABLE,\n", "")
        errors, _ = run(HEAD + new, HEAD + BRAND)
        self.assertEqual(errors, ["Brand.name が消えている (Production では列を消せない)"])

    def test_changing_a_type_is_an_error(self):
        new = BRAND.replace("name            STRING", "name            INT64")
        errors, _ = run(HEAD + new, HEAD + BRAND)
        self.assertTrue(errors and "型が STRING → INT64" in errors[0], errors)

    def test_dropping_an_index_is_an_error(self):
        new = BRAND.replace("modifiedAt      TIMESTAMP QUERYABLE SORTABLE", "modifiedAt      TIMESTAMP SORTABLE")
        errors, _ = run(HEAD + new, HEAD + BRAND)
        self.assertTrue(any("QUERYABLE が外れている" in e for e in errors), errors)

    def test_removing_a_type_is_an_error(self):
        errors, _ = run(HEAD, HEAD + BRAND)
        self.assertEqual(errors, ["RECORD TYPE Brand が消えている (Production では型を消せない)"])

    def test_new_type_needs_sync_columns(self):
        new = BRAND.replace("Brand", "Tag").replace(
            "        modifiedAt      TIMESTAMP QUERYABLE SORTABLE,\n", ""
        )
        errors, added = run(HEAD + BRAND + new, HEAD + BRAND)
        self.assertEqual(added, ["RECORD TYPE `Tag` (新規)"])
        self.assertTrue(any("Tag" in e and "modifiedAt" in e for e in errors), errors)

    def test_summary_lists_owner_steps_only_when_something_is_added(self):
        self.assertIn("やることはありません", ccs.summary_markdown([], []))
        md = ccs.summary_markdown([], ["`Brand.nameKo` STRING"])
        self.assertIn("Deploy Schema Changes", md)


if __name__ == "__main__":
    unittest.main()
