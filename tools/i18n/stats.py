"""カタログの数 (i18n.py stats。Markdown で出す)。

言語 × 名前空間の 対象 / 訳あり / 欠落 と網羅率 (UI: kind が ui と system だけ)。
planned の言語も出す (訳が 1 件も無い言語は名前空間別の表を省く)。
"""

from __future__ import annotations


def _count(lang, namespaces):
    total = sum(len(ns.entries) for ns in namespaces)
    done = sum(1 for ns in namespaces for e in ns.entries if e.has(lang))
    return total, done


def _pct(total, done):
    if not total:
        return "-"
    return "%.1f%%" % (100.0 * done / total)


def markdown(catalog):
    config = catalog.config
    ui = [ns for ns in catalog.namespaces if ns.kind in ("ui", "system")]
    content = [ns for ns in catalog.namespaces if ns.kind == "content"]
    keys = sum(len(ns.entries) for ns in catalog.namespaces)
    lines = ["## i18n カタログ", "",
             "名前空間 %d / キー %d (基準言語 %s)" % (len(catalog.namespaces), keys, config.source_language), ""]
    lines += ["| 言語 | channel | 対象 (UI) | 訳あり | 欠落 | 網羅率 |",
              "|---|---|---:|---:|---:|---:|"]
    for lang in config.others():
        total, done = _count(lang, ui)
        lines.append("| %s | %s | %d | %d | %d | %s |" % (
            lang, config.channel(lang), total, done, total - done, _pct(total, done)))
    lines += ["", "- planned の言語はビルドに入らない"]
    for lang in config.others():
        lines += ["", "### %s (名前空間別)" % lang, ""]
        if not any(e.has(lang) for e in catalog.entries()):
            lines.append("訳がまだ 1 件も無い (%s)" % config.channel(lang))
            continue
        lines += ["| 名前空間 | kind | キー | 訳あり | 欠落 | 網羅率 |",
                  "|---|---|---:|---:|---:|---:|"]
        for ns in ui + content:
            total, done = _count(lang, [ns])
            lines.append("| %s | %s | %d | %d | %d | %s |" % (
                ns.name, ns.kind, total, done, total - done, _pct(total, done)))
    lines.append("")
    return "\n".join(lines)
