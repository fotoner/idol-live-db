"""見本の引数と期待値の計算。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture, rich

import cldr  # noqa: E402
import model  # noqa: E402


class GroupingTest(unittest.TestCase):
    def test_group(self):
        self.assertEqual(cldr.group("ja", 1234), "1,234")
        self.assertEqual(cldr.group("ko", 1234567), "1,234,567")
        self.assertEqual(cldr.group("ja", 999), "999")
        self.assertEqual(cldr.group("en", -1234), "-1,234")

    def test_categories(self):
        self.assertEqual(cldr.categories("ja"), ("other",))
        self.assertEqual(cldr.category_for("en", 1), "one")
        self.assertEqual(cldr.category_for("en", 1234), "other")
        self.assertEqual(cldr.category_for("ko", 1), "other")


class RenderTest(unittest.TestCase):
    def setUp(self):
        self.fx = Fixture(rich(), support.RICH_LANGUAGES)
        _, self.catalog = self.fx.emit()

    def tearDown(self):
        self.fx._tmp.cleanup()

    def render(self, key, lang, **sample):
        e = self.catalog.find(key)
        return model.render(self.catalog, e, lang, sample)

    def test_samples(self):
        e = self.catalog.find("events.attendance.group_header")
        self.assertEqual([s["count"] for s in model.samples(e)], [1, 3, 1234])
        self.assertEqual(model.samples(e)[0]["label"], "かな カナ1")
        year = self.catalog.find("events.detail.first_show_year")
        self.assertEqual(model.samples(year), [{"year": 2026}])
        self.assertEqual(model.describe_sample(e, model.samples(e)[2]), "label=かな カナ1, count=1234")

    def test_int_has_no_grouping(self):
        self.assertEqual(self.render("events.detail.first_show_year", "ja", year=2026), "2026年")
        self.assertEqual(self.render("events.detail.first_show_year", "ko", year=2026), "2026년")

    def test_count_is_grouped(self):
        self.assertEqual(self.render("events.songs", "ja", count=1234), "1,234曲")
        self.assertEqual(self.render("events.songs", "ko", count=1234), "1,234곡")
        self.assertEqual(self.render("events.attendance.group_header", "ja", label="出演", count=3), "出演 ・ 3名")

    def test_plural_category(self):
        self.assertEqual(self.render("events.songs", "en", count=1), "one song")
        self.assertEqual(self.render("events.songs", "en", count=3), "3 songs")
        self.assertEqual(self.render("events.attendance.group_header", "en", label="A", count=1), "1 member in A")

    def test_fallback_to_source(self):
        self.assertEqual(self.render("events.only_ja", "ko"), "日本語だけ")
        # 訳が無い言語でも、数の書式はその言語 (en の桁区切り)、範疇は基準言語の値にあるものだけ
        self.assertEqual(self.render("events.detail.first_show_year", "en", year=2026), "2026年")

    def test_text_is_resolved_in_same_language(self):
        tag = model.TextSample()
        self.assertEqual(self.render("events.nested", "ja", inner=tag), "言語: ja")
        self.assertEqual(self.render("events.nested", "ko", inner=tag), "언어: ko")
        self.assertEqual(self.render("events.nested", "en", inner=tag), "言語: en")

    def test_literal_percent_and_braces(self):
        self.assertEqual(self.render("common.discount", "ja"), "50%オフ")
        self.assertEqual(self.render("events.rate", "ja", name="X"), "Xの達成率 100%")
        self.assertEqual(self.render("common.sym.braces", "ja"), "{そのまま}")


class TemplateTest(unittest.TestCase):
    def test_parse(self):
        self.assertEqual(model.parse_template("{a}と{{b}}"), [("arg", "a"), ("lit", "と{b}")])
        with self.assertRaises(model.TemplateError):
            model.parse_template("{a")
        with self.assertRaises(model.TemplateError):
            model.parse_template("a}")

    def test_names(self):
        self.assertEqual(model.camel("list.sort_title"), "listSortTitle")
        self.assertEqual(model.camel("preset.steps3.level1"), "presetSteps3Level1")
        self.assertEqual(model.pascal("call_guide"), "CallGuide")
        self.assertEqual(model.pascal("i18n"), "I18n")
        self.assertEqual(model.android_name("events", "attendance.group_header"), "events_attendance_group_header")


if __name__ == "__main__":
    unittest.main()
