"""tools/check_domain_purity.sh (Domain と Shared の依存ガード) の落ちる例・通る例。

    python3 -m unittest discover -s tools -p 'test_check_domain_purity.py'

一時ディレクトリに ImasLiveDB/Domain と ImasLiveDB/Shared を作り、ルートを引数に渡して走らせる。
最後に本物のリポジトリでも走らせて、今の木が新しい規則に通ることを確かめる。
"""

import os
import shutil
import subprocess
import tempfile
import unittest

TOOLS = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(TOOLS)
SCRIPT = os.path.join(TOOLS, "check_domain_purity.sh")


@unittest.skipIf(shutil.which("bash") is None, "bash が無い")
class DomainPurityTest(unittest.TestCase):
    def run_on(self, files):
        with tempfile.TemporaryDirectory() as root:
            os.makedirs(os.path.join(root, "ImasLiveDB", "Domain"))
            for rel, text in files.items():
                path = os.path.join(root, rel)
                os.makedirs(os.path.dirname(path), exist_ok=True)
                with open(path, "w", encoding="utf-8") as f:
                    f.write(text)
            r = subprocess.run(["bash", SCRIPT, root], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            return r.returncode, r.stdout.decode("utf-8")

    def assert_fails(self, rel, text, needle):
        code, out = self.run_on({rel: text})
        self.assertEqual(code, 1, "%r は落ちるはず:\n%s" % (text, out))
        self.assertIn(needle, out)

    def assert_passes(self, rel, text):
        code, out = self.run_on({rel: text})
        self.assertEqual(code, 0, "%r は通るはず:\n%s" % (text, out))

    def test_domain_forbidden_imports(self):
        for text in (
            "import SwiftUI\n",
            "@preconcurrency import SwiftUI\n",
            "@_exported import SwiftUI\n",
            "import struct SwiftUI.Text\n",
            "@_implementationOnly import GRDB\n",
            "  import CloudKit\n",
            "@_spi(Internal) import GRDB\n",
            "import SwiftUI.Text\n",
        ):
            with self.subTest(text=text):
                self.assert_fails("ImasLiveDB/Domain/UseCases/A.swift", text, "SwiftUI/GRDB/CloudKit を import")

    def test_domain_forbidden_l10n_apis(self):
        for text in (
            'let k: LocalizedStringKey = "a"\n',
            'let s = String(localized: "a")\n',
            'let s = NSLocalizedString("a", comment: "")\n',
            'let s = String(localized: r) // 解決する\n',
        ):
            with self.subTest(text=text):
                self.assert_fails("ImasLiveDB/Domain/Entities/A.swift", text, "文言を文字列に解決")

    def test_domain_allowed(self):
        for text in (
            "import Foundation\n",
            "import os\n",
            "// import SwiftUI はしない\n",
            "import SwiftUIX\n",
            "var title: LocalizedStringResource { L10n.Timeline.laneLive }\n",
            "/// String(localized:) は View で呼ぶ\n",
            "let x = 1 // NSLocalizedString は使わない\n",
        ):
            with self.subTest(text=text):
                self.assert_passes("ImasLiveDB/Domain/UseCases/A.swift", text)

    def test_shared_imports(self):
        self.assert_passes("ImasLiveDB/Shared/A.swift", "import Foundation\nimport os\nimport os.log\n")
        self.assert_passes("ImasLiveDB/Shared/L10n/DisplayText.swift",
                           "import Foundation\nlet s = String(localized: r)\n")
        for text in ("import SwiftUI\n", "import WidgetKit\n", "@preconcurrency import SwiftUI\n", "import struct SwiftUI.Text\n"):
            with self.subTest(text=text):
                self.assert_fails("ImasLiveDB/Shared/L10n/A.swift", text, "Shared 純粋性違反")

    def test_non_swift_files_are_ignored(self):
        self.assert_passes("ImasLiveDB/Domain/README.md", "import SwiftUI\n")

    def test_missing_domain_dir(self):
        with tempfile.TemporaryDirectory() as root:
            r = subprocess.run(["bash", SCRIPT, root], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            self.assertEqual(r.returncode, 2)

    def test_current_tree_passes(self):
        r = subprocess.run(["bash", SCRIPT, REPO], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        self.assertEqual(r.returncode, 0, r.stdout.decode("utf-8"))


if __name__ == "__main__":
    unittest.main()
