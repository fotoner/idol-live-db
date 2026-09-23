"""scan: 日本語リテラルの数え方と禁止パターン (報告だけ)。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import json
import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture

import scan  # noqa: E402


def lines_of(text, kotlin=False, rel="ImasLiveDB/Views/A.swift"):
    report = scan.scan_file(rel, "android" if kotlin else "ios", text)
    return [line for line, _ in report.lines], report


class LexerTest(unittest.TestCase):
    def test_comments_are_not_counted(self):
        src = '\n'.join([
            '// Text("コメント")',
            '/* 複数行',
            '   Text("まだコメント") /* 入れ子 */ まだ */',
            'let a = "本物" // "後ろのコメント"',
            '/// ドキュメント',
        ])
        got, _ = lines_of(src)
        self.assertEqual(got, [4])

    def test_swift_interpolation_with_nested_strings(self):
        src = 'Text("\\(ok ? "はい" : "いいえ")件")\nlet x = "abc"\n'
        lexed = scan.lex(src)
        texts = [lit.text for lit in lexed.literals]
        self.assertIn("{}件", texts)
        self.assertIn("はい", texts)
        self.assertIn("いいえ", texts)
        got, _ = lines_of(src)
        self.assertEqual(got, [1])

    def test_swift_raw_and_multiline(self):
        src = '\n'.join([
            'let r = #"生の "文字列" \\n"#',
            'let m = """',
            '    一行目',
            '    二行目 \\(x)',
            '    """',
            'let after = "後"',
        ])
        lexed = scan.lex(src)
        texts = [lit.text for lit in lexed.literals]
        self.assertIn('生の "文字列" \\n', texts)
        self.assertTrue(any("一行目" in t and "{}" in t for t in texts), texts)
        got, _ = lines_of(src)
        self.assertEqual(got, [1, 2, 6])

    def test_kotlin_templates_and_char_literals(self):
        src = '\n'.join([
            'val q = \'"\'',
            'val s = "${if (a) "はい" else "いいえ"}と$name"',
            'val raw = """',
            '  生 $x \\n',
            '"""',
            'val c = \'曲\'',
        ])
        lexed = scan.lex(src, kotlin=True)
        texts = [lit.text for lit in lexed.literals]
        self.assertIn("{}と{}", texts)
        self.assertIn("はい", texts)
        self.assertTrue(any(t.startswith("\n  生 {}") for t in texts), texts)
        got, _ = lines_of(src, kotlin=True, rel="ImasLiveDB-Android/app/src/main/kotlin/A.kt")
        self.assertEqual(got, [2, 3])

    def test_line_numbers_survive_block_comments(self):
        src = '/*\n\n\n*/\nlet a = "日本語"\n'
        got, _ = lines_of(src)
        self.assertEqual(got, [5])


class IgnoreAndAllowTest(unittest.TestCase):
    def test_ignore_same_line_and_previous_line(self):
        src = '\n'.join([
            'let a = "保存値" // i18n-ignore(storage): CloudKit の語彙',
            '// i18n-ignore(sentinel): コアの判定',
            'let b = "欠席"',
            'let c = "残る"',
        ])
        got, report = lines_of(src)
        self.assertEqual(got, [4])
        self.assertEqual(report.forbidden, {})

    def test_ignore_without_reason_is_counted(self):
        src = 'let a = "保存値" // i18n-ignore(storage):\nlet b = "値" // i18n-ignore(unknown): 理由\n'
        got, report = lines_of(src)
        self.assertEqual(got, [1, 2])
        self.assertEqual(report.forbidden, {"ignore_without_reason": 2})

    def test_ignore_file(self):
        src = '// i18n-ignore-file(sample): プレビュー用のデータだけ\nlet a = "見本"\n'
        got, _ = lines_of(src)
        self.assertEqual(got, [])

    def test_logs_and_previews(self):
        src = '\n'.join([
            'logger.info("ログ")',
            'fatalError("落ちる")',
            '#Preview {',
            '    Text("プレビュー")',
            '}',
            'Text("本物")',
        ])
        got, _ = lines_of(src)
        self.assertEqual(got, [6])

    def test_kotlin_preview_and_log(self):
        src = '\n'.join([
            'Log.d(TAG, "ログ")',
            '@Preview(showBackground = true)',
            '@Composable',
            'private fun P() {',
            '    Text("プレビュー")',
            '}',
            'Text("本物")',
        ])
        got, _ = lines_of(src, kotlin=True, rel="ImasLiveDB-Android/app/src/main/kotlin/A.kt")
        self.assertEqual(got, [7])


class ForbiddenTest(unittest.TestCase):
    def rules(self, src, kotlin=False, rel=None):
        rel = rel or ("ImasLiveDB-Android/app/src/main/kotlin/x/A.kt" if kotlin else "ImasLiveDB/Views/A.swift")
        return scan.scan_file(rel, "android" if kotlin else "ios", src, catalog_keys={"widget.select_oshi.title"}).forbidden

    def test_swift_rules(self):
        src = '\n'.join([
            'Text(order.rawValue)',
            'let f = DateFormatter(); f.locale = Locale(identifier: "ja_JP")',
            'let w = ["日", "月", "火", "水", "木", "金", "土"]',
            'f.dateFormat = "yyyy年M月"',
            'static let cached = String(localized: "x")',
            'let r = LocalizedStringResource("common.x", defaultValue: "x")',
        ])
        got = self.rules(src)
        for rule in ("rawvalue_display", "ja_jp_formatter", "ja_weekday_array", "ja_date_pattern",
                     "static_let_localized", "localized_resource_call", "intent_key_missing"):
            self.assertIn(rule, got)

    def test_app_intent_metadata_is_allowed(self):
        src = '\n'.join([
            'static let title = LocalizedStringResource("widget.select_oshi.title", defaultValue: "担当を選ぶ", table: "Widget")',
            'static let bundle = LocalizedStringResource.BundleDescription.main',
        ])
        self.assertEqual(self.rules(src), {})

    def test_intent_key_missing(self):
        src = 'static let title = LocalizedStringResource("widget.nope", defaultValue: "x", table: "Widget")\n'
        self.assertEqual(self.rules(src), {"intent_key_missing": 1})

    def test_ja_jp_allowed_file(self):
        src = 'f.locale = Locale(identifier: "ja_JP")\n'
        self.assertEqual(self.rules(src, rel="ImasLiveDB/Services/CalendarExportService.swift"), {})

    def test_kotlin_rules(self):
        src = 'val s = context.getString(R.string.app_name)\nval w = listOf("日", "月", "火")\n'
        got = self.rules(src, kotlin=True, rel="ImasLiveDB-Android/app/src/main/kotlin/x/ui/FooViewModel.kt")
        self.assertEqual(got, {"android_r_string": 1, "android_resolve_in_vm_data": 1, "ja_weekday_array": 1})
        got = self.rules(src, kotlin=True, rel="ImasLiveDB-Android/app/src/main/kotlin/x/ui/FooScreen.kt")
        self.assertNotIn("android_resolve_in_vm_data", got)


class RepoScanTest(unittest.TestCase):
    CATALOG = {"songs": {"namespace": "songs", "kind": "ui",
                         "slices": {"ios": ["ImasLiveDB/Views/Songs/"],
                                    "android": ["ImasLiveDB-Android/app/src/main/kotlin/x/ui/songs/"]},
                         "strings": {"x": {"ja": "曲"}}}}

    def fixture(self):
        fx = Fixture(self.CATALOG)
        fx.write("ImasLiveDB/Views/Songs/SongList.swift", 'Text("曲一覧")\nText("並び替え")\n')
        fx.write("ImasLiveDB/Views/Other.swift", 'Text("その他")\n')
        fx.write("ImasLiveDB-Android/app/src/main/kotlin/x/ui/songs/SongList.kt", 'Text("曲一覧")\n')
        fx.write("ImasLiveDBTests/SongTests.swift", 'XCTAssertEqual(x, "テスト")\n')
        fx.write("ImasLiveDB-Android/app/src/test/kotlin/x/SongTest.kt", 'assertEquals("テスト", x)\n')
        fx.write("ImasLiveDB/L10n/Generated/L10n+Songs.generated.swift", 'defaultValue: "生成物"\n')
        return fx

    def test_buckets_and_exclusions(self):
        with self.fixture() as fx:
            catalog, _ = fx.load()
            result = scan.scan(fx.root, catalog, support.CLI.OWNED_ROOTS)
            buckets = {b: v["lines"] for b, v in result.buckets().items()}
            self.assertEqual(buckets, {"ios/songs": 2, "ios/_unsliced": 1, "android/songs": 1})
            self.assertEqual(result.totals(), {"ios": 3, "android": 1})

    def test_update_writes_baseline_and_split_keeps_totals(self):
        with self.fixture() as fx:
            code, out = fx.run("scan", "--update")
            self.assertEqual(code, 0, out)
            base = json.loads(fx.read("i18n/baseline/literals.json"))
            self.assertEqual(base["buckets"]["ios/songs"]["lines"], 2)
            # ファイルを 2 つに分けても、バケットの合計とリテラルの集合は同じ
            fx.write("ImasLiveDB/Views/Songs/SongList.swift", 'Text("曲一覧")\n')
            fx.write("ImasLiveDB/Views/Songs/SongSort.swift", 'Text("並び替え")\n')
            catalog, _ = fx.load()
            after = scan.scan(fx.root, catalog, support.CLI.OWNED_ROOTS).baseline()
            self.assertEqual(after["buckets"], base["buckets"])
            code, out = fx.run("scan", "--ratchet")
            self.assertEqual(code, 0)
            self.assertIn("| ios/songs | 2 | 2 | +0 |", out)

    def test_scan_never_fails_even_in_enforce(self):
        with Fixture(self.CATALOG, ratchet="enforce") as fx:
            fx.write("ImasLiveDB/Views/A.swift", 'Text("日本語")\n')
            code, out = fx.run("scan", "--ratchet")
            self.assertEqual(code, 0)
            self.assertIn("報告だけ", out)


if __name__ == "__main__":
    unittest.main()
