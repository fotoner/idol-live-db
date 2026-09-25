# i18n

iOS / Android の UI 文言の置き場。

画面の文言・Info.plist の表示名と権限の説明・Android のウィジェットの名前と説明は、ここのカタログ
(`i18n/catalog/<名前空間>.json`) を正にする。今のカタログは仕組みで使う `i18n` だけで、画面の文言は
画面ごとの PR で移す。iOS の String Catalog (`.xcstrings`)、Android の `strings_<ns>.xml`、両方のアクセサ
(`L10n.<Ns>.<key>`) は `tools/i18n/i18n.py generate` がカタログから作る。**生成物は手で直さない**
(Xcode・Android Studio の翻訳エディタは見るだけにする)。文言を変えるときは**ここを変えてから** generate して、
生成物も同じ commit に入れる。

訳す人・訳を確かめる人 (人も AI エージェントも) は、先に [TRANSLATION.md](TRANSLATION.md) を読む
(用語集と文体の決まり・レビューの流れ。`generate` が `glossary.json` と `config.json` から作る)。

## 置いてあるもの

| パス | 中身 |
|---|---|
| `config.json` | 言語と出荷チャネル |
| `catalog/<ns>.json` | 名前空間 (= 機能のまとまり) ごとの文言。キー・原文 (ja)・訳・引数・翻訳者メモ |
| `glossary.json` | 用語集と言語ごとの文体 (今は枠だけ。語と文体は訳を入れる PR で足す) |
| `TRANSLATION.md` | 翻訳者 (人と AI) への手引き。**生成物** |

## カタログの書き方

```json
{
  "namespace": "songs",
  "kind": "ui",
  "ios_bundles": ["app"],
  "strings": {
    "list.count": {
      "note": "一覧の上の曲数。1000 以上は桁区切りが付く (1,234曲)",
      "args": [{ "name": "count", "type": "count" }],
      "ja": "{count}曲",
      "ko": "{count}곡"
    }
  }
}
```

- ファイル名 = `namespace`。キーは名前空間を除いた相対キー (`<画面|部品>.<要素>[.<変形>]`、
  英小文字で始まるセグメントを `.` でつなぐ。最大 4 段)。完全キーは `<ns>.<相対キー>`。
- `ja` は必須で、コードから移すときは元の文字列と **1 バイトも違えない** (文言を直すのは別 PR)。
- 引数は `{名前}`。`%@` や `\(x)` や `${x}` は書かない (検査で落ちる)。波括弧そのものは `{{` `}}`。
- 訳が無い言語は書かない (空文字列も書かない)。iOS は defaultValue (= ja)、Android は既定の `values/` に落ちる。
- `kind`: `ui` / `system` (仕組みの文言・Info.plist・Manifest・ウィジェット選択画面) / `content` (長文。UI の網羅率から除く)。
- `ios_bundles` に `widget` を入れた名前空間は、ウィジェット拡張にも入る (`ImasLiveDB/Shared/L10n/Generated/`)。
- `platforms` (名前空間・項目) で片方のプラットフォームだけにできる。
- ほかのフィールド: `max_len` (引数を除いた長さの上限。どの言語でも超えるとエラー)、`keep_whitespace` (前後の空白を許す)、
  `verbatim_ok` (訳に仮名が混じっても警告しない)、`ios.infoplist` (`system` だけ。`{target, key}`)、
  `ios.intent_metadata` (AppIntent / AppEntity のメタデータ。キーを宣言に直書きする)。
- ファイルは正規形 (キー整列・字下げ 2・`ensure_ascii` なし・末尾改行) で置く。`add` はこの形で書き直す。
- `i18n.language_tag` はアプリが「実際に画面に出ている言語」を知るためのキー (`DisplayLocale` が読む)。
  値は言語コードそのもの。ビルドに入る言語を足したら、ここにもその言語のコードを足す (`check` が見る)。

### 引数の型と数の書式

| 型 | Swift | Kotlin | 桁区切り | 使いどころ |
|---|---|---|---|---|
| `int` | `Int` → `String(n)` を `%@` | `Int` / `%d` | なし (2026年) | 年・ID・順位など、数量でない整数 |
| `count` | `Int` / `%lld` + 複数形 | `Int` / `%,d` + `<plurals>` | ロケールどおり (1,234曲) | 助数詞が付く数量。キーに 1 つまで。複数形の選択子 |
| `string` | `String` / `%@` | `String` / `%s` | — | 訳さないデータ (名前・サーバの文言・書式済みの日付や小数) |
| `core` | `String` / `%@` | `String` / `%s` | — | imas-core が作った文字列 (今は ja のまま出る) |
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
python3 tools/i18n/i18n.py add songs list.count "{count}曲" --arg count:count --ko "{count}곡"
python3 tools/i18n/i18n.py stats                 # 言語ごとの網羅率・欠落
python3 tools/i18n/i18n.py gate --config Release # XCSTRINGS_LANGUAGES_TO_COMPILE に入れる言語
python3 tools/i18n/i18n.py outputs --check-committed   # 生成物が git の索引に入っているか (CI)
```

- `add` は名前空間のファイルが無ければ `kind: ui` / `ios_bundles: ["app"]` で作る。ウィジェットにも入れる名前空間は、
  先にファイルを置いて `ios_bundles` を決めておく。
- 画面では、iOS は `Text(display: .key(L10n.Songs.listSortTitle))`、Android は同じ名前の `L10n.Songs.listSortTitle`
  (`DisplayText` のまま渡し、文字列にするなら `.resolve()`)。
- Python 3.9 と標準ライブラリだけで動く。テストは `python3 -m unittest discover -s tools/i18n/test -p 'test_*.py'`
  (tools-guard が回す)。

## 言語とチャネル (出荷ゲート)

`config.json` の言語ごとの `channel` (低い順に planned < dev < beta < release):

| channel | 入るビルド | iOS | Android |
|---|---|---|---|
| `release` | すべて | Release の `XCSTRINGS_LANGUAGES_TO_COMPILE` に入る | `app/i18n/main/values-xx/` |
| `beta` | Debug・Beta | (Beta 構成はまだ無い) | `app/i18n/debug/values-xx/` (beta 用の置き場はまだ無い) |
| `dev` | Debug だけ | Debug は言語を絞らない | `app/i18n/debug/values-xx/` |
| `planned` | どれにも入らない | xcstrings に出さない | リソースを出さない |

- 今は `ja` = release、`ko` = dev、`en`・`zh-Hans` = planned。Debug ビルドにだけ ko が入る。
- planned の言語は、カタログ・用語集に値を書いてよく、`check` と `stats` の対象になるが、生成物
  (xcstrings・Android のリソース・`locale_config.xml`・テストの期待値) には出ない。
- iOS の出荷ゲートは project.yml の **プロジェクト全体の** `settings.configs.Release.XCSTRINGS_LANGUAGES_TO_COMPILE`
  に 1 箇所だけ書く (ターゲット側に書くと上書きしてしまうので `check` が落とす)。値は `gate --config Release`。
- `beta` / `release` に上げる言語は、`ui` / `system` の名前空間に訳の欠落が 1 件も無いこと (`check` が見る)。ほかの条件は [TRANSLATION.md](TRANSLATION.md) の「言語を上げる条件」。
- 言語を足すときは `tools/i18n/cldr.py` に複数形の範疇と桁区切りがあるか確かめてから、`config.json` に 1 行
  (`"<言語>": {"channel": "planned"}`) 足して `generate` する。ディレクトリ名・言語コード (`values-ko/`・
  `values-b+zh+Hans/`・`ko.lproj` など) は生成器が作る。

### どの言語で出るか

- **iOS**: ユーザーの「優先する言語」(アプリごとの言語があればそれ) を上から見て、バンドルに lproj がある最初の言語。
  どれも無ければ開発言語 (`ja`)。Release は ja だけなので常に ja。
- **Android**: OS の言語の一覧を上から見て、APK のリソースにある言語と最初に合う言語。ライブラリ (AppCompat・Material)
  の `values-xx` も数えることと、英語は常に合うと見なされることが iOS と違う。選ばれた言語にアプリの訳が無ければ
  既定の `values/` (= ja)。
- **キー単位**: 選ばれた言語に訳の無いキーは、iOS は defaultValue、Android は既定の `values/` で、どちらも ja。
- Debug の iOS では、端末の言語が ko ならアプリの言語 (`Locale.current`) も ko になる。まだカタログに移していない
  画面の日付の書式 (`Date.formatted` など) も ko で出る。

### キーの使い回し

- **意味が変わったら新しいキーにする** (古いキーは消す)。誤字の修正など、意味が同じ直しはキーを変えず、
  同じ PR で各言語の訳も直す (直せない訳は消す。古い訳を残さない)。
- **同じ文字列でも、文脈 (画面・役割) が違えば別のキーにする** (ボタンの「保存」と見出しの「保存」など)。

### 対象外

- **データ** (アイドル名・曲名・ライブ名などの表記) はカタログの外。訳すなら DB に列を足すことになるので、
  [CONTRIBUTING.md の 5.](../CONTRIBUTING.md#5-スキーマ-db-の構造-を変えたいとき) の流れに乗り、先に Issue で合意する。
- **imas-core が作る文字列** (`core` 引数・`DisplayText.core`) は今は ja のまま出る。扱いはまだ決めていない。

## 翻訳の確認

訳を人が確かめたかどうかは、今は PR のレビューで見る (カタログには記録しない)。AI が書いた訳を入れる PR には
その旨を書く。訳ごとに「確かめたか・原文が変わったか」を記録する仕組みは、言語を dev より上に上げるときに
足す (翻訳サービスを使うなら、その状態を使う)。

## 検査の強さ

機械で白黒が付くものはエラー (`check` が落ちる)、判断が要るものは警告 (落ちない)。

| エラー | 警告 |
|---|---|
| どの言語でも、値が `args` と違う組の `{…}` を使う (other 以外の範疇が count を省くのは可) | 用語集の語が訳に無い |
| どの言語でも `max_len` を超える | 訳に仮名が混じる (`verbatim_ok` で止める) |
| beta / release の言語の訳の欠落 | 複数形の範疇が足りない (en の one など) |
| プラットフォームの書式・制御文字・前後の空白・名前の衝突 など | 用語集の形の崩れ |

## 用語集 (glossary.json)

- `terms`: `{"ja": 語 (必須), "ko" / "en" / "zh-Hans": 訳語 (文字列か、許す候補の配列), "note": メモ, "keep": true}`。
  `keep: true` は訳さない語。
- `style`: `{"ko" / "en" / "zh-Hans": 文体の決まり}` (日本語で書く)。
- 今は `terms`・`style` とも空。語と文体は、その言語の訳を入れる PR で足す。草案のうちは `status` に草案であることを書き、
  全部の言語が確定したら `status` を消す。
- 用語集と文体を変えたら `generate` して、`TRANSLATION.md` も同じ commit に入れる。

## 生成物

生成器は下の経路を持つ。`generate` は経路ごと空にしてから作り直すので、ここに人が書くコードを置かない
(人が書くコードは一つ上: `ImasLiveDB/Shared/L10n/`・`…/i18n/`)。

| 経路 | 中身 |
|---|---|
| `ImasLiveDB/Shared/L10n/Generated/` | `<Table>.xcstrings` と `L10n+<Table>.generated.swift` (ウィジェットにも入る名前空間) |
| `ImasLiveDB/L10n/Generated/` | 同上 (アプリだけの名前空間) と、アプリの `InfoPlist.xcstrings`。できるのはその文言を移してから |
| `ImasLiveDBWidget/L10n/Generated/` | ウィジェット拡張の `InfoPlist.xcstrings`。同上 |
| `ImasLiveDBTests/L10n/Generated/` | `L10nCatalogKeys.generated.swift` (全キーの見本と言語ごとの期待値) |
| `ImasLiveDB-Android/app/i18n/` | `main/` と `debug/` (`values[-xx]/strings_<ns>.xml` と `xml/locale_config.xml`) |
| `ImasLiveDB-Android/app/src/main/kotlin/com/fugaif/imaslivedb/i18n/generated/` | `L10n.kt` (索引) と `L10n<Ns>.kt` |
| `ImasLiveDB-Android/app/src/test/kotlin/com/fugaif/imaslivedb/i18n/generated/` | `L10nCatalogKeys.kt` (全キーの見本と言語ごとの期待値) |
| `i18n/TRANSLATION.md` | 翻訳者への手引き |

- xcstrings は全項目 `extractionState: manual`。`Localizable` の表は作らない (まだ移していない
  `Text("日本語")` は今までどおりキー = 日本語がそのまま出る)。project.yml で Xcode の文字列の抽出も止めている。
- Android の `app/i18n/main` と `app/i18n/debug` は `app/build.gradle.kts` の sourceSets で足している。
- `xml/locale_config.xml` (Android 13 以降の「アプリの言語」) は debug には常に、main には release の言語が 2 つ以上に
  なったときだけ出す。参照しているのは `src/debug/AndroidManifest.xml` だけ (Release の端末の設定に、選べる言語が
  ja しか無いアプリの言語の項目を出さないため)。release の言語が増えたら、参照を `src/main/AndroidManifest.xml` に移す。
- 生成物は `.gitattributes` の `linguist-generated` で PR の diff では畳まれる (`i18n/TRANSLATION.md` だけは畳まない)。
- マージで生成物がぶつかったら、カタログだけ解決して `generate` し直す (生成物を手でマージしない)。

## CI

`.github/workflows/i18n-guard.yml` が 1) `check` 2) 生成物が commit されているか 3) 作り直して差分が出ないか を見る。
ツール自体のテストと 3.9 の構文検査は tools-guard が回す。

## 実測メモ

- Xcode 27.0 の `xcstringstool compile` は、引数のある項目で訳の無い言語の表に「キーそのもの」を値として書く
  (26.0.1 は書かなかった)。そのままだと実行時にキーが画面に出るので、生成器は引数のある項目に限り、
  訳の無い言語にも基準言語の値を state `new` で出す (`tools/i18n/emit_apple.py` の `_localizations`)。
- `xcstringstool compile -l ja` は ja.lproj だけを出す (iOS の出荷ゲートの仕組み)。
- `xcodebuild build` / `test` は生成物の xcstrings を書き換えない (ビルドのあとも `generate --check` が通る)。
- SwiftUI で `DisplayText` を出す init は `Text(display:)` とラベルを付ける。ラベルの無い `Text(_: DisplayText)` を
  足すと、すべての `Text("…")` の呼び出しで候補の多重定義が 1 つ増え、型検査が重くなる。

## 手で確かめる

ko は Debug ビルドにだけ入る。端末の言語は変えずに、アプリだけ ko で起動する。

```sh
# iOS シミュレータ
xcrun simctl launch <UDID> com.fugaif.ImasLiveDB -AppleLanguages "(ko)" -AppleLocale ko_KR
# Android エミュレータ (Debug は localeConfig があるので、設定 → アプリの言語 からも選べる)
adb shell cmd locale set-app-locales site.fugaapp.imaslivedb --locales ko-KR
```
