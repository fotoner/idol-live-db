"""Android への出力アダプタ: 文字列リソースと Kotlin のアクセサ。

- ImasLiveDB-Android/app/i18n/<overlay>/values[-xx]/strings_<ns>.xml
  main: 基準言語 (既定の values/) と channel=release の言語。
  debug: channel=dev / beta の言語 (Debug ビルドにだけ入る。beta 用の overlay は Beta 構成を作るときに足す)。
- overlay ごとに xml/locale_config.xml (その overlay までで入る言語) と
  values/i18n_meta.xml (言語が 2 つ以上なら設定画面に言語の行を出す bool)。
- アクセサ: src/main/kotlin/…/i18n/generated/L10n.kt (索引) と L10n<Ns>.kt。
- テスト用: src/test/kotlin/…/i18n/generated/L10nCatalogKeys.kt (全キーの見本と期待値)。

書式 (「引数の型と数の書式」(i18n/README.md)): int → %N$d (桁区切りなし)、count → <plurals> と %N$,d (ロケールの桁区切り)、
string / core / text → %N$s。引数のある項目のリテラル % は %%、引数の無い項目で % を含むものは
formatted="false" を付けて 1 つのまま出す (getString(id) は書式を通らない)。
"""

from __future__ import annotations

import re

import cldr
import model

APP = "ImasLiveDB-Android/app"
RES_ROOT = APP + "/i18n"
PACKAGE = "com.fugaif.imaslivedb.i18n.generated"
KOTLIN_MAIN = APP + "/src/main/kotlin/com/fugaif/imaslivedb/i18n/generated"
KOTLIN_TEST = APP + "/src/test/kotlin/com/fugaif/imaslivedb/i18n/generated"
OWNED_ROOTS = (RES_ROOT, KOTLIN_MAIN, KOTLIN_TEST)

COMMAND = "python3 tools/i18n/i18n.py generate"
META_BOOL = "i18n_language_picker_enabled"

KOTLIN_TYPES = {
    "int": "Int",
    "count": "Int",
    "string": "String",
    "core": "String",
    "text": "DisplayText",
}
SPECIFIERS = {"int": "d", "count": ",d", "string": "s", "core": "s", "text": "s"}

KOTLIN_KEYWORDS = frozenset("""
    as break class continue do else false for fun if in interface is null object package return
    super this throw true try typealias typeof val var when while
""".split())

# テストの見本を 1 関数に詰める上限 (JVM のメソッドの大きさの上限を避ける)
_CHUNK = 100


def overlay_of(config, lang):
    """lang のリソースを置く overlay (main / debug)。"""
    if lang == config.source_language or config.channel(lang) == "release":
        return "main"
    return "debug"


def overlay_languages(config, overlay):
    """overlay までで入る言語 (main は release だけ、debug は全部)。"""
    if overlay == "main":
        return config.languages_for("Release")
    return config.languages_for("Debug")


def values_dir(config, lang):
    if lang == config.source_language:
        return "values"
    if re.match(r"^[a-z]{2,3}$", lang):
        return "values-" + lang
    return "values-b+" + lang.replace("-", "+")


def android_escape(text):
    """文字列リソースの中身のエスケープ (リテラル部分だけに使う。% は呼び出し側)。"""
    out = []
    for ch in text:
        if ch == "\\":
            out.append("\\\\")
        elif ch == "'":
            out.append("\\'")
        elif ch == '"':
            out.append('\\"')
        elif ch == "&":
            out.append("&amp;")
        elif ch == "<":
            out.append("&lt;")
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\t":
            out.append("\\t")
        else:
            out.append(ch)
    return "".join(out)


def resource_text(entry, segments):
    """テンプレート → リソースの中身 (エスケープ・書式指定子・空白の囲い込み込み)。"""
    has_args = bool(entry.args)
    parts = []
    raw = []  # 空白の判定用 (エスケープ前の見た目)
    for kind, s in segments:
        if kind == "lit":
            lit = s.replace("%", "%%") if has_args else s
            parts.append(android_escape(lit))
            raw.append(s)
        else:
            a = entry.arg(s)
            parts.append("%%%d$%s" % (entry.arg_position(s), SPECIFIERS[a.type]))
            raw.append("x")
    text = "".join(parts)
    if text[:1] in ("@", "?"):
        text = "\\" + text
    plain = "".join(raw)
    if plain != plain.strip(" ") or "  " in plain:
        text = '"%s"' % text
    return text


def _formatted_false(entry, segments):
    return not entry.args and any(kind == "lit" and "%" in s for kind, s in segments)


def xml_comment(text):
    # XML コメントに "--" は書けない。"---" のような並びも残らないよう、隣り合うハイフンを全部割る
    t = re.sub(r"-(?=-)", "- ", text.replace("\n", " "))
    if t.endswith("-"):
        t += " "
    return t


def strings_xml(catalog, ns, lang):
    config = catalog.config
    src = lang == config.source_language
    lines = ['<?xml version="1.0" encoding="utf-8"?>',
             "<!-- 生成物: %s → %s。手で直さない -->" % (ns.path, COMMAND)]
    if src:
        # 訳の無い言語・キーは既定の values/ (基準言語) に落ちる設計なので MissingTranslation は出さない
        lines.append('<resources xmlns:tools="http://schemas.android.com/tools" tools:locale="%s" '
                     'tools:ignore="MissingTranslation">' % lang)
    else:
        lines.append("<resources>")
    for e in ns.android_entries():
        if not e.has(lang):
            continue
        name = model.android_name(ns.name, e.key)
        if src:
            note = "%s: %s" % (e.full_key, e.note) if e.note else e.full_key
            lines.append("    <!-- %s -->" % xml_comment(note))
        if e.count_arg is None:
            segs = e.segments(lang)
            attr = ' formatted="false"' if _formatted_false(e, segs) else ""
            lines.append('    <string name="%s"%s>%s</string>' % (name, attr, resource_text(e, segs)))
        else:
            forms = e.forms(lang)
            lines.append('    <plurals name="%s">' % name)
            for cat in cldr.categories(lang):
                if cat in forms:
                    lines.append('        <item quantity="%s">%s</item>' % (
                        cat, resource_text(e, model.parse_template(forms[cat]))))
            lines.append("    </plurals>")
    lines += ["</resources>", ""]
    return "\n".join(lines)


def locale_config_xml(config, overlay):
    lines = ['<?xml version="1.0" encoding="utf-8"?>',
             "<!-- 生成物: %s → %s。手で直さない -->" % (model.CONFIG_PATH, COMMAND),
             '<locale-config xmlns:android="http://schemas.android.com/apk/res/android">']
    for lang in overlay_languages(config, overlay):
        lines.append('    <locale android:name="%s" />' % lang)
    lines += ["</locale-config>", ""]
    return "\n".join(lines)


def meta_xml(config, overlay):
    enabled = len(overlay_languages(config, overlay)) >= 2
    return "\n".join([
        '<?xml version="1.0" encoding="utf-8"?>',
        "<!-- 生成物: %s → %s。手で直さない -->" % (model.CONFIG_PATH, COMMAND),
        "<resources>",
        "    <!-- このビルドに言語が 2 つ以上あるときだけ、設定画面に言語の行 (OS のアプリの言語へ) を出す -->",
        '    <bool name="%s">%s</bool>' % (META_BOOL, "true" if enabled else "false"),
        "</resources>",
        "",
    ])


# ---------------------------------------------------------------- Kotlin

def kotlin_ident(name):
    return "`%s`" % name if name in KOTLIN_KEYWORDS else name


def kotlin_string(s):
    out = []
    for ch in s:
        if ch == "\\":
            out.append("\\\\")
        elif ch == '"':
            out.append('\\"')
        elif ch == "$":
            out.append("\\$")
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\t":
            out.append("\\t")
        elif ch == "\r":
            out.append("\\r")
        elif ord(ch) < 0x20 or ch == "\x7f":
            out.append("\\u%04x" % ord(ch))
        else:
            out.append(ch)
    return "".join(out)


def kdoc(text):
    # Kotlin のブロックコメントは入れ子になる (/* が中にあると閉じの */ が 1 つ余計に要る) ので、
    # 閉じだけでなく開きも崩す
    return text.replace("*/", "* /").replace("/*", "/ *")


def summary(entry):
    bits = [entry.source.replace("\n", "\\n")]
    if entry.note:
        bits.append(entry.note.replace("\n", " "))
    if entry.args:
        bits.append("引数: " + ", ".join("%s (%s)" % (a.name, a.type) for a in entry.args))
    return " — ".join(bits)


def object_name(ns):
    return "L10n" + ns.table


def header(source):
    return "// 生成物: %s → %s。手で直さない。" % (source, COMMAND)


def accessor_kotlin(catalog, ns):
    lines = [
        header(ns.path),
        "package " + PACKAGE,
        "",
        "import com.fugaif.imaslivedb.R",
        "import com.fugaif.imaslivedb.i18n.DisplayText",
        "",
        "/** %s の文言。L10n.%s から引く (iOS の L10n.%s と同じ名前)。 */" % (ns.path, ns.table, ns.table),
        "object %s {" % object_name(ns),
    ]
    for e in ns.android_entries():
        name = kotlin_ident(model.camel(e.key))
        res = model.android_name(ns.name, e.key)
        lines.append("    /** %s */" % kdoc(summary(e)))
        if not e.args:
            lines.append("    val %s: DisplayText get() = DisplayText.Res(R.string.%s)" % (name, res))
            continue
        params = ", ".join("%s: %s" % (kotlin_ident(model.camel(a.name)), KOTLIN_TYPES[a.type]) for a in e.args)
        values = ", ".join(kotlin_ident(model.camel(a.name)) for a in e.args)
        count = e.count_arg
        if count is None:
            body = "DisplayText.Res(R.string.%s, listOf(%s))" % (res, values)
        else:
            body = "DisplayText.Plural(R.plurals.%s, %s, listOf(%s))" % (res, kotlin_ident(model.camel(count.name)), values)
        lines.append("    fun %s(%s): DisplayText = %s" % (name, params, body))
    lines += ["}", ""]
    return "\n".join(lines)


def index_kotlin(namespaces):
    lines = [
        header("i18n/catalog/*.json"),
        "package " + PACKAGE,
        "",
        "/**",
        " * カタログ (i18n/catalog) の文言への入口。名前空間ごとの object を同じ名前で並べる",
        " * (Kotlin の object は複数ファイルに分けて足せないため)。iOS と同じく L10n.<Ns>.<key> で引く。",
        " */",
        "object L10n {",
    ]
    for ns in namespaces:
        lines.append("    val %s: %s get() = %s" % (ns.table, object_name(ns), object_name(ns)))
    lines += ["}", ""]
    return "\n".join(lines)


def _kotlin_sample_value(value):
    if isinstance(value, model.TextSample):
        tag_ns, tag_key = value.key.split(".", 1)
        return "L10n.%s.%s" % (model.pascal(tag_ns), kotlin_ident(model.camel(tag_key)))
    if isinstance(value, str):
        return '"%s"' % kotlin_string(value)
    return str(value)


def _make_expr(ns, entry, sample):
    head = "L10n.%s.%s" % (ns.table, kotlin_ident(model.camel(entry.key)))
    if not entry.args:
        return head
    args = ", ".join("%s = %s" % (kotlin_ident(model.camel(a.name)), _kotlin_sample_value(sample[a.name]))
                     for a in entry.args)
    return "%s(%s)" % (head, args)


def _kotlin_list(items):
    return "listOf(%s)" % ", ".join('"%s"' % kotlin_string(i) for i in items)


def _kotlin_map(pairs):
    return "mapOf(%s)" % ", ".join('"%s" to "%s"' % (kotlin_string(k), kotlin_string(v)) for k, v in pairs)


def test_keys_kotlin(catalog, namespaces):
    langs = list(catalog.config.languages)
    rows = []  # (関数名, 行)
    for ns in namespaces:
        items = []
        for e in ns.android_entries():
            with_value = [lang for lang in langs if e.has(lang)]
            for sample in model.samples(e):
                expected = [(lang, model.render(catalog, e, lang, sample)) for lang in langs]
                items.append('        L10nCatalogSample("%s", "%s", %s, "%s", { %s }, %s),' % (
                    e.full_key, model.android_name(ns.name, e.key), _kotlin_list(with_value),
                    kotlin_string(model.describe_sample(e, sample)), _make_expr(ns, e, sample), _kotlin_map(expected)))
        for i in range(0, len(items), _CHUNK):
            rows.append(("%s%d" % (model.camel(ns.name), i // _CHUNK), items[i:i + _CHUNK]))
    lines = [
        header("i18n/catalog/*.json"),
        "package " + PACKAGE,
        "",
        "import com.fugaif.imaslivedb.i18n.DisplayText",
        "",
        "/**",
        " * カタログの 1 キー × 見本引数 1 組と、生成器が計算した言語ごとの期待値。",
        " * L10nCatalogJaTest / L10nCatalogKoTest が実行時の解決結果と比べる (書式・エスケープ・桁区切り・複数形)。",
        " */",
        "class L10nCatalogSample(",
        "    /** 完全キー (<名前空間>.<相対キー>) */",
        "    val key: String,",
        "    /** リソース名 (R.string / R.plurals) */",
        "    val resourceName: String,",
        "    /** 値を持つ言語 (基準言語と、訳のある言語) */",
        "    val languagesWithValue: List<String>,",
        "    /** 見本の引数 (失敗メッセージ用) */",
        "    val args: String,",
        "    /** 見本の引数で作った文言 */",
        "    val make: () -> DisplayText,",
        "    /** 言語 → 期待値 (訳の無い言語は基準言語へのフォールバック) */",
        "    val expected: Map<String, String>,",
        ") {",
        "    /** 見本の引数で作った文言 (呼ぶたびに作る) */",
        "    val text: DisplayText get() = make()",
        "",
        "    override fun toString(): String = if (args.isEmpty()) key else \"$key ($args)\"",
        "}",
        "",
        "object L10nCatalogKeys {",
        "    /** このカタログの言語 (基準言語が先頭) */",
        "    val languages: List<String> = %s" % _kotlin_list(langs),
        "",
        "    /** 全キー × 見本 */",
        "    val all: List<L10nCatalogSample>",
        "        get() = %s" % (" + ".join("%s()" % name for name, _ in rows) if rows else "emptyList()"),
    ]
    for name, items in rows:
        lines += ["", "    private fun %s(): List<L10nCatalogSample> = listOf(" % name] + items + ["    )"]
    lines += ["}", ""]
    return "\n".join(lines)


# ---------------------------------------------------------------- まとめ

def emit(catalog):
    """{リポジトリ相対パス: 中身}。"""
    config = catalog.config
    files = {}
    namespaces = [ns for ns in catalog.namespaces if ns.android_entries()]
    if not namespaces:
        return files
    for ns in namespaces:
        for lang in config.languages:
            if lang != config.source_language and not any(e.has(lang) for e in ns.android_entries()):
                continue
            path = "%s/%s/%s/strings_%s.xml" % (RES_ROOT, overlay_of(config, lang), values_dir(config, lang), ns.name)
            files[path] = strings_xml(catalog, ns, lang)
        files["%s/%s.kt" % (KOTLIN_MAIN, object_name(ns))] = accessor_kotlin(catalog, ns)
    overlays = ["main"]
    if any(overlay_of(config, lang) == "debug" for lang in config.languages):
        overlays.append("debug")
    for overlay in overlays:
        files["%s/%s/xml/locale_config.xml" % (RES_ROOT, overlay)] = locale_config_xml(config, overlay)
        files["%s/%s/values/i18n_meta.xml" % (RES_ROOT, overlay)] = meta_xml(config, overlay)
    files["%s/L10n.kt" % KOTLIN_MAIN] = index_kotlin(namespaces)
    files["%s/L10nCatalogKeys.kt" % KOTLIN_TEST] = test_keys_kotlin(catalog, namespaces)
    return files


_NAME = re.compile(r'<(?:string|plurals) name="([^"]+)"')


def invariant_problems(catalog, files):
    """規則 12: 生成したリソースの不変式。

    - values-<lang> に、既定の values/ に無い名前を書かない (ExtraTranslation は Fatal)。
    - i18n/main/ には release 言語 (と基準言語) しか無い。
    """
    config = catalog.config
    out = []
    base = {}
    for path, text in files.items():
        m = re.match(r"^%s/main/values/strings_([a-z0-9_]+)\.xml$" % re.escape(RES_ROOT), path)
        if m:
            base[m.group(1)] = set(_NAME.findall(text))
    release_dirs = {values_dir(config, lang) for lang in config.languages_for("Release")}
    for path, text in sorted(files.items()):
        m = re.match(r"^%s/([a-z]+)/(values[^/]*)/strings_([a-z0-9_]+)\.xml$" % re.escape(RES_ROOT), path)
        if not m:
            continue
        overlay, vdir, ns = m.groups()
        if overlay == "main" and vdir not in release_dirs:
            out.append(model.error(path, None, "i18n/main/ に release でない言語 (%s) がある" % vdir))
        if vdir == "values":
            if overlay != "main":
                out.append(model.error(path, None, "既定の values/ は main にだけ置く"))
            continue
        extra = sorted(set(_NAME.findall(text)) - base.get(ns, set()))
        if extra:
            out.append(model.error(path, None, "既定の values/ に無い名前を書いた (ExtraTranslation): %s" % ", ".join(extra)))
    return out


def accessor_example(ns, entry):
    head = "L10n.%s.%s" % (ns.table, kotlin_ident(model.camel(entry.key)))
    if not entry.args:
        return head
    return "%s(%s)" % (head, ", ".join("%s = …" % kotlin_ident(model.camel(a.name)) for a in entry.args))
