"""カタログの意味の検査 (i18n.py check の本体)。

形の検査 (型・未知のフィールド) は model.build が済ませている。ここは組めたカタログに対して
規則 1〜10, 13 を当てる。規則 12 (生成物の不変式) は emit_android.invariant_problems、
規則 11 (移行マニフェスト) はまだ無い。

機械で白黒が付くもの (プレースホルダの組・max_len・出荷ゲート) はエラー、判断の要るもの
(用語集・仮名の混じり・複数形の範疇の不足) は警告にする。

外部の入力 (project.yml の本文、ソースの参照) は呼び出し側が渡す。ここではファイルを読まない。
"""

from __future__ import annotations

import re

import cldr
import model
from model import error, warning

# 規則 4: コードから写し間違えたプラットフォームの書式
_PLATFORM_SYNTAX = [
    # %,d (Android の桁区切り) / %.1f / %i なども拾う。"100%" や "50%オフ" のような素の % は通す
    (re.compile(r"%(?:\d+\$)?[-+ 0#,]*\d*(?:\.\d+)?(?:ll|l|h|q)?[@dDiuUxXoOfFeEgGcCsSp]"),
     "%@ / %d / %s / %lld / %,d / %f (プラットフォームの書式指定子)"),
    (re.compile(r"\\\("), "\\( (Swift の文字列補間)"),
    (re.compile(r"\$\{"), "${ (Kotlin の文字列テンプレート)"),
    (re.compile(r"\$\d"), "$1 (位置引数の書き方)"),
]

_KANA = re.compile(r"[\u3040-\u309f\u30a0-\u30fa\u30fc-\u30ff\uff66-\uff9f]")
_BAD_CONTROL = re.compile(r"[\x00-\x09\x0b-\x1f\x7f]")
_EDGE_SPACE = " \t\n\u3000"

# アクセサ名に使えない (Swift の enum の中で宣言できない / 意味が変わる)
_FORBIDDEN_MEMBERS = ("self", "init", "deinit", "subscript")


def validate(catalog, project_yml=None, refs=None, external=True):
    """問題の一覧を返す。external=False なら project.yml とソース参照の規則 (8, 13 の後半) を飛ばす。"""
    out = []
    _names(catalog, out)
    _glossary_shape(catalog, out)
    glossary_terms = _glossary_terms(catalog.glossary)
    infoplist_seen = {}
    for ns in catalog.namespaces:
        _namespace_rules(ns, out)
        for e in ns.entries:
            _values(catalog, ns, e, out)
            _platform_rules(catalog, ns, e, out, infoplist_seen)
            _quality(catalog, ns, e, glossary_terms, out)
    _text_sample(catalog, out)
    _gate(catalog, out)
    _lock(catalog, out)
    if external:
        if ios_outputs(catalog):
            _project_yml(catalog, project_yml, out)
        _core_refs(refs or [], out)
    return out


def ios_outputs(catalog):
    """iOS に出す項目 (表・Info.plist) が 1 つでもあるか。規則 8 はそのときだけ起きる。"""
    return any(e.on("ios") for ns in catalog.namespaces if not ns.reserved for e in ns.entries)


# ---------------------------------------------------------------- 規則 1: 名前

def _names(catalog, out):
    tables = {}
    android = {}
    for ns in catalog.namespaces:
        t = ns.table
        if t in model.RESERVED_TABLES:
            out.append(error(ns.path, None, "名前空間 %s の表名 %s は Xcode の予約名なので使えない" % (ns.name, t)))
        if t in tables:
            out.append(error(ns.path, None, "表名・アクセサの型名 %s が名前空間 %s とぶつかる" % (t, tables[t])))
        tables[t] = ns.name
        members = {}
        for e in ns.entries:
            if not model.KEY_RE.match(e.key):
                out.append(error(ns.path, e.key, "キーの書式が違う",
                                 "英小文字で始まるセグメントを . でつなぐ (最大 4 段)。例: list.sort_title / preset.steps3"))
                continue
            member = model.camel(e.key)
            if member in _FORBIDDEN_MEMBERS:
                out.append(error(ns.path, e.key, "アクセサ名 %s は Swift で使えない" % member))
            if member in members:
                out.append(error(ns.path, e.key, "アクセサ名 %s が %s とぶつかる" % (member, members[member]),
                                 "キーの _ と . を入れ替えただけの 2 つは同じ名前になる"))
            members[member] = e.full_key
            res = model.android_name(ns.name, e.key)
            if res in android:
                out.append(error(ns.path, e.key, "Android のリソース名 %s が %s とぶつかる" % (res, android[res])))
            android[res] = e.full_key
            params = {}
            for a in e.args:
                p = model.camel(a.name)
                if p in params:
                    out.append(error(ns.path, e.key, "引数 %s と %s が同じ引数名 %s になる" % (params[p], a.name, p)))
                params[p] = a.name


def _namespace_rules(ns, out):
    if ns.name == "core" and ns.kind != "reserved":
        out.append(error(ns.path, None, "core 名前空間は kind: reserved にする (コア段階用。アクセサは作らない)"))
    if ns.kind == "reserved" and ns.name != "core":
        out.append(error(ns.path, None, "kind: reserved は core 名前空間だけ"))


# ---------------------------------------------------------------- 規則 2〜6: 値

def _values(catalog, ns, e, out):
    config = catalog.config
    src = config.source_language
    arg_names = [a.name for a in e.args]
    count = e.count_arg
    counts = [a for a in e.args if a.type == "count"]
    if len(counts) > 1:
        out.append(error(ns.path, e.key, "count 引数は 1 キーに 1 つまで (複数形の選択子になる)"))

    for lang in e.values:
        value = e.values[lang]
        if isinstance(value, dict):
            if lang == src:
                out.append(error(ns.path, e.key, "%s は文字列で書く (複数形でも %s は other だけ)" % (src, src)))
                continue
            if count is None:
                out.append(error(ns.path, e.key, "%s が複数形のオブジェクトだが count 引数が無い" % lang))
                continue
            allowed = cldr.categories(lang)
            bad = [c for c in value if c not in allowed]
            if bad:
                out.append(error(ns.path, e.key, "%s の範疇 %s は CLDR に無い (使えるのは %s)" % (
                    lang, ", ".join(bad), ", ".join(allowed))))
                continue
            if "other" not in value:
                out.append(error(ns.path, e.key, "%s の複数形に other が無い" % lang))
                continue
        forms = e.forms(lang)
        if count is not None:
            missing = [c for c in cldr.categories(lang) if c not in forms]
            if missing:
                out.append(warning(ns.path, e.key, "%s の複数形に %s が無い (other で出る)" % (lang, ", ".join(missing)),
                                   "%s の範疇は %s。例: {%s}" % (lang, " / ".join(cldr.categories(lang)), ", ".join(
                                       '"%s": "…"' % c for c in cldr.categories(lang)))))
        for cat, text in forms.items():
            label = lang if isinstance(value, str) else "%s.%s" % (lang, cat)
            _text_rules(ns, e, label, text, out)
            try:
                segs = model.parse_template(text)
            except model.TemplateError as ex:
                out.append(error(ns.path, e.key, "%s の値: %s" % (label, ex)))
                continue
            used = model.placeholders(segs)
            unknown = [p for p in used if p not in arg_names]
            if unknown:
                out.append(error(ns.path, e.key, "%s の値に args に無い {%s} がある (args: %s)" % (
                    label, "}, {".join(dict.fromkeys(unknown)), ", ".join(arg_names) or "なし"),
                    "全言語の値は args の {名前} をちょうど含むこと"))
                continue
            if lang == src:
                if sorted(used) != sorted(arg_names):
                    out.append(error(ns.path, e.key, "%s の値は各引数を 1 回ずつ使う (使っている: %s / args: %s)" % (
                        label, ", ".join(used) or "なし", ", ".join(arg_names) or "なし")))
                elif used != arg_names:
                    out.append(error(ns.path, e.key, "args の順番 (%s) が %s に出る順番 (%s) と違う" % (
                        ", ".join(arg_names), src, ", ".join(used)),
                        "args は %s に最初に出る順に並べる (iOS の引数の位置がこの順になる)" % src))
                continue
            need = set(arg_names)
            got = set(used)
            if got == need:
                continue
            if cat != "other" and count is not None and got == need - {count.name}:
                continue
            missing = [a for a in arg_names if a not in got]
            out.append(error(ns.path, e.key, "%s の値に {%s} がない (args: %s)" % (
                label, "}, {".join(missing), ", ".join(arg_names)),
                "全言語の値は args の {名前} をちょうど含むこと (other 以外の範疇は count を省いてよい)"))


def _text_rules(ns, e, label, text, out):
    for rx, what in _PLATFORM_SYNTAX:
        if rx.search(text):
            out.append(error(ns.path, e.key, "%s の値に %s がある" % (label, what),
                             "引数は {名前} で書く。コードから写すときに残った書式を消す"))
    if _BAD_CONTROL.search(text):
        out.append(error(ns.path, e.key, "%s の値に改行 (\\n) 以外の制御文字がある (タブ・CR など)" % label))
    if not e.keep_whitespace and text and (text[0] in _EDGE_SPACE or text[-1] in _EDGE_SPACE):
        out.append(error(ns.path, e.key, "%s の値の前後に空白がある" % label,
                         "区切り記号など前後の空白が要るなら keep_whitespace: true"))


# ---------------------------------------------------------------- 規則 7: プラットフォームと束

def _platform_rules(catalog, ns, e, out, infoplist_seen):
    if e.infoplist is not None:
        if ns.name != "system":
            out.append(error(ns.path, e.key, "ios.infoplist は system 名前空間でだけ使える"))
        if not e.on("ios"):
            out.append(error(ns.path, e.key, "ios.infoplist があるのに platforms に ios が無い"))
        if e.args:
            out.append(error(ns.path, e.key, "Info.plist の文言は引数を持てない"))
        if e.intent_metadata:
            out.append(error(ns.path, e.key, "ios.infoplist と ios.intent_metadata は同じ項目に書けない"))
        if e.infoplist in infoplist_seen:
            out.append(error(ns.path, e.key, "Info.plist の %s (%s) が %s と重なる" % (
                e.infoplist[1], e.infoplist[0], infoplist_seen[e.infoplist])))
        infoplist_seen[e.infoplist] = e.full_key
    if e.intent_metadata:
        if "widget" not in ns.ios_bundles:
            out.append(error(ns.path, e.key, "ios.intent_metadata のキーは ios_bundles に widget がある名前空間に置く"))
        if not e.on("ios"):
            out.append(error(ns.path, e.key, "ios.intent_metadata があるのに platforms に ios が無い"))
        if e.args:
            out.append(error(ns.path, e.key, "AppIntent / AppEntity のメタデータは引数を持てない"))


# ---------------------------------------------------------------- 規則 9: 品質 (max_len はエラー、ほかは警告)

def _glossary_shape(catalog, out):
    """用語集 (i18n/glossary.json) の形。草案なので崩れていても警告だけにする (check は落とさない)。"""
    g = catalog.glossary
    where = model.GLOSSARY_PATH
    if not g:
        return
    config = catalog.config
    for k in g:
        if k not in model.GLOSSARY_FIELDS:
            out.append(warning(where, None, "未知のフィールド %s (使えるのは %s)" % (k, ", ".join(model.GLOSSARY_FIELDS))))
    style = g.get("style", {})
    if not isinstance(style, dict):
        out.append(warning(where, None, "style は {言語: 文体の決まり} にする"))
    else:
        for lang, rule in style.items():
            if lang not in config.others():
                out.append(warning(where, None, "style.%s: %s" % (lang, _unknown_language(config, lang))))
            elif not isinstance(rule, str) or not rule:
                out.append(warning(where, None, "style.%s は文字列にする" % lang))
    terms = g.get("terms", [])
    if not isinstance(terms, list):
        out.append(warning(where, None, "terms は [{ja, <言語>…, note, keep}] の配列にする"))
        return
    seen = {}
    for i, t in enumerate(terms):
        label = "terms[%d]" % i
        # 用語集は ja の語で引く (カタログの原文が ja なので)
        if not isinstance(t, dict) or not isinstance(t.get("ja"), str) or not t["ja"]:
            out.append(warning(where, None, "%s: ja (基準言語の語) が無い" % label))
            continue
        label = "terms[%d] (%s)" % (i, t["ja"])
        if t["ja"] in seen:
            out.append(warning(where, None, "%s: 同じ語が terms[%d] にもある" % (label, seen[t["ja"]])))
        seen.setdefault(t["ja"], i)
        for k, v in t.items():
            if k in model.GLOSSARY_TERM_FIELDS:
                continue
            if k not in config.others():
                out.append(warning(where, None, "%s: %s" % (label, _unknown_language(config, k))))
            elif not _term_forms(v):
                out.append(warning(where, None, "%s: %s は空でない文字列か、その配列にする" % (label, k)))
        if "note" in t and not isinstance(t["note"], str):
            out.append(warning(where, None, "%s: note は文字列にする" % label))
        if "keep" in t and not isinstance(t["keep"], bool):
            out.append(warning(where, None, "%s: keep は true / false にする" % label))


def _unknown_language(config, key):
    if model.LANG_LIKE_RE.match(key):
        hint = " (中国語の簡体字は zh-Hans、繁体字は zh-Hant)" if key.lower() in ("cn", "zh", "zh-cn", "zh-tw", "tw") else ""
        return "言語 %s は config.json の languages (基準言語以外) に無い%s" % (key, hint)
    return "未知のフィールド %s (使えるのは %s と言語コード)" % (key, ", ".join(model.GLOSSARY_TERM_FIELDS))


def _term_forms(v):
    """用語集の 1 言語の値 → 候補の並び (文字列か文字列の配列。読めなければ空)。"""
    if isinstance(v, str):
        return [v] if v else []
    if isinstance(v, list) and v and all(isinstance(x, str) and x for x in v):
        return list(v)
    return []


def glossary_forms(term, lang):
    """用語集の語 term を lang で書くときの候補。keep: true なら ja の語そのものが先頭に入る。"""
    forms = _term_forms(term.get(lang))
    if term.get("keep") is True:
        ja = term["ja"]
        forms = [ja] + [f for f in forms if f != ja]
    return forms


def _glossary_terms(glossary):
    """用語集の項目と、その語を中に含む長い語 (アンコール ⊃ コール など) の組。

    長い語の出現の中の短い語は数えない (アンコール の中の コール で「コール → 콜」を求めない)。
    長い語の訳は長い語の項目が見る。
    """
    terms = glossary.get("terms", []) if isinstance(glossary, dict) else []
    terms = terms if isinstance(terms, list) else []
    terms = [t for t in terms if isinstance(t, dict) and isinstance(t.get("ja"), str) and t["ja"]]
    return [(t, sorted({u["ja"] for u in terms if t["ja"] in u["ja"] and u["ja"] != t["ja"]}, key=len, reverse=True))
            for t in terms]


def _literal(e, lang, cat):
    try:
        return model.literal_text(e.segments(lang, cat))
    except model.TemplateError:
        return ""


def _quality(catalog, ns, e, terms, out):
    src = catalog.config.source_language
    for lang in e.values:
        for cat in e.forms(lang):
            lit = _literal(e, lang, cat)
            label = lang if isinstance(e.values[lang], str) else "%s.%s" % (lang, cat)
            if e.max_len is not None and len(lit) > e.max_len:
                out.append(error(ns.path, e.key, "%s が %d 文字で max_len %d を超える" % (label, len(lit), e.max_len),
                                 "max_len は引数を除いた長さの上限 (画面に収まる長さ)。短い言い方にする"))
            if lang == src:
                continue
            if not e.verbatim_ok and _KANA.search(lit):
                out.append(warning(ns.path, e.key, "%s の値に仮名が混じる" % label,
                                   "固有名詞をそのまま残すなら verbatim_ok: true"))
    source_lit = _literal(e, src, "other")
    for t, longer in terms:
        if t["ja"] not in source_lit:
            continue
        masked = source_lit
        for u in longer:
            masked = masked.replace(u, "\0")
        if t["ja"] not in masked:
            continue
        # 訳のある言語 (基準言語以外) のそれぞれで、用語集のその言語の語 (候補のどれか) があるか。
        # 英字は大文字小文字を区別しない (文頭の Sentence case)
        for lang in e.values:
            if lang == src:
                continue
            wants = glossary_forms(t, lang)
            if not wants:
                continue
            lits = [_literal(e, lang, c).casefold() for c in e.forms(lang)]
            if any(w.casefold() in lit for w in wants for lit in lits):
                continue
            if t.get("keep") is True and wants == [t["ja"]]:
                out.append(warning(ns.path, e.key, "用語集では %s は訳さない (%s の値に %s が無い)" % (t["ja"], lang, t["ja"])))
            else:
                out.append(warning(ns.path, e.key, "用語集では %s → %s (%s の値に無い)" % (t["ja"], " / ".join(wants), lang)))


# ---------------------------------------------------------------- text 引数の見本

def _text_sample(catalog, out):
    tag = catalog.find(model.LANGUAGE_TAG_KEY)
    for e in catalog.entries():
        if not any(a.type == "text" for a in e.args):
            continue
        missing = [p for p in e.platforms if tag is None or not tag.on(p) or tag.args]
        if missing:
            ns = catalog.namespace(e.ns)
            out.append(error(ns.path, e.key, "text 引数の見本に %s を使うが、%s に無い" % (
                model.LANGUAGE_TAG_KEY, " / ".join(missing)),
                "i18n/catalog/i18n.json に引数なしの language_tag を置く"))


# ---------------------------------------------------------------- 規則 10: 出荷ゲート

def _gate(catalog, out):
    """beta / release の言語だけを見る (dev と planned は出荷しないので止めない)。"""
    config = catalog.config
    for lang, channel in config.languages.items():
        if lang == config.source_language or channel not in ("beta", "release"):
            continue
        counts = {"missing": 0, "unreviewed": 0, "stale": 0, "edited": 0}
        where = {}
        for ns in catalog.namespaces:
            if ns.kind not in ("ui", "system"):
                continue
            for e in ns.entries:
                s = catalog.status(e, lang)
                if s in counts:
                    counts[s] += 1
                    where.setdefault(ns.name, 0)
                    where[ns.name] += 1
        if any(counts.values()):
            out.append(error(model.CONFIG_PATH, None, "%s が %s なのに 欠落 %d 件 / 未検収 %d 件 / stale %d 件 / edited %d 件 (%s)" % (
                lang, channel, counts["missing"], counts["unreviewed"], counts["stale"], counts["edited"],
                ", ".join(sorted(where))),
                "python3 tools/i18n/i18n.py stats で一覧。人が確かめたら stamp %s --reviewer <名前> --ns …" % lang))


# ---------------------------------------------------------------- lock

def _lock(catalog, out):
    keys = {e.full_key for e in catalog.entries()}
    for lang, entries in catalog.lock.items():
        stale = sorted(k for k in entries if k not in keys)
        if stale:
            out.append(warning("%s/%s.json" % (model.LOCK_DIR, lang), None,
                               "カタログに無いキーの lock が %d 件 (%s)" % (len(stale), ", ".join(stale[:5]) + (" …" if len(stale) > 5 else ""))))


# ---------------------------------------------------------------- 規則 8: project.yml

def _unquote(v):
    v = v.strip()
    if v.startswith('"'):
        end = v.rfind('"')
        body = v[1:end] if end > 0 else v[1:]
        return body.replace('\\"', '"').replace("\\\\", "\\")
    if v.startswith("'"):
        end = v.rfind("'")
        body = v[1:end] if end > 0 else v[1:]
        return body.replace("''", "'")
    m = re.search(r"\s#", v)
    if m:
        v = v[:m.start()]
    return v.strip()


_YAML_KEY = re.compile(r"""^(?P<key>"[^"]*"|'[^']*'|[^\s:#'"][^:#]*?)\s*:(?:\s+(?P<val>.*)|)$""")


def yaml_scalars(text):
    """project.yml を行の字下げで読み、(キーの道筋, 値, 行番号) を並べる。YAML ライブラリは使わない。

    配列の要素は道筋に "-" として入る。ブロック文字列 (| >) は読まない。
    """
    out = []
    stack = []  # (字下げ, キー)
    for lineno, raw in enumerate(text.splitlines(), 1):
        line = raw.rstrip()
        body = line.lstrip(" ")
        if not body or body.startswith("#"):
            continue
        indent = len(line) - len(body)
        if body == "-" or body.startswith("- "):
            while stack and stack[-1][0] >= indent:
                stack.pop()
            stack.append((indent, "-"))
            body = body[1:].lstrip(" ")
            indent = len(line) - len(body)
            if not body:
                continue
        m = _YAML_KEY.match(body)
        if not m:
            continue
        key = m.group("key").strip("\"'")
        val = m.group("val")
        while stack and stack[-1][0] >= indent:
            stack.pop()
        path = tuple(k for _, k in stack) + (key,)
        if val is not None and val.strip() and not val.strip().startswith("#") and val.strip() not in ("|", ">"):
            out.append((path, _unquote(val), lineno))
        stack.append((indent, key))
    return out


_GATE_KEY = "XCSTRINGS_LANGUAGES_TO_COMPILE"


def _project_yml(catalog, text, out):
    where = "project.yml"
    if text is None:
        out.append(error(where, None, "project.yml が無い (iOS に出す名前空間があるので出荷ゲートを照合する)"))
        return
    scalars = yaml_scalars(text)
    gates = {}
    for path, val, line in scalars:
        if path[-1] != _GATE_KEY:
            continue
        if len(path) == 4 and path[0] == "settings" and path[1] == "configs":
            gates[path[2]] = (val, line)
        else:
            out.append(error(where, None, "%d 行目: %s は プロジェクト全体の settings.configs.<構成> にだけ書く (今 %s)" % (
                line, _GATE_KEY, ".".join(path[:-1])),
                "ターゲット側の設定はプロジェクトの設定を上書きしてしまう"))
    config = catalog.config
    for name in ("Release", "Beta", "Debug"):
        want = config.languages_for(name)
        if name not in gates:
            if name == "Release":
                out.append(error(where, None, "settings.configs.Release.%s が無い (config.json の release 言語: %s)" % (
                    _GATE_KEY, " ".join(want)),
                    "project.yml の settings.configs.Release に %s: %s を書く" % (_GATE_KEY, " ".join(want))))
            continue
        val, line = gates[name]
        if set(val.split()) != set(want):
            out.append(error(where, None, "%s の %s (%s) が config.json の %s 言語 (%s) と違う" % (
                name, _GATE_KEY, val, name, " ".join(want))))

    values = {path: val for path, val, _ in scalars}
    for ns in catalog.namespaces:
        for e in ns.entries:
            if e.infoplist is None or not e.on("ios"):
                continue
            target, key = e.infoplist
            tname = model.IOS_TARGETS[target]
            path = ("targets", tname, "settings", "base", "INFOPLIST_KEY_" + key)
            if path not in values:
                out.append(error(ns.path, e.key, "project.yml の %s に INFOPLIST_KEY_%s が無い" % (tname, key),
                                 "Info.plist の既定値 (= %s の値) は project.yml に残す" % catalog.config.source_language))
            elif values[path] != e.source:
                out.append(error(ns.path, e.key, "%s が project.yml の %s.INFOPLIST_KEY_%s (%s) と違う" % (
                    catalog.config.source_language, tname, key, values[path])))


# ---------------------------------------------------------------- 規則 13: core

def _core_refs(refs, out):
    for r in refs:
        if r.ns_hint == "core":
            out.append(error(r.path, None, "%d 行目: core 名前空間 (%s) はアプリから引かない (コア段階用の予約)" % (r.line, r.token)))
