"""generate が決定的で、持ち場 (出力の経路) の外を触らないこと。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import hashlib
import os
import unittest

import support
from support import Fixture, rich


def snapshot(root):
    out = {}
    for dirpath, _, filenames in os.walk(root):
        for name in filenames:
            path = os.path.join(dirpath, name)
            with open(path, "rb") as f:
                out[os.path.relpath(path, root)] = hashlib.sha256(f.read()).hexdigest()
    return out


class DeterminismTest(unittest.TestCase):
    def test_generate_twice_is_byte_identical(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            self.assertEqual(fx.run("generate")[0], 0)
            first = snapshot(fx.root)
            self.assertEqual(fx.run("generate")[0], 0)
            self.assertEqual(snapshot(fx.root), first)

    def test_emit_is_stable_and_ends_with_newline(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            a, _ = fx.emit()
            b, _ = fx.emit()
        self.assertEqual(a, b)
        for path, text in a.items():
            self.assertTrue(text.endswith("\n"), path)
            self.assertNotIn("\r", text, path)
            self.assertFalse(text.endswith("\n\n"), path)

    def test_generate_check(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            code, out = fx.run("generate", "--check")
            self.assertEqual(code, 1)
            self.assertIn("生成物が無い", out)
            fx.run("generate")
            code, out = fx.run("generate", "--check")
            self.assertEqual(code, 0, out)
            path = "ImasLiveDB/Shared/L10n/Generated/Common.xcstrings"
            fx.write(path, fx.read(path).replace("すべて見る", "全部見る"))
            fx.write("ImasLiveDB/L10n/Generated/Stray.swift", "// 手で置いた\n")
            code, out = fx.run("generate", "--check")
            self.assertEqual(code, 1)
            self.assertIn("生成物が古い: " + path, out)
            self.assertIn("余分な生成物: ImasLiveDB/L10n/Generated/Stray.swift", out)

    def test_generate_keeps_hand_code_and_removes_dropped_namespace(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            hand = {
                "ImasLiveDB/Shared/L10n/L10n.swift": "enum L10n {}\n",
                "ImasLiveDB/L10n/UserFacingError.swift": "protocol UserFacingError {}\n",
                "ImasLiveDB-Android/app/src/main/kotlin/com/fugaif/imaslivedb/i18n/DisplayText.kt": "// 手\n",
            }
            for rel, text in hand.items():
                fx.write(rel, text)
            fx.run("generate")
            self.assertTrue(fx.exists("ImasLiveDB/L10n/Generated/Events.xcstrings"))
            os.remove(fx.path("i18n/catalog/events.json"))
            self.assertEqual(fx.run("generate")[0], 0)
            self.assertFalse(fx.exists("ImasLiveDB/L10n/Generated/Events.xcstrings"))
            self.assertFalse(fx.exists("ImasLiveDB-Android/app/i18n/main/values/strings_events.xml"))
            for rel, text in hand.items():
                self.assertEqual(fx.read(rel), text, rel)

    def test_generate_refuses_broken_catalog(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            fx.run("generate")
            before = snapshot(fx.root)
            fx.write_json("i18n/catalog/songs.json", {"namespace": "songs", "kind": "ui", "strings": {"x": {"ja": "{n}曲"}}})
            code, out = fx.run("generate")
            self.assertEqual(code, 1)
            self.assertIn("生成しない", out)
            after = snapshot(fx.root)
            after.pop(os.path.join("i18n", "catalog", "songs.json"))
            self.assertEqual(after, before)


if __name__ == "__main__":
    unittest.main()
