"""i18n.py check の規則。落ちるべきものが落ち、正しいものが通ること。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import unittest

import support
from support import Fixture, messages, rich


def ns(name, strings, **fields):
    raw = {"namespace": name, "kind": "ui", "strings": strings}
    raw.update(fields)
    return raw


class ValidCatalogTest(unittest.TestCase):
    def test_rich_catalog_is_clean(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            errors = messages(fx.problems(), "error")
            self.assertEqual(errors, [])

    def test_empty_catalog_is_clean_and_rule8_sleeps(self):
        # カタログが空 (PR1 の状態) なら project.yml が無くても通る
        with Fixture({}, project=False) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])
            code, out = fx.run("check")
            self.assertEqual(code, 0, out)
            self.assertIn("休眠", out)


class KeyAndNameTest(unittest.TestCase):
    def check(self, namespaces, needle, languages=None):
        with Fixture(namespaces, languages) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any(needle in e for e in errors), "%r が無い: %s" % (needle, errors))

    def test_segment_starting_with_digit(self):
        self.check({"songs": ns("songs", {"preset.3": {"ja": "3段"}})}, "キーの書式が違う")

    def test_uppercase_key(self):
        self.check({"songs": ns("songs", {"listTitle": {"ja": "曲"}})}, "キーの書式が違う")

    def test_too_deep_key(self):
        self.check({"songs": ns("songs", {"a.b.c.d.e": {"ja": "曲"}})}, "キーの書式が違う")

    def test_namespace_must_match_file_name(self):
        self.check({"songs": ns("idols", {"x": {"ja": "曲"}})}, "ファイル名")

    def test_accessor_name_collision(self):
        self.check({"songs": ns("songs", {"a.b_c": {"ja": "1"}, "a_b.c": {"ja": "2"}})}, "アクセサ名 aBC")

    def test_android_name_collision_across_namespaces(self):
        self.check({"foo": ns("foo", {"bar_baz": {"ja": "1"}}), "foo_bar": ns("foo_bar", {"baz": {"ja": "2"}})},
                   "リソース名 foo_bar_baz")

    def test_reserved_table_name(self):
        self.check({"localizable": ns("localizable", {"x": {"ja": "1"}})}, "予約名")

    def test_reserved_swift_identifier_as_table(self):
        # 生成 Swift が使う識別子と同名の enum ができると、生成物全体がコンパイルできなくなる
        for name in ("string", "int", "l10n", "bundle", "foundation"):
            with self.subTest(name=name):
                self.check({name: ns(name, {"x": {"ja": "1"}})}, "予約名")

    def test_duplicate_json_key(self):
        with Fixture({}) as fx:
            fx.write("i18n/catalog/songs.json",
                     '{"namespace": "songs", "kind": "ui", "strings": {"x": {"ja": "1"}, "x": {"ja": "2"}}}\n')
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("2 回ある" in e for e in errors), errors)

    def test_forbidden_member(self):
        self.check({"songs": ns("songs", {"init": {"ja": "1"}})}, "Swift で使えない")


class ValueTest(unittest.TestCase):
    def check(self, entry, needle, languages=None, extra=None, level="error"):
        namespaces = {"songs": ns("songs", {"x": entry})}
        namespaces.update(extra or {})
        with Fixture(namespaces, languages) as fx:
            found = messages(fx.problems(), level)
            self.assertTrue(any(needle in e for e in found), "%r が無い: %s" % (needle, found))

    def test_ja_required(self):
        self.check({"ko": "곡"}, "基準言語の原文")

    def test_empty_ja(self):
        self.check({"ja": ""}, "基準言語の原文")

    def test_empty_ko(self):
        self.check({"ja": "曲", "ko": ""}, "空文字列")

    def test_language_not_in_config(self):
        self.check({"ja": "曲", "fr": "chanson"}, "languages に無い")

    def test_unknown_field(self):
        self.check({"ja": "曲", "comment": "x"}, "未知のフィールド")

    def test_placeholder_missing_in_ko(self):
        self.check({"args": [{"name": "label", "type": "core"}, {"name": "count", "type": "count"}],
                    "ja": "{label} ・ {count}名", "ko": "{label} 명"}, "{count} がない")

    def test_placeholder_not_in_args(self):
        self.check({"ja": "{name}さん"}, "args に無い {name}")

    def test_ja_uses_argument_twice(self):
        self.check({"args": [{"name": "n", "type": "string"}], "ja": "{n}と{n}"}, "1 回ずつ")

    def test_ko_may_repeat_and_reorder(self):
        entry = {"args": [{"name": "a", "type": "string"}, {"name": "b", "type": "string"}],
                 "ja": "{a}と{b}", "ko": "{b} {a} {b}"}
        with Fixture({"songs": ns("songs", {"x": entry})}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_args_order_must_follow_ja(self):
        self.check({"args": [{"name": "b", "type": "string"}, {"name": "a", "type": "string"}],
                    "ja": "{a}と{b}"}, "args の順番")

    def test_unbalanced_braces(self):
        self.check({"ja": "{閉じない"}, "閉じていない")
        self.check({"ja": "閉じる}"}, "対応する {")

    def test_bad_placeholder_name(self):
        self.check({"ja": "{Name}"}, "プレースホルダとして読めない")

    def test_platform_syntax(self):
        for text in ("%@件", "%1$d件", "%lld件", "\\(n)件", "${n}件", "$1件", "%s件",
                     "%,d人", "%1$,d人", "%.1f倍", "%f", "%i件", "%2$@"):
            with self.subTest(text=text):
                self.check({"ja": text}, "の値に")

    def test_plain_percent_is_allowed(self):
        # 素の % (割合の表記) は書式指定子ではないので通す
        with Fixture({"songs": ns("songs", {"a": {"ja": "100%"}, "b": {"ja": "50%オフ"}, "c": {"ja": "% 表示"}})}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_two_count_args(self):
        self.check({"args": [{"name": "a", "type": "count"}, {"name": "b", "type": "count"}],
                    "ja": "{a}と{b}"}, "count 引数は 1 キーに 1 つまで")

    def test_unknown_arg_type(self):
        self.check({"args": [{"name": "a", "type": "float"}], "ja": "{a}"}, "の型")

    def test_plural_object_without_count(self):
        self.check({"ja": "曲", "en": {"one": "song", "other": "songs"}}, "count 引数が無い",
                   languages={"ja": "release", "en": "dev"})

    def test_plural_category_not_in_cldr(self):
        self.check({"args": [{"name": "n", "type": "count"}], "ja": "{n}曲", "ko": {"one": "{n}곡", "other": "{n}곡"}},
                   "CLDR に無い")

    def test_plural_needs_other(self):
        self.check({"args": [{"name": "n", "type": "count"}], "ja": "{n}曲", "en": {"one": "{n} song"}},
                   "other が無い", languages={"ja": "release", "en": "dev"})

    def test_ja_must_be_string(self):
        self.check({"args": [{"name": "n", "type": "count"}], "ja": {"other": "{n}曲"}}, "文字列")

    def test_plural_non_other_may_omit_count(self):
        entry = {"args": [{"name": "n", "type": "count"}], "ja": "{n}曲", "en": {"one": "one song", "other": "{n} songs"}}
        with Fixture({"songs": ns("songs", {"x": entry})}, {"ja": "release", "en": "dev"}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_missing_plural_category_is_warning(self):
        self.check({"args": [{"name": "n", "type": "count"}], "ja": "{n}曲", "en": "{n} songs"},
                   "one が無い", languages={"ja": "release", "en": "dev"}, level="warning")

    def test_edge_whitespace(self):
        self.check({"ja": " 前"}, "前後に空白")
        self.check({"ja": "後\u3000"}, "前後に空白")

    def test_keep_whitespace_allows_edges(self):
        entry = {"keep_whitespace": True, "ja": "・", "ko": " · "}
        with Fixture({"songs": ns("songs", {"x": entry})}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_control_characters(self):
        self.check({"ja": "a\tb"}, "制御文字")
        self.check({"ja": "a\rb"}, "制御文字")

    def test_text_arg_needs_language_tag(self):
        self.check({"args": [{"name": "inner", "type": "text"}], "ja": "[{inner}]"}, "i18n.language_tag")


class PlatformRuleTest(unittest.TestCase):
    def check(self, namespaces, needle):
        with Fixture(namespaces) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any(needle in e for e in errors), "%r が無い: %s" % (needle, errors))

    def test_core_platform_is_reserved(self):
        self.check({"songs": ns("songs", {"x": {"platforms": ["core"], "ja": "曲"}})}, "core は予約")

    def test_bad_ios_bundles(self):
        self.check({"songs": ns("songs", {"x": {"ja": "曲"}}, ios_bundles=["watch"])}, "ios_bundles")

    def test_infoplist_only_in_system(self):
        self.check({"songs": ns("songs", {"x": {"ios": {"infoplist": {"target": "app", "key": "CFBundleName"}}, "ja": "曲"}})},
                   "system 名前空間でだけ")

    def test_infoplist_target(self):
        self.check({"system": ns("system", {"x": {"ios": {"infoplist": {"target": "watch", "key": "K"}}, "ja": "曲"}},
                                 kind="system")}, "ios.infoplist は")

    def test_intent_metadata_needs_widget_bundle(self):
        self.check({"songs": ns("songs", {"x": {"ios": {"intent_metadata": True}, "ja": "曲"}})}, "widget がある名前空間")

    def test_core_namespace_must_be_reserved(self):
        self.check({"core": ns("core", {"x": {"ja": "曲"}})}, "kind: reserved にする")

    def test_reserved_kind_only_for_core(self):
        self.check({"songs": ns("songs", {"x": {"ja": "曲"}}, kind="reserved")}, "core 名前空間だけ")

    def test_core_reference_from_source(self):
        with Fixture({"core": ns("core", {"vocab.x": {"ja": "語"}}, kind="reserved")}) as fx:
            fx.write("ImasLiveDB/Views/A.swift", "let t = L10n.Core.vocabX\n")
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("core 名前空間" in e and "A.swift" in e for e in errors), errors)


class ProjectYmlTest(unittest.TestCase):
    """規則 8: iOS に出す名前空間があるときだけ project.yml を照合する。"""

    APP = {"songs": ns("songs", {"x": {"ja": "曲"}})}

    def test_dormant_without_ios_outputs(self):
        android_only = {"songs": ns("songs", {"x": {"ja": "曲"}}, platforms=["android"])}
        with Fixture(android_only, project=False) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_missing_project_yml(self):
        with Fixture(self.APP, project=False) as fx:
            self.assertTrue(any("project.yml が無い" in e for e in messages(fx.problems(), "error")))

    def test_release_gate_matches(self):
        with Fixture(self.APP, project=support.project_yml("ja")) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_release_gate_mismatch(self):
        with Fixture(self.APP, project=support.project_yml('"ja ko"')) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("Release の XCSTRINGS_LANGUAGES_TO_COMPILE" in e for e in errors), errors)

    def test_release_gate_missing(self):
        text = support.project_yml("ja").replace("      XCSTRINGS_LANGUAGES_TO_COMPILE: ja\n", "      FOO: bar\n", 1)
        with Fixture(self.APP, project=text) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("settings.configs.Release.XCSTRINGS_LANGUAGES_TO_COMPILE が無い" in e for e in errors), errors)

    def test_target_level_gate_is_error(self):
        with Fixture(self.APP, project=support.project_yml("ja", target_gate=True)) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("targets.ImasLiveDB.settings.configs.Release" in e for e in errors), errors)

    def test_infoplist_value_must_match(self):
        system = {"system": ns("system", {"app.display_name": {
            "ios": {"infoplist": {"target": "app", "key": "CFBundleDisplayName"}}, "ja": "別の名前"}}, kind="system")}
        with Fixture(system) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("INFOPLIST_KEY_CFBundleDisplayName (アイドルライブDB)" in e for e in errors), errors)

    def test_infoplist_key_must_exist(self):
        system = {"system": ns("system", {"app.mic": {
            "ios": {"infoplist": {"target": "app", "key": "NSMicrophoneUsageDescription"}}, "ja": "マイク"}}, kind="system")}
        with Fixture(system) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("INFOPLIST_KEY_NSMicrophoneUsageDescription が無い" in e for e in errors), errors)

    def test_yaml_scalars_reads_quotes_and_lists(self):
        import validate
        values = {p: v for p, v, _ in validate.yaml_scalars(support.project_yml('"ja"'))}
        self.assertEqual(values[("settings", "configs", "Release", "XCSTRINGS_LANGUAGES_TO_COMPILE")], "ja")
        self.assertEqual(values[("targets", "ImasLiveDB", "settings", "base", "INFOPLIST_KEY_NSCameraUsageDescription")],
                         "セットリストの写真を撮影してOCRで曲名を認識します")
        self.assertEqual(values[("targets", "ImasLiveDB", "sources", "-", "path")], "ImasLiveDB")


class QualityWarningTest(unittest.TestCase):
    def warnings(self, entry, glossary=None):
        with Fixture({"songs": ns("songs", {"x": entry})}) as fx:
            if glossary is not None:
                fx.write_json("i18n/glossary.json", glossary)
            return messages(fx.problems(), "warning")

    def test_kana_in_ko(self):
        self.assertTrue(any("仮名" in w for w in self.warnings({"ja": "ライブ", "ko": "ライブ 라이브"})))
        self.assertEqual(self.warnings({"ja": "担当", "ko": "ライブ", "verbatim_ok": True}), [])

    def test_glossary(self):
        g = {"terms": [{"ja": "担当", "ko": "담당"}]}
        self.assertTrue(any("用語集" in w for w in self.warnings({"ja": "担当を選ぶ", "ko": "최애 고르기"}, g)))
        self.assertEqual(self.warnings({"ja": "担当を選ぶ", "ko": "담당 고르기"}, g), [])

    def test_max_len(self):
        self.assertTrue(any("max_len" in w for w in self.warnings({"ja": "まる", "ko": "다섯글자다", "max_len": 4})))


class GateTest(unittest.TestCase):
    """規則 10: beta / release の言語は ui / system に欠落・未検収・stale を残さない。"""

    def test_dev_is_not_gated(self):
        with Fixture({"songs": ns("songs", {"x": {"ja": "曲"}})}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_beta_needs_reviewed_translations(self):
        catalog = {"songs": ns("songs", {"x": {"ja": "曲", "ko": "곡"}, "y": {"ja": "歌"}})}
        with Fixture(catalog, {"ja": "release", "ko": "beta"}) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("欠落 1 件 / 未検収 1 件 / stale 0 件" in e for e in errors), errors)
            # content は対象外
            fx.write_json("i18n/catalog/songs.json", ns("songs", {"x": {"ja": "曲", "ko": "곡"}, "y": {"ja": "歌"}},
                                                        kind="content"))
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_stamp_then_stale(self):
        catalog = {"songs": ns("songs", {"x": {"ja": "曲", "ko": "곡"}})}
        with Fixture(catalog, {"ja": "release", "ko": "beta"}) as fx:
            code, out = fx.run("stamp", "ko")
            self.assertEqual(code, 0, out)
            self.assertEqual(messages(fx.problems(), "error"), [])
            fx.write_json("i18n/catalog/songs.json", ns("songs", {"x": {"ja": "楽曲", "ko": "곡"}}))
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("stale 1 件" in e for e in errors), errors)


class ConfigTest(unittest.TestCase):
    def test_unknown_language(self):
        with Fixture({}, {"ja": "release", "xx": "dev"}) as fx:
            self.assertTrue(any("生成器が知らない" in e for e in messages(fx.problems(), "error")))

    def test_source_must_be_release(self):
        with Fixture({}, {"ja": "dev"}) as fx:
            self.assertTrue(any("release にする" in e for e in messages(fx.problems(), "error")))

    def test_bad_ratchet(self):
        with Fixture({}, ratchet="strict") as fx:
            self.assertTrue(any("guard.ratchet" in e for e in messages(fx.problems(), "error")))


if __name__ == "__main__":
    unittest.main()
