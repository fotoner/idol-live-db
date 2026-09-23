"""iOS の出力 (xcstrings・Swift のアクセサ・InfoPlist・テスト用の全キー)。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'

macOS で xcrun xcstringstool があれば、生成した xcstrings を実際にコンパイルする。
xcrun swiftc もあれば、生成した Swift をコンパイルして実行し、表から引いた結果が
生成器の期待値と一致することまで確かめる (無ければ飛ばす)。
"""

import json
import os
import shutil
import subprocess
import tempfile
import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture, rich

import emit_apple  # noqa: E402


def _xcrun_has(tool):
    if shutil.which("xcrun") is None:
        return False
    try:
        return subprocess.run(["xcrun", "--find", tool], stdout=subprocess.DEVNULL,
                              stderr=subprocess.DEVNULL, env=TOOL_ENV).returncode == 0
    except OSError:
        return False


# /usr/bin/python3 (Xcode の Python) は SDKROOT をコマンドラインツールの SDK に向けて起動する。
# そのまま swiftc に渡すと Xcode のコンパイラと SDK の版が食い違うので、子プロセスからは外す。
TOOL_ENV = {k: v for k, v in os.environ.items() if k not in ("SDKROOT", "CPATH", "LIBRARY_PATH")}

HAS_XCSTRINGSTOOL = _xcrun_has("xcstringstool")
HAS_SWIFTC = _xcrun_has("swiftc")

SHARED = emit_apple.SHARED_DIR
APP = emit_apple.APP_DIR


class XcstringsFormatTest(unittest.TestCase):
    def test_bytes_of_simple_table(self):
        catalog = {"common": {"namespace": "common", "kind": "ui", "ios_bundles": ["app", "widget"], "strings": {
            "action.see_all": {"note": "導線", "ja": "すべて見る", "ko": "모두 보기"}}}}
        with Fixture(catalog) as fx:
            files, _ = fx.emit()
        expected = (
            '{\n'
            '  "sourceLanguage" : "ja",\n'
            '  "strings" : {\n'
            '    "common.action.see_all" : {\n'
            '      "comment" : "導線 (i18n/catalog/common.json)",\n'
            '      "extractionState" : "manual",\n'
            '      "localizations" : {\n'
            '        "ja" : {\n'
            '          "stringUnit" : {\n'
            '            "state" : "translated",\n'
            '            "value" : "すべて見る"\n'
            '          }\n'
            '        },\n'
            '        "ko" : {\n'
            '          "stringUnit" : {\n'
            '            "state" : "needs_review",\n'
            '            "value" : "모두 보기"\n'
            '          }\n'
            '        }\n'
            '      }\n'
            '    }\n'
            '  },\n'
            '  "version" : "1.0"\n'
            '}\n'
        )
        self.assertEqual(files[SHARED + "/Common.xcstrings"], expected)

    def setUp(self):
        self.fx = Fixture(rich(), support.RICH_LANGUAGES)
        self.files, self.catalog = self.fx.emit()

    def tearDown(self):
        self.fx._tmp.cleanup()

    def table(self, path):
        return json.loads(self.files[path])["strings"]

    def test_placement(self):
        self.assertIn(SHARED + "/Common.xcstrings", self.files)
        self.assertIn(SHARED + "/L10n+Common.generated.swift", self.files)
        self.assertIn(SHARED + "/I18n.xcstrings", self.files)
        self.assertIn(APP + "/Events.xcstrings", self.files)
        self.assertIn(APP + "/L10n+Events.generated.swift", self.files)
        # Android だけの名前空間は iOS に出さない。Info.plist の項目は System 表にしない
        self.assertFalse(any(p.endswith(("/Widget.xcstrings", "/L10n+Widget.generated.swift")) for p in self.files))
        self.assertNotIn(APP + "/System.xcstrings", self.files)

    def test_plural_substitution(self):
        e = self.table(APP + "/Events.xcstrings")["events.attendance.group_header"]
        ja = e["localizations"]["ja"]
        self.assertEqual(ja["stringUnit"]["value"], "%#@count@")
        sub = ja["substitutions"]["count"]
        self.assertEqual(sub["argNum"], 2)
        self.assertEqual(sub["formatSpecifier"], "lld")
        self.assertEqual(sub["variations"]["plural"]["other"]["stringUnit"]["value"], "%1$@ ・ %arg名")
        en = e["localizations"]["en"]["substitutions"]["count"]["variations"]["plural"]
        self.assertEqual(en["one"]["stringUnit"]["value"], "%arg member in %1$@")
        self.assertEqual(en["other"]["stringUnit"]["value"], "%arg members in %1$@")
        self.assertEqual(list(en), ["one", "other"])

    def test_percent_rules(self):
        common = self.table(SHARED + "/Common.xcstrings")
        # 引数の無い項目は % 1 つ (書式を通らない)
        self.assertEqual(common["common.discount"]["localizations"]["ja"]["stringUnit"]["value"], "50%オフ")
        # 引数のある項目は %%
        events = self.table(APP + "/Events.xcstrings")
        self.assertEqual(events["events.rate"]["localizations"]["ja"]["stringUnit"]["value"], "%1$@の達成率 100%%")

    def test_int_is_string_placeholder(self):
        events = self.table(APP + "/Events.xcstrings")
        self.assertEqual(events["events.detail.first_show_year"]["localizations"]["ja"]["stringUnit"]["value"], "%1$@年")
        swift = self.files[APP + "/L10n+Events.generated.swift"]
        self.assertIn('static func detailFirstShowYear(year: Int) -> LocalizedStringResource {', swift)
        self.assertIn('defaultValue: "\\(String(year))年"', swift)
        self.assertIn('static func attendanceGroupHeader(label: String, count: Int) -> LocalizedStringResource {', swift)
        self.assertIn('defaultValue: "\\(label) ・ \\(count)名"', swift)
        self.assertIn('static func nested(inner: LocalizedStringResource) -> LocalizedStringResource {', swift)

    def test_missing_translation_is_left_out(self):
        events = self.table(APP + "/Events.xcstrings")
        self.assertEqual(sorted(events["events.only_ja"]["localizations"]), ["ja"])

    def test_braces_and_escapes_in_swift(self):
        swift = self.files[SHARED + "/L10n+Common.generated.swift"]
        self.assertIn('defaultValue: "@担当 \'です\' \\"引用\\" & <b>"', swift)
        self.assertIn('defaultValue: "一行目\\n二行目"', swift)
        self.assertIn('defaultValue: "a\\\\b"', swift)
        self.assertIn('defaultValue: "{そのまま}"', swift)
        self.assertIn("static var `default`: LocalizedStringResource {", swift)
        common = self.table(SHARED + "/Common.xcstrings")
        self.assertEqual(common["common.sym.braces"]["localizations"]["ja"]["stringUnit"]["value"], "{そのまま}")

    def test_accessor_shape(self):
        swift = self.files[SHARED + "/L10n+Common.generated.swift"]
        self.assertTrue(swift.startswith("// 生成物: i18n/catalog/common.json → python3 tools/i18n/i18n.py generate。"))
        self.assertIn("extension L10n {\n", swift)
        self.assertIn("    enum Common {\n", swift)
        self.assertIn('LocalizedStringResource("common.action.see_all", defaultValue: "すべて見る", table: "Common", '
                      'bundle: L10n.bundle)', swift)
        self.assertTrue(swift.endswith("}\n"))

    def test_infoplist_tables(self):
        app = self.table(APP + "/InfoPlist.xcstrings")
        self.assertEqual(sorted(app), ["CFBundleDisplayName", "NSCameraUsageDescription"])
        self.assertEqual(app["CFBundleDisplayName"]["localizations"]["ko"]["stringUnit"]["value"], "아이돌 라이브 DB")
        self.assertIn("system.app.display_name", app["CFBundleDisplayName"]["comment"])
        widget = self.table(emit_apple.WIDGET_DIR + "/InfoPlist.xcstrings")
        self.assertEqual(sorted(widget), ["CFBundleDisplayName"])
        self.assertEqual(widget["CFBundleDisplayName"]["localizations"]["ja"]["stringUnit"]["value"], "担当ウィジェット")

    def test_every_entry_is_manual(self):
        for path, text in self.files.items():
            if path.endswith(".xcstrings"):
                for key, e in json.loads(text)["strings"].items():
                    self.assertEqual(e["extractionState"], "manual", key)

    def test_test_keys_file(self):
        keys = self.files[emit_apple.TESTS_DIR + "/L10nCatalogKeys.generated.swift"]
        self.assertIn("@testable import ImasLiveDB", keys)
        # count は 1 / 3 / 1234 の 3 組、期待値は「引数の型と数の書式」(i18n/README.md)のとおり
        self.assertEqual(keys.count('key: "events.songs"'), 3)
        self.assertIn('make: { L10n.Events.songs(count: 1234) }, expected: ["ja": "1,234曲", "en": "1,234 songs", '
                      '"ko": "1,234곡"]', keys)
        self.assertIn('make: { L10n.Events.detailFirstShowYear(year: 2026) }, expected: ["ja": "2026年", '
                      '"en": "2026年", "ko": "2026년"]', keys)
        self.assertIn('make: { L10n.Events.nested(inner: L10n.I18n.languageTag) }, expected: ["ja": "言語: ja", '
                      '"en": "言語: en", "ko": "언어: ko"]', keys)
        self.assertIn('catalogKey: "system.widget_extension.display_name", target: "widget", key: "CFBundleDisplayName"', keys)


class LockStateTest(unittest.TestCase):
    def test_state_follows_lock(self):
        catalog = {"common": {"namespace": "common", "kind": "ui", "strings": {"x": {"ja": "曲", "ko": "곡"}}}}
        with Fixture(catalog) as fx:
            def state():
                files, _ = fx.emit()
                return json.loads(files[APP + "/Common.xcstrings"])["strings"]["common.x"]["localizations"]["ko"]["stringUnit"]["state"]
            self.assertEqual(state(), "needs_review")
            self.assertEqual(fx.run("stamp", "ko")[0], 0)
            self.assertEqual(state(), "translated")
            fx.write_json("i18n/catalog/common.json",
                          {"namespace": "common", "kind": "ui", "strings": {"x": {"ja": "楽曲", "ko": "곡"}}})
            self.assertEqual(state(), "needs_review")  # stale


class IntentMetadataTest(unittest.TestCase):
    def test_in_table_without_accessor(self):
        catalog = {
            "i18n": support.I18N_NS,
            "widget": {"namespace": "widget", "kind": "ui", "ios_bundles": ["app", "widget"], "strings": {
                "select_oshi.title": {"platforms": ["ios"], "ios": {"intent_metadata": True}, "ja": "担当を選ぶ"}}},
        }
        with Fixture(catalog, support.RICH_LANGUAGES) as fx:
            files, _ = fx.emit()
        self.assertIn(SHARED + "/Widget.xcstrings", files)
        self.assertNotIn(SHARED + "/L10n+Widget.generated.swift", files)
        keys = files[emit_apple.TESTS_DIR + "/L10nCatalogKeys.generated.swift"]
        self.assertIn('make: { LocalizedStringResource("widget.select_oshi.title", defaultValue: "担当を選ぶ", '
                      'table: "Widget", bundle: L10n.bundle) }', keys)


@unittest.skipUnless(HAS_XCSTRINGSTOOL, "xcrun xcstringstool が無い")
class XcstringstoolCompileTest(unittest.TestCase):
    def test_generated_tables_compile(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            files, _ = fx.emit()
            tables = [p for p in files if p.endswith(".xcstrings")]
            self.assertTrue(tables)
            for path in tables:
                with self.subTest(path=path), tempfile.TemporaryDirectory() as out:
                    src = fx.path(path)
                    os.makedirs(os.path.dirname(src), exist_ok=True)
                    with open(src, "w", encoding="utf-8") as f:
                        f.write(files[path])
                    r = subprocess.run(["xcrun", "xcstringstool", "compile", src, "--output-directory", out],
                                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=TOOL_ENV)
                    self.assertEqual(r.returncode, 0, r.stdout.decode("utf-8", "replace"))
                    self.assertTrue(os.path.isdir(os.path.join(out, "ja.lproj")), os.listdir(out))

    def test_release_gate_compiles_only_ja(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx, tempfile.TemporaryDirectory() as out:
            files, _ = fx.emit()
            src = os.path.join(out, "Events.xcstrings")
            with open(src, "w", encoding="utf-8") as f:
                f.write(files[APP + "/Events.xcstrings"])
            r = subprocess.run(["xcrun", "xcstringstool", "compile", src, "--output-directory", out, "-l", "ja"],
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=TOOL_ENV)
            self.assertEqual(r.returncode, 0, r.stdout.decode("utf-8", "replace"))
            self.assertEqual(sorted(n for n in os.listdir(out) if n.endswith(".lproj")), ["ja.lproj"])


_RUNNER = r'''
import Foundation

enum L10n {
    static let bundle = LocalizedStringResource.BundleDescription.atURL(
        URL(fileURLWithPath: CommandLine.arguments[1]))
}

var failures = 0
var checked = 0
for e in L10nCatalogKeys.all {
    for (lang, expected) in e.expected {
        var r = e.sample
        r.locale = Locale(identifier: lang)
        let got = String(localized: r)
        checked += 1
        if got != expected {
            failures += 1
            print("NG \(e.key) [\(lang)] \(e.args): got \(got.debugDescription) want \(expected.debugDescription)")
        }
    }
}
print("checked \(checked) failures \(failures)")
exit(failures == 0 && checked > 0 ? 0 : 1)
'''


@unittest.skipUnless(HAS_XCSTRINGSTOOL and HAS_SWIFTC, "xcrun xcstringstool / swiftc が無い")
class SwiftRuntimeTest(unittest.TestCase):
    """生成した表とアクセサを macOS の Foundation で実際に引き、生成器の期待値と比べる。"""

    def test_rendered_values_match_generator(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx, tempfile.TemporaryDirectory() as work:
            files, _ = fx.emit()
            bundle = os.path.join(work, "bundle")
            os.makedirs(bundle)
            sources = []
            for path, text in files.items():
                name = os.path.basename(path)
                if path.endswith(".xcstrings") and name != "InfoPlist.xcstrings":
                    src = os.path.join(work, name)
                    with open(src, "w", encoding="utf-8") as f:
                        f.write(text)
                    r = subprocess.run(["xcrun", "xcstringstool", "compile", src, "--output-directory", bundle],
                                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=TOOL_ENV)
                    self.assertEqual(r.returncode, 0, r.stdout.decode("utf-8", "replace"))
                elif path.endswith(".swift"):
                    src = os.path.join(work, name)
                    with open(src, "w", encoding="utf-8") as f:
                        f.write(text.replace("@testable import ImasLiveDB\n", ""))
                    sources.append(src)
            main = os.path.join(work, "main.swift")
            with open(main, "w", encoding="utf-8") as f:
                f.write(_RUNNER)
            exe = os.path.join(work, "runner")
            # アプリと同じ Swift 6 + 厳格な並行性で、警告も失敗にする (生成物が警告を出さないこと)
            r = subprocess.run(["xcrun", "swiftc", "-swift-version", "6", "-strict-concurrency=complete",
                                "-warnings-as-errors", "-o", exe, main] + sources,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=TOOL_ENV)
            self.assertEqual(r.returncode, 0, r.stdout.decode("utf-8", "replace"))
            r = subprocess.run([exe, bundle], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=TOOL_ENV)
            self.assertEqual(r.returncode, 0, r.stdout.decode("utf-8", "replace"))


if __name__ == "__main__":
    unittest.main()
