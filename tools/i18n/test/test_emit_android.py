"""Android の出力 (strings_<ns>.xml・overlay・locale_config・Kotlin のアクセサ)。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import unittest
import xml.etree.ElementTree as ET

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture, rich

import emit_android  # noqa: E402

RES = emit_android.RES_ROOT
KT = emit_android.KOTLIN_MAIN


def names(xml_text):
    root = ET.fromstring(xml_text.encode("utf-8"))
    return {el.get("name"): el for el in root}


class AndroidResourceTest(unittest.TestCase):
    def setUp(self):
        self.fx = Fixture(rich(), support.RICH_LANGUAGES)
        self.files, self.catalog = self.fx.emit()

    def tearDown(self):
        self.fx._tmp.cleanup()

    def base(self, ns):
        return self.files["%s/main/values/strings_%s.xml" % (RES, ns)]

    def test_files_and_overlays(self):
        self.assertIn(RES + "/main/values/strings_common.xml", self.files)
        self.assertIn(RES + "/debug/values-ko/strings_common.xml", self.files)
        self.assertIn(RES + "/debug/values-en/strings_events.xml", self.files)
        # dev の言語は main に置かない
        self.assertFalse(any(p.startswith(RES + "/main/values-") for p in self.files))
        # en の訳が 1 つも無い名前空間には values-en を作らない
        self.assertNotIn(RES + "/debug/values-en/strings_common.xml", self.files)
        # Android だけの名前空間も出る
        self.assertIn(RES + "/main/values/strings_widget.xml", self.files)

    def test_base_header(self):
        text = self.base("common")
        self.assertTrue(text.startswith('<?xml version="1.0" encoding="utf-8"?>\n'
                                        "<!-- 生成物: i18n/catalog/common.json → python3 tools/i18n/i18n.py generate。手で直さない -->\n"))
        self.assertIn('tools:locale="ja"', text)
        self.assertIn('tools:ignore="MissingTranslation"', text)
        self.assertIn("    <!-- common.action.see_all: セクション見出し右の導線 -->\n", text)

    def test_escapes(self):
        text = self.base("common")
        self.assertIn('<string name="common_sym_at">\\@担当 \\\'です\\\' \\"引用\\" &amp; &lt;b></string>', text)
        self.assertIn('<string name="common_sym_question">\\?はてな</string>', text)
        self.assertIn('<string name="common_sym_spaces">"前  後"</string>', text)
        self.assertIn('<string name="common_sym_newline">一行目\\n二行目</string>', text)
        self.assertIn('<string name="common_sym_backslash">a\\\\b</string>', text)
        self.assertIn('<string name="common_sym_braces">{そのまま}</string>', text)
        # 前後の空白を残す (keep_whitespace) は二重引用符で囲む
        ko = self.files[RES + "/debug/values-ko/strings_common.xml"]
        self.assertIn('<string name="common_list_middot">" · "</string>', ko)
        self.assertIn('<string name="common_list_middot">・</string>', text)
        # XML として読める
        names(text)
        names(ko)

    def test_percent(self):
        common = self.base("common")
        self.assertIn('<string name="common_discount" formatted="false">50%オフ</string>', common)
        events = self.base("events")
        self.assertIn('<string name="events_rate">%1$sの達成率 100%%</string>', events)

    def test_placeholders_and_plurals(self):
        events = self.base("events")
        self.assertIn('<string name="events_detail_first_show_year">%1$d年</string>', events)
        self.assertIn('    <plurals name="events_attendance_group_header">\n'
                      '        <item quantity="other">%1$s ・ %2$,d名</item>\n'
                      '    </plurals>', events)
        self.assertIn('<string name="events_nested">言語: %1$s</string>', events)
        en = self.files[RES + "/debug/values-en/strings_events.xml"]
        self.assertIn('    <plurals name="events_attendance_group_header">\n'
                      '        <item quantity="one">%2$,d member in %1$s</item>\n'
                      '        <item quantity="other">%2$,d members in %1$s</item>\n'
                      '    </plurals>', en)
        self.assertIn('<item quantity="one">one song</item>', en)

    def test_platforms(self):
        self.assertNotIn("events_ios_only", self.base("events"))
        # system の Info.plist 用の項目は platforms に android があるもの (アプリ名) だけ Android に出る
        self.assertEqual(sorted(names(self.base("system"))), ["system_app_display_name"])
        kt = self.files[KT + "/L10nEvents.kt"]
        self.assertNotIn("iosOnly", kt)

    def test_ko_file_only_has_names_of_base(self):
        base = set(names(self.base("events")))
        for lang in ("ko", "en"):
            extra = set(names(self.files["%s/debug/values-%s/strings_events.xml" % (RES, lang)])) - base
            self.assertEqual(extra, set(), lang)
        self.assertEqual(emit_android.invariant_problems(self.catalog, self.files), [])

    def test_invariant_catches_extra_translation(self):
        files = dict(self.files)
        path = RES + "/debug/values-ko/strings_events.xml"
        files[path] = files[path].replace("</resources>", '    <string name="events_ghost">유령</string>\n</resources>')
        problems = emit_android.invariant_problems(self.catalog, files)
        self.assertTrue(any("ExtraTranslation" in p.format() and "events_ghost" in p.format() for p in problems))

    def test_invariant_catches_non_release_in_main(self):
        files = dict(self.files)
        files[RES + "/main/values-ko/strings_common.xml"] = files[RES + "/debug/values-ko/strings_common.xml"]
        problems = emit_android.invariant_problems(self.catalog, files)
        self.assertTrue(any("release でない言語" in p.format() for p in problems))

    def test_locale_config_and_meta(self):
        main = self.files[RES + "/main/xml/locale_config.xml"]
        debug = self.files[RES + "/debug/xml/locale_config.xml"]
        self.assertIn('<locale android:name="ja" />', main)
        self.assertNotIn("ko", main)
        self.assertEqual(debug.count("<locale "), 3)
        self.assertIn('<bool name="i18n_language_picker_enabled">false</bool>', self.files[RES + "/main/values/i18n_meta.xml"])
        self.assertIn('<bool name="i18n_language_picker_enabled">true</bool>', self.files[RES + "/debug/values/i18n_meta.xml"])

    def test_kotlin_accessors(self):
        kt = self.files[KT + "/L10nEvents.kt"]
        self.assertIn("package com.fugaif.imaslivedb.i18n.generated\n", kt)
        self.assertIn("import com.fugaif.imaslivedb.R\n", kt)
        self.assertIn("object L10nEvents {\n", kt)
        self.assertIn("    val onlyJa: DisplayText get() = DisplayText.Res(R.string.events_only_ja)\n", kt)
        self.assertIn("    fun detailFirstShowYear(year: Int): DisplayText = "
                      "DisplayText.Res(R.string.events_detail_first_show_year, listOf(year))\n", kt)
        self.assertIn("    fun attendanceGroupHeader(label: String, count: Int): DisplayText = "
                      "DisplayText.Plural(R.plurals.events_attendance_group_header, count, listOf(label, count))\n", kt)
        self.assertIn("    fun nested(inner: DisplayText): DisplayText = DisplayText.Res(R.string.events_nested, listOf(inner))\n", kt)
        index = self.files[KT + "/L10n.kt"]
        self.assertIn("object L10n {\n", index)
        self.assertIn("    val Events: L10nEvents get() = L10nEvents\n", index)
        self.assertIn("    val Widget: L10nWidget get() = L10nWidget\n", index)
        self.assertIn("    val System: L10nSystem get() = L10nSystem\n", index)

    def test_kotlin_test_keys(self):
        kt = self.files[emit_android.KOTLIN_TEST + "/L10nCatalogKeys.kt"]
        self.assertIn('L10nCatalogSample("events.songs", "events_songs", listOf("ja", "en", "ko"), "count=1234", '
                      '{ L10n.Events.songs(count = 1234) }, mapOf("ja" to "1,234曲", "en" to "1,234 songs", "ko" to "1,234곡")),', kt)
        self.assertIn('{ L10n.Events.nested(inner = L10n.I18n.languageTag) }', kt)
        self.assertIn('"ja" to "一行目\\n二行目"', kt)


class ChannelPlacementTest(unittest.TestCase):
    CATALOG = {"common": {"namespace": "common", "kind": "ui", "strings": {"x": {"ja": "曲", "ko": "곡"}}}}

    def emit(self, channel):
        with Fixture(self.CATALOG, {"ja": "release", "ko": channel}) as fx:
            if channel != "dev":
                fx.run("stamp", "ko", "--reviewer", "hana")
            files, _ = fx.emit()
            return files

    def test_release_goes_to_main(self):
        files = self.emit("release")
        self.assertIn(RES + "/main/values-ko/strings_common.xml", files)
        self.assertFalse(any(p.startswith(RES + "/debug/") for p in files))
        self.assertIn('<bool name="i18n_language_picker_enabled">true</bool>', files[RES + "/main/values/i18n_meta.xml"])

    def test_dev_and_beta_go_to_debug(self):
        for channel in ("dev", "beta"):
            files = self.emit(channel)
            self.assertIn(RES + "/debug/values-ko/strings_common.xml", files, channel)
            self.assertNotIn(RES + "/main/values-ko/strings_common.xml", files, channel)

    def test_no_android_entries_no_files(self):
        catalog = {"common": {"namespace": "common", "kind": "ui", "platforms": ["ios"], "strings": {"x": {"ja": "曲"}}}}
        with Fixture(catalog) as fx:
            files, _ = fx.emit()
        self.assertFalse(any(p.startswith("ImasLiveDB-Android/") for p in files))


class EscapeFunctionTest(unittest.TestCase):
    def test_android_escape(self):
        self.assertEqual(emit_android.android_escape("It's \"x\" & <y>\n\t\\"), "It\\'s \\\"x\\\" &amp; &lt;y>\\n\\t\\\\")

    def test_kotlin_string(self):
        self.assertEqual(emit_android.kotlin_string('a"$b\\\n'), 'a\\"\\$b\\\\\\n')

    def test_xml_comment_splits_every_double_hyphen(self):
        # XML コメントに "--" は書けない。"---" や "----" も割り切る
        for text in ("a--b", "a---b", "a----b", "x-", "--"):
            with self.subTest(text=text):
                out = emit_android.xml_comment(text)
                self.assertNotIn("--", out)
                self.assertFalse(out.endswith("-"))

    def test_kdoc_breaks_nested_comment(self):
        # Kotlin のコメントは入れ子になるので、文言に /* があると KDoc が閉じなくなる
        self.assertEqual(emit_android.kdoc("a/*b*/c"), "a/ *b* /c")


if __name__ == "__main__":
    unittest.main()
