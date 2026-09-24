"""channel が planned の言語: カタログ・用語集・lock に値を持てるが、ビルドの生成物には一切出ない。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import copy
import json
import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture, rich

import emit_android  # noqa: E402
import emit_apple  # noqa: E402

RES = emit_android.RES_ROOT
PLANNED = {"ja": "release", "ko": "dev", "en": "planned", "zh-Hans": "planned"}
WITHOUT_PLANNED = {"ja": "release", "ko": "dev"}


def planned_catalog():
    """RICH (en の訳あり) に zh-Hans の訳も足したもの。引数のある項目・Info.plist・複数形を含む。"""
    data = rich()
    data["i18n"]["strings"]["language_tag"]["zh-Hans"] = "zh-Hans"
    data["common"]["strings"]["action.see_all"].update({"en": "See all", "zh-Hans": "查看全部"})
    data["events"]["strings"]["rate"].update({"en": "{name} completion 100%", "zh-Hans": "{name}的达成率 100%"})
    data["events"]["strings"]["songs"]["zh-Hans"] = "{count}首"
    data["events"]["strings"]["only_ja"]["zh-Hans"] = "只有日语"
    data["system"]["strings"]["app.display_name"].update({"en": "Idol Live DB", "zh-Hans": "偶像Live DB"})
    data["widget"]["strings"]["next_live.description"]["en"] = "Shows the days until the next live show."
    return data


def strip(data, langs):
    """カタログから langs の値を抜く (planned の言語が無かったときのカタログ)。"""
    data = copy.deepcopy(data)
    for ns in data.values():
        for entry in ns["strings"].values():
            for lang in langs:
                entry.pop(lang, None)
    return data


def app_outputs(files):
    return {p: t for p, t in files.items() if p != "i18n/TRANSLATION.md"}


class PlannedIsNotBuiltTest(unittest.TestCase):
    def setUp(self):
        self.fx = Fixture(planned_catalog(), PLANNED)
        self.files, self.catalog = self.fx.emit()

    def tearDown(self):
        self.fx._tmp.cleanup()

    def test_catalog_with_planned_values_is_clean(self):
        self.assertEqual(support.messages(self.fx.problems(), "error"), [])
        self.assertEqual(self.catalog.config.built_languages(), ["ja", "ko"])
        self.assertEqual(self.catalog.config.others(), ["en", "ko", "zh-Hans"])

    def test_app_outputs_equal_the_catalog_without_planned_languages(self):
        # planned の言語の値があっても無くても、アプリの生成物は 1 バイトも変わらない
        with Fixture(strip(planned_catalog(), ("en", "zh-Hans")), WITHOUT_PLANNED) as fx:
            files, _ = fx.emit()
        self.assertEqual(sorted(app_outputs(self.files)), sorted(app_outputs(files)))
        for path in files:
            if path in app_outputs(files):
                self.assertEqual(self.files[path], files[path], path)

    def test_xcstrings_have_no_planned_localizations(self):
        tables = [p for p in self.files if p.endswith(".xcstrings")]
        self.assertIn(emit_apple.APP_DIR + "/InfoPlist.xcstrings", tables)
        for path in tables:
            for key, e in json.loads(self.files[path])["strings"].items():
                self.assertFalse({"en", "zh-Hans"} & set(e["localizations"]), "%s %s" % (path, key))
        events = json.loads(self.files[emit_apple.APP_DIR + "/Events.xcstrings"])["strings"]
        # 引数のある項目の基準言語へのフォールバック (Xcode 27 対策) もビルドに入る言語だけ
        self.assertEqual(sorted(events["events.rate"]["localizations"]), ["ja", "ko"])
        self.assertEqual(events["events.rate"]["localizations"]["ko"]["stringUnit"]["state"], "new")
        self.assertEqual(sorted(events["events.songs"]["localizations"]), ["ja", "ko"])
        self.assertEqual(sorted(events["events.only_ja"]["localizations"]), ["ja"])

    def test_android_has_no_planned_resources(self):
        self.assertFalse([p for p in self.files if "/values-en/" in p or "/values-b+zh+Hans/" in p])
        for overlay in ("main", "debug"):
            config = self.files["%s/%s/xml/locale_config.xml" % (RES, overlay)]
            self.assertNotIn('"en"', config)
            self.assertNotIn("zh-Hans", config)
        self.assertEqual(self.files[RES + "/debug/xml/locale_config.xml"].count("<locale "), 2)
        self.assertIn('<bool name="i18n_language_picker_enabled">false</bool>', self.files[RES + "/main/values/i18n_meta.xml"])
        self.assertIn('<bool name="i18n_language_picker_enabled">true</bool>', self.files[RES + "/debug/values/i18n_meta.xml"])
        self.assertEqual(emit_android.invariant_problems(self.catalog, self.files), [])

    def test_expectation_files_list_only_built_languages(self):
        swift = self.files[emit_apple.TESTS_DIR + "/L10nCatalogKeys.generated.swift"]
        self.assertIn('static let languages: [String] = ["ja", "ko"]', swift)
        self.assertNotIn('"en"', swift)
        self.assertNotIn("zh-Hans", swift)
        kotlin = self.files[emit_android.KOTLIN_TEST + "/L10nCatalogKeys.kt"]
        self.assertIn('val languages: List<String> = listOf("ja", "ko")', kotlin)
        self.assertNotIn('"en"', kotlin)
        self.assertNotIn("zh-Hans", kotlin)

    def test_gate_output_has_no_planned_language(self):
        for name, want in (("Release", "ja\n"), ("Beta", "ja\n"), ("Debug", "ja ko\n")):
            with self.subTest(config=name):
                self.assertEqual(self.fx.run("gate", "--config", name), (0, want))

    def test_invariant_catches_planned_resources(self):
        files = dict(self.files)
        files[RES + "/debug/values-en/strings_events.xml"] = files[RES + "/debug/values-ko/strings_events.xml"]
        problems = [p.format() for p in emit_android.invariant_problems(self.catalog, files)]
        self.assertTrue(any("planned の言語 (values-en)" in p for p in problems), problems)

    def test_stats_lists_planned_languages(self):
        code, out = self.fx.run("stats")
        self.assertEqual(code, 0)
        self.assertIn("| en | planned |", out)
        self.assertIn("| zh-Hans | planned |", out)

    def test_planned_language_can_be_stamped(self):
        code, out = self.fx.run("stamp", "zh-Hans", "--reviewer", "lin", "--ns", "common")
        self.assertEqual(code, 0, out)
        lock = json.loads(self.fx.read("i18n/lock/zh-Hans.json"))
        self.assertEqual(sorted(lock), ["common.action.see_all"])
        files, catalog = self.fx.emit()
        self.assertEqual(catalog.status(catalog.find("common.action.see_all"), "zh-Hans"), "reviewed")
        self.assertEqual(app_outputs(files), app_outputs(self.files))


class PromotionTest(unittest.TestCase):
    """planned から dev に上げると、同じカタログのまま生成物に出る (zh-Hans の置き場も確かめる)。"""

    def test_dev_emits_en_and_zh_hans(self):
        langs = {"ja": "release", "ko": "dev", "en": "dev", "zh-Hans": "dev"}
        with Fixture(planned_catalog(), langs) as fx:
            files, catalog = fx.emit()
        self.assertEqual(catalog.config.built_languages(), ["ja", "en", "ko", "zh-Hans"])
        self.assertIn(RES + "/debug/values-en/strings_events.xml", files)
        self.assertIn(RES + "/debug/values-b+zh+Hans/strings_events.xml", files)
        self.assertIn('<locale android:name="zh-Hans" />', files[RES + "/debug/xml/locale_config.xml"])
        events = json.loads(files[emit_apple.APP_DIR + "/Events.xcstrings"])["strings"]
        self.assertEqual(sorted(events["events.rate"]["localizations"]), ["en", "ja", "ko", "zh-Hans"])
        self.assertEqual(events["events.songs"]["localizations"]["zh-Hans"]["substitutions"]["count"]
                         ["variations"]["plural"]["other"]["stringUnit"]["value"], "%arg首")
        swift = files[emit_apple.TESTS_DIR + "/L10nCatalogKeys.generated.swift"]
        self.assertIn('static let languages: [String] = ["ja", "en", "ko", "zh-Hans"]', swift)
        self.assertIn('"zh-Hans": "1,234首"', swift)


class ConfigTest(unittest.TestCase):
    def test_planned_is_a_channel(self):
        with Fixture({}, PLANNED) as fx:
            self.assertEqual(support.messages(fx.problems(), "error"), [])
            catalog, _ = fx.load()
            self.assertEqual(catalog.config.languages, {"ja": "release", "en": "planned", "ko": "dev",
                                                        "zh-Hans": "planned"})

    def test_bad_channel_lists_planned(self):
        with Fixture({}, {"ja": "release", "en": "later"}) as fx:
            errors = support.messages(fx.problems(), "error")
            self.assertTrue(any("planned / dev / beta / release" in e for e in errors), errors)

    def test_source_cannot_be_planned(self):
        with Fixture({}, {"ja": "planned"}) as fx:
            self.assertTrue(any("release にする" in e for e in support.messages(fx.problems(), "error")))


if __name__ == "__main__":
    unittest.main()
