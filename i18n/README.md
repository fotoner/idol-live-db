# i18n

iOS / Android の UI 文言の **唯一の実体**。

画面の文言・Info.plist の表示名と権限の説明・Android のウィジェットの名前と説明は、ここのカタログ
(`i18n/catalog/<名前空間>.json`) が正になる。iOS の String Catalog (`.xcstrings`)、Android の
`strings_<ns>.xml`、両方のアクセサ (`L10n.<Ns>.<key>`) は `tools/i18n/i18n.py generate` が
カタログから作る。**生成物は手で直さない** (Xcode・Android Studio の翻訳エディタは見るだけにする)。
文言を変えるときは、**ここを変えてから** generate して、生成物も同じ commit に入れる。

訳す人・訳を確かめる人 (人も AI エージェントも) は、先に [TRANSLATION.md](TRANSLATION.md) を読む
(用語集と文体の決まり・検収の流れ。`generate` が `glossary.json` と `config.json` から作る)。

言語は **ja (原文)・ko・en・zh-Hans の 4 つ**を前提に設計してある (「[言語とチャネル](#言語とチャネル-出荷ゲート)」)。

## 置いてあるもの

| パス | 中身 |
|---|---|
| `config.json` | 言語と出荷チャネル、ガードのモード |
| `catalog/<ns>.json` | 名前空間 (= 機能のまとまり) ごとの文言。キー・原文 (ja)・訳・引数・翻訳者メモ |
| `lock/<言語>.json` | 検収の記録。原文のハッシュ・訳のハッシュ・レビュアー (`stamp` が書く) |
| `glossary.json` | 用語集と言語ごとの文体 (草案。オーナー確定前) |
| `TRANSLATION.md` | 翻訳者 (人と AI) への手引き。**生成物** (`generate` が `config.json` と `glossary.json` から作る) |
| `baseline/parity.json` | 片方のプラットフォームだけで使ってよいキーの許可リスト (`{"<完全キー>": "<理由>"}`) |
| `baseline/literals.json` | ソースに残る日本語リテラルの基準線 (`scan --update` が書く。今は報告だけ) |

## カタログの書き方

```json
{
  "namespace": "count",
  "kind": "ui",
  "ios_bundles": ["app", "widget"],
  "strings": {
    "songs": {
      "note": "曲数。1000 以上は桁区切りが付く (1,234曲)",
      "args": [{ "name": "count", "type": "count" }],
      "ja": "{count}曲",
      "ko": "{count}곡"
    }
  }
}
```

- ファイル名 = `namespace`。キーは名前空間を除いた相対キー (`<画面|部品>.<要素>[.<変形>]`、
  英小文字で始まるセグメントを `.` でつなぐ。最大 4 段)。完全キーは `<ns>.<相対キー>`。
- `ja` は必須で、コードにあった文字列と **1 バイトも違えない** (移行中は文言を直さない。直すのは別 PR)。
- 引数は `{名前}`。`%@` や `\(x)` や `${x}` は書かない (検査で落ちる)。波括弧そのものは `{{` `}}`。
- 訳が無い言語は書かない (空文字列も書かない)。iOS は defaultValue (= ja)、Android は既定の `values/` に落ちる。
- `kind`: `ui` / `system` (Info.plist・Manifest・ウィジェット選択画面) / `content` (長文。UI の網羅率から除く) /
  `reserved` (`core` 名前空間だけ。コア段階用で、アクセサは作らない)。
- `ios_bundles` に `widget` を入れた名前空間は、ウィジェット拡張にも入る (`ImasLiveDB/Shared/L10n/Generated/`)。
- `platforms` (名前空間・項目) で片方のプラットフォームだけにできる。
- ほかのフィールド: `max_len` (引数を除いた長さの上限。どの言語でも超えるとエラー)、`keep_whitespace` (前後の空白を許す)、
  `verbatim_ok` (訳に仮名が混じっても警告しない)、`ios.infoplist` (`system` だけ。`{target, key}`)、
  `ios.intent_metadata` (AppIntent / AppEntity のメタデータ。キーを宣言に直書きする)。
- ファイルは正規形 (キー整列・字下げ 2・`ensure_ascii` なし・末尾改行) で置く。`add` / `stamp` はこの形で書き直す。

### 引数の型と数の書式

| 型 | Swift | Kotlin | 桁区切り | 使いどころ |
|---|---|---|---|---|
| `int` | `Int` → `String(n)` を `%@` | `Int` / `%d` | なし (2026年) | 年・ID・順位・HTTP の状態など、数量でない整数 |
| `count` | `Int` / `%lld` + 複数形 | `Int` / `%,d` + `<plurals>` | ロケールどおり (1,234曲) | 助数詞が付く数量。キーに 1 つまで。複数形の選択子 |
| `string` | `String` / `%@` | `String` / `%s` | — | 訳さないデータ (名前・サーバの文言・書式済みの日付や小数) |
| `core` | `String` / `%@` | `String` / `%s` | — | imas-core が作った文字列 (コア段階の置換リスト) |
| `text` | `LocalizedStringResource` / `%@` | `DisplayText` / `%s` | — | 訳した文言を差し込む (外側と同じ言語で解決される) |

- 小数・パーセント・金額の型は無い。文字列にしてから `string` で渡す。
- `count` を持つキーは最初から複数形で出す (iOS は置換の plural、Android は `<plurals>`)。
  en を足すときは `"en": {"one": "{count} song", "other": "{count} songs"}` の 1 行で済む。
- 引数の順番は `ja` に最初に出る順。他の言語は並べ替え・繰り返しをしてよい。

## 命令

```sh
python3 tools/i18n/i18n.py check                 # 検査 (CI と同じ)
python3 tools/i18n/i18n.py generate              # 生成物を作り直す (何度やっても同じバイト列)
python3 tools/i18n/i18n.py generate --check      # 生成物が古くないかだけ見る
python3 tools/i18n/i18n.py add songs list.sort_title "並び替え" --note "並び替えシートの見出し"
python3 tools/i18n/i18n.py add events detail.first_show_year "{year}年" --arg year:int --ko "{year}년"
python3 tools/i18n/i18n.py stamp ko --reviewer <名前> --ns songs   # 人が確かめた ko の訳を検収済みにする
python3 tools/i18n/i18n.py stats                 # 網羅率・未検収・stale・edited
python3 tools/i18n/i18n.py scan [--list]         # 日本語リテラルと禁止パターンの数 (今は報告だけ)
python3 tools/i18n/i18n.py parity                # 両プラットフォームで同じキーを使っているか
python3 tools/i18n/i18n.py gate --config Release # XCSTRINGS_LANGUAGES_TO_COMPILE に入れる言語
python3 tools/i18n/i18n.py outputs               # 生成器が持つ経路 (在るものだけ)
python3 tools/i18n/i18n.py outputs --check-committed   # 生成物が git の索引に入っているか (CI)
```

`add` は名前空間のファイルが無ければ `kind: ui` / `ios_bundles: ["app"]` で作る。ウィジェットにも入れる名前空間
(`common` など) は、先にファイルを置いて `ios_bundles` を決めておく。

Python 3.9 と標準ライブラリだけで動く。テストは `python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'`。

`add` の出力どおりに、iOS では `L10n.Songs.listSortTitle` (DS 部品には `.key(L10n.Songs.listSortTitle)`)、
Android では同じ名前の `L10n.Songs.listSortTitle` (DS 部品にはそのまま、文字列にするなら `.resolve()`) を使う。

## 言語とチャネル (出荷ゲート)

`config.json` の言語ごとの `channel` (低い順に planned < dev < beta < release):

| channel | 入るビルド | iOS | Android |
|---|---|---|---|
| `release` | すべて | `XCSTRINGS_LANGUAGES_TO_COMPILE` (Release) に入る | `app/i18n/main/values-xx/` |
| `beta` | Debug・Beta | (Beta 構成はまだ無い) | `app/i18n/debug/values-xx/` (beta 用の overlay はまだ無い) |
| `dev` | Debug だけ | Debug は言語を絞らない | `app/i18n/debug/values-xx/` |
| `planned` | どれにも入らない | xcstrings に出さない (lproj ができない) | リソースを出さない |

- 今は `ja` = release、`ko` = dev、`en`・`zh-Hans` = planned。Debug ビルドにだけ ko が入る。
- planned の言語は、カタログの項目・用語集・lock に値を書いてよく、`check` (形・プレースホルダ・max_len・用語集)
  と `stats` の対象になる。ただし**生成物には一切出ない**: xcstrings の訳 (引数のある項目の基準言語への
  フォールバックも)、InfoPlist の表、Android の `values-xx`、`locale_config.xml`、`i18n_meta.xml`、
  テストの期待値 (`L10nCatalogKeys`)、`gate --config` のどれにも入らない。生成器は `Config.built_languages()`
  (planned を除いた言語) だけを見る。
- 出荷ゲート (下) は beta / release の言語だけに掛かる。dev と planned は止めない。
- iOS の出荷ゲートは project.yml の **プロジェクト全体の** `settings.configs.Release.XCSTRINGS_LANGUAGES_TO_COMPILE`
  に 1 箇所だけ書く (ターゲット側に書くと上書きしてしまうので `check` が落とす)。値は `gate --config Release`。
- `beta` / `release` に上げる言語は、`ui` / `system` の名前空間に欠落・未検収・stale・edited が 1 件も無いこと
  (`check` が見る)。ほかの条件 (用語集の確定・字形の組版など) は [TRANSLATION.md](TRANSLATION.md) の「言語を上げる条件」。
- 言語を足すときは `tools/i18n/cldr.py` に複数形の範疇と桁区切りがあるか確かめてから、`config.json` に 1 行
  (`"<言語>": {"channel": "planned"}`) 足し、`glossary.json` にその言語の語と `style` を足して `generate` する。

### 4 つの言語の前提

| 言語 | 複数形の範疇 | iOS (xcstrings のキー / lproj) | Android (リソースのディレクトリ / localeConfig) |
|---|---|---|---|
| `ja` (原文) | other | `ja` / `ja.lproj` (開発言語) | 既定の `values/` / `ja` |
| `ko` | other | `ko` / `ko.lproj` | `values-ko/` / `ko` |
| `en` | one / other | `en` / `en.lproj` | `values-en/` / `en` |
| `zh-Hans` | other | `zh-Hans` / `zh-Hans.lproj` | `values-b+zh+Hans/` (BCP 47 の書き方。minSdk 26 なので使える) / `zh-Hans` |

- ディレクトリ名・言語コードは生成器が `config.json` の言語コードから作る (手で書かない)。
- **en**: `count` を持つキーは `{"one": "…", "other": "…"}` の 2 形で書く。one が無い en の値は `check` が警告する
  (other で出てしまう)。米国英語・sentence case (TRANSLATION.md の en の文体)。訳が長くなりやすいので、
  `max_len` と画面の切れを疑似言語 (下) で確かめる。
- **zh-Hans**: 句読点は全角 (，。“”)、漢字どうしの間に空白を入れない (日本語の区切りの空白を持ち込まない)、
  固有名詞は日本語の原表記のまま (簡体字に直さない)。
- **zh-Hant (繁体字) を足すとき**は、`cldr.py` にもう範疇と桁区切りがあるので `config.json` に 1 行
  (`"zh-Hant": {"channel": "planned"}`) と、用語集の `zh-Hant` の語と `style.zh-Hant` を足すだけ
  (iOS は `zh-Hant.lproj`、Android は `values-b+zh+Hant/`)。zh-Hans の訳を機械的に繁体字にしない (語が違う)。

### どの言語で出るか (フォールバック)

- **iOS**: OS がユーザーの「優先する言語」(アプリごとの言語を設定していればそれ) を上から見て、アプリのバンドルに
  lproj がある最初の言語を選ぶ。どれも無ければ開発言語 (`CFBundleDevelopmentRegion` = `ja`) になる。
  Release は `XCSTRINGS_LANGUAGES_TO_COMPILE` = `ja` なので常に ja。Debug は ja と ko (たとえば「English → 한국어」の
  端末では ko、「English」だけなら ja)。
- **Android**: OS の言語の一覧 (アプリの言語を設定していればそれ) を上から見て、合う `values-xx` がある最初の言語を
  選ぶ。どれも無ければ既定の `values/` (= ja)。アプリの言語 (Android 13+) に出るのは `locale_config.xml` の言語。
- **キー単位**: 選ばれた言語に訳の無いキーは、iOS は defaultValue、Android は既定の `values/` で、どちらも ja が出る。
- ja を基準 (開発言語・既定の `values/`) のままにする。英語を既定にはしない (原文とデータが日本語で、
  Release の利用者は ja が前提のため)。

### 漢字の字形 (Han unification) — 決まりだけ。未実装

- 曲名・アイドル名・ライブ名・CD 名などのデータは日本語の文字列。UI が ko / en / zh-Hans で出ると、OS はその言語の
  フォントで漢字を組むことがあり、同じ文字でも日本語と違う字形 (中国語・韓国語の字形) に見える。
- 決まり (予定): **データの文字列は ja として組む**。iOS は SwiftUI の `typesettingLanguage(_:)` (iOS 17+。アプリの
  deployment target は 17.0) に ja を渡し、Android は Compose の `TextStyle(localeList = LocaleList("ja"))`。
  `DisplayText` の `verbatim` / `core` を出すところ (`Text(display:)` と DS 部品) でまとめて付ける。カタログの訳
  (`key`) には付けない (その言語で組む)。
- 訳した文の中に `string` 引数で差し込んだデータは、文全体の言語で組まれる。部分ごとに言語を付ける
  (AttributedString / AnnotatedString) かは、実装するときに決める。
- **まだ実装していない。** ko も含め、言語を beta 以上に上げる前に実装する (TRANSLATION.md の「言語を上げる条件」)。

### キーの使い回し

- **意味が変わったら新しいキーにする** (古いキーは消す)。同じキーの原文を別の意味に書き換えると、各言語の訳が
  古い意味のまま残る (lock は stale にするが、訳す人には意味が変わったことが分からない)。誤字の修正など、
  意味が同じ直しはキーを変えない (stale になり、確かめ直して stamp する)。
- **同じ文字列でも、文脈 (画面・役割) が違えば別のキーにする** (ボタンの「保存」と見出しの「保存」など)。
  ja では同じでも、ほかの言語では訳し分けが要ることがある。同じ部品・同じ文脈の文言は `common` などに置いて使い回す。

### 対象外

- **データ** (アイドル名・曲名・ライブ名などの翻訳表記) はカタログの外。訳すなら DB に列を足すことになるので、
  [CONTRIBUTING.md の 5.](../CONTRIBUTING.md#5-スキーマ-db-の構造-を変えたいとき) の流れに乗り、先に Issue で合意する。
- **imas-core が作る文字列** (`core` 引数・`DisplayText.core`) は今は ja のまま出る。コア段階で、コアが構造化した値を
  返すようにしてアプリ側でカタログの文言に組み替える (`stats` の「コア由来の目印」がその置換リスト)。

## 翻訳の状態

`lock/<言語>.json` と今のカタログから決まる。`stamp <言語> --reviewer <名前>` は、完全キーごとに
`{"source": 原文の sha256, "target": 訳の sha256, "reviewer": 名前}` を書く (訳の sha256 は、文字列ならそのまま、
複数形なら範疇を整列した JSON から。other だけの複数形は同じ文字列と同じに数える)。`--reviewer` は必須で、**訳を確かめた人**の名前を書く (AI エージェントは
`stamp` しない)。

| 状態 | 意味 | xcstrings の state | 出荷ゲート (beta / release) |
|---|---|---|---|
| 欠落 (missing) | 訳が無い | (項目を出さない。引数のある項目だけ基準言語の値を `new` で出す) | 止める |
| 未検収 (unreviewed) | 訳はあるが `stamp` していない | `needs_review` | 止める |
| 確定 (reviewed) | `stamp` のあとで原文も訳も変わっていない | `translated` | 通す |
| stale | `stamp` のあとで原文が変わった (訳が変わっていても stale) | `needs_review` | 止める |
| edited | 原文は同じで、`stamp` のあとで訳だけが変わった | `needs_review` | 止める |

- 旧形式の lock (値が原文のハッシュの文字列だけ) も読む。旧形式は訳の変化を見られないので edited にならない。
  `stamp` し直したキーから新しい形式になる (触らないキーは元の形のまま残す)。
- state はコンパイルに影響しない。出荷を止めるのは `check` の出荷ゲートの規則。

## 検査の強さ

機械で白黒が付くものはエラー (`check` が落ちる)、判断が要るものは警告 (落ちない)。

| エラー | 警告 |
|---|---|
| どの言語でも、値が `args` と違う組の `{…}` を使う (other 以外の範疇が count を省くのは可) | 用語集の語が訳に無い (訳のある言語すべて。英字は大文字小文字を区別せず、語の頭から探す) |
| どの言語でも `max_len` を超える | 訳に仮名が混じる (`verbatim_ok` で止める) |
| beta / release の言語の欠落・未検収・stale・edited | 複数形の範疇が足りない (en の one など) |
| プラットフォームの書式・制御文字・前後の空白 など | 用語集の形の崩れ (未知の言語・フィールド) |

## 用語集 (glossary.json)

- `terms`: `{"ja": 語 (必須), "ko" / "en" / "zh-Hans": 訳語 (文字列か、許す候補の配列), "note": メモ, "keep": true}`。
  `keep: true` は訳さない語 (訳に ja の語がそのまま残っているかを見る。その言語の語を書けば、それも候補に入る)。
- `style`: `{"ko" / "en" / "zh-Hans": 文体の決まり}` (日本語で書く)。
- `check` は、項目の原文に用語の ja の語があるとき、その項目に訳のある言語 (基準言語以外) のそれぞれで、訳に
  その言語の語が無ければ警告する。長い語の中の短い語は数えない (アンコール の中の コール)。
  英字・数字で始まる候補は語の頭から探す (call の中の all・deliver の中の live は数えない。語尾は問わないので
  songs は song に合う)。仮名・漢字・ハングルの候補は語の区切りが無いので、どこにあってもよい (短すぎる候補は避ける)。
- 用語集と文体を変えたら `generate` して、`TRANSLATION.md` も同じ commit に入れる。
- en・zh-Hans の語と文体は草案 (オーナーの確認待ち)。確定したら `status` を消す。

## 生成物

生成器は下の経路を持つ。`generate` は経路ごと空にしてから作り直すので、ここに手のコードを置かない
(手のコードは一つ上: `ImasLiveDB/Shared/L10n/`・`ImasLiveDB/L10n/`・`…/i18n/`)。

| 経路 | 中身 |
|---|---|
| `ImasLiveDB/Shared/L10n/Generated/` | `<Table>.xcstrings` と `L10n+<Table>.generated.swift` (ウィジェットにも入る名前空間) |
| `ImasLiveDB/L10n/Generated/` | 同上 (アプリだけの名前空間) と、アプリの `InfoPlist.xcstrings` |
| `ImasLiveDBWidget/L10n/Generated/` | ウィジェット拡張の `InfoPlist.xcstrings` |
| `ImasLiveDBTests/L10n/Generated/` | `L10nCatalogKeys.generated.swift` (全キーの見本と言語ごとの期待値) |
| `ImasLiveDB-Android/app/i18n/` | `main/` と `debug/` の overlay (`values[-xx]/strings_<ns>.xml`、`xml/locale_config.xml`、`values/i18n_meta.xml`) |
| `ImasLiveDB-Android/app/src/main/kotlin/com/fugaif/imaslivedb/i18n/generated/` | `L10n.kt` (索引) と `L10n<Ns>.kt` |
| `ImasLiveDB-Android/app/src/test/kotlin/com/fugaif/imaslivedb/i18n/generated/` | `L10nCatalogKeys.kt` (全キーの見本と言語ごとの期待値) |
| `i18n/TRANSLATION.md` (ファイル 1 つ) | 翻訳者への手引き (`config.json` と `glossary.json` から。`i18n/` のほかのファイルは手の物なので、生成器はこのファイルだけを持つ) |

- xcstrings は全項目 `extractionState: manual`。`Localizable` の表は作らない (まだ移していない
  `Text("日本語")` は表に無いので、今までどおりキー = 日本語がそのまま出る)。
- リテラルの `%`: 引数のある項目は両方 `%%`。引数の無い項目は iOS では 1 つのまま、Android は `formatted="false"`。
- 生成物は `.gitattributes` の `linguist-generated` で PR の diff では畳まれる。レビューで見るのはカタログと呼び出し側。
- マージで生成物がぶつかったら、カタログだけ解決して `generate` し直す (生成物を手でマージしない)。

## CI

`.github/workflows/i18n-guard.yml` が 1) `check` 2) 生成物が commit されているか 3) 作り直して差分が
出ないか 4) `scan --ratchet` (報告) 5) `parity` (PR では `--strict`) 6) `stats` を回す。
ツール自体のテストと 3.9 の構文検査は tools-guard が回す。

## 実測メモ

- macOS 27 / Xcode 26.0.1 の `xcstringstool compile` で、count を持つ項目を「トップの値は `%#@count@` だけ、
  文全体を置換の plural に入れる」形で出すと、stringsdict は `%2$#@count@` / other `%1$@ ・ %2$lld名` になる。
  他の引数 (`%1$@`) を置換の中に書いてよく、en の one / other で文の形が違っても引ける
  (tools/i18n/test/test_emit_apple.py の SwiftRuntimeTest が Foundation で実際に引いて期待値と比べる)。
- `xcstringstool compile -l ja` は ja.lproj だけを出す (出荷ゲートの仕組み)。
- 表に無いキーは defaultValue で書式される (リテラルの `%` は defaultValue 側では自動で逃がされる)。
- Xcode 27.0 の `xcstringstool compile` は、引数のある項目で訳の無い言語の表に「キーそのもの」を値として書く
  (26.0.1 は書かなかった)。そのままだと実行時にキーが画面に出るので、生成器は引数のある項目に限り、
  訳の無い言語にも基準言語の値を state `new` で出す (tools/i18n/emit_apple.py の `_localizations`)。
- `xcodebuild build` / `test` (Xcode 26.0.1 と 27.0) は生成物の xcstrings を書き換えない (ビルドのあとも
  `generate --check` が通る)。Debug のアプリとウィジェット拡張の両方に `ko.lproj` (表と `InfoPlist.strings`) が入る。
  Release の `XCSTRINGS_LANGUAGES_TO_COMPILE` は両ターゲットとも `ja` (`xcodebuild -showBuildSettings` で確認。
  Release の成果物そのものはまだ開いていない)。
- 未確認: Xcode の画面でカタログを開いたときに書き換えないか (特に `/` のエスケープ)、
  SwiftUI の `Text(LocalizedStringResource)` 経路での `%`。
- SwiftUI で `DisplayText` を出す init は `Text(display:)` とラベルを付ける。ラベルの無い `Text(_: DisplayText)` を
  足すと、すべての `Text("…")` の呼び出しで候補の多重定義が 1 つ増え、型検査が重くなる。
- `CalendarView` の body は Xcode 26.0.1 だと「reasonable time で型検査できない」で落ちる (develop でも同じ)。
  Xcode 27.0 (macOS 27、iOS 26.0 のシミュレータ) では分けずにビルドでき、iOS のテスト 242 件が通る。
  手元が 26.0.1 のままなら body を一時的に分けて試し、その変更は commit しない。
- `count` 型は桁区切りが付くので、もとは補間だけだった `units.detail.similar.shared_tags` (タグ{count}個一致) は
  1000 以上のときだけ表示が変わる (1000 → 1,000)。一致するタグの数としては出ない値なので、そのままにしている。
- `isPseudoLocalesEnabled` を入れた Android の Debug の APK は、`aapt2 dump configurations` で `en-rXA` と `ar-rXB` を
  持つ (AGP 8.8.0)。端末での見た目はまだ確かめていない。
- `en`・`zh-Hans` を planned で足しても、アプリの生成物 (xcstrings・Swift・Android のリソース・Kotlin・テストの期待値)
  は 1 バイトも変わらない (増えるのは `i18n/TRANSLATION.md` だけ。tools/i18n/test/test_planned.py でも見る)。

## 手で確かめる

ko は Debug ビルドにだけ入る (planned の en・zh-Hans はまだどのビルドにも入らない)。端末の言語は変えずに、アプリだけ ko で起動する。

```sh
# iOS シミュレータ
xcrun simctl launch <UDID> com.fugaif.ImasLiveDB -AppleLanguages "(ko)" -AppleLocale ko_KR
# Android エミュレータ (Manifest の localeConfig があるので、設定 → アプリの言語 からも選べる)
adb shell cmd locale set-app-locales site.fugaapp.imaslivedb --locales ko-KR
```

- CI と同じダミーの `GoogleService-Info.plist` を置いたビルドは、テストは通るが普通に起動すると Firebase の
  初期化で落ちる。手で触るときは、ビルドしたアプリの複製からその plist を抜き、`codesign --force --sign - --deep`
  で署名し直してからシミュレータに入れる。

### 疑似言語で確かめる

訳が無くても、カタログを通っていない文字列 (飾られない) と、長い訳での切れ・右から左の崩れを見られる。
基準言語 (ja) の文言が飾られて出る。

- **Android**: Debug の buildType に `isPseudoLocalesEnabled = true` を入れてある (`app/build.gradle.kts`。Release には
  入らない)。Debug の APK に `en-rXA` と `ar-rXB` のリソースができる。端末・エミュレータの 設定 → システム → 言語 で
  「English (XA)」(文字を飾って長くする) か「العربية (XB)」(右から左) を足して一番上にする (開発者向けオプションを
  有効にすると一覧に出る)。
- **iOS**: コードは要らない。Xcode の scheme → Run → Options → App Language で「Double-Length Pseudolanguage」
  「Accented Pseudolanguage」「Bounded String Pseudolanguage」「Right-to-Left Pseudolanguage」を選んで Run する。
  (シミュレータに直接入れるなら同じ働きの起動引数 `-NSDoubleLocalizedStrings YES` など。
  `LocalizedStringResource` の経路でどこまで効くかは、まだ実測していない)
