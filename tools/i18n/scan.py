"""ソースに残る日本語リテラルと禁止パターンを数える (i18n.py scan)。

マイルストーン 1 では報告だけ: 数を出し、--update で基準線 (i18n/baseline/literals.json) を
書く。基準線と比べて落とす (enforce) のは次の段階。

- 対象は Swift (ImasLiveDB/, ImasLiveDBWidget/) と Kotlin (ImasLiveDB-Android/app/src/)。
  生成物 (i18n.py outputs の経路)・テストのディレクトリ・プレビューは数えない。
- コメントは数えない。文字列の中の補間 (Swift の \\( ), Kotlin の ${ } / $name) は {} に畳む。
- `// i18n-ignore(<分類>): <理由>` の付いた行 (その行か、コメントだけの直前の行) は数えない。
  理由の無い ignore は禁止パターン ignore_without_reason として数える。
- バケットは名前空間の slices の接頭で決める。どこにも入らないファイルは <platform>/_unsliced。
"""

from __future__ import annotations

import hashlib
import os
import re
from dataclasses import dataclass, field

import model

SWIFT_ROOTS = ("ImasLiveDB", "ImasLiveDBWidget")
KOTLIN_ROOTS = ("ImasLiveDB-Android/app/src",)
TEST_PARTS = ("/src/test/", "/src/androidTest/", "/src/testDebug/", "/Preview Content/")
TEST_PREFIXES = ("ImasLiveDBTests/", "ImasLiveDBUITests/")

IGNORE_CATEGORIES = ("storage", "sentinel", "path", "log", "data", "sample", "core")
_IGNORE = re.compile(r"i18n-ignore(-file)?(?:\((\w*)\))?(:?)[ \t]*(.*)")

_JAPANESE = re.compile(r"[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uff66-\uff9f]")

# 行ごと飛ばす (UI に出ない): ログ・SQL・落とす系
_ALLOW_LINE = re.compile(
    r"\bLog\.[vdiwe]\(|\blogger\.|\bLogger\(|\bos_log\(|execSQL\(|\bfatalError\(|\bpreconditionFailure\(|"
    r"\bassertionFailure\(|\bprecondition\(|\bassert\(")
_PREVIEW = re.compile(r"#Preview\b|:\s*PreviewProvider\b|@Preview\b")

# 禁止パターン: (規則名, 対象 "swift" / "kotlin" / "both", 正規表現, 行に日本語があるときだけ数えるか)
FORBIDDEN = [
    # 表示の経路の rawValue (保存値をそのまま見せている)。文字列補間は日本語の文の中にあるときだけ
    # (ID・SQL・ログの補間は表示ではない)
    ("rawvalue_display", "swift", re.compile(r"Text\(\s*[\w.]*\.rawValue\s*\)|\{\s*\$0\.rawValue\s*\}"), False),
    ("rawvalue_display", "swift", re.compile(r"\\\([^)]*\.rawValue\)"), True),
    ("ja_jp_formatter", "both", re.compile(
        r"Locale\(identifier:\s*\"ja_JP\"\)|Locale\.JAPAN\b|Locale\(\"ja\",\s*\"JP\"\)|Locale\.forLanguageTag\(\"ja-JP\"\)"), False),
    ("ja_weekday_array", "both", re.compile(r"\"[日月火水木金土]\"\s*,\s*\"[日月火水木金土]\"\s*,\s*\"[日月火水木金土]\""), False),
    ("ja_date_pattern", "both", re.compile(r"(?:dateFormat\s*=|ofPattern\(|SimpleDateFormat\()\s*\"[^\"]*年"), False),
    # 文言を static let に置くと作った時点の言語で固まる (BundleDescription のような値は構わない)
    ("static_let_localized", "swift", re.compile(
        r"\bstatic\s+let\s+\w+\s*:\s*LocalizedStringResource\b(?!\.)"
        r"|\bstatic\s+let\s+\w+[^=]*=\s*.*(?:String\(localized:|LocalizedStringResource\(|\bL10n\.[A-Z]\w*\.)"), False),
    ("localized_resource_call", "swift", re.compile(r"\bLocalizedStringResource\("), False),
    ("android_r_string", "kotlin", re.compile(r"\bR\.(?:string|plurals)\."), False),
    # ViewModel / data で文言を文字列にしている (SharedPreferences・JSON の getString は別物なので数えない)
    ("android_resolve_in_vm_data", "kotlin", re.compile(
        r"\bget(?:Quantity)?String\(\s*R\.|\b(?:context|ctx|resources|res|appContext|applicationContext)\??\."
        r"get(?:Quantity)?String\(|\bstringResource\(|\bpluralStringResource\("), False),
]
# AppIntent / AppEntity の静的メタデータ (ここだけ LocalizedStringResource を直に書いてよい)
_INTENT_METADATA = re.compile(r"\bstatic\s+(?:let|var)\s+(?:title|description|typeDisplayRepresentation)\b|@Parameter\(\s*title:|TypeDisplayRepresentation\(|IntentDescription\(")
_DIRECT_KEY = re.compile(r"\bLocalizedStringResource\(\s*\"([a-z][a-z0-9_]*(?:\.[a-z][a-z0-9_]*)+)\"")

# 表示用の書式に ja_JP を固定してよいファイル (パース用)
JA_JP_ALLOWED_FILES = (
    "ImasLiveDB/Services/CalendarExportService.swift",
    "ImasLiveDB/Domain/UseCases/JSTDay.swift",
)


# ---------------------------------------------------------------- 字句

@dataclass
class Literal:
    line: int
    text: str  # 補間は {} に畳んだ中身


@dataclass
class Lexed:
    code: list  # 行ごとのコード (コメントを除く。文字列は残す)
    bare: list  # 行ごとのコード (コメントと文字列の中身を除く)
    literals: list = field(default_factory=list)
    comments: list = field(default_factory=list)  # (行, 本文)


class _Lexer:
    def __init__(self, src, kotlin):
        self.s = src
        self.n = len(src)
        self.kotlin = kotlin
        self.code = []
        self.bare = []
        self.literals = []
        self.comments = []
        self.line = 1

    def put(self, text, in_string=False):
        """コードとして出す。in_string なら bare には出さない (改行だけは両方に)。"""
        self.code.append(text)
        if in_string:
            nl = text.count("\n")
            if nl:
                self.bare.append("\n" * nl)
        else:
            self.bare.append(text)
        self.line += text.count("\n")

    def newline_only(self, text):
        nl = text.count("\n")
        if nl:
            self.code.append("\n" * nl)
            self.bare.append("\n" * nl)
            self.line += nl

    _CODE_STOP = re.compile(r"""[/"'#\n(){}\[\]]""")

    def code_until(self, i, closer=None):
        s, n = self.s, self.n
        depth = 0
        while i < n:
            m = self._CODE_STOP.search(s, i)
            if m is None:
                self.put(s[i:])
                return n
            if m.start() > i:
                self.put(s[i:m.start()])
                i = m.start()
            c = s[i]
            if c == "\n":
                self.put("\n")
                i += 1
            elif s.startswith("//", i):
                end = s.find("\n", i)
                end = n if end < 0 else end
                self.comments.append((self.line, s[i + 2:end]))
                i = end
            elif s.startswith("/*", i):
                i = self.block_comment(i)
            elif c == "'" and self.kotlin:
                i = self.char_literal(i)
            elif c == '"':
                i = self.string(i, 0)
            elif c == "#" and not self.kotlin and re.match(r'#+"', s[i:i + 16]):
                hashes = len(re.match(r"#+", s[i:]).group(0))
                i = self.string(i + hashes, hashes)
            elif closer is not None and c in "([{":
                depth += 1
                self.put(c)
                i += 1
            elif closer is not None and c in ")]}":
                if depth == 0 and c == closer:
                    return i
                depth -= 1
                self.put(c)
                i += 1
            else:
                self.put(c)
                i += 1
        return i

    def block_comment(self, i):
        s, n = self.s, self.n
        depth = 0
        start_line = self.line
        j = i
        body_start = i + 2
        while j < n:
            if s.startswith("/*", j):
                depth += 1
                j += 2
            elif s.startswith("*/", j):
                depth -= 1
                j += 2
                if depth == 0:
                    break
            else:
                j += 1
        body = s[body_start:max(body_start, j - 2)]
        for k, text in enumerate(body.split("\n")):
            self.comments.append((start_line + k, text))
        self.newline_only(s[i:j])
        return j

    def char_literal(self, i):
        s = self.s
        m = re.match(r"'(?:\\u[0-9a-fA-F]{4}|\\.|[^'\\\n])'", s[i:i + 10])
        if m:
            self.put("'", False)
            self.put(m.group(0)[1:-1], True)
            self.put("'", False)
            return i + len(m.group(0))
        self.put("'")
        return i + 1

    def string(self, i, hashes):
        """i は最初の " の位置 (raw 文字列の # は読み終えたあと)。"""
        s, n = self.s, self.n
        prefix = "#" * hashes
        multi = s.startswith('"""', i)
        opener = '"""' if multi else '"'
        closing = opener + prefix
        self.put(prefix + opener)
        i += len(opener)
        start_line = self.line
        buf = []
        raw_kotlin = self.kotlin and multi
        esc = "\\" + prefix
        while i < n:
            if s.startswith(closing, i):
                self.put(closing)
                self.literals.append(Literal(start_line, "".join(buf)))
                return i + len(closing)
            c = s[i]
            if c == "\n" and not multi:
                self.literals.append(Literal(start_line, "".join(buf)))
                return i
            if not raw_kotlin and s.startswith(esc, i):
                j = i + len(esc)
                if not self.kotlin and j < n and s[j] == "(":
                    self.put(s[i:j + 1])
                    buf.append("{}")
                    i = self.code_until(j + 1, ")")
                    if i < n:
                        self.put(")")
                        i += 1
                    continue
                if j < n and s[j] == "u" and s.startswith("{", j + 1):
                    end = s.find("}", j)
                    seq = s[i:end + 1] if end > 0 else s[i:j + 1]
                else:
                    seq = s[i:j + 1]
                self.put(seq, True)
                buf.append(seq)
                i += len(seq)
                continue
            if self.kotlin and c == "$":
                if s.startswith("${", i):
                    self.put("${")
                    buf.append("{}")
                    i = self.code_until(i + 2, "}")
                    if i < n:
                        self.put("}")
                        i += 1
                    continue
                m = re.match(r"\$[A-Za-z_][A-Za-z0-9_]*", s[i:i + 80])
                if m:
                    self.put(m.group(0))
                    buf.append("{}")
                    i += len(m.group(0))
                    continue
            self.put(c, True)
            buf.append(c)
            i += 1
        self.literals.append(Literal(start_line, "".join(buf)))
        return i


def lex(src, kotlin=False):
    lx = _Lexer(src, kotlin)
    lx.code_until(0)
    code = "".join(lx.code).split("\n")
    bare = "".join(lx.bare).split("\n")
    return Lexed(code=code, bare=bare, literals=lx.literals, comments=lx.comments)


def has_japanese(text):
    return bool(_JAPANESE.search(text))


def literal_hash(text):
    return hashlib.sha256(" ".join(text.split()).encode("utf-8")).hexdigest()[:16]


# ---------------------------------------------------------------- ソースを歩く

def is_test_path(rel):
    return rel.startswith(TEST_PREFIXES) or any(p in "/" + rel for p in TEST_PARTS)


def iter_sources(root, exclude_roots=(), include_tests=False):
    """(相対パス, "ios" / "android", 本文)。生成物の経路 (exclude_roots) は飛ばす。"""
    targets = [(r, "ios", ".swift") for r in SWIFT_ROOTS] + [(r, "android", ".kt") for r in KOTLIN_ROOTS]
    excluded = tuple(r.rstrip("/") + "/" for r in exclude_roots)
    for base, platform, ext in targets:
        top = os.path.join(root, base)
        if not os.path.isdir(top):
            continue
        for dirpath, dirnames, filenames in os.walk(top):
            dirnames.sort()
            rel_dir = os.path.relpath(dirpath, root).replace(os.sep, "/")
            dirnames[:] = [d for d in dirnames if not d.startswith(".") and d != "build"
                           and not (rel_dir + "/" + d + "/").startswith(excluded)]
            for name in sorted(filenames):
                if not name.endswith(ext):
                    continue
                rel = rel_dir + "/" + name
                if rel.startswith(excluded):
                    continue
                if not include_tests and is_test_path(rel):
                    continue
                try:
                    with open(os.path.join(dirpath, name), encoding="utf-8") as f:
                        yield rel, platform, f.read()
                except (OSError, UnicodeDecodeError):
                    continue


def bucket_for(catalog, rel, platform):
    best = None
    if catalog is not None:
        for ns in catalog.namespaces:
            for prefix in ns.slices.get(platform, []):
                if rel.startswith(prefix) and (best is None or len(prefix) > len(best[0])):
                    best = (prefix, ns.name)
    return "%s/%s" % (platform, best[1] if best else "_unsliced")


# ---------------------------------------------------------------- 1 ファイル

@dataclass
class FileReport:
    path: str
    platform: str
    bucket: str
    lines: list = field(default_factory=list)  # (行, リテラル) 日本語リテラルのある行
    forbidden: dict = field(default_factory=dict)  # 規則 → 件数
    hits: list = field(default_factory=list)  # (規則, 行, コード)


def _ignores(lexed):
    """(無視する行の集合, ファイルごと無視か, 理由の無い ignore の行)。"""
    ignored = set()
    whole = False
    bad = []
    for line, text in lexed.comments:
        m = _IGNORE.search(text)
        if not m:
            continue
        is_file, cat, colon, reason = m.groups()
        if cat not in IGNORE_CATEGORIES or not colon or not reason.strip():
            bad.append(line)
            continue
        if is_file:
            whole = True
            continue
        ignored.add(line)
        code_here = lexed.code[line - 1].strip() if line - 1 < len(lexed.code) else ""
        if not code_here:
            nxt = line + 1
            while nxt - 1 < len(lexed.code) and not lexed.code[nxt - 1].strip():
                nxt += 1
            ignored.add(nxt)
    return ignored, whole, bad


def _preview_lines(lexed):
    skip = set()
    i = 0
    n = len(lexed.bare)
    while i < n:
        if _PREVIEW.search(lexed.bare[i]):
            depth = 0
            opened = False
            j = i
            while j < n:
                for ch in lexed.bare[j]:
                    if ch == "{":
                        depth += 1
                        opened = True
                    elif ch == "}":
                        depth -= 1
                skip.add(j + 1)
                j += 1
                if opened and depth <= 0:
                    break
            i = j
        else:
            i += 1
    return skip


def scan_file(rel, platform, text, catalog=None, catalog_keys=None):
    kotlin = platform == "android"
    lexed = lex(text, kotlin)
    report = FileReport(path=rel, platform=platform, bucket=bucket_for(catalog, rel, platform))
    ignored, whole, bad = _ignores(lexed)
    for line in bad:
        report.forbidden["ignore_without_reason"] = report.forbidden.get("ignore_without_reason", 0) + 1
        report.hits.append(("ignore_without_reason", line, ""))
    if whole:
        return report
    preview = _preview_lines(lexed)

    def skipped(line):
        code = lexed.code[line - 1] if line - 1 < len(lexed.code) else ""
        return line in ignored or line in preview or bool(_ALLOW_LINE.search(code))

    seen = set()
    for lit in lexed.literals:
        if lit.line in seen or not has_japanese(lit.text) or skipped(lit.line):
            continue
        seen.add(lit.line)
        report.lines.append((lit.line, lit.text))
    report.lines.sort()

    lang = "kotlin" if kotlin else "swift"
    vm_or_data = kotlin and (rel.endswith("ViewModel.kt") or "/data/" in rel)
    for idx, code in enumerate(lexed.code):
        line = idx + 1
        if not code.strip() or line in ignored or line in preview:
            continue
        allowed_line = bool(_ALLOW_LINE.search(code))
        japanese = has_japanese(code)
        counted = set()
        for rule, target, rx, needs_japanese in FORBIDDEN:
            if rule in counted or target not in ("both", lang) or allowed_line or (needs_japanese and not japanese):
                continue
            if rule == "android_resolve_in_vm_data" and not vm_or_data:
                continue
            if rule == "ja_jp_formatter" and rel in JA_JP_ALLOWED_FILES:
                continue
            if not rx.search(code):
                continue
            if rule in ("static_let_localized", "localized_resource_call") and _INTENT_METADATA.search(code):
                continue
            counted.add(rule)
            report.forbidden[rule] = report.forbidden.get(rule, 0) + 1
            report.hits.append((rule, line, code.strip()))
        if not kotlin and catalog_keys is not None:
            for m in _DIRECT_KEY.finditer(code):
                if m.group(1) not in catalog_keys:
                    report.forbidden["intent_key_missing"] = report.forbidden.get("intent_key_missing", 0) + 1
                    report.hits.append(("intent_key_missing", line, m.group(1)))
    return report


# ---------------------------------------------------------------- まとめ

@dataclass
class ScanResult:
    files: list  # FileReport

    def buckets(self):
        out = {}
        for f in self.files:
            b = out.setdefault(f.bucket, {"lines": 0, "literals": set()})
            b["lines"] += len(f.lines)
            for _, text in f.lines:
                b["literals"].add(literal_hash(text))
        return out

    def forbidden(self):
        out = {}
        for f in self.files:
            for rule, n in f.forbidden.items():
                out["%s::%s" % (f.path, rule)] = n
        return out

    def forbidden_by_rule(self):
        out = {}
        for f in self.files:
            for rule, n in f.forbidden.items():
                out[rule] = out.get(rule, 0) + n
        return out

    def totals(self):
        out = {}
        for f in self.files:
            out[f.platform] = out.get(f.platform, 0) + len(f.lines)
        return out

    def baseline(self):
        return {
            "buckets": {b: {"lines": v["lines"], "literals": sorted(v["literals"])}
                        for b, v in sorted(self.buckets().items())},
            "forbidden": dict(sorted(self.forbidden().items())),
            "files": {f.path: len(f.lines) for f in self.files if f.lines},
        }


def scan(root, catalog=None, exclude_roots=()):
    keys = {e.full_key for e in catalog.entries()} if catalog is not None else None
    files = [scan_file(rel, platform, text, catalog, keys)
             for rel, platform, text in iter_sources(root, exclude_roots)]
    return ScanResult(files=files)


def report_markdown(result, baseline=None, mode="report"):
    lines = ["## i18n scan (%s)" % mode, ""]
    totals = result.totals()
    lines.append("日本語リテラルのある行: iOS %d / Android %d" % (totals.get("ios", 0), totals.get("android", 0)))
    lines.append("")
    base_buckets = (baseline or {}).get("buckets", {})
    lines += ["| バケット | 行 | 基準線 | 差 |", "|---|---:|---:|---:|"]
    buckets = result.buckets()
    for b in sorted(set(buckets) | set(base_buckets)):
        now = buckets.get(b, {}).get("lines", 0)
        if baseline is None:
            lines.append("| %s | %d | - | - |" % (b, now))
        else:
            was = base_buckets.get(b, {}).get("lines", 0)
            lines.append("| %s | %d | %d | %+d |" % (b, now, was, now - was))
    lines += ["", "| 禁止パターン | 件数 | 基準線 | 差 |", "|---|---:|---:|---:|"]
    by_rule = result.forbidden_by_rule()
    base_rule = {}
    for k, n in (baseline or {}).get("forbidden", {}).items():
        rule = k.split("::", 1)[-1]
        base_rule[rule] = base_rule.get(rule, 0) + n
    for rule in sorted(set(by_rule) | set(base_rule)):
        now = by_rule.get(rule, 0)
        if baseline is None:
            lines.append("| %s | %d | - | - |" % (rule, now))
        else:
            was = base_rule.get(rule, 0)
            lines.append("| %s | %d | %d | %+d |" % (rule, now, was, now - was))
    lines.append("")
    return "\n".join(lines)
