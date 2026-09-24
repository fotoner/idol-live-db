"""outputs (CI のドリフト検査が git add する経路) と、生成物が commit されているかの確認。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import os
import shutil
import subprocess
import unittest

import support
from support import Fixture, rich

HAS_GIT = shutil.which("git") is not None


def git(root, *args):
    subprocess.run(["git", "-C", root] + list(args), check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


class OutputsTest(unittest.TestCase):
    def test_nothing_when_no_roots(self):
        with Fixture({}) as fx:
            code, out = fx.run("outputs")
            self.assertEqual(code, 0)
            self.assertEqual(out, "")

    def test_only_existing_roots(self):
        android_only = {"widget": {"namespace": "widget", "kind": "ui", "platforms": ["android"],
                                   "strings": {"x": {"ja": "次のライブ"}}}}
        with Fixture(android_only) as fx:
            fx.run("generate")
            code, out = fx.run("outputs")
            self.assertEqual(code, 0)
            self.assertEqual(out.split(), [
                "ImasLiveDB-Android/app/i18n",
                "ImasLiveDB-Android/app/src/main/kotlin/com/fugaif/imaslivedb/i18n/generated",
                "ImasLiveDB-Android/app/src/test/kotlin/com/fugaif/imaslivedb/i18n/generated",
                "i18n/TRANSLATION.md",
            ])

    def test_all_roots_for_rich_catalog(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            fx.run("generate")
            _, out = fx.run("outputs")
            self.assertEqual(out.split(), list(support.CLI.OWNED_ROOTS) + ["i18n/TRANSLATION.md"])

    @unittest.skipUnless(HAS_GIT, "git が無い")
    def test_deleted_root_still_listed_while_in_index(self):
        # 名前空間を消して生成し直すと経路ごと消えるが、索引に残っていれば出す (削除を diff に載せるため)
        android_only = {"widget": {"namespace": "widget", "kind": "ui", "platforms": ["android"],
                                   "strings": {"x": {"ja": "次のライブ"}}}}
        with Fixture(android_only) as fx:
            git(fx.root, "init", "-q")
            fx.run("generate")
            git(fx.root, "add", "-A")
            os.remove(fx.path("i18n/catalog/widget.json"))
            fx.run("generate")
            self.assertFalse(fx.exists("ImasLiveDB-Android/app/i18n"))
            _, out = fx.run("outputs")
            self.assertIn("ImasLiveDB-Android/app/i18n", out.split())

    @unittest.skipUnless(HAS_GIT, "git が無い")
    def test_check_committed(self):
        with Fixture(rich(), support.RICH_LANGUAGES) as fx:
            git(fx.root, "init", "-q")
            fx.run("generate")
            code, out = fx.run("outputs", "--check-committed")
            self.assertEqual(code, 1)
            self.assertIn("commit されていない", out)
            git(fx.root, "add", "-A")
            code, out = fx.run("outputs", "--check-committed")
            self.assertEqual(code, 0, out)

    @unittest.skipUnless(HAS_GIT, "git が無い")
    def test_check_committed_skips_empty_catalog(self):
        with Fixture({}) as fx:
            git(fx.root, "init", "-q")
            code, out = fx.run("outputs", "--check-committed")
            self.assertEqual(code, 0, out)
            self.assertIn("カタログが空", out)


if __name__ == "__main__":
    unittest.main()
