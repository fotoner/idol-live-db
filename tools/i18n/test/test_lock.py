"""検収の記録 (lock v2) と翻訳の状態: missing / unreviewed / reviewed / stale / edited。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import json
import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture, messages

import model  # noqa: E402

LANGS = {"ja": "release", "ko": "dev", "en": "dev"}
COUNT = [{"name": "count", "type": "count"}]


def ns(strings):
    return {"namespace": "songs", "kind": "ui", "strings": strings}


def catalog(x=("曲", "곡"), plural=None):
    ja, ko = x
    strings = {"x": {"ja": ja, "ko": ko}, "missing": {"ja": "歌"}}
    strings["n"] = {"args": COUNT, "ja": "{count}曲",
                    "en": plural or {"one": "{count} song", "other": "{count} songs"}}
    return {"songs": ns(strings)}


class StatusTest(unittest.TestCase):
    def status(self, fx, key, lang):
        cat, problems = fx.load()
        self.assertEqual([p.format() for p in problems if p.is_error], [])
        return cat.status(cat.find(key), lang)

    def test_states(self):
        with Fixture(catalog(), LANGS) as fx:
            self.assertEqual(self.status(fx, "songs.missing", "ko"), "missing")
            self.assertEqual(self.status(fx, "songs.x", "ko"), "unreviewed")
            self.assertEqual(self.status(fx, "songs.x", "ja"), "reviewed")  # 基準言語は常に確定
            self.assertEqual(fx.run("stamp", "ko", "--reviewer", "hana")[0], 0)
            self.assertEqual(self.status(fx, "songs.x", "ko"), "reviewed")
            # 訳だけ変わった → edited
            fx.write_json("i18n/catalog/songs.json", catalog(("曲", "노래"))["songs"])
            self.assertEqual(self.status(fx, "songs.x", "ko"), "edited")
            # 原文が変わった → stale (訳が同じでも、両方変わっていても)
            fx.write_json("i18n/catalog/songs.json", catalog(("楽曲", "곡"))["songs"])
            self.assertEqual(self.status(fx, "songs.x", "ko"), "stale")
            fx.write_json("i18n/catalog/songs.json", catalog(("楽曲", "노래"))["songs"])
            self.assertEqual(self.status(fx, "songs.x", "ko"), "stale")
            # 検収し直すと確定に戻る
            self.assertEqual(fx.run("stamp", "ko", "--reviewer", "min", "--keys", "songs.x")[0], 0)
            self.assertEqual(self.status(fx, "songs.x", "ko"), "reviewed")
            self.assertEqual(json.loads(fx.read("i18n/lock/ko.json"))["songs.x"]["reviewer"], "min")

    def test_legacy_string_has_no_edited(self):
        with Fixture(catalog(), LANGS) as fx:
            fx.write_json("i18n/lock/ko.json", {"songs.x": model.ja_hash("曲")})
            self.assertEqual(self.status(fx, "songs.x", "ko"), "reviewed")
            fx.write_json("i18n/catalog/songs.json", catalog(("曲", "노래"))["songs"])
            self.assertEqual(self.status(fx, "songs.x", "ko"), "reviewed")  # 旧形式は訳の変化を見られない
            fx.write_json("i18n/catalog/songs.json", catalog(("楽曲", "노래"))["songs"])
            self.assertEqual(self.status(fx, "songs.x", "ko"), "stale")

    def test_plural_value_hash(self):
        with Fixture(catalog(), LANGS) as fx:
            self.assertEqual(fx.run("stamp", "en", "--reviewer", "sam")[0], 0)
            lock = json.loads(fx.read("i18n/lock/en.json"))
            self.assertEqual(lock["songs.n"]["target"],
                             model.value_hash({"other": "{count} songs", "one": "{count} song"}))
            self.assertEqual(self.status(fx, "songs.n", "en"), "reviewed")
            # 範疇の書き順だけが違うのは同じ訳
            fx.write_json("i18n/catalog/songs.json",
                          catalog(plural={"other": "{count} songs", "one": "{count} song"})["songs"])
            self.assertEqual(self.status(fx, "songs.n", "en"), "reviewed")
            fx.write_json("i18n/catalog/songs.json",
                          catalog(plural={"one": "one song", "other": "{count} songs"})["songs"])
            self.assertEqual(self.status(fx, "songs.n", "en"), "edited")

    def test_value_hash(self):
        self.assertEqual(model.value_hash("곡"), model.ja_hash("곡"))
        self.assertEqual(model.value_hash({"one": "a", "other": "b"}), model.value_hash({"other": "b", "one": "a"}))
        self.assertNotEqual(model.value_hash({"one": "a", "other": "b"}), model.value_hash({"one": "b", "other": "a"}))


class LockShapeTest(unittest.TestCase):
    GOOD = model.ja_hash("曲")

    def errors(self, lock):
        with Fixture(catalog(), LANGS) as fx:
            fx.write_json("i18n/lock/ko.json", lock)
            return messages(fx.problems(), "error")

    def test_accepts_both_shapes(self):
        lock = {"songs.x": {"reviewer": "hana", "source": self.GOOD, "target": model.ja_hash("곡")},
                "songs.n": self.GOOD}
        self.assertEqual(self.errors(lock), [])

    def test_rejects_broken_values(self):
        bad = [
            "abc",
            {"source": self.GOOD, "target": self.GOOD},
            {"reviewer": "hana", "source": self.GOOD, "target": "xyz"},
            {"reviewer": "", "source": self.GOOD, "target": self.GOOD},
            {"reviewer": " hana", "source": self.GOOD, "target": self.GOOD},
            {"reviewer": "ha\x01na", "source": self.GOOD, "target": self.GOOD},
            {"reviewer": "hana", "source": self.GOOD, "target": self.GOOD, "date": "2026-09-24"},
            None,
        ]
        for value in bad:
            with self.subTest(value=value):
                errors = self.errors({"songs.x": value})
                self.assertTrue(any("読めない値が 1 件 (songs.x)" in e for e in errors), errors)
        self.assertTrue(self.errors(["songs.x"]))

    def test_edited_is_counted_in_stats(self):
        with Fixture(catalog(), LANGS) as fx:
            fx.run("stamp", "ko", "--reviewer", "hana")
            fx.write_json("i18n/catalog/songs.json", catalog(("曲", "노래"))["songs"])
            code, out = fx.run("stats")
            self.assertEqual(code, 0)
            # 言語 | channel | 対象 | 確定 | 未検収 | stale | edited | 欠落 | 網羅率
            self.assertIn("| ko | dev | 3 | 0 | 0 | 0 | 1 | 2 | 33.3% |", out)


if __name__ == "__main__":
    unittest.main()
