#!/usr/bin/env python3
"""文言カタログ (i18n/catalog) の検査と、iOS / Android の生成物づくり。

    python3 tools/i18n/i18n.py check                 カタログの検査
    python3 tools/i18n/i18n.py generate              生成物 (i18n/TRANSLATION.md も) を作り直す (決定的)
    python3 tools/i18n/i18n.py generate --check      生成物が古くないか (書かずに比べる)
    python3 tools/i18n/i18n.py outputs               生成器が持つ出力の経路のうち、在るもの
    python3 tools/i18n/i18n.py outputs --check-committed   生成物が git に入っているか (CI)
    python3 tools/i18n/i18n.py gate --config Release XCSTRINGS_LANGUAGES_TO_COMPILE に入れる言語
    python3 tools/i18n/i18n.py add <ns> <相対キー> "<原文>" [--arg 名前:型 …] [--note …] [--ko …]
    python3 tools/i18n/i18n.py stats                 網羅率など (Markdown)

Python 3.9 と標準ライブラリだけで動く。文言の正はカタログ。生成物は手で直さない。
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import emit_android  # noqa: E402
import emit_apple  # noqa: E402
import model  # noqa: E402
import source_json  # noqa: E402
import stats  # noqa: E402
import translation_doc  # noqa: E402
import validate  # noqa: E402

REPO = os.path.dirname(os.path.dirname(HERE))

# 生成器が持つ出力の経路。generate はここを空にしてから作り直す (人が書くコードは置かない)
OWNED_ROOTS = emit_apple.OWNED_ROOTS + emit_android.OWNED_ROOTS
# 生成器が持つ 1 ファイルの出力 (同じディレクトリに人が書くファイルもあるので、ファイルだけを持つ)
OWNED_FILES = (model.TRANSLATION_DOC_PATH,)
OUTPUT_PATHS = OWNED_ROOTS + OWNED_FILES

# 生成物の置き場にあっても生成物として扱わないもの (Finder が勝手に作る)
IGNORED_NAMES = (".DS_Store",)


# ---------------------------------------------------------------- 共通

def load(root):
    problems = []
    raw = source_json.load_repo(root, problems)
    catalog = model.build(raw, problems)
    return catalog, problems


def read_text(root, rel):
    path = os.path.join(root, rel)
    if not os.path.isfile(path):
        return None
    with open(path, encoding="utf-8") as f:
        return f.read()


def emit(catalog):
    files = {}
    files.update(emit_apple.emit(catalog))
    files.update(emit_android.emit(catalog))
    files.update(translation_doc.emit(catalog))
    return files


def full_problems(root, catalog, problems, external=True):
    """形の問題に、意味の検査 (external なら project.yml との照合も) と生成物の不変式を足す。"""
    if catalog is None:
        return problems
    project = read_text(root, "project.yml") if external else None
    problems = problems + validate.validate(catalog, project, external)
    if not any(p.is_error for p in problems):
        problems += emit_android.invariant_problems(catalog, emit(catalog))
    return problems


def print_problems(problems, quiet_warnings=False):
    errors = [p for p in problems if p.is_error]
    warnings = [p for p in problems if not p.is_error]
    for p in errors:
        print(p.format())
    if not quiet_warnings:
        for p in warnings:
            print(p.format())
    return len(errors), len(warnings)


def git_tracked(root, paths):
    """paths の下で git の索引にあるファイル (相対パス)。git が使えなければ None。"""
    try:
        out = subprocess.run(["git", "-C", root, "ls-files", "-z", "--"] + list(paths),
                             stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, check=True).stdout
    except (OSError, subprocess.CalledProcessError):
        return None
    return {p for p in out.decode("utf-8").split("\0") if p}


def files_on_disk(root):
    out = {f for f in OWNED_FILES if os.path.isfile(os.path.join(root, f))}
    for r in OWNED_ROOTS:
        top = os.path.join(root, r)
        if not os.path.isdir(top):
            continue
        for dirpath, _, filenames in os.walk(top):
            for name in filenames:
                if name in IGNORED_NAMES:
                    continue
                out.add(os.path.relpath(os.path.join(dirpath, name), root).replace(os.sep, "/"))
    return out


def write_outputs(root, files):
    # 1 つでも消せない置き場があれば、どれも消さないうちに止める
    for r in OWNED_ROOTS:
        if os.path.islink(os.path.join(root, r)):
            raise SystemExit("✗ %s がシンボリックリンクなので消さない (生成物の置き場は普通のディレクトリにする)" % r)
    for r in OWNED_ROOTS:
        path = os.path.join(root, r)
        if os.path.isdir(path):
            shutil.rmtree(path)
    for f in OWNED_FILES:
        path = os.path.join(root, f)
        if os.path.isfile(path) or os.path.islink(path):
            os.remove(path)
    for rel in sorted(files):
        path = os.path.join(root, rel)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8", newline="\n") as f:
            f.write(files[rel])


def regenerate(root):
    """カタログから生成物を作り直す。検査で落ちれば書かずに False。"""
    catalog, problems = load(root)
    problems = full_problems(root, catalog, problems, external=False)
    if catalog is None or any(p.is_error for p in problems):
        print_problems(problems, quiet_warnings=True)
        print("✗ カタログにエラーがあるので生成しない")
        return False
    files = emit(catalog)
    write_outputs(root, files)
    return files


# ---------------------------------------------------------------- 各コマンド

def cmd_check(args):
    catalog, problems = load(args.root)
    problems = full_problems(args.root, catalog, problems, external=True)
    errors, warnings = print_problems(problems)
    if catalog is None:
        print("✗ カタログを読めない")
        return 1
    keys = sum(len(ns.entries) for ns in catalog.namespaces)
    gate = "照合した" if validate.ios_outputs(catalog) else "照合しない (iOS に出す名前空間が無い)"
    summary = "名前空間 %d / キー %d。エラー %d 件、警告 %d 件 (project.yml: %s)" % (
        len(catalog.namespaces), keys, errors, warnings, gate)
    print(("✗ " if errors else "✓ ") + summary)
    return 1 if errors else 0


def cmd_generate(args):
    if args.check:
        catalog, problems = load(args.root)
        problems = full_problems(args.root, catalog, problems, external=False)
        if catalog is None or any(p.is_error for p in problems):
            print_problems(problems, quiet_warnings=True)
            print("✗ カタログにエラーがあるので比べられない")
            return 1
        files = emit(catalog)
        stale = []
        disk = files_on_disk(args.root)
        for rel in sorted(set(files) | disk):
            if rel not in disk:
                stale.append("✗ 生成物が無い: %s" % rel)
            elif rel not in files:
                stale.append("✗ 余分な生成物: %s" % rel)
            elif read_text(args.root, rel) != files[rel]:
                stale.append("✗ 生成物が古い: %s" % rel)
        for line in stale:
            print(line)
        if stale:
            print("  → python3 tools/i18n/i18n.py generate を実行して commit する")
            return 1
        print("✓ 生成物は新しい (%d ファイル)" % len(files))
        return 0
    files = regenerate(args.root)
    if files is False:
        return 1
    print("✓ 生成した: %d ファイル" % len(files))
    return 0


def cmd_outputs(args):
    if args.check_committed:
        catalog, problems = load(args.root)
        if catalog is None or any(p.is_error for p in problems):
            print_problems(problems, quiet_warnings=True)
            return 1
        files = emit(catalog)
        has_entries = any(ns.entries for ns in catalog.namespaces)
        if not files:
            if has_entries:
                print("✗ カタログに文言があるのに生成物が 1 つも無い (生成器の不具合)")
                return 1
            print("生成物なし (カタログが空)")
            return 0
        tracked = git_tracked(args.root, OUTPUT_PATHS)
        if tracked is None:
            print("✗ git の索引を読めない")
            return 1
        missing = sorted(f for f in files if f not in tracked)
        for f in missing:
            print("✗ 生成物が commit されていない: %s" % f)
        if missing:
            print("  → python3 tools/i18n/i18n.py generate を実行して生成物も commit する")
            return 1
        print("✓ 生成物 %d ファイルが git に入っている" % len(files))
        return 0
    tracked = git_tracked(args.root, OUTPUT_PATHS) or set()
    for r in OWNED_ROOTS:
        if os.path.exists(os.path.join(args.root, r)) or any(t.startswith(r + "/") for t in tracked):
            print(r)
    for f in OWNED_FILES:
        if os.path.exists(os.path.join(args.root, f)) or f in tracked:
            print(f)
    return 0


def cmd_gate(args):
    catalog, problems = load(args.root)
    if catalog is None:
        print_problems(problems)
        return 1
    print(" ".join(catalog.config.languages_for(args.config)))
    return 0


def _parse_arg(spec):
    if ":" not in spec:
        raise SystemExit("✗ --arg は 名前:型 (例: count:count)。型は %s" % " / ".join(model.ARG_TYPES))
    name, typ = spec.split(":", 1)
    return {"name": name, "type": typ}


def cmd_add(args):
    root = args.root
    problems = []
    raw_repo = source_json.load_repo(root, problems)
    catalog = model.build(raw_repo, problems)
    if catalog is None:
        print_problems(problems)
        return 1
    rel = source_json.catalog_rel(args.ns)
    existing = [item for item in raw_repo.namespaces if item[0] == rel]
    created = not existing
    if created:
        if not model.NS_RE.match(args.ns):
            print("✗ 名前空間 %s は英小文字で始まる英小文字・数字・_ にする" % args.ns)
            return 1
        raw_ns = {"namespace": args.ns, "kind": "ui", "strings": {}}
        raw_repo.namespaces.append((rel, args.ns, raw_ns))
    else:
        raw_ns = existing[0][2]
    strings = raw_ns.get("strings")
    if not isinstance(strings, dict):
        print("✗ %s の strings がオブジェクトでない" % rel)
        return 1
    if args.key in strings:
        print("✗ %s.%s はもうある (%s)" % (args.ns, args.key, rel))
        return 1
    entry = {catalog.config.source_language: args.text}
    if args.ko is not None:
        entry["ko"] = args.ko
    if args.arg:
        entry["args"] = [_parse_arg(a) for a in args.arg]
    if args.note:
        entry["note"] = args.note
    if args.platforms:
        entry["platforms"] = [p.strip() for p in args.platforms.split(",") if p.strip()]
    strings[args.key] = entry

    problems = []
    new_catalog = model.build(raw_repo, problems)
    problems = full_problems(root, new_catalog, problems, external=False)
    if new_catalog is None or any(p.is_error for p in problems):
        print_problems(problems, quiet_warnings=True)
        print("✗ 足すと検査に落ちるので書かなかった")
        return 1
    source_json.write_json(root, rel, raw_ns)
    files = regenerate(root)
    if files is False:
        return 1
    ns = new_catalog.namespace(args.ns)
    e = new_catalog.find("%s.%s" % (args.ns, args.key))
    print("✓ %s に %s を足した%s。生成物も作り直した (%d ファイル)" % (
        rel, e.full_key, " (名前空間を新しく作った: kind ui / ios_bundles app)" if created else "", len(files)))
    if e.on("ios"):
        ios = emit_apple.accessor_example(ns, e)
        print("  iOS:     %s" % ios)
        if not e.intent_metadata:
            print("           画面へは Text(display: .key(%s))" % ios)
    if e.on("android"):
        android = emit_android.accessor_example(ns, e)
        print("  Android: %s" % android)
        print("           画面へは DisplayText のまま渡し、文字列にするなら .resolve()")
    return 0


def cmd_stats(args):
    catalog, problems = load(args.root)
    if catalog is None:
        print_problems(problems)
        return 1
    print(stats.markdown(catalog))
    return 0


def parser():
    p = argparse.ArgumentParser(prog="i18n.py", description="文言カタログの検査と生成")
    p.add_argument("--root", default=REPO, help=argparse.SUPPRESS)
    sub = p.add_subparsers(dest="command")
    sub.required = True

    sub.add_parser("check", help="カタログの検査").set_defaults(func=cmd_check)

    g = sub.add_parser("generate", help="生成物を作り直す")
    g.add_argument("--check", action="store_true", help="書かずに、生成物が新しいかだけ比べる")
    g.set_defaults(func=cmd_generate)

    o = sub.add_parser("outputs", help="生成器が持つ出力の経路 (在るものだけ)")
    o.add_argument("--check-committed", action="store_true", help="生成するはずのファイルが git の索引にあるか")
    o.set_defaults(func=cmd_outputs)

    gt = sub.add_parser("gate", help="ビルド構成に入る言語")
    gt.add_argument("--config", required=True, choices=sorted(model.CONFIG_CHANNELS))
    gt.set_defaults(func=cmd_gate)

    a = sub.add_parser("add", help="文言を 1 つ足して生成し直す")
    a.add_argument("ns")
    a.add_argument("key")
    a.add_argument("text", help="基準言語の原文 (引数は {名前})")
    a.add_argument("--arg", action="append", help="名前:型 (型は %s)。原文に出る順に" % " / ".join(model.ARG_TYPES))
    a.add_argument("--note", help="翻訳者へのメモ")
    a.add_argument("--ko", help="韓国語の訳 (無ければ書かない)")
    a.add_argument("--platforms", help="ios,android の一部だけにするとき")
    a.set_defaults(func=cmd_add)

    sub.add_parser("stats", help="網羅率など (Markdown)").set_defaults(func=cmd_stats)
    return p


def main(argv=None):
    args = parser().parse_args(argv)
    args.root = os.path.abspath(args.root)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
