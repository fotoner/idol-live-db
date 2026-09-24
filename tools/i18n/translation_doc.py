"""翻訳者 (人と AI) への手引き i18n/TRANSLATION.md を作る (i18n.py generate の出力の 1 つ)。

中身は i18n/config.json (言語と channel) と i18n/glossary.json (文体・用語) から決まる。
文章そのものはここに置き、用語や文体を変えるときは glossary.json を直して generate する。
カタログの項目の数などは入れない (文言を 1 つ足すたびに差分が出ないように)。
"""

from __future__ import annotations

import cldr
import model
import validate

COMMAND = "python3 tools/i18n/i18n.py generate"

# 表示用の言語名。無い言語はコードだけ出す
LANGUAGE_NAMES = {
    "ja": "日本語",
    "ko": "한국어 (韓国語)",
    "en": "English (英語)",
    "zh-Hans": "简体中文 (中国語・簡体字)",
    "zh-Hant": "繁體中文 (中国語・繁体字)",
}

CHANNEL_BUILDS = {
    "planned": "どのビルドにも入らない (準備中)",
    "dev": "Debug だけ",
    "beta": "Debug・Beta",
    "release": "すべて",
}


def _cell(text):
    return text.replace("\n", " ").replace("|", "\\|")


def _language_name(lang):
    return LANGUAGE_NAMES.get(lang, lang)


def _plural_rule(lang):
    cats = cldr.categories(lang)
    if cats == ("other",):
        return "数で語の形が変わらない (count を持つキーも文字列 1 つで書く)"
    example = ", ".join('"%s": "…"' % c for c in cats)
    return "count を持つキーは %s の形をそれぞれ書く (`{%s}`。足りない範疇は other で出る = 警告)" % (
        " / ".join(cats), example)


def _term_value(term, lang):
    forms = validate.glossary_forms(term, lang)
    if not forms:
        return "—"
    shown = " / ".join(forms)
    if term.get("keep") is True:
        return "(訳さない) " + shown
    return shown


def _terms(glossary):
    terms = glossary.get("terms", []) if isinstance(glossary, dict) else []
    if not isinstance(terms, list):
        return []
    return [t for t in terms if isinstance(t, dict) and isinstance(t.get("ja"), str) and t["ja"]]


def _style(glossary, lang):
    style = glossary.get("style", {}) if isinstance(glossary, dict) else {}
    rule = style.get(lang) if isinstance(style, dict) else None
    if isinstance(rule, str) and rule:
        return rule
    return "(まだ無い。i18n/glossary.json の style.%s に書く)" % lang


INTRO = """\
UI の文言 (`i18n/catalog/<名前空間>.json`) を訳す人・訳を確かめる人のための手引き。

## 誰が読むか

- **人の翻訳者・レビュアー。**
- **AI エージェント。** 手元のコーディングエージェント (Claude Code・Codex など) や、Xcode 27 の String Catalog の
  エージェント翻訳で下訳を作るときも、この手引きに従わせる。手元の `AGENTS.md` / `CLAUDE.md` に
  「UI の文言を訳すときは i18n/TRANSLATION.md に従う」と 1 行書いておく (このリポジトリの `CLAUDE.md` は
  追跡外なので、各自の手元のものに書く)。
- 文言の仕組み (カタログの書き方・命令・生成物・言語とチャネル) は [i18n/README.md](README.md)。
  ここに書くのは「どう訳すか」と「どう確かめるか」。

このファイルは `i18n/config.json` と `i18n/glossary.json` から `generate` が作る (手で直さない)。
用語や文体の決まりを変えるときは `glossary.json` を直して `generate` し、このファイルも同じ commit に入れる。
"""

WHERE = """\
## 訳を書く場所

- 訳は**カタログの項目に言語コードで書く** (`"ko": "…"`・`"en": "…"`・`"zh-Hans": "…"`)。
- 生成物 (`*.xcstrings`・`strings_<ns>.xml`) は直さない。Xcode の String Catalog エディタや Xcode 27 の
  エージェント翻訳で xcstrings に書いた訳は、次の `generate` で消える。Xcode で下訳を作ったなら、値をカタログに写す。
- 書いたら次を回し、生成物もカタログと同じ commit に入れる。

```sh
python3 tools/i18n/i18n.py check      # エラー 0 件にする (警告も読む)
python3 tools/i18n/i18n.py generate   # 生成物を作り直す
python3 tools/i18n/i18n.py stats      # 言語ごとの 確定 / 未検収 / stale / edited / 欠落
```
"""

RULES = """\
## 共通の規則

1. **プレースホルダ `{名前}` はそのまま残す。** 名前を訳さない・綴りを変えない。語順に合わせて並べ替えたり、
   2 回使ったりはしてよい。`args` に無い `{…}` を足したり、`args` の引数を落としたりすると check のエラー
   (count を持つキーの other 以外の範疇だけは `{count}` を省いてよい)。波括弧そのものは `{{` `}}`。
   `%@`・`%d`・`\\(x)`・`${x}` などのプラットフォームの書式は書かない。
2. **データと固有名詞は訳さない。** アイドル名・曲名・CD 名・ライブ名・ユニット名・会場名・ブランドの正式名・
   会社名。多くは引数 (`string` / `core`) で差し込まれる。原文に直接書かれた固有名詞も原表記のまま残す
   (ローマ字にしない・簡体字にしない・ハングルにしない)。その言語の公式の表記があるものだけ用語集で決める。
3. **[CONTRIBUTING.md の 2. 非公式・版権の遵守](../CONTRIBUTING.md#2-非公式版権の遵守-絶対) を守る。**
   「アプリ名・表示に『アイマス』『アイドルマスター』等の固有名称を入れない」は、どの言語でも、その訳や英字表記
   (THE IDOLM@STER・iM@S・아이마스・偶像大师 など) も含めて守る。アプリ名 (`system.app.display_name` など) には
   入れない。免責の文などでシリーズ名を説明に出すのは ja の原文と同じ扱い (原文にあるところだけ訳し、足さない)。
4. **`note` (翻訳者へのメモ) に従う。** どの画面のどこに出るか・何を指すかが書いてある。分からなければ PR で聞く。
5. **`max_len` を超えない。** 引数を除いた文字数の上限 (画面に収まる長さ)。超えると check のエラー。
6. 前後の空白と改行は原文に合わせる (`keep_whitespace` の項目だけが前後の空白を持てる)。
7. 訳が無い項目には何も書かない (空文字列も書かない)。実行時は ja に落ちる。
8. **用語集の語を使う** (下の言語別の表)。原文に ja の語があるのに、訳にその言語の語 (候補のどれか) が無いと
   check が警告する (英字は大文字小文字を区別せず、語の頭から探す。songs は song に合い、call は all に合わない)。
   警告は判断の材料で、文脈で別の語が正しければそのままでよい (用語集を直すなら PR で)。
   「訳さない」の語は ja のまま残す。仮名が残る項目には `verbatim_ok: true` が要る (仮名の警告を止める)。
9. **AI は `stamp` しない。** `stamp` は人が訳を確かめた記録で、`--reviewer` に確かめた人の名前が残る。
   AI エージェントの仕事は訳を書く・直す・check を通すところまで。
"""

REVIEW = """\
## 検収 (レビュー) の流れ

1. 訳を書いて PR にする (人でも AI でもよい)。この時点の状態は「未検収」。
2. その言語が分かる人がレビューする。用語集と文体に合っているか、画面で切れないか (Debug ビルド・
   疑似言語で見る。やり方は i18n/README.md)。直す点は PR の上で直す。
   - planned の言語 (上の「言語」の表で channel が planned のもの) はビルドに入らないので、画面では見られない
     (疑似言語で見えるのは飾った ja で、その言語の訳ではない)。画面で確かめるのは、config.json の channel を
     dev に上げる PR のあと。planned のうちに stamp すると lock だけが変わる (xcstrings は変わらない)。
3. レビューした人が自分の名前で stamp する。`lock/<言語>.json` に 原文のハッシュ・訳のハッシュ・レビュアーが残る。
   dev 以上の言語は xcstrings の state も変わる (stamp が生成物を作り直す) ので、生成物と一緒に commit する。

   ```sh
   python3 tools/i18n/i18n.py stamp ko --reviewer <名前> --ns songs            # 名前空間ごと
   python3 tools/i18n/i18n.py stamp ko --reviewer <名前> --keys songs.list.title  # 1 件ずつ
   ```

4. あとで原文が変わると stale、訳だけが変わると edited になり、もう一度レビューと stamp が要る。

| 状態 | 意味 | xcstrings の state | 出荷ゲート (beta / release) |
|---|---|---|---|
| 欠落 (missing) | 訳が無い | (出さない。引数のある項目だけ基準言語の値を `new` で出す) | 止める |
| 未検収 (unreviewed) | 訳はあるが stamp していない | `needs_review` | 止める |
| 確定 (reviewed) | stamp のあとで原文も訳も変わっていない | `translated` | 通す |
| stale | stamp のあとで原文が変わった | `needs_review` | 止める |
| edited | stamp のあとで訳だけが変わった | `needs_review` | 止める |

- 旧形式の lock (値が原文のハッシュの文字列だけ) は edited を見分けられない。stamp し直すと新しい形式になる。
- xcstrings の state はコンパイルに影響しない。出荷を止めるのは check の出荷ゲート。
"""

PROMOTION = """\
## 言語を上げる条件 (channel)

| 上げ先 | 条件 |
|---|---|
| planned | 用語集に語と文体 (style) の草案を書いた。カタログに訳を書き始めてよい (ビルドには入らない) |
| dev | 主な画面の訳がそろい、Debug ビルドで見て確かめたい。`config.json` の channel を変える PR をオーナーが受ける |
| beta | ui / system の名前空間に 欠落・未検収・stale・edited が 0 件 (check の出荷ゲートが止める)。その言語の用語と文体をオーナーが確定した (glossary.json の status にその言語の確定者と日付を書く。全部の言語が確定したら status を消す)。データの字形の組版 (i18n/README.md の「漢字の字形」) を実装した。Beta 構成を作る |
| release | beta で主な画面を実機で確かめた。ストアの説明文などアプリの外の文言もそろった。オーナーが決める |
"""


def _languages_table(config):
    lines = ["## 言語", "",
             "| 言語 | 名前 | channel | 入るビルド | 複数形の範疇 |",
             "|---|---|---|---|---|"]
    for lang, channel in config.languages.items():
        name = _language_name(lang)
        if lang == config.source_language:
            name += " — 原文"
        lines.append("| `%s` | %s | %s | %s | %s |" % (
            lang, name, channel, CHANNEL_BUILDS[channel], " / ".join(cldr.categories(lang))))
    lines += ["", "planned の言語は、カタログ・用語集・lock に値を書いてよいが、生成物には出ない (どのビルドにも入らない)。", ""]
    return lines


def _language_section(config, glossary, lang):
    channel = config.channel(lang)
    terms = _terms(glossary)
    lines = ["### %s — %s" % (lang, _language_name(lang)), "",
             "- channel: **%s** — %s" % (channel, CHANNEL_BUILDS[channel]),
             "- 複数形: %s" % _plural_rule(lang),
             "", "**文体**", "", _style(glossary, lang), ""]
    if not terms:
        lines += ["用語集にまだ語が無い。", ""]
        return lines
    missing = sum(1 for t in terms if not validate.glossary_forms(t, lang))
    head = "**用語** (%d 語" % len(terms)
    if missing:
        head += "。この言語の語がまだ無いもの %d 語 = —" % missing
    head += ")"
    lines += [head, "", "| ja | %s | メモ |" % lang, "|---|---|---|"]
    for t in terms:
        note = t.get("note") if isinstance(t.get("note"), str) else ""
        lines.append("| %s | %s | %s |" % (_cell(t["ja"]), _cell(_term_value(t, lang)), _cell(note)))
    lines.append("")
    return lines


def markdown(catalog):
    config = catalog.config
    glossary = catalog.glossary if isinstance(catalog.glossary, dict) else {}
    status = glossary.get("status")
    lines = ["<!-- 生成物: %s・%s → %s。手で直さない (文章は tools/i18n/translation_doc.py) -->" % (
        model.CONFIG_PATH, model.GLOSSARY_PATH, COMMAND),
        "# 翻訳の手引き", ""]
    lines += INTRO.splitlines() + [""]
    if isinstance(status, str) and status:
        lines += ["> 用語集の状態: %s" % status.replace("\n", " "), ""]
    lines += _languages_table(config)
    lines += WHERE.splitlines() + [""]
    lines += RULES.splitlines() + [""]
    lines += REVIEW.splitlines() + [""]
    lines += PROMOTION.splitlines() + [""]
    others = config.others()
    lines += ["## 言語別の決まり", ""]
    if not others:
        lines += ["基準言語のほかに言語が無い。", ""]
    for lang in others:
        lines += _language_section(config, glossary, lang)
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines) + "\n"


def emit(catalog):
    """{リポジトリ相対パス: 中身}。カタログに文言が 1 つも無ければ出さない (ほかの生成物と同じ)。"""
    if not any(ns.entries for ns in catalog.namespaces if not ns.reserved):
        return {}
    return {model.TRANSLATION_DOC_PATH: markdown(catalog)}
