"""tools/i18n のテストの下ごしらえ。

    python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'

テストは一時ディレクトリにリポジトリの形 (i18n/, project.yml, ソース) を作って、そこだけを触る。
本物の i18n/ と生成物は読まない・書かない。
"""

import contextlib
import copy
import importlib.util
import io
import json
import os
import sys
import tempfile
from pathlib import Path

TOOLS_I18N = Path(__file__).resolve().parent.parent
REPO = TOOLS_I18N.parent.parent

if str(TOOLS_I18N) not in sys.path:
    sys.path.insert(0, str(TOOLS_I18N))

import model  # noqa: E402
import source_json  # noqa: E402


def load_cli():
    """tools/i18n/i18n.py を読み込む (名前が i18n/ ディレクトリとぶつからないよう別名で)。"""
    spec = importlib.util.spec_from_file_location("i18n_cli", str(TOOLS_I18N / "i18n.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


CLI = load_cli()

PROJECT_YML = """\
name: ImasLiveDB
settings:
  base:
    MARKETING_VERSION: "2.3.0"
  configs:
    Release:
      XCSTRINGS_LANGUAGES_TO_COMPILE: {release}
targets:
  ImasLiveDB:
    type: application
    sources:
      - path: ImasLiveDB
        excludes:
          - Resources/master.sqlite
    settings:
      base:
        INFOPLIST_KEY_CFBundleDisplayName: アイドルライブDB
        INFOPLIST_KEY_NSCameraUsageDescription: "セットリストの写真を撮影してOCRで曲名を認識します"
{app_extra}      configs:
        Release:
          CODE_SIGN_STYLE: Automatic
{target_gate}  ImasLiveDBWidget:
    type: app-extension
    settings:
      base:
        INFOPLIST_KEY_CFBundleDisplayName: 担当ウィジェット
"""


def project_yml(release="ja", target_gate=False, app_extra=""):
    gate = "          XCSTRINGS_LANGUAGES_TO_COMPILE: ja ko\n" if target_gate else ""
    return PROJECT_YML.format(release=release, target_gate=gate, app_extra=app_extra)


def config(languages=None, ratchet="report"):
    languages = languages or {"ja": "release", "ko": "dev"}
    return {
        "source_language": "ja",
        "languages": {lang: {"channel": ch} for lang, ch in languages.items()},
        "guard": {"ratchet": ratchet},
    }


I18N_NS = {
    "namespace": "i18n",
    "kind": "system",
    "ios_bundles": ["app", "widget"],
    "strings": {"language_tag": {"ja": "ja", "ko": "ko", "en": "en"}},
}

# 両エミッタのテストで使う、書式・エスケープ・複数形を一通り含むカタログ
RICH = {
    "i18n": I18N_NS,
    "common": {
        "namespace": "common",
        "kind": "ui",
        "ios_bundles": ["app", "widget"],
        "slices": {"ios": ["ImasLiveDB/DesignSystem/"], "android": ["ImasLiveDB-Android/app/src/main/kotlin/x/ui/components/"]},
        "strings": {
            "action.see_all": {"note": "セクション見出し右の導線", "ja": "すべて見る", "ko": "모두 보기"},
            "discount": {"ja": "50%オフ", "ko": "50% 할인"},
            "sym.at": {"ja": "@担当 'です' \"引用\" & <b>"},
            "sym.question": {"ja": "?はてな"},
            "sym.spaces": {"ja": "前  後"},
            "sym.newline": {"ja": "一行目\n二行目"},
            "sym.backslash": {"ja": "a\\b"},
            "sym.braces": {"ja": "{{そのまま}}"},
            "list.middot": {"keep_whitespace": True, "ja": "・", "ko": " · "},
            "default": {"note": "Swift / Kotlin の予約語", "ja": "既定"},
        },
    },
    "events": {
        "namespace": "events",
        "kind": "ui",
        "slices": {"ios": ["ImasLiveDB/Views/Events/"]},
        "strings": {
            "attendance.group_header": {
                "note": "出演者グループの小見出し",
                "args": [{"name": "label", "type": "core"}, {"name": "count", "type": "count"}],
                "ja": "{label} ・ {count}名",
                "ko": "{label} · {count}명",
                "en": {"one": "{count} member in {label}", "other": "{count} members in {label}"},
            },
            "detail.first_show_year": {
                "args": [{"name": "year", "type": "int"}],
                "ja": "{year}年",
                "ko": "{year}년",
            },
            "songs": {
                "args": [{"name": "count", "type": "count"}],
                "ja": "{count}曲",
                "ko": "{count}곡",
                "en": {"one": "one song", "other": "{count} songs"},
            },
            "rate": {
                "args": [{"name": "name", "type": "string"}],
                "ja": "{name}の達成率 100%",
            },
            "nested": {
                "args": [{"name": "inner", "type": "text"}],
                "ja": "言語: {inner}",
                "ko": "언어: {inner}",
            },
            "only_ja": {"ja": "日本語だけ"},
            "ios_only": {"platforms": ["ios"], "ja": "iOS だけ"},
        },
    },
    "system": {
        "namespace": "system",
        "kind": "system",
        "strings": {
            "app.display_name": {
                "ios": {"infoplist": {"target": "app", "key": "CFBundleDisplayName"}},
                "ja": "アイドルライブDB",
                "ko": "아이돌 라이브 DB",
            },
            "app.camera_usage": {
                "platforms": ["ios"],
                "ios": {"infoplist": {"target": "app", "key": "NSCameraUsageDescription"}},
                "ja": "セットリストの写真を撮影してOCRで曲名を認識します",
            },
            "widget_extension.display_name": {
                "platforms": ["ios"],
                "ios": {"infoplist": {"target": "widget", "key": "CFBundleDisplayName"}},
                "ja": "担当ウィジェット",
            },
        },
    },
    "widget": {
        "namespace": "widget",
        "kind": "ui",
        "ios_bundles": ["app", "widget"],
        "platforms": ["android"],
        "strings": {
            "next_live.description": {"ja": "次のライブまでの日数を表示します。", "ko": "다음 라이브까지 남은 날을 보여 줘요."},
        },
    },
}

RICH_LANGUAGES = {"ja": "release", "ko": "dev", "en": "dev"}


class Fixture:
    """一時ディレクトリに作るリポジトリ。with で使う。"""

    def __init__(self, namespaces=None, languages=None, project=True, ratchet="report"):
        self._tmp = tempfile.TemporaryDirectory()
        self.root = self._tmp.name
        self.write_json(model.CONFIG_PATH, config(languages, ratchet))
        for name, raw in (namespaces or {}).items():
            self.write_json(source_json.catalog_rel(name), raw)
        if project:
            self.write("project.yml", project if isinstance(project, str) else project_yml())

    def __enter__(self):
        return self

    def __exit__(self, *exc):
        self._tmp.cleanup()

    def path(self, rel):
        return os.path.join(self.root, rel)

    def write(self, rel, text):
        p = self.path(rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8", newline="\n") as f:
            f.write(text)

    def write_json(self, rel, obj):
        self.write(rel, json.dumps(obj, ensure_ascii=False, indent=2) + "\n")

    def read(self, rel):
        with open(self.path(rel), encoding="utf-8") as f:
            return f.read()

    def exists(self, rel):
        return os.path.exists(self.path(rel))

    def load(self):
        return CLI.load(self.root)

    def problems(self, external=True):
        catalog, problems = self.load()
        return CLI.full_problems(self.root, catalog, problems, external=external)

    def emit(self):
        catalog, problems = self.load()
        errors = [p.format() for p in CLI.full_problems(self.root, catalog, problems, external=False) if p.is_error]
        if errors:
            raise AssertionError("フィクスチャのカタログにエラー:\n" + "\n".join(errors))
        return CLI.emit(catalog), catalog

    def run(self, *argv):
        out = io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(out):
            try:
                code = CLI.main(["--root", self.root] + list(argv))
            except SystemExit as e:
                code = e.code if isinstance(e.code, int) else 2
        return code, out.getvalue()


def rich(**overrides):
    """RICH の深いコピー (テストごとに書き換えてよい)。"""
    data = copy.deepcopy(RICH)
    data.update(overrides)
    return data


def messages(problems, level=None):
    return [p.format() for p in problems if level is None or p.level == level]
