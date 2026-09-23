"""カタログの数 (i18n.py stats。Markdown で出す。CI の Job summary 用)。

- 言語 × 名前空間の 対象 / 確定 / 未検収 / stale / 欠落 と網羅率 (UI: kind が ui と system だけ)
- コア由来の目印の数 (カタログの core 引数と、ソースの DisplayText.core / .core( / DisplayText.Core /
  coreText( / Text(core:) 。コア段階の置換リストの大きさ)
"""

from __future__ import annotations

import re

import scan

_CORE_MARK = re.compile(r"DisplayText\.core\b|\.core\(|DisplayText\.Core\b|\bcoreText\(|\bText\(core:")


def _count(catalog, lang, namespaces):
    c = {"total": 0, "reviewed": 0, "unreviewed": 0, "stale": 0, "missing": 0}
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
    lines += ["| 言語 | channel | 対象 (UI) | 確定 | 未検収 | stale | 欠落 | 網羅率 |",
              "|---|---|---:|---:|---:|---:|---:|---:|"]
    for lang in config.others():
        c = _count(catalog, lang, ui)
        lines.append("| %s | %s | %d | %d | %d | %d | %d | %s |" % (
            lang, config.channel(lang), c["total"], c["reviewed"], c["unreviewed"], c["stale"], c["missing"], _pct(c)))
    for lang in config.others():
        lines += ["", "### %s (名前空間別)" % lang, "",
                  "| 名前空間 | kind | キー | 確定 | 未検収 | stale | 欠落 | 網羅率 |",
                  "|---|---|---:|---:|---:|---:|---:|---:|"]
        for ns in ui + content:
            c = _count(catalog, lang, [ns])
            lines.append("| %s | %s | %d | %d | %d | %d | %d | %s |" % (
                ns.name, ns.kind, c["total"], c["reviewed"], c["unreviewed"], c["stale"], c["missing"], _pct(c)))
    core_args = sum(1 for e in catalog.entries() for a in e.args if a.type == "core")
    lines += ["", "### コア由来の目印", "", "- カタログの core 引数: %d" % core_args]
    if root is not None:
        lines.append("- ソースの目印 (DisplayText.core / .core( / DisplayText.Core / coreText( / Text(core:): %d"
                     % core_marks(root, exclude_roots))
    lines.append("")
    return "\n".join(lines)
