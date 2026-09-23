"""parity: 両プラットフォームのキー参照の集め方と判定。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture

import parity  # noqa: E402

CATALOG = {
    "i18n": {"namespace": "i18n", "kind": "system", "ios_bundles": ["app", "widget"],
             "strings": {"language_tag": {"ja": "ja", "ko": "ko"}}},
    "common": {"namespace": "common", "kind": "ui", "ios_bundles": ["app", "widget"], "strings": {
        "action.see_all": {"ja": "すべて見る"},
        "action.close": {"ja": "閉じる"},
        "action.ok": {"ja": "OK"},
    }},
    "system": {"namespace": "system", "kind": "system", "strings": {
        "app.display_name": {"ios": {"infoplist": {"target": "app", "key": "CFBundleDisplayName"}}, "ja": "アイドルライブDB"},
    }},
    "widget": {"namespace": "widget", "kind": "ui", "ios_bundles": ["app", "widget"], "platforms": ["android"], "strings": {
        "next_live.name": {"ja": "次のライブ"},
        "next_live.description": {"ja": "次のライブまでの日数を表示します。"},
    }},
}

KT = "ImasLiveDB-Android/app/src/main/kotlin/com/fugaif/imaslivedb/"


def fixture():
    fx = Fixture(CATALOG)
    fx.write("ImasLiveDB/Shared/L10n/DisplayLocale.swift", "let tag = String(localized: L10n.I18n.languageTag)\n")
    fx.write(KT + "i18n/DisplayLocale.kt", "val tag = L10n.I18n.languageTag.resolve(context)\n")
    fx.write("ImasLiveDB/DesignSystem/ImasComponents.swift",
             "Text(L10n.Common.actionSeeAll)\n// Text(L10n.Common.actionOk) はコメント\n")
    fx.write(KT + "ui/components/ImasComponents.kt",
             "Text(L10n.Common.actionSeeAll.resolve())\nval c = stringResource(R.string.common_action_close)\n")
    fx.write("ImasLiveDB-Android/app/src/main/AndroidManifest.xml",
             '<application android:label="@string/system_app_display_name">\n'
             '<receiver android:label="@string/widget_next_live_name" />\n'
             '<!-- @string/widget_next_live_description はコメント -->\n</application>\n')
    fx.write("ImasLiveDB-Android/app/src/main/res/xml/next_live_widget_info.xml",
             '<appwidget-provider android:description="@string/widget_next_live_description" />\n')
    # 生成したテスト用の全キーは数えない (全部を呼ぶので「誰も使っていない」が見えなくなる)
    fx.write("ImasLiveDBTests/L10n/Generated/L10nCatalogKeys.generated.swift", "L10n.Common.actionOk\n")
    fx.write("ImasLiveDB-Android/app/src/test/kotlin/com/fugaif/imaslivedb/i18n/generated/L10nCatalogKeys.kt",
             "L10n.Common.actionOk\n")
    return fx


class ParityTest(unittest.TestCase):
    def test_collect_and_evaluate(self):
        with fixture() as fx:
            catalog, _ = fx.load()
            refs = parity.collect(fx.root, catalog, support.CLI.OWNED_ROOTS)
            kinds = {(r.kind, r.key) for r in refs}
            self.assertIn(("resource", "common.action.close"), kinds)
            self.assertIn(("manifest", "system.app.display_name"), kinds)
            self.assertIn(("manifest", "widget.next_live.description"), kinds)
            result = parity.evaluate(catalog, refs)
            self.assertEqual(result.unused, ["common.action.ok"])
            self.assertEqual(result.one_sided, [("common.action.close", "android")])

    def test_baseline_allows_one_sided(self):
        with fixture() as fx:
            fx.write_json("i18n/baseline/parity.json", {"common.action.close": "Android だけの確認ダイアログ",
                                                         "common.action.see_all": "古い許可"})
            catalog, _ = fx.load()
            result = parity.evaluate(catalog, parity.collect(fx.root, catalog, support.CLI.OWNED_ROOTS))
            self.assertEqual(result.one_sided, [])
            self.assertEqual(result.allowed_one_sided, ["common.action.close"])
            self.assertEqual(result.stale_allowance, ["common.action.see_all"])

    def test_strict_exit_code(self):
        with fixture() as fx:
            code, out = fx.run("parity")
            self.assertEqual(code, 0)
            self.assertIn("✗ 誰も使っていない: common.action.ok", out)
            code, _ = fx.run("parity", "--strict")
            self.assertEqual(code, 1)

    def test_unknown_reference(self):
        with fixture() as fx:
            fx.write("ImasLiveDB/Views/X.swift", "Text(L10n.Common.nope)\n")
            code, out = fx.run("parity")
            self.assertIn("カタログに無い参照 L10n.Common.nope", out)


if __name__ == "__main__":
    unittest.main()
