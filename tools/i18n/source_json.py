"""カタログの JSON を読み書きする (入力アダプタ)。

読むもの: i18n/config.json, i18n/catalog/*.json, i18n/lock/*.json, i18n/glossary.json,
i18n/baseline/parity.json。書くもの (add / stamp / scan --update): 同じ正規形
(UTF-8, 字下げ 2, キー整列, ensure_ascii=False, 末尾改行) で書く。
"""

from __future__ import annotations

import json
import os
from dataclasses import dataclass, field

import model


class CatalogFileError(Exception):
    def __init__(self, path, message):
        super().__init__("%s: %s" % (path, message))
        self.path = path
        self.message = message


def _no_duplicates(pairs):
    seen = {}
    for k, v in pairs:
        if k in seen:
            raise ValueError("キー %r が 2 回ある" % k)
        seen[k] = v
    return seen


def load_json(root, rel):
    """rel (リポジトリ相対) を読む。無ければ None。壊れていれば CatalogFileError。"""
    path = os.path.join(root, rel)
    if not os.path.exists(path):
        return None
    try:
        with open(path, encoding="utf-8") as f:
            text = f.read()
    except (OSError, UnicodeDecodeError) as e:
        raise CatalogFileError(rel, "読めない (%s)" % e)
    try:
        return json.loads(text, object_pairs_hook=_no_duplicates)
    except ValueError as e:
        raise CatalogFileError(rel, "JSON として読めない (%s)" % e)


def dumps(obj):
    """カタログ・lock・基準線の正規形。"""
    return json.dumps(obj, indent=2, sort_keys=True, ensure_ascii=False) + "\n"


def write_json(root, rel, obj):
    path = os.path.join(root, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(dumps(obj))


def catalog_rel(ns):
    return "%s/%s.json" % (model.CATALOG_DIR, ns)


def lock_rel(lang):
    return "%s/%s.json" % (model.LOCK_DIR, lang)


@dataclass
class RawRepo:
    config: object = None
    namespaces: list = field(default_factory=list)  # (相対パス, ファイル名の幹, dict)
    locks: dict = field(default_factory=dict)  # 言語 → (相対パス, dict)
    glossary: object = None
    parity_baseline: object = None


def _json_files(root, rel_dir):
    d = os.path.join(root, rel_dir)
    if not os.path.isdir(d):
        return []
    return sorted(n for n in os.listdir(d) if n.endswith(".json") and os.path.isfile(os.path.join(d, n)))


def load_repo(root, problems):
    """i18n/ を読む。読めないファイルは problems に積んで飛ばす。"""
    raw = RawRepo()

    def read(rel):
        try:
            return load_json(root, rel)
        except CatalogFileError as e:
            problems.append(model.error(e.path, None, e.message))
            return None

    raw.config = read(model.CONFIG_PATH)
    for name in _json_files(root, model.CATALOG_DIR):
        rel = "%s/%s" % (model.CATALOG_DIR, name)
        data = read(rel)
        if data is not None:
            raw.namespaces.append((rel, name[:-len(".json")], data))
    for name in _json_files(root, model.LOCK_DIR):
        rel = "%s/%s" % (model.LOCK_DIR, name)
        data = read(rel)
        if data is not None:
            raw.locks[name[:-len(".json")]] = (rel, data)
    raw.glossary = read(model.GLOSSARY_PATH)
    raw.parity_baseline = read("%s/parity.json" % model.BASELINE_DIR)
    return raw
