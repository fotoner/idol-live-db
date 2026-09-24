"""翻訳の手引き i18n/TRANSLATION.md (generate の出力の 1 つ)。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'
"""

import os
import shutil
import subprocess
import unittest

import support  # 先に読む (sys.path に tools/i18n を足す)
from support import Fixture, rich

import model  # noqa: E402
import translation_doc  # noqa: E402

DOC = model.TRANSLATION_DOC_PATH
LANGS = {"ja": "release", "ko": "dev", "en": "planned", "zh-Hans": "planned"}
GLOSSARY = {
    "status": "草案 (オーナー確定前)",
    "style": {"ko": "해요체로 쓴다", "en": "US English, sentence case"},
    "terms": [
        {"ja": "担当", "ko": "담당", "en": ["my idol", "your idol"], "zh-Hans": "担当", "note": "推しの | アイドル"},
        {"ja": "イントロクイズ", "keep": True, "note": "訳さない"},
        {"ja": "ライブ", "ko": "라이브"},
    ],
}
HAS_GIT = shutil.which("git") is not None


def fixture(namespaces=None):
    fx = Fixture(rich() if namespaces is None else namespaces, LANGS)
    fx.write_json(model.GLOSSARY_PATH, GLOSSARY)
    return fx


class ContentTest(unittest.TestCase):
    def setUp(self):
        self.fx = fixture()
        files, self.catalog = self.fx.emit()
        self.doc = files[DOC]

    def tearDown(self):
        self.fx._tmp.cleanup()

    def test_header_and_audience(self):
        self.assertTrue(self.doc.startswith("<!-- 生成物: i18n/config.json・i18n/glossary.json → "
                                            "python3 tools/i18n/i18n.py generate。手で直さない"))
        self.assertIn("# 翻訳の手引き\n", self.doc)
        for needle in ("## 誰が読むか", "AI エージェント", "Xcode 27", "AGENTS.md", "CLAUDE.md",
                       "> 用語集の状態: 草案 (オーナー確定前)"):
            self.assertIn(needle, self.doc)

    def test_general_rules(self):
        for needle in ("## 共通の規則", "プレースホルダ `{名前}` はそのまま残す", "データと固有名詞は訳さない",
                       "../CONTRIBUTING.md#2-非公式版権の遵守-絶対", "「アイマス」「アイドルマスター」",
                       "`max_len` を超えない", "`note`", "**AI は `stamp` しない。**"):
            self.assertIn(needle, self.doc)

    def test_review_states_and_promotion(self):
        self.assertIn("## 検収 (レビュー) の流れ", self.doc)
        self.assertIn("stamp ko --reviewer <名前> --ns songs", self.doc)
        # planned の言語は画面で見られない (dev に上げてから確かめる)
        self.assertIn("planned の言語 (上の「言語」の表で channel が planned のもの) はビルドに入らない", self.doc)
        for state in ("欠落 (missing)", "未検収 (unreviewed)", "確定 (reviewed)", "| stale |", "| edited |"):
            self.assertIn(state, self.doc)
        self.assertIn("## 言語を上げる条件 (channel)", self.doc)

    def test_languages_table(self):
        self.assertIn("| `ja` | 日本語 — 原文 | release | すべて | other |", self.doc)
        self.assertIn("| `en` | English (英語) | planned | どのビルドにも入らない (準備中) | one / other |", self.doc)
        self.assertIn("| `ko` | 한국어 (韓国語) | dev | Debug だけ | other |", self.doc)
        self.assertIn("| `zh-Hans` | 简体中文 (中国語・簡体字) | planned |", self.doc)

    def test_section_per_non_source_language(self):
        heads = [line for line in self.doc.splitlines() if line.startswith("### ")]
        self.assertEqual(heads, ["### en — English (英語)", "### ko — 한국어 (韓国語)", "### zh-Hans — 简体中文 (中国語・簡体字)"])
        self.assertIn("- channel: **planned** — どのビルドにも入らない (準備中)", self.doc)
        self.assertIn("- channel: **dev** — Debug だけ", self.doc)
        self.assertIn("US English, sentence case", self.doc)
        self.assertIn("(まだ無い。i18n/glossary.json の style.zh-Hans に書く)", self.doc)

    def test_terms_tables(self):
        self.assertIn("| ja | en | メモ |", self.doc)
        self.assertIn("| 担当 | my idol / your idol | 推しの \\| アイドル |", self.doc)
        self.assertIn("| 担当 | 담당 | 推しの \\| アイドル |", self.doc)
        self.assertIn("| イントロクイズ | (訳さない) イントロクイズ | 訳さない |", self.doc)
        self.assertIn("| ライブ | — |  |", self.doc)  # en の語がまだ無い
        self.assertIn("**用語** (3 語。この言語の語がまだ無いもの 1 語 = —)", self.doc)

    def test_does_not_depend_on_catalog_entries(self):
        # カタログの項目の数や中身は入れない (文言を足しても手引きは変わらない)
        data = rich()
        data["events"]["strings"]["extra"] = {"ja": "足した文言"}
        with fixture(data) as fx:
            files, _ = fx.emit()
        self.assertEqual(files[DOC], self.doc)
        self.assertEqual(translation_doc.markdown(self.catalog), self.doc)
        self.assertTrue(self.doc.endswith("|\n"))


class GenerateTest(unittest.TestCase):
    def test_generate_writes_and_check_detects_drift(self):
        with fixture() as fx:
            code, out = fx.run("generate")
            self.assertEqual(code, 0, out)
            first = fx.read(DOC)
            self.assertEqual(fx.run("generate")[0], 0)
            self.assertEqual(fx.read(DOC), first)
            self.assertEqual(fx.run("generate", "--check")[0], 0)
            fx.write(DOC, first.replace("翻訳の手引き", "手で直した"))
            code, out = fx.run("generate", "--check")
            self.assertEqual(code, 1)
            self.assertIn("生成物が古い: " + DOC, out)
            os.remove(fx.path(DOC))
            code, out = fx.run("generate", "--check")
            self.assertEqual(code, 1)
            self.assertIn("生成物が無い: " + DOC, out)

    def test_glossary_change_regenerates(self):
        with fixture() as fx:
            fx.run("generate")
            g = dict(GLOSSARY, style=dict(GLOSSARY["style"], **{"zh-Hans": "简体・全角标点"}))
            fx.write_json(model.GLOSSARY_PATH, g)
            code, out = fx.run("generate", "--check")
            self.assertEqual(code, 1)
            self.assertIn("生成物が古い: " + DOC, out)
            fx.run("generate")
            self.assertIn("简体・全角标点", fx.read(DOC))

    def test_empty_catalog_has_no_doc_and_generate_removes_it(self):
        with fixture({}) as fx:
            files, _ = fx.emit()
            self.assertNotIn(DOC, files)
        with fixture() as fx:
            fx.run("generate")
            self.assertTrue(fx.exists(DOC))
            for name in ("common", "events", "i18n", "system", "widget"):
                os.remove(fx.path("i18n/catalog/%s.json" % name))
            self.assertEqual(fx.run("generate")[0], 0)
            self.assertFalse(fx.exists(DOC))
            # 同じディレクトリの手の物は触らない
            self.assertTrue(fx.exists(model.GLOSSARY_PATH))
            self.assertTrue(fx.exists(model.CONFIG_PATH))

    @unittest.skipUnless(HAS_GIT, "git が無い")
    def test_check_committed_covers_doc(self):
        with fixture() as fx:
            subprocess.run(["git", "-C", fx.root, "init", "-q"], check=True)
            fx.run("generate")
            subprocess.run(["git", "-C", fx.root, "add", "-A"], check=True)
            subprocess.run(["git", "-C", fx.root, "rm", "-q", "--cached", DOC], check=True)
            code, out = fx.run("outputs", "--check-committed")
            self.assertEqual(code, 1)
            self.assertIn("生成物が commit されていない: " + DOC, out)
            subprocess.run(["git", "-C", fx.root, "add", DOC], check=True)
            code, out = fx.run("outputs", "--check-committed")
            self.assertEqual(code, 0, out)


if __name__ == "__main__":
    unittest.main()
