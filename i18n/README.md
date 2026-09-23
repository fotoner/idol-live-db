# i18n

iOS / Android の UI 文言の **唯一の実体**。

画面の文言・Info.plist の表示名と権限の説明・Android のウィジェットの名前と説明は、ここのカタログ
(`i18n/catalog/<名前空間>.json`) が正になる。iOS の String Catalog (`.xcstrings`)、Android の
`strings_<ns>.xml`、両方のアクセサ (`L10n.<Ns>.<key>`) は `tools/i18n/i18n.py generate` が
カタログから作る。**生成物は手で直さない** (Xcode・Android Studio の翻訳エディタは見るだけにする)。
文言を変えるときは、**ここを変えてから** generate して、生成物も同じ commit に入れる。

## 置いてあるもの

| パス | 中身 |
|---|---|
| `config.json` | 言語と出荷チャネル、ガードのモード |
| `catalog/<ns>.json` | 名前空間 (= 機能のまとまり) ごとの文言。キー・原文 (ja)・訳・引数・翻訳者メモ |
| `lock/<言語>.json` | 検収を確定したときの原文のハッシュ (`stamp` が書く) |
| `glossary.json` | 用語集 (草案。オーナー確定前) |
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
- ほかのフィールド: `max_len` (引数を除いた長さの上限。超えると警告)、`keep_whitespace` (前後の空白を許す)、
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
python3 tools/i18n/i18n.py stamp ko --ns songs   # ko の訳を検収済みにする
python3 tools/i18n/i18n.py stats                 # 網羅率・未検収・stale
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

`config.json` の言語ごとの `channel`:

| channel | 入るビルド | iOS | Android |
|---|---|---|---|
| `release` | すべて | `XCSTRINGS_LANGUAGES_TO_COMPILE` (Release) に入る | `app/i18n/main/values-xx/` |
| `beta` | Debug・Beta | (Beta 構成はまだ無い) | `app/i18n/debug/values-xx/` (beta 用の overlay はまだ無い) |
| `dev` | Debug だけ | Debug は言語を絞らない | `app/i18n/debug/values-xx/` |

- 今は `ja` = release、`ko` = dev。Debug ビルドにだけ ko が入る。
- iOS の出荷ゲートは project.yml の **プロジェクト全体の** `settings.configs.Release.XCSTRINGS_LANGUAGES_TO_COMPILE`
  に 1 箇所だけ書く (ターゲット側に書くと上書きしてしまうので `check` が落とす)。値は `gate --config Release`。
- `beta` / `release` に上げる言語は、`ui` / `system` の名前空間に欠落・未検収・stale が 1 件も無いこと (`check` が見る)。
- 言語を足すときは `tools/i18n/cldr.py` に複数形の範疇と桁区切りがあるか確かめてから、`config.json` に 1 行足す。

## 翻訳の状態

`lock/<言語>.json` と今の原文から決まる。

| 状態 | 意味 | xcstrings の state |
|---|---|---|
| 欠落 | 訳が無い | (項目を出さない) |
| 未検収 | 訳はあるが `stamp` していない | `needs_review` |
| 確定 | `stamp` したときの原文のハッシュが今の原文と同じ | `translated` |
| stale | `stamp` のあとで原文が変わった | `needs_review` |

state はコンパイルに影響しない。出荷を止めるのは `check` の出荷ゲートの規則。

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
- `xcodebuild build` / `test` (Xcode 26.0.1) は生成物の xcstrings を書き換えない (ビルドのあとも
  `generate --check` が通る)。Debug のアプリとウィジェット拡張の両方に `ko.lproj` (表と `InfoPlist.strings`) が入る。
  Release の `XCSTRINGS_LANGUAGES_TO_COMPILE` は両ターゲットとも `ja` (`xcodebuild -showBuildSettings` で確認。
  Release の成果物そのものはまだ開いていない)。
- 未確認: Xcode の画面でカタログを開いたときに書き換えないか (特に `/` のエスケープ)、
  SwiftUI の `Text(LocalizedStringResource)` 経路での `%`。
- SwiftUI で `DisplayText` を出す init は `Text(display:)` とラベルを付ける。ラベルの無い `Text(_: DisplayText)` を
  足すと、すべての `Text("…")` の呼び出しで候補の多重定義が 1 つ増え、型検査が重くなる。
- `CalendarView` の body は Xcode 26.0.1 だと「reasonable time で型検査できない」で落ちる (develop でも同じ。
  CI の Xcode 26.2 では通る)。手元が 26.0.1 なら body を一時的に分けて試し、その変更は commit しない。
- `count` 型は桁区切りが付くので、もとは補間だけだった `units.detail.similar.shared_tags` (タグ{count}個一致) は
  1000 以上のときだけ表示が変わる (1000 → 1,000)。一致するタグの数としては出ない値なので、そのままにしている。

## 手で確かめる

ko は Debug ビルドにだけ入る。端末の言語は変えずに、アプリだけ ko で起動する。

```sh
# iOS シミュレータ
xcrun simctl launch <UDID> com.fugaif.ImasLiveDB -AppleLanguages "(ko)" -AppleLocale ko_KR
# Android エミュレータ (Manifest の localeConfig があるので、設定 → アプリの言語 からも選べる)
adb shell cmd locale set-app-locales site.fugaapp.imaslivedb --locales ko-KR
```

- CI と同じダミーの `GoogleService-Info.plist` を置いたビルドは、テストは通るが普通に起動すると Firebase の
  初期化で落ちる。手で触るときは、ビルドしたアプリの複製からその plist を抜き、`codesign --force --sign - --deep`
  で署名し直してからシミュレータに入れる。
