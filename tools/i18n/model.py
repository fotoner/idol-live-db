"""文言カタログの型 (ドメイン)。プラットフォームの形式 (xcstrings / strings.xml) は知らない。

- カタログ (i18n/catalog/<ns>.json) と i18n/config.json を読んだ生の dict から
  Config / Namespace / Entry を組む (build)。形の崩れ (型違い・未知のフィールド) は
  ここで Problem にする。意味の検査 (プレースホルダ・出荷ゲートなど) は validate.py。
- テンプレート (`{name}` プレースホルダと `{{` `}}`) の読み方と、キーから派生する名前
  (Android のリソース名・Swift/Kotlin のアクセサ名) もここに置く。両エミッタが同じ規則を使う。
"""

from __future__ import annotations

import hashlib
import re
from dataclasses import dataclass, field

import cldr

ARG_TYPES = ("int", "count", "string", "core", "text")
KINDS = ("ui", "system", "content", "reserved")
CHANNELS = ("dev", "beta", "release")
PLATFORMS = ("ios", "android")
IOS_BUNDLES = ("app", "widget")
RATCHET_MODES = ("report", "enforce")

# ios.infoplist の target → project.yml のターゲット名
IOS_TARGETS = {"app": "ImasLiveDB", "widget": "ImasLiveDBWidget"}

# ビルド構成 → 入る言語のチャネル (i18n/README.md の「言語とチャネル」)
CONFIG_CHANNELS = {
    "Release": ("release",),
    "Beta": ("release", "beta"),
    "Debug": ("release", "beta", "dev"),
}

NS_RE = re.compile(r"^[a-z][a-z0-9_]*$")
KEY_RE = re.compile(r"^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){0,3}$")
ARG_NAME_RE = re.compile(r"^[a-z][a-z0-9_]*$")
LANG_LIKE_RE = re.compile(r"^[a-z]{2,3}(-[A-Za-z0-9]{2,8})*$")
INFOPLIST_KEY_RE = re.compile(r"^[A-Za-z][A-Za-z0-9_]*$")
SHA256_RE = re.compile(r"^[0-9a-f]{64}$")

NS_FIELDS = ("namespace", "kind", "ios_bundles", "platforms", "slices", "strings")
ENTRY_FIELDS = ("args", "note", "platforms", "max_len", "keep_whitespace", "verbatim_ok", "ios")
IOS_ENTRY_FIELDS = ("infoplist", "intent_metadata")
CONFIG_FIELDS = ("source_language", "languages", "guard")

# テーブル名として使えない (Xcode が予約している)
# Localizable / InfoPlist は Xcode の予約表。残りは生成 Swift が使う識別子で、
# 同名の enum が extension L10n の中にできると生成物全体が型を見失う
RESERVED_TABLES = ("Localizable", "InfoPlist",
                   "L10n", "String", "Int", "LocalizedStringResource", "Foundation", "Bundle")

# 予約キー: 実際に解決された表示言語 (DisplayLocale がこれを引く)。text 引数の見本にも使う
LANGUAGE_TAG_KEY = "i18n.language_tag"

CATALOG_DIR = "i18n/catalog"
CONFIG_PATH = "i18n/config.json"
LOCK_DIR = "i18n/lock"
GLOSSARY_PATH = "i18n/glossary.json"
BASELINE_DIR = "i18n/baseline"


# ---------------------------------------------------------------- 問題の報告

@dataclass
class Problem:
    level: str  # "error" / "warning"
    where: str  # ファイル (リポジトリ相対)
    key: str | None
    message: str
    hint: str | None = None

    @property
    def is_error(self):
        return self.level == "error"

    def format(self):
        mark = "✗" if self.is_error else "⚠"
        head = "%s %s: " % (mark, self.where)
        if self.key:
            head += "%s: " % self.key
        text = head + self.message
        if self.hint:
            text += "\n  → " + self.hint
        return text


def error(where, key, message, hint=None):
    return Problem("error", where, key, message, hint)


def warning(where, key, message, hint=None):
    return Problem("warning", where, key, message, hint)


# ---------------------------------------------------------------- テンプレート

class TemplateError(ValueError):
    pass


def parse_template(text):
    """`{name}` を引数、`{{` `}}` を波括弧 1 文字として読む。

    返り値は ("lit", 文字列) と ("arg", 名前) の並び。隣り合う lit はまとめる。
    """
    segments = []
    buf = []
    i = 0
    n = len(text)
    while i < n:
        c = text[i]
        if c == "{":
            if text.startswith("{{", i):
                buf.append("{")
                i += 2
                continue
            end = text.find("}", i + 1)
            if end < 0:
                raise TemplateError("閉じていない { がある (位置 %d)" % i)
            name = text[i + 1:end]
            if not ARG_NAME_RE.match(name):
                raise TemplateError("{%s} はプレースホルダとして読めない (英小文字・数字・_ だけ。波括弧そのものは {{ }} と書く)" % name)
            if buf:
                segments.append(("lit", "".join(buf)))
                buf = []
            segments.append(("arg", name))
            i = end + 1
            continue
        if c == "}":
            if text.startswith("}}", i):
                buf.append("}")
                i += 2
                continue
            raise TemplateError("対応する { の無い } がある (位置 %d。波括弧そのものは }} と書く)" % i)
        buf.append(c)
        i += 1
    if buf:
        segments.append(("lit", "".join(buf)))
    return segments


def placeholders(segments):
    return [s for kind, s in segments if kind == "arg"]


def literal_text(segments):
    return "".join(s for kind, s in segments if kind == "lit")


# ---------------------------------------------------------------- 派生する名前

def pascal(ns):
    """名前空間 → iOS の表名・アクセサの型名 (call_guide → CallGuide)。"""
    return "".join(part[:1].upper() + part[1:] for part in ns.split("_") if part)


def camel(key):
    """相対キー → アクセサ名 (list.sort_title → listSortTitle)。引数名にも使う。"""
    parts = [p for p in re.split(r"[._]", key) if p]
    return parts[0] + "".join(p[:1].upper() + p[1:] for p in parts[1:])


def android_name(ns, key):
    """完全キー → Android のリソース名 (events.attendance.group_header → events_attendance_group_header)。"""
    return ns + "_" + key.replace(".", "_")


def ja_hash(text):
    """lock に書く基準言語の原文のハッシュ。"""
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


# ---------------------------------------------------------------- 型

@dataclass
class Arg:
    name: str
    type: str


@dataclass
class Config:
    source_language: str
    languages: dict  # 言語 → channel (基準言語が先頭、残りは整列)
    ratchet: str = "report"

    def channel(self, lang):
        return self.languages.get(lang)

    def others(self):
        """基準言語以外の言語 (整列済み)。"""
        return [lang for lang in self.languages if lang != self.source_language]

    def languages_for(self, config_name):
        """ビルド構成に入る言語 (基準言語が先頭)。"""
        channels = CONFIG_CHANNELS[config_name]
        return [lang for lang, ch in self.languages.items() if ch in channels]


@dataclass
class Entry:
    ns: str
    key: str  # 名前空間を除いた相対キー
    source_language: str
    values: dict  # 言語 → 文字列 or {範疇: 文字列}
    args: list = field(default_factory=list)
    note: str | None = None
    platforms: tuple = PLATFORMS
    max_len: int | None = None
    keep_whitespace: bool = False
    verbatim_ok: bool = False
    infoplist: tuple | None = None  # (target, Info.plist のキー)
    intent_metadata: bool = False

    @property
    def full_key(self):
        return self.ns + "." + self.key

    @property
    def count_arg(self):
        for a in self.args:
            if a.type == "count":
                return a
        return None

    def arg_position(self, name):
        """1 始まりの引数の位置 (%N$ の N)。"""
        for i, a in enumerate(self.args):
            if a.name == name:
                return i + 1
        raise KeyError(name)

    def arg(self, name):
        return self.args[self.arg_position(name) - 1]

    @property
    def source(self):
        return self.values[self.source_language]

    def has(self, lang):
        return lang in self.values

    def forms(self, lang):
        """lang の値を {範疇: テンプレート文字列} で返す (文字列の値は other だけ)。"""
        v = self.values[lang]
        if isinstance(v, str):
            return {"other": v}
        return dict(v)

    def segments(self, lang, category="other"):
        return parse_template(self.forms(lang)[category])

    def on(self, platform):
        return platform in self.platforms


@dataclass
class Namespace:
    name: str
    path: str  # i18n/catalog/<ns>.json
    kind: str = "ui"
    ios_bundles: tuple = ("app",)
    platforms: tuple = PLATFORMS
    slices: dict = field(default_factory=dict)
    entries: list = field(default_factory=list)  # キー順

    @property
    def table(self):
        return pascal(self.name)

    @property
    def reserved(self):
        return self.kind == "reserved"

    @property
    def shared(self):
        """ウィジェット拡張にも入る (ImasLiveDB/Shared/L10n/Generated に置く)。"""
        return "widget" in self.ios_bundles

    def ios_entries(self):
        """iOS の表 (<Table>.xcstrings) に入る項目。Info.plist 用の項目は InfoPlist 表へ回す。"""
        if self.reserved:
            return []
        return [e for e in self.entries if e.on("ios") and e.infoplist is None]

    def android_entries(self):
        if self.reserved:
            return []
        return [e for e in self.entries if e.on("android")]


@dataclass
class Catalog:
    config: Config
    namespaces: list  # 名前順
    lock: dict = field(default_factory=dict)  # 言語 → {完全キー: ハッシュ}
    glossary: dict = field(default_factory=dict)
    parity_baseline: dict = field(default_factory=dict)

    def entries(self):
        for ns in self.namespaces:
            for e in ns.entries:
                yield e

    def namespace(self, name):
        for ns in self.namespaces:
            if ns.name == name:
                return ns
        return None

    def find(self, full_key):
        for e in self.entries():
            if e.full_key == full_key:
                return e
        return None

    def status(self, entry, lang):
        """翻訳の状態: missing / unreviewed / reviewed / stale。基準言語は常に reviewed。"""
        if lang == self.config.source_language:
            return "reviewed"
        if not entry.has(lang):
            return "missing"
        stamped = self.lock.get(lang, {}).get(entry.full_key)
        if stamped is None:
            return "unreviewed"
        return "reviewed" if stamped == ja_hash(entry.source) else "stale"


# ---------------------------------------------------------------- 生の dict から組む

def _is_str_list(v):
    return isinstance(v, list) and all(isinstance(x, str) for x in v)


def build_config(path, raw, problems):
    if not isinstance(raw, dict):
        problems.append(error(path, None, "config.json の中身はオブジェクトにする"))
        return None
    for k in raw:
        if k not in CONFIG_FIELDS:
            problems.append(error(path, None, "未知のフィールド %s" % k))
    src = raw.get("source_language")
    if not isinstance(src, str):
        problems.append(error(path, None, "source_language (基準言語) が無い"))
        return None
    langs_raw = raw.get("languages")
    if not isinstance(langs_raw, dict) or not langs_raw:
        problems.append(error(path, None, "languages が無い (言語 → {channel} のオブジェクト)"))
        return None
    languages = {}
    for lang, spec in langs_raw.items():
        if not cldr.known(lang):
            problems.append(error(path, None, "言語 %s は生成器が知らない (tools/i18n/cldr.py に範疇と桁区切りを足す)" % lang))
            continue
        if not isinstance(spec, dict) or set(spec) - {"channel"}:
            problems.append(error(path, None, "languages.%s は {\"channel\": …} だけにする" % lang))
            continue
        ch = spec.get("channel")
        if ch not in CHANNELS:
            problems.append(error(path, None, "languages.%s.channel は %s のどれか (今 %r)" % (lang, " / ".join(CHANNELS), ch)))
            continue
        languages[lang] = ch
    if src not in languages:
        problems.append(error(path, None, "基準言語 %s が languages に無い" % src))
        return None
    if languages[src] != "release":
        problems.append(error(path, None, "基準言語 %s の channel は release にする" % src))
    ordered = {src: languages[src]}
    for lang in sorted(languages):
        if lang != src:
            ordered[lang] = languages[lang]
    ratchet = "report"
    guard = raw.get("guard", {})
    if not isinstance(guard, dict) or set(guard) - {"ratchet"}:
        problems.append(error(path, None, "guard は {\"ratchet\": \"report\" | \"enforce\"} だけにする"))
    else:
        ratchet = guard.get("ratchet", "report")
        if ratchet not in RATCHET_MODES:
            problems.append(error(path, None, "guard.ratchet は report か enforce (今 %r)" % ratchet))
            ratchet = "report"
    return Config(source_language=src, languages=ordered, ratchet=ratchet)


def _build_entry(ns, path, key, raw, config, ns_platforms, problems):
    where = path
    if not isinstance(raw, dict):
        problems.append(error(where, key, "項目はオブジェクトにする ({\"ja\": …})"))
        return None
    values = {}
    ok = True
    for k, v in raw.items():
        if k in ENTRY_FIELDS:
            continue
        if k in config.languages:
            if isinstance(v, str):
                if v == "" and k != config.source_language:
                    problems.append(error(where, key, "%s が空文字列 (訳が無いなら項目ごと書かない)" % k))
                    ok = False
                    continue
                values[k] = v
            elif isinstance(v, dict) and v and all(isinstance(c, str) and isinstance(t, str) for c, t in v.items()):
                values[k] = dict(v)
            else:
                problems.append(error(where, key, "%s の値は文字列か {範疇: 文字列} にする" % k))
                ok = False
        elif LANG_LIKE_RE.match(k):
            problems.append(error(where, key, "言語 %s は i18n/config.json の languages に無い" % k,
                                  "言語を足すなら config.json に channel を書く"))
            ok = False
        else:
            problems.append(error(where, key, "未知のフィールド %s" % k,
                                  "使えるのは %s と言語コード" % ", ".join(ENTRY_FIELDS)))
            ok = False
    src = config.source_language
    if not isinstance(raw.get(src), str) or raw.get(src) == "":
        problems.append(error(where, key, "%s (基準言語の原文) が無いか空" % src,
                              "%s は必須で、文字列で書く (複数形でも %s は文字列 = other)" % (src, src)))
        ok = False

    args = []
    raw_args = raw.get("args", [])
    if not isinstance(raw_args, list):
        problems.append(error(where, key, "args は [{name, type}] の配列にする"))
        ok = False
        raw_args = []
    seen = set()
    for a in raw_args:
        if not isinstance(a, dict) or set(a) != {"name", "type"}:
            problems.append(error(where, key, "args の要素は {\"name\": …, \"type\": …} だけにする"))
            ok = False
            continue
        name, typ = a["name"], a["type"]
        if not isinstance(name, str) or not ARG_NAME_RE.match(name):
            problems.append(error(where, key, "引数名 %r は英小文字で始まる英小文字・数字・_ にする" % (name,)))
            ok = False
            continue
        if typ not in ARG_TYPES:
            problems.append(error(where, key, "引数 %s の型 %r は %s のどれか" % (name, typ, " / ".join(ARG_TYPES))))
            ok = False
            continue
        if name in seen:
            problems.append(error(where, key, "引数 %s が 2 回ある" % name))
            ok = False
            continue
        seen.add(name)
        args.append(Arg(name, typ))

    note = raw.get("note")
    if note is not None and not isinstance(note, str):
        problems.append(error(where, key, "note は文字列にする"))
        note = None

    platforms = ns_platforms
    if "platforms" in raw:
        p = raw["platforms"]
        if not _is_str_list(p) or not p:
            problems.append(error(where, key, "platforms は [\"ios\", \"android\"] の空でない部分集合にする"))
            ok = False
        else:
            platforms = tuple(x for x in PLATFORMS if x in p)
            bad = [x for x in p if x not in PLATFORMS]
            if bad:
                problems.append(error(where, key, "platforms に %s は書けない (%s)" % (
                    ", ".join(bad), "core は予約" if "core" in bad else "ios / android だけ")))
                ok = False

    max_len = raw.get("max_len")
    if max_len is not None and (isinstance(max_len, bool) or not isinstance(max_len, int) or max_len <= 0):
        problems.append(error(where, key, "max_len は正の整数にする"))
        max_len = None
    flags = {}
    for flag in ("keep_whitespace", "verbatim_ok"):
        v = raw.get(flag, False)
        if not isinstance(v, bool):
            problems.append(error(where, key, "%s は true / false にする" % flag))
            v = False
        flags[flag] = v

    infoplist = None
    intent_metadata = False
    ios = raw.get("ios")
    if ios is not None:
        if not isinstance(ios, dict):
            problems.append(error(where, key, "ios は {infoplist, intent_metadata} のオブジェクトにする"))
            ok = False
        else:
            for k in ios:
                if k not in IOS_ENTRY_FIELDS:
                    problems.append(error(where, key, "ios.%s は未知のフィールド" % k))
                    ok = False
            if "infoplist" in ios:
                ip = ios["infoplist"]
                if (not isinstance(ip, dict) or set(ip) != {"target", "key"}
                        or ip.get("target") not in IOS_TARGETS
                        or not isinstance(ip.get("key"), str) or not INFOPLIST_KEY_RE.match(ip["key"])):
                    problems.append(error(where, key, "ios.infoplist は {\"target\": \"app\" | \"widget\", \"key\": \"<Info.plist のキー>\"}"))
                    ok = False
                else:
                    infoplist = (ip["target"], ip["key"])
            if "intent_metadata" in ios:
                if not isinstance(ios["intent_metadata"], bool):
                    problems.append(error(where, key, "ios.intent_metadata は true / false にする"))
                    ok = False
                else:
                    intent_metadata = ios["intent_metadata"]
    if not ok:
        return None
    return Entry(ns=ns, key=key, source_language=src, values=values, args=args, note=note,
                 platforms=platforms, max_len=max_len, keep_whitespace=flags["keep_whitespace"],
                 verbatim_ok=flags["verbatim_ok"], infoplist=infoplist, intent_metadata=intent_metadata)


def build_namespace(path, stem, raw, config, problems):
    if not isinstance(raw, dict):
        problems.append(error(path, None, "名前空間ファイルの中身はオブジェクトにする"))
        return None
    for k in raw:
        if k not in NS_FIELDS:
            problems.append(error(path, None, "未知のフィールド %s" % k, "使えるのは %s" % ", ".join(NS_FIELDS)))
    name = raw.get("namespace")
    if name != stem:
        problems.append(error(path, None, "namespace (%r) はファイル名 (%s) と同じにする" % (name, stem)))
        return None
    if not NS_RE.match(name):
        problems.append(error(path, None, "名前空間 %s は英小文字で始まる英小文字・数字・_ にする" % name))
        return None
    kind = raw.get("kind")
    if kind not in KINDS:
        problems.append(error(path, None, "kind は %s のどれか (今 %r)" % (" / ".join(KINDS), kind)))
        return None
    bundles = raw.get("ios_bundles", ["app"])
    if not _is_str_list(bundles) or not bundles or any(b not in IOS_BUNDLES for b in bundles):
        problems.append(error(path, None, "ios_bundles は [\"app\"] か [\"app\", \"widget\"] (app / widget の部分集合)"))
        bundles = ["app"]
    platforms = raw.get("platforms", list(PLATFORMS))
    if not _is_str_list(platforms) or not platforms or any(p not in PLATFORMS for p in platforms):
        problems.append(error(path, None, "platforms は [\"ios\", \"android\"] の空でない部分集合にする (core は予約)"))
        platforms = list(PLATFORMS)
    slices = raw.get("slices", {})
    if (not isinstance(slices, dict) or set(slices) - set(PLATFORMS)
            or not all(_is_str_list(v) for v in slices.values())):
        problems.append(error(path, None, "slices は {\"ios\": [パス接頭], \"android\": [パス接頭]} にする"))
        slices = {}
    strings = raw.get("strings")
    if not isinstance(strings, dict):
        problems.append(error(path, None, "strings ({相対キー: 項目}) が無い"))
        return None
    ns = Namespace(name=name, path=path, kind=kind,
                   ios_bundles=tuple(b for b in IOS_BUNDLES if b in bundles),
                   platforms=tuple(p for p in PLATFORMS if p in platforms),
                   slices={k: list(v) for k, v in slices.items()})
    for key in sorted(strings):
        e = _build_entry(name, path, key, strings[key], config, ns.platforms, problems)
        if e is not None:
            ns.entries.append(e)
    return ns


def build(raw_repo, problems):
    """source_json.RawRepo から Catalog を組む。組めなければ None (問題は problems に入る)。"""
    if raw_repo.config is None:
        problems.append(error(CONFIG_PATH, None, "i18n/config.json が無い"))
        return None
    config = build_config(CONFIG_PATH, raw_repo.config, problems)
    if config is None:
        return None
    namespaces = []
    for path, stem, raw in raw_repo.namespaces:
        ns = build_namespace(path, stem, raw, config, problems)
        if ns is not None:
            namespaces.append(ns)
    namespaces.sort(key=lambda n: n.name)

    lock = {}
    for lang, (path, raw) in sorted(raw_repo.locks.items()):
        if not isinstance(raw, dict) or not all(isinstance(v, str) and SHA256_RE.match(v) for v in raw.values()):
            problems.append(error(path, None, "lock は {完全キー: sha256 の 16 進 64 桁} にする"))
            continue
        if lang not in config.languages:
            problems.append(warning(path, None, "言語 %s は config.json に無い (lock を消すか言語を足す)" % lang))
        elif lang == config.source_language:
            problems.append(warning(path, None, "基準言語の lock は使わない"))
        lock[lang] = dict(raw)

    glossary = raw_repo.glossary if isinstance(raw_repo.glossary, dict) else {}
    baseline = raw_repo.parity_baseline if isinstance(raw_repo.parity_baseline, dict) else {}
    return Catalog(config=config, namespaces=namespaces, lock=lock, glossary=glossary, parity_baseline=baseline)


# ---------------------------------------------------------------- 見本と期待値

SAMPLE_INT = 2026
SAMPLE_COUNTS = (1, 3, 1234)


def sample_string(position):
    """string / core 引数の見本。仮名と空白を混ぜる (エスケープ・書式の取り違えが見える)。"""
    return "かな カナ%d" % position


class TextSample:
    """text 引数の見本: 予約キー i18n.language_tag (同じ言語で入れ子に解決されるはず)。"""

    key = LANGUAGE_TAG_KEY

    def __repr__(self):
        return "TextSample()"


def samples(entry):
    """見本の引数の組 ({引数名: 値}) の並び。count があれば 1, 3, 1234 の 3 組。"""
    base = {}
    for i, a in enumerate(entry.args, 1):
        if a.type == "int":
            base[a.name] = SAMPLE_INT
        elif a.type in ("string", "core"):
            base[a.name] = sample_string(i)
        elif a.type == "text":
            base[a.name] = TextSample()
    count = entry.count_arg
    if count is None:
        return [base]
    out = []
    for n in SAMPLE_COUNTS:
        s = dict(base)
        s[count.name] = n
        out.append(s)
    return out


def describe_sample(entry, sample):
    """見本の組を短く書く (テストの失敗メッセージ用)。"""
    parts = []
    for a in entry.args:
        v = sample[a.name]
        parts.append("%s=%s" % (a.name, "<%s>" % v.key if isinstance(v, TextSample) else v))
    return ", ".join(parts)


def render(catalog, entry, lang, sample):
    """lang の実行時に出るはずの文字列 (「引数の型と数の書式」(i18n/README.md)の数の書式、値が無ければ基準言語へフォールバック)。"""
    form_lang = lang if entry.has(lang) else entry.source_language
    forms = entry.forms(form_lang)
    category = "other"
    count = entry.count_arg
    if count is not None:
        c = cldr.category_for(lang, sample[count.name])
        if c in forms:
            category = c
    out = []
    for kind, s in parse_template(forms[category]):
        if kind == "lit":
            out.append(s)
            continue
        a = entry.arg(s)
        v = sample[s]
        if a.type == "int":
            out.append(str(v))
        elif a.type == "count":
            out.append(cldr.group(lang, v))
        elif a.type == "text":
            tag = catalog.find(v.key)
            out.append(render(catalog, tag, lang, {}))
        else:
            out.append(v)
    return "".join(out)
