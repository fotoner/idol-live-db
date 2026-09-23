"""両プラットフォームがカタログのキーをどう引いているか (i18n.py parity)。

参照の集め方 (生成物の経路とテストのディレクトリは除く。生成したテスト用の全キーは
全部を呼ぶので、含めると「誰も使っていないキー」が見えなくなる):
- Swift / Kotlin の L10n.<Ns>.<member>
- Kotlin の R.string.<名前> / R.plurals.<名前> (手のコードでは禁止だが、残っていれば数える)
- AndroidManifest.xml と res/xml/*.xml の @string/<名前>
- Swift の LocalizedStringResource("<完全キー>", …) (AppIntent / AppEntity のメタデータ)
- Info.plist の項目 (ios.infoplist) は OS が引くので iOS で使っていることにする

判定:
- 誰も使っていないキー → --strict で失敗
- platforms に両方あるのに片方でしか使っていないキーで、i18n/baseline/parity.json に無いもの
  → --strict で失敗
"""

from __future__ import annotations

import os
import re
from dataclasses import dataclass

import model
import scan

ANDROID_RES_FILES = ("ImasLiveDB-Android/app/src/main/AndroidManifest.xml",)
ANDROID_RES_XML_DIR = "ImasLiveDB-Android/app/src/main/res/xml"

_ACCESSOR = re.compile(r"\bL10n\.([A-Z][A-Za-z0-9_]*)\.`?([A-Za-z_][A-Za-z0-9_]*)`?")
_R_RES = re.compile(r"\bR\.(string|plurals)\.([a-z][a-z0-9_]*)")
_AT_STRING = re.compile(r"@string/([a-z][a-z0-9_]*)")
_DIRECT = re.compile(r"\bLocalizedStringResource\(\s*\"([a-z][a-z0-9_]*(?:\.[a-z][a-z0-9_]*)+)\"")


@dataclass
class Ref:
    platform: str  # ios / android
    kind: str  # accessor / resource / manifest / direct
    token: str  # 見つけた書き方
    path: str
    line: int
    key: str | None  # 解決できた完全キー
    ns_hint: str  # 名前空間の見当 (core 参照の検出用)


def _snake(pascal_name):
    return re.sub(r"(?<!^)(?=[A-Z])", "_", pascal_name).lower()


def _maps(catalog):
    accessors = {}  # (表名, メンバ) → 完全キー
    tables = {}  # 表名 → 名前空間
    resources = {}  # Android のリソース名 → 完全キー
    if catalog is None:
        return accessors, tables, resources
    for ns in catalog.namespaces:
        tables[ns.table] = ns.name
        for e in ns.entries:
            accessors[(ns.table, model.camel(e.key))] = e.full_key
            resources[model.android_name(ns.name, e.key)] = e.full_key
    return accessors, tables, resources


def _resource_ns(name, catalog):
    if catalog is not None:
        for ns in sorted(catalog.namespaces, key=lambda n: -len(n.name)):
            if name.startswith(ns.name + "_"):
                return ns.name
    return name.split("_", 1)[0]


def collect(root, catalog, exclude_roots=()):
    accessors, tables, resources = _maps(catalog)
    refs = []
    for rel, platform, text in scan.iter_sources(root, exclude_roots):
        lexed = scan.lex(text, platform == "android")
        for idx, code in enumerate(lexed.code):
            line = idx + 1
            for m in _ACCESSOR.finditer(code):
                table, member = m.group(1), m.group(2)
                ns = tables.get(table, _snake(table))
                refs.append(Ref(platform, "accessor", m.group(0), rel, line, accessors.get((table, member)), ns))
            if platform == "android":
                for m in _R_RES.finditer(code):
                    name = m.group(2)
                    refs.append(Ref(platform, "resource", m.group(0), rel, line, resources.get(name),
                                    _resource_ns(name, catalog)))
            else:
                for m in _DIRECT.finditer(code):
                    key = m.group(1)
                    found = key if catalog is not None and catalog.find(key) is not None else None
                    refs.append(Ref(platform, "direct", m.group(0), rel, line, found, key.split(".", 1)[0]))
    xml_files = list(ANDROID_RES_FILES)
    xml_dir = os.path.join(root, ANDROID_RES_XML_DIR)
    if os.path.isdir(xml_dir):
        xml_files += sorted("%s/%s" % (ANDROID_RES_XML_DIR, n) for n in os.listdir(xml_dir) if n.endswith(".xml"))
    for rel in xml_files:
        path = os.path.join(root, rel)
        if not os.path.isfile(path):
            continue
        with open(path, encoding="utf-8") as f:
            text = re.sub(r"<!--.*?-->", lambda m: "\n" * m.group(0).count("\n"), f.read(), flags=re.S)
        for idx, line_text in enumerate(text.split("\n")):
            for m in _AT_STRING.finditer(line_text):
                name = m.group(1)
                refs.append(Ref("android", "manifest", m.group(0), rel, idx + 1, resources.get(name),
                                _resource_ns(name, catalog)))
    return refs


@dataclass
class ParityResult:
    unused: list  # 完全キー
    one_sided: list  # (完全キー, 使っている側)
    allowed_one_sided: list  # baseline で許したもの
    stale_allowance: list  # baseline にあるが片側ではなくなったキー
    wrong_platform: list  # (完全キー, 側) platforms に無い側で使っている
    unknown: list  # カタログに無い参照 (Ref)

    @property
    def failures(self):
        return len(self.unused) + len(self.one_sided)


def evaluate(catalog, refs):
    used = {}
    unknown = []
    for r in refs:
        if r.key is None:
            if r.kind in ("accessor", "direct"):
                unknown.append(r)
            continue
        used.setdefault(r.key, set()).add(r.platform)
    unused, one_sided, allowed, wrong = [], [], [], []
    baseline = catalog.parity_baseline
    for ns in catalog.namespaces:
        if ns.reserved:
            continue
        for e in ns.entries:
            sides = set(used.get(e.full_key, set()))
            if e.infoplist is not None and e.on("ios"):
                sides.add("ios")
            for side in sorted(sides - set(e.platforms)):
                wrong.append((e.full_key, side))
            sides &= set(e.platforms)
            if not sides:
                unused.append(e.full_key)
            elif len(e.platforms) == 2 and len(sides) == 1:
                if e.full_key in baseline:
                    allowed.append(e.full_key)
                else:
                    one_sided.append((e.full_key, next(iter(sides))))
    stale = sorted(k for k in baseline if k not in allowed)
    return ParityResult(unused=unused, one_sided=one_sided, allowed_one_sided=allowed,
                        stale_allowance=stale, wrong_platform=wrong, unknown=unknown)


def report(result):
    lines = ["## i18n parity", ""]
    lines.append("- 誰も使っていないキー: %d" % len(result.unused))
    lines.append("- 片方だけで使っているキー (基準線に無い): %d" % len(result.one_sided))
    lines.append("- 片方だけで使っているキー (基準線で許可): %d" % len(result.allowed_one_sided))
    lines.append("")
    for k in result.unused:
        lines.append("✗ 誰も使っていない: %s" % k)
    for k, side in result.one_sided:
        lines.append("✗ %s でだけ使っている: %s" % (side, k))
    if result.unused or result.one_sided:
        lines.append("  → 両プラットフォームで同じ L10n.<Ns>.<key> を使う。片方だけで正しいなら"
                     " i18n/baseline/parity.json に {\"<完全キー>\": \"<理由>\"} を足す。使わないキーはカタログから消す")
    for k in result.stale_allowance:
        lines.append("⚠ i18n/baseline/parity.json の %s はもう片側だけではない (消してよい)" % k)
    for k, side in result.wrong_platform:
        lines.append("⚠ %s を platforms に無い %s で使っている" % (k, side))
    for r in result.unknown:
        lines.append("⚠ %s:%d: カタログに無い参照 %s" % (r.path, r.line, r.token))
    lines.append("")
    return "\n".join(lines)
