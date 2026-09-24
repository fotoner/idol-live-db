"""カタログの数 (i18n.py stats。Markdown で出す。CI の Job summary 用)。

- 言語 × 名前空間の 対象 / 確定 / 未検収 / stale / edited / 欠落 と網羅率 (UI: kind が ui と system だけ)。
  planned の言語も出す (訳が 1 件も無い言語は名前空間別の表を省く)
- コア由来の目印の数 (カタログの core 引数と、ソースの DisplayText.core / .core( / DisplayText.Core /
  coreText( / Text(core:) 。コア段階の置換リストの大きさ)
"""

from __future__ import annotations

import re

import model
import scan

_CORE_MARK = re.compile(r"DisplayText\.core\b|\.core\(|DisplayText\.Core\b|\bcoreText\(|\bText\(core:")


def _count(catalog, lang, namespaces):
    c = {"total": 0}
    c.update((s, 0) for s in model.STATUSES)
    for ns in namespaces:
        for e in ns.entries:
            c["total"] += 1
            c[catalog.status(e, lang)] += 1
    return c


def _pct(c):
    if not c["total"]:
        return "-"
    return "%.1f%%" % (100.0 * (c["total"] - c["missing"]) / c["total"])


# 目印の型そのものを定義しているファイル。ここの case / 定義は「コア由来の表示」ではないので数えない
CORE_MARK_DEFINITIONS = (
    "ImasLiveDB/Shared/L10n/DisplayText.swift",
    "ImasLiveDB/DesignSystem/DisplayText+SwiftUI.swift",
    "ImasLiveDB-Android/app/src/main/kotlin/com/fugaif/imaslivedb/i18n/DisplayText.kt",
)


def core_marks(root, exclude_roots=()):
    n = 0
    for rel, platform, text in scan.iter_sources(root, exclude_roots):
        if rel in CORE_MARK_DEFINITIONS:
            continue
        lexed = scan.lex(text, platform == "android")
        for code in lexed.code:
            n += len(_CORE_MARK.findall(code))
    return n


def markdown(catalog, root=None, exclude_roots=()):
    config = catalog.config
    ui = [ns for ns in catalog.namespaces if ns.kind in ("ui", "system")]
    content = [ns for ns in catalog.namespaces if ns.kind == "content"]
    keys = sum(len(ns.entries) for ns in catalog.namespaces if not ns.reserved)
    lines = ["## i18n カタログ", "",
             "名前空間 %d / キー %d (基準言語 %s)" % (
                 len([n for n in catalog.namespaces if not n.reserved]), keys, config.source_language), ""]
    lines += ["| 言語 | channel | 対象 (UI) | 確定 | 未検収 | stale | edited | 欠落 | 網羅率 |",
              "|---|---|---:|---:|---:|---:|---:|---:|---:|"]
    for lang in config.others():
        c = _count(catalog, lang, ui)
        lines.append("| %s | %s | %d | %s | %s |" % (
            lang, config.channel(lang), c["total"], " | ".join(str(c[s]) for s in model.STATUSES), _pct(c)))
    lines += ["", "- 確定: stamp のあとで原文も訳も変わっていない / stale: 原文が変わった / edited: 訳だけが変わった "
              "(旧形式の lock では出ない)。planned の言語はビルドに入らない"]
    for lang in config.others():
        if not any(e.has(lang) for e in catalog.entries()):
            lines += ["", "### %s (名前空間別)" % lang, "", "訳がまだ 1 件も無い (%s)" % config.channel(lang)]
            continue
        lines += ["", "### %s (名前空間別)" % lang, "",
                  "| 名前空間 | kind | キー | 確定 | 未検収 | stale | edited | 欠落 | 網羅率 |",
                  "|---|---|---:|---:|---:|---:|---:|---:|---:|"]
        for ns in ui + content:
            c = _count(catalog, lang, [ns])
            lines.append("| %s | %s | %d | %s | %s |" % (
                ns.name, ns.kind, c["total"], " | ".join(str(c[s]) for s in model.STATUSES), _pct(c)))
    core_args = sum(1 for e in catalog.entries() for a in e.args if a.type == "core")
    lines += ["", "### コア由来の目印", "", "- カタログの core 引数: %d" % core_args]
    if root is not None:
        lines.append("- ソースの目印 (DisplayText.core / .core( / DisplayText.Core / coreText( / Text(core:): %d"
                     % core_marks(root, exclude_roots))
    lines.append("")
    return "\n".join(lines)
