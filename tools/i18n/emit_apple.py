"""iOS への出力アダプタ: String Catalog (.xcstrings) と Swift のアクセサ。

- 名前空間ごとに表 <Table>.xcstrings と L10n+<Table>.generated.swift を 1 組。
  ios_bundles に widget があれば ImasLiveDB/Shared/L10n/Generated/ (アプリとウィジェットの両方が
  コンパイルする)、無ければ ImasLiveDB/L10n/Generated/ (アプリだけ)。
- system 名前空間の ios.infoplist の項目は、ターゲットごとの InfoPlist.xcstrings に出す
  (キーは Info.plist のキー名)。
- テスト用に ImasLiveDBTests/L10n/Generated/L10nCatalogKeys.generated.swift (全キーの見本と期待値)。

書式 (「引数の型と数の書式」(i18n/README.md)): int は String(n) にして %N$@ (桁区切りなし)、count は Int のまま %lld で
複数形の置換 (substitutions) に入れる (ロケールの桁区切りあり)、string / core / text は %N$@。
count を持つ項目は文全体を置換の中に入れる (トップの値は %#@<count>@ だけ)。こうすると
en の one / other で文の形が違っても書ける。
リテラルの % は、引数がある項目では %% に、引数が無い項目では 1 つのまま出す
(引数の無い LocalizedStringResource は書式を通らない)。
"""

from __future__ import annotations

import json

import cldr
import model

SHARED_DIR = "ImasLiveDB/Shared/L10n/Generated"
APP_DIR = "ImasLiveDB/L10n/Generated"
WIDGET_DIR = "ImasLiveDBWidget/L10n/Generated"
TESTS_DIR = "ImasLiveDBTests/L10n/Generated"
OWNED_ROOTS = (SHARED_DIR, APP_DIR, WIDGET_DIR, TESTS_DIR)
INFOPLIST_DIRS = {"app": APP_DIR, "widget": WIDGET_DIR}

COMMAND = "python3 tools/i18n/i18n.py generate"

SWIFT_TYPES = {
    "int": "Int",
    "count": "Int",
    "string": "String",
    "core": "String",
    "text": "LocalizedStringResource",
}

# 識別子に使うとき ` で囲むもの
SWIFT_KEYWORDS = frozenset("""
    associatedtype class deinit enum extension fileprivate func import init inout internal let open
    operator private precedencegroup protocol public rethrows static struct subscript typealias var
    break case catch continue default defer do else fallthrough for guard if in repeat return throw
    switch where while Any as await false is nil self Self super throws true try
""".split())


def header(source):
    return "// 生成物: %s → %s。手で直さない。" % (source, COMMAND)


def xcstrings_dumps(doc):
    """Xcode の String Catalog と同じ直列化 (キー整列・字下げ 2・" : "・末尾改行)。"""
    return json.dumps(doc, indent=2, separators=(",", " : "), sort_keys=True, ensure_ascii=False) + "\n"


def swift_string(s):
    """Swift の文字列リテラルの中身 (両端の " は付けない)。"""
    out = []
    for ch in s:
        if ch == "\\":
            out.append("\\\\")
        elif ch == '"':
            out.append('\\"')
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\t":
            out.append("\\t")
        elif ch == "\r":
            out.append("\\r")
        elif ch == "\0":
            out.append("\\0")
        elif ord(ch) < 0x20 or ch == "\x7f":
            out.append("\\u{%x}" % ord(ch))
        else:
            out.append(ch)
    return "".join(out)


def swift_ident(name):
    return "`%s`" % name if name in SWIFT_KEYWORDS else name


def ios_format(entry, segments):
    """カタログのテンプレート → 表の値 (count は置換の中なので %arg)。"""
    has_args = bool(entry.args)
    parts = []
    for kind, s in segments:
        if kind == "lit":
            parts.append(s.replace("%", "%%") if has_args else s)
        elif entry.arg(s).type == "count":
            parts.append("%arg")
        else:
            parts.append("%%%d$@" % entry.arg_position(s))
    return "".join(parts)


def _state(catalog, entry, lang):
    return "translated" if catalog.status(entry, lang) == "reviewed" else "needs_review"


def localization(catalog, entry, lang, fallback=False):
    """lang の項目。fallback のときは基準言語の値を state new で入れる (_localizations を参照)。"""
    state = "new" if fallback else _state(catalog, entry, lang)
    forms = entry.forms(catalog.config.source_language if fallback else lang)
    count = entry.count_arg
    if count is None:
        return {"stringUnit": {"state": state, "value": ios_format(entry, model.parse_template(forms["other"]))}}
    plural = {}
    for cat in cldr.categories(lang):
        if cat in forms:
            plural[cat] = {"stringUnit": {"state": state, "value": ios_format(entry, model.parse_template(forms[cat]))}}
    return {
        "stringUnit": {"state": state, "value": "%#@" + count.name + "@"},
        "substitutions": {
            count.name: {
                "argNum": entry.arg_position(count.name),
                "formatSpecifier": "lld",
                "variations": {"plural": plural},
            },
        },
    }


def comment(ns, entry, with_key=False):
    source = ns.path
    if with_key:
        source = "%s, %s" % (entry.full_key, ns.path)
    if entry.note:
        return "%s (%s)" % (entry.note, source)
    return source


def _localizations(catalog, entry):
    """訳のある言語の項目。訳の無い言語は基本は出さない (defaultValue = 基準言語に落ちる)。

    ただし引数のある項目は、訳の無い言語にも基準言語の値を state new で出す。Xcode 27.0 の
    xcstringstool は、引数のある項目で訳の無い言語の表に「キーそのもの」を値として書き、
    実行時にキーが画面に出てしまう (26.0.1 は書かなかった)。明示しておけば版によらず基準言語に落ちる。
    """
    out = {}
    for lang in catalog.config.languages:
        if entry.has(lang):
            out[lang] = localization(catalog, entry, lang)
        elif entry.args:
            out[lang] = localization(catalog, entry, lang, fallback=True)
    return out


def _document(catalog, items):
    """items: (表のキー, Namespace, Entry, キーをコメントに入れるか)。"""
    strings = {}
    for key, ns, e, with_key in items:
        strings[key] = {
            "comment": comment(ns, e, with_key),
            "extractionState": "manual",
            "localizations": _localizations(catalog, e),
        }
    return {"sourceLanguage": catalog.config.source_language, "strings": strings, "version": "1.0"}


def table_xcstrings(catalog, ns):
    return xcstrings_dumps(_document(catalog, [(e.full_key, ns, e, False) for e in ns.ios_entries()]))


def infoplist_entries(catalog, target):
    return [(ns, e) for ns in catalog.namespaces if not ns.reserved for e in ns.entries
            if e.infoplist is not None and e.infoplist[0] == target and e.on("ios")]


def infoplist_xcstrings(catalog, target):
    items = [(e.infoplist[1], ns, e, True) for ns, e in infoplist_entries(catalog, target)]
    return xcstrings_dumps(_document(catalog, items))


# ---------------------------------------------------------------- アクセサ

def summary(entry):
    """アクセサの説明 1 行: 原文 — メモ — 引数。"""
    bits = [entry.source.replace("\n", "\\n")]
    if entry.note:
        bits.append(entry.note.replace("\n", " "))
    if entry.args:
        bits.append("引数: " + ", ".join("%s (%s)" % (a.name, a.type) for a in entry.args))
    return " — ".join(bits)


def default_value(entry):
    """defaultValue の Swift リテラル (引数は補間。int は String(n) にして桁区切りを付けない)。"""
    parts = []
    for kind, s in entry.segments(entry.source_language):
        if kind == "lit":
            parts.append(swift_string(s))
            continue
        a = entry.arg(s)
        ident = swift_ident(model.camel(a.name))
        if a.type == "int":
            parts.append("\\(String(%s))" % ident)
        else:
            parts.append("\\(%s)" % ident)
    return '"%s"' % "".join(parts)


def resource_call(ns, entry):
    return 'LocalizedStringResource("%s", defaultValue: %s, table: "%s", bundle: L10n.bundle)' % (
        entry.full_key, default_value(entry), ns.table)


def accessor_swift(catalog, ns):
    lines = [
        header(ns.path),
        "import Foundation",
        "",
        "extension L10n {",
        "    /// %s の文言 (表 %s)" % (ns.path, ns.table),
        "    enum %s {" % ns.table,
    ]
    for e in ns.ios_entries():
        if e.intent_metadata:
            continue
        name = swift_ident(model.camel(e.key))
        lines.append("        /// " + summary(e))
        if e.args:
            params = ", ".join("%s: %s" % (swift_ident(model.camel(a.name)), SWIFT_TYPES[a.type]) for a in e.args)
            lines.append("        static func %s(%s) -> LocalizedStringResource {" % (name, params))
        else:
            lines.append("        static var %s: LocalizedStringResource {" % name)
        lines.append("            " + resource_call(ns, e))
        lines.append("        }")
    lines += ["    }", "}", ""]
    return "\n".join(lines)


# ---------------------------------------------------------------- テスト用の全キー

def _swift_sample_value(entry, name, value):
    if isinstance(value, model.TextSample):
        tag_ns, tag_key = value.key.split(".", 1)
        return "L10n.%s.%s" % (model.pascal(tag_ns), swift_ident(model.camel(tag_key)))
    if isinstance(value, str):
        return '"%s"' % swift_string(value)
    return str(value)


def _make_expr(ns, entry, sample):
    if entry.intent_metadata:
        return resource_call(ns, entry)
    head = "L10n.%s.%s" % (ns.table, swift_ident(model.camel(entry.key)))
    if not entry.args:
        return head
    args = ", ".join("%s: %s" % (swift_ident(model.camel(a.name)), _swift_sample_value(entry, a.name, sample[a.name]))
                     for a in entry.args)
    return "%s(%s)" % (head, args)


def _swift_array(items):
    return "[%s]" % ", ".join('"%s"' % swift_string(i) for i in items)


def _swift_dict(pairs):
    return "[%s]" % ", ".join('"%s": "%s"' % (swift_string(k), swift_string(v)) for k, v in pairs)


def test_keys_swift(catalog):
    langs = list(catalog.config.languages)
    namespaces = [ns for ns in catalog.namespaces if ns.ios_entries()]
    infoplist = [(t, ns, e) for t in ("app", "widget") for ns, e in infoplist_entries(catalog, t)]
    if not namespaces and not infoplist:
        return None
    lines = [
        header("i18n/catalog/*.json"),
        "import Foundation",
        "@testable import ImasLiveDB",
        "",
        "/// カタログの 1 キー × 見本引数 1 組と、生成器が計算した言語ごとの期待値。",
        "/// L10nCatalogTests が実行時の解決結果と比べる (書式・エスケープ・桁区切り・表の置き場所)。",
        "struct L10nCatalogSample {",
        "    /// 完全キー (<名前空間>.<相対キー>)",
        "    let key: String",
        "    /// String Catalog の表の名前",
        "    let table: String",
        "    /// 表が入るバンドル (\"app\" / \"widget\")",
        "    let bundles: [String]",
        "    /// 値を持つ言語 (基準言語と、訳のある言語)",
        "    let languagesWithValue: [String]",
        "    /// 見本の引数 (失敗メッセージ用)",
        "    let args: String",
        "    /// 見本の引数で作った文言",
        "    let make: () -> LocalizedStringResource",
        "    /// 言語 → 期待値 (訳の無い言語は基準言語へのフォールバック)",
        "    let expected: [String: String]",
        "",
        "    var sample: LocalizedStringResource { make() }",
        "}",
        "",
        "/// Info.plist の表 (InfoPlist.xcstrings) の 1 キー。key は Info.plist のキー名。",
        "struct L10nInfoPlistSample {",
        "    let catalogKey: String",
        "    /// \"app\" / \"widget\"",
        "    let target: String",
        "    let key: String",
        "    /// 言語 → 値 (値のある言語だけ)",
        "    let values: [String: String]",
        "}",
        "",
        "enum L10nCatalogKeys {",
        "    /// このカタログの言語 (基準言語が先頭)",
        "    static let languages: [String] = %s" % _swift_array(langs),
        "",
        "    /// 全キー × 見本",
    ]
    # 空の配列に var を使うと「変えていない」警告になるので、空なら [] を返すだけにする
    if namespaces:
        lines += ["    static var all: [L10nCatalogSample] {", "        var all: [L10nCatalogSample] = []"]
        lines += ["        all += samples%s()" % ns.table for ns in namespaces]
        lines += ["        return all", "    }"]
    else:
        lines.append("    static var all: [L10nCatalogSample] { [] }")
    lines += ["", "    /// Info.plist の表のキー"]
    if infoplist:
        lines += ["    static var infoPlist: [L10nInfoPlistSample] {", "        var all: [L10nInfoPlistSample] = []"]
        for target, ns, e in infoplist:
            values = [(lang, e.forms(lang)["other"]) for lang in langs if e.has(lang)]
            lines.append('        all.append(L10nInfoPlistSample(catalogKey: "%s", target: "%s", key: "%s", values: %s))' % (
                e.full_key, target, e.infoplist[1], _swift_dict(values)))
        lines += ["        return all", "    }"]
    else:
        lines.append("    static var infoPlist: [L10nInfoPlistSample] { [] }")
    for ns in namespaces:
        bundles = list(ns.ios_bundles)
        lines += ["", "    private static func samples%s() -> [L10nCatalogSample] {" % ns.table,
                  "        var s: [L10nCatalogSample] = []"]
        for e in ns.ios_entries():
            with_value = [lang for lang in langs if e.has(lang)]
            for sample in model.samples(e):
                expected = [(lang, model.render(catalog, e, lang, sample)) for lang in langs]
                lines.append(
                    '        s.append(L10nCatalogSample(key: "%s", table: "%s", bundles: %s, languagesWithValue: %s, '
                    'args: "%s", make: { %s }, expected: %s))' % (
                        e.full_key, ns.table, _swift_array(bundles), _swift_array(with_value),
                        swift_string(model.describe_sample(e, sample)), _make_expr(ns, e, sample), _swift_dict(expected)))
        lines += ["        return s", "    }"]
    lines += ["}", ""]
    return "\n".join(lines)


# ---------------------------------------------------------------- まとめ

def emit(catalog):
    """{リポジトリ相対パス: 中身}。"""
    files = {}
    for ns in catalog.namespaces:
        entries = ns.ios_entries()
        if not entries:
            continue
        d = SHARED_DIR if ns.shared else APP_DIR
        files["%s/%s.xcstrings" % (d, ns.table)] = table_xcstrings(catalog, ns)
        if any(not e.intent_metadata for e in entries):
            files["%s/L10n+%s.generated.swift" % (d, ns.table)] = accessor_swift(catalog, ns)
    for target, d in INFOPLIST_DIRS.items():
        if infoplist_entries(catalog, target):
            files["%s/InfoPlist.xcstrings" % d] = infoplist_xcstrings(catalog, target)
    tests = test_keys_swift(catalog)
    if tests is not None:
        files["%s/L10nCatalogKeys.generated.swift" % TESTS_DIR] = tests
    return files


def accessor_example(ns, entry):
    """add が出す呼び出し例。"""
    head = "L10n.%s.%s" % (ns.table, swift_ident(model.camel(entry.key)))
    if entry.intent_metadata:
        return 'LocalizedStringResource("%s", defaultValue: …, table: "%s")' % (entry.full_key, ns.table)
    if not entry.args:
        return head
    return "%s(%s)" % (head, ", ".join("%s: …" % swift_ident(model.camel(a.name)) for a in entry.args))
