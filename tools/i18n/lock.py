"""検収の記録 i18n/lock/<lang>.json。

人が訳を確かめたときに、完全キーごとに {"source": 原文の sha256, "target": 訳の sha256,
"reviewer": 名前} を書く (i18n.py stamp --reviewer)。旧形式 (値が原文のハッシュの文字列だけ) も読むが、
書くのは新しい形式だけ。stamp し直したキーは新しい形式になり、触らないキーは元の形のまま残す。

状態 (欠落 / 未検収 / 確定 / stale / edited) はこの記録と今のカタログから出す (model.Catalog.status)。
"""

from __future__ import annotations

import model
import source_json


def stamp(catalog, lang, reviewer, namespaces=None, keys=None):
    """lang の訳を reviewer が検収したことにする。

    返り値は (新しい lock (JSON に書ける dict), 書いたキー, 訳が無くて飛ばしたキー)。
    """
    current = dict(catalog.lock.get(lang, {}))
    stamped, skipped = [], []
    wanted_ns = set(namespaces or [])
    wanted_keys = set(keys or [])
    for e in catalog.entries():
        if wanted_ns and e.ns not in wanted_ns:
            continue
        if wanted_keys and e.full_key not in wanted_keys:
            continue
        if not e.has(lang):
            skipped.append(e.full_key)
            continue
        current[e.full_key] = model.Stamp(source=model.ja_hash(e.source), target=model.value_hash(e.values[lang]),
                                          reviewer=reviewer)
        stamped.append(e.full_key)
    return {k: v.to_json() for k, v in sorted(current.items())}, stamped, skipped


def write(root, lang, lock):
    source_json.write_json(root, source_json.lock_rel(lang), lock)
