"""add / stamp / gate / stats / check の入口。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import json
import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture, rich

import model  # noqa: E402

BASE = {"i18n": support.I18N_NS}


class AddTest(unittest.TestCase):
    def test_add_writes_catalog_generates_and_prints_accessors(self):
        with Fixture(dict(BASE), support.RICH_LANGUAGES) as fx:
            code, out = fx.run("add", "songs", "list.count", "{count}曲", "--arg", "count:count",
                               "--note", "一覧の件数", "--ko", "{count}곡")
            self.assertEqual(code, 0, out)
            self.assertIn("L10n.Songs.listCount(count: …)", out)
            self.assertIn("L10n.Songs.listCount(count = …)", out)
            raw = json.loads(fx.read("i18n/catalog/songs.json"))
            self.assertEqual(raw["strings"]["list.count"], {
                "args": [{"name": "count", "type": "count"}], "ja": "{count}曲", "ko": "{count}곡", "note": "一覧の件数"})
            self.assertEqual(fx.read("i18n/catalog/songs.json"), json.dumps(raw, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
            self.assertTrue(fx.exists("ImasLiveDB/L10n/Generated/Songs.xcstrings"))
            self.assertTrue(fx.exists("ImasLiveDB-Android/app/i18n/main/values/strings_songs.xml"))

    def test_add_refuses_duplicate_and_broken(self):
        with Fixture(dict(BASE), support.RICH_LANGUAGES) as fx:
            self.assertEqual(fx.run("add", "songs", "title", "楽曲")[0], 0)
            code, out = fx.run("add", "songs", "title", "曲")
            self.assertEqual(code, 1)
            self.assertIn("もうある", out)
            before = fx.read("i18n/catalog/songs.json")
            code, out = fx.run("add", "songs", "bad", "{n}曲")
            self.assertEqual(code, 1)
            self.assertIn("書かなかった", out)
            self.assertEqual(fx.read("i18n/catalog/songs.json"), before)


class StampTest(unittest.TestCase):
    def test_stamp_namespace(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            code, out = fx.run("stamp", "ko", "--ns", "common")
            self.assertEqual(code, 0, out)
            lock = json.loads(fx.read("i18n/lock/ko.json"))
            self.assertEqual(sorted(lock), ["common.action.see_all", "common.discount", "common.list.middot"])
            self.assertEqual(lock["common.action.see_all"], model.ja_hash("すべて見る"))
            self.assertIn("訳が無くて飛ばした 7 件", out)

    def test_stamp_rejects_source_and_unknown(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            self.assertEqual(fx.run("stamp", "ja")[0], 1)
            self.assertEqual(fx.run("stamp", "fr")[0], 1)
            self.assertEqual(fx.run("stamp", "ko", "--ns", "nope")[0], 1)


class GateTest(unittest.TestCase):
    def test_gate(self):
        with Fixture({}, {"ja": "release", "ko": "dev", "en": "beta"}) as fx:
            self.assertEqual(fx.run("gate", "--config", "Release"), (0, "ja\n"))
            self.assertEqual(fx.run("gate", "--config", "Beta"), (0, "ja en\n"))
            self.assertEqual(fx.run("gate", "--config", "Debug"), (0, "ja en ko\n"))


class StatsTest(unittest.TestCase):
    def test_stats_markdown(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            fx.write("ImasLiveDB/Views/A.swift", "Text(core: song.singerLabel)\nImasSectionHeader(title: .core(x))\n")
            fx.run("stamp", "ko", "--ns", "common")
            code, out = fx.run("stats")
            self.assertEqual(code, 0)
            self.assertIn("## i18n カタログ", out)
            self.assertIn("| ko | dev |", out)
            self.assertIn("| common | ui | 10 | 3 | 0 | 0 | 7 | 30.0% |", out)
            self.assertIn("- カタログの core 引数: 1", out)
            self.assertIn("Text(core:): 2", out)


class CheckCommandTest(unittest.TestCase):
    def test_check_reports_errors_with_exit_code(self):
        with Fixture({"songs": {"namespace": "songs", "kind": "ui", "strings": {"x": {"ja": "{n}曲"}}}}) as fx:
            code, out = fx.run("check")
            self.assertEqual(code, 1)
            self.assertIn("✗ i18n/catalog/songs.json: x: ja の値に args に無い {n} がある", out)
            self.assertIn("→ 全言語の値は args の {名前} をちょうど含むこと", out)


if __name__ == "__main__":
    unittest.main()
