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

    def test_empty_catalog_skips_project_yml(self):
        # カタログが空なら project.yml が無くても通る
        with Fixture({}, project=False) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])
            code, out = fx.run("check")
            self.assertEqual(code, 0, out)
            self.assertIn("照合しない", out)


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
        for name in ("string", "int", "l10n", "bundle", "foundation", "type", "self", "any", "protocol", "catalog_keys"):
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
        for text in ("%@件", "%1$d件", "%lld件", "\\(n)件", "${n}件", "%s件",
                     "%,d人", "%1$,d人", "%.1f倍", "%f", "%i件", "%2$@"):
            with self.subTest(text=text):
                self.check({"ja": text}, "の値に")

    def test_plain_percent_is_allowed(self):
        # 素の % (割合の表記) と値段の $ は書式指定子ではないので通す
        texts = ("100%", "50%オフ", "% 表示", "最大50% OFF", "50%OFF", "50% off", "$5")
        strings = {"k%d" % i: {"ja": t} for i, t in enumerate(texts)}
        with Fixture({"songs": ns("songs", strings)}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_note_control_character(self):
        # note は生成物のコメントに入る。CR は Swift の /// を割る
        self.check({"note": "一行目\r二行目", "ja": "曲"}, "note に改行")

    def test_empty_plural_category(self):
        self.check({"args": [{"name": "n", "type": "count"}], "ja": "{n}曲",
                    "en": {"one": "", "other": "{n} songs"}}, "en の one が空文字列",
                   languages={"ja": "release", "en": "dev"})

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

    def test_en_count_without_one_is_warning_even_when_planned(self):
        entry = {"args": [{"name": "n", "type": "count"}], "ja": "{n}曲", "en": {"other": "{n} songs"}}
        with Fixture({"songs": ns("songs", {"x": entry})}, {"ja": "release", "en": "planned"}) as fx:
            problems = fx.problems()
            self.assertEqual(messages(problems, "error"), [])
            warned = messages(problems, "warning")
            self.assertTrue(any("en の複数形に one が無い (other で出る)" in w and '{"one": "…", "other": "…"}' in w
                                for w in warned), warned)
        # ko / zh-Hans は範疇が other だけなので警告しない
        entry = {"args": [{"name": "n", "type": "count"}], "ja": "{n}曲", "ko": "{n}곡", "zh-Hans": "{n}首"}
        with Fixture({"songs": ns("songs", {"x": entry})}, {"ja": "release", "ko": "dev", "zh-Hans": "planned"}) as fx:
            self.assertEqual(messages(fx.problems()), [])

    def test_translation_placeholder_set_must_match_args(self):
        # 翻訳の値が args と違う組の {…} を使うのはエラー (planned の言語も同じ)
        langs = {"ja": "release", "ko": "dev", "en": "planned", "zh-Hans": "planned"}
        args = [{"name": "name", "type": "string"}, {"name": "year", "type": "int"}]
        for lang, value, needle in (("en", "{name} in {yr}", "args に無い {yr}"),
                                    ("zh-Hans", "{name}的年份", "{year} がない"),
                                    ("ko", "{year}년", "{name} がない")):
            with self.subTest(lang=lang):
                self.check({"args": args, "ja": "{name}の{year}年", lang: value}, needle, languages=langs)

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


class LanguageTagTest(unittest.TestCase):
    """i18n.language_tag はビルドに入る言語ごとに、その言語のコードを値に持つ。"""

    def errors(self, values, languages):
        tag = {"namespace": "i18n", "kind": "system", "strings": {"language_tag": values}}
        with Fixture({"i18n": tag}, languages) as fx:
            return messages(fx.problems(), "error")

    def test_built_language_needs_its_code(self):
        errors = self.errors({"ja": "ja", "ko": "ko"}, {"ja": "release", "ko": "dev", "en": "dev"})
        self.assertTrue(any("en の値が無い" in e for e in errors), errors)
        errors = self.errors({"ja": "ja", "ko": "kr"}, {"ja": "release", "ko": "dev"})
        self.assertTrue(any("ko の値は言語コードそのもの" in e for e in errors), errors)

    def test_planned_language_may_be_missing(self):
        self.assertEqual(self.errors({"ja": "ja", "ko": "ko"}, {"ja": "release", "ko": "dev", "en": "planned"}), [])


class PlatformRuleTest(unittest.TestCase):
    def check(self, namespaces, needle):
        with Fixture(namespaces) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any(needle in e for e in errors), "%r が無い: %s" % (needle, errors))

    def test_unknown_platform(self):
        self.check({"songs": ns("songs", {"x": {"platforms": ["core"], "ja": "曲"}})}, "ios / android だけ")

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


class ProjectYmlTest(unittest.TestCase):
    """iOS に出す名前空間があるときだけ project.yml を照合する。"""

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

    def test_glossary_longer_term_masks_shorter(self):
        g = {"terms": [{"ja": "コール", "ko": "콜"}, {"ja": "アンコール", "ko": "앙코르"}]}
        self.assertEqual(self.warnings({"ja": "アンコール", "ko": "앙코르"}, g), [])
        warned = self.warnings({"ja": "アンコール", "ko": "재청"}, g)
        self.assertEqual(len(warned), 1)
        self.assertIn("アンコール", warned[0])
        # 長い語の外に短い語があれば、短い語の訳も求める
        self.assertTrue(any("コール → 콜" in w for w in self.warnings({"ja": "アンコールのコール", "ko": "앙코르의 함성"}, g)))

    def test_max_len_is_error_for_every_language(self):
        with Fixture({"songs": ns("songs", {"x": {"ja": "まる", "ko": "다섯글자다", "max_len": 4}})}) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("ko が 5 文字で max_len 4 を超える" in e for e in errors), errors)
        with Fixture({"songs": ns("songs", {"x": {"ja": "いつつのじ", "max_len": 4}})}) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("ja が 5 文字で max_len 4 を超える" in e for e in errors), errors)
        # 引数は数えない。planned の言語の値も同じ規則
        entry = {"args": [{"name": "name", "type": "string"}], "ja": "{name}まる", "en": "{name} ok", "max_len": 3}
        with Fixture({"songs": ns("songs", {"x": entry})}, {"ja": "release", "en": "planned"}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])
            fx.write_json("i18n/catalog/songs.json", ns("songs", {"x": dict(entry, en="{name} long")}))
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("en が 5 文字で max_len 3 を超える" in e for e in errors), errors)


class GlossaryTest(unittest.TestCase):
    """用語集 (i18n/glossary.json) の多言語の警告。失敗はしない。"""

    LANGS = {"ja": "release", "ko": "dev", "en": "planned", "zh-Hans": "planned"}
    GLOSSARY = {
        "style": {"ko": "해요체", "en": "US English", "zh-Hans": "简体"},
        "terms": [
            {"ja": "担当", "ko": "담당", "en": ["my idol", "your idol"], "zh-Hans": "担当"},
            {"ja": "イントロクイズ", "keep": True},
            {"ja": "アイドルマスター", "keep": True, "en": "THE IDOLM@STER"},
        ],
    }

    def problems(self, entry, glossary=None):
        with Fixture({"songs": ns("songs", {"x": entry})}, self.LANGS) as fx:
            fx.write_json("i18n/glossary.json", self.GLOSSARY if glossary is None else glossary)
            problems = fx.problems()
        self.assertEqual(messages(problems, "error"), [])
        return messages(problems, "warning")

    def test_every_translated_language_is_checked(self):
        warned = self.problems({"ja": "担当を選ぶ", "ko": "최애 고르기", "en": "Choose an oshi", "zh-Hans": "选择本命"})
        self.assertEqual(sorted(w.split(": x: ")[1] for w in warned), [
            "用語集では 担当 → my idol / your idol (en の値に無い)",
            "用語集では 担当 → 担当 (zh-Hans の値に無い)",
            "用語集では 担当 → 담당 (ko の値に無い)",
        ])

    def test_matching_translations_and_case(self):
        self.assertEqual(self.problems({"ja": "担当を選ぶ", "ko": "담당 고르기", "en": "Choose your idol",
                                        "zh-Hans": "选择担当"}), [])
        # 英字は大文字小文字を区別しない (sentence case の文頭)
        self.assertEqual(self.problems({"ja": "担当", "en": "My idol"}), [])

    def test_latin_forms_match_from_the_start_of_a_word(self):
        g = {"terms": [{"ja": "一覧", "en": ["list", "all"]}, {"ja": "ライブ", "en": "live", "zh-Hans": "Live"},
                       {"ja": "楽曲", "en": "song"}]}
        # call の中の all、deliver の中の live は数えない
        warned = self.problems({"ja": "コールガイドの一覧", "en": "Call guide"}, g)
        self.assertEqual([w.split(": x: ")[1] for w in warned], ["用語集では 一覧 → list / all (en の値に無い)"])
        warned = self.problems({"ja": "ライブを届ける", "en": "We deliver it"}, g)
        self.assertEqual([w.split(": x: ")[1] for w in warned], ["用語集では ライブ → live (en の値に無い)"])
        # 語の頭にあれば、大文字でも語尾が付いていてもよい。漢字のすぐあとの英字も語の頭
        self.assertEqual(self.problems({"ja": "楽曲一覧", "en": "All songs"}, g), [])
        self.assertEqual(self.problems({"ja": "ライブ", "en": "Lives", "zh-Hans": "联合Live"}, g), [])

    def test_only_languages_present_on_the_entry(self):
        self.assertEqual(self.problems({"ja": "担当を選ぶ", "en": "Choose your idol"}), [])

    def test_keep_requires_the_ja_term(self):
        warned = self.problems({"ja": "イントロクイズで遊ぶ", "ko": "인트로 퀴즈 하기", "en": "Play Intro Quiz"})
        self.assertIn("用語集では イントロクイズ は訳さない (ko の値に イントロクイズ が無い)", "\n".join(warned))
        self.assertIn("用語集では イントロクイズ は訳さない (en の値に イントロクイズ が無い)", "\n".join(warned))
        self.assertEqual(self.problems({"ja": "イントロクイズで遊ぶ", "ko": "イントロクイズ 하기",
                                        "en": "Play イントロクイズ", "verbatim_ok": True}), [])

    def test_keep_accepts_listed_forms_too(self):
        self.assertEqual(self.problems({"ja": "アイドルマスターの曲", "en": "Songs of THE IDOLM@STER"}), [])
        self.assertEqual(self.problems({"ja": "アイドルマスターの曲", "en": "Songs of アイドルマスター",
                                        "verbatim_ok": True}), [])
        warned = self.problems({"ja": "アイドルマスターの曲", "en": "Songs of the series"})
        self.assertTrue(any("アイドルマスター → アイドルマスター / THE IDOLM@STER (en の値に無い)" in w for w in warned), warned)

    def test_unknown_language_keys_warn(self):
        g = {"terms": [{"ja": "担当", "cn": "担当", "fr": "idole", "comment": "x"}],
             "style": {"fr": "x", "ja": "y"}, "extra": 1}
        warned = "\n".join(self.problems({"ja": "曲"}, g))
        self.assertIn("terms[0] (担当): 言語 cn は config.json の languages (基準言語以外) に無い (中国語の簡体字は zh-Hans", warned)
        self.assertIn("terms[0] (担当): 言語 fr は", warned)
        self.assertIn("terms[0] (担当): 未知のフィールド comment", warned)
        self.assertIn("style.fr: 言語 fr は", warned)
        self.assertIn("style.ja: 言語 ja は", warned)
        self.assertIn("未知のフィールド extra", warned)

    def test_shape_problems_warn(self):
        g = {"terms": [{"ko": "담당"}, {"ja": "担当", "en": [], "keep": "yes"}, {"ja": "担当", "ko": 3}]}
        warned = "\n".join(self.problems({"ja": "曲"}, g))
        self.assertIn("terms[0]: ja (基準言語の語) が無い", warned)
        self.assertIn("terms[1] (担当): en は空でない文字列か、その配列にする", warned)
        self.assertIn("terms[1] (担当): keep は true / false にする", warned)
        self.assertIn("terms[2] (担当): 同じ語が terms[1] にもある", warned)
        self.assertIn("terms[2] (担当): ko は空でない文字列か、その配列にする", warned)


class GateTest(unittest.TestCase):
    """出荷ゲート: beta / release の言語は ui / system に訳の欠落を残さない。"""

    def test_dev_is_not_gated(self):
        with Fixture({"songs": ns("songs", {"x": {"ja": "曲"}})}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_beta_needs_translations(self):
        catalog = {"songs": ns("songs", {"x": {"ja": "曲", "ko": "곡"}, "y": {"ja": "歌"}})}
        with Fixture(catalog, {"ja": "release", "ko": "beta"}) as fx:
            errors = messages(fx.problems(), "error")
            self.assertTrue(any("ko が beta なのに訳の欠落が 1 件 (songs)" in e for e in errors), errors)
            # content は対象外
            fx.write_json("i18n/catalog/songs.json", ns("songs", {"x": {"ja": "曲", "ko": "곡"}, "y": {"ja": "歌"}},
                                                        kind="content"))
            self.assertEqual(messages(fx.problems(), "error"), [])

    def test_planned_is_not_gated(self):
        catalog = {"songs": ns("songs", {"x": {"ja": "曲", "en": "Song"}, "y": {"ja": "歌"}})}
        with Fixture(catalog, {"ja": "release", "ko": "dev", "en": "planned", "zh-Hans": "planned"}) as fx:
            self.assertEqual(messages(fx.problems(), "error"), [])


class ConfigTest(unittest.TestCase):
    def test_unknown_language(self):
        with Fixture({}, {"ja": "release", "xx": "dev"}) as fx:
            self.assertTrue(any("生成器が知らない" in e for e in messages(fx.problems(), "error")))

    def test_source_must_be_release(self):
        with Fixture({}, {"ja": "dev"}) as fx:
            self.assertTrue(any("release にする" in e for e in messages(fx.problems(), "error")))



if __name__ == "__main__":
    unittest.main()
