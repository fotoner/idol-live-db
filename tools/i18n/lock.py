"""検収の記録 i18n/lock/<lang>.json。

検収を確定した時点の基準言語の原文のハッシュを完全キーごとに書く (i18n.py stamp)。
状態 (欠落 / 未検収 / 確定 / stale) はこの記録と今の原文から出す (model.Catalog.status)。
"""

from __future__ import annotations

import model
import source_json


def stamp(catalog, lang, namespaces=None, keys=None):
    """lang の訳を検収済みにする。返り値は (新しい lock, 書いたキー, 訳が無くて飛ばしたキー)。"""
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
        current[e.full_key] = model.ja_hash(e.source)
        stamped.append(e.full_key)
    return dict(sorted(current.items())), stamped, skipped


def write(root, lang, lock):
    source_json.write_json(root, source_json.lock_rel(lang), lock)
