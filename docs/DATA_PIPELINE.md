# データパイプライン (master データの鮮度と投入)

## 全体像

```
                ┌──────────────── source of truth ────────────────┐
   貢献者 PR ──▶ │  CloudKit Public DB  ◀── オーナーが apply/seed で書込 │
    (data/)      └───────┬──────────────────────────────────────────┘
                            │ 日次 cron (GitHub Actions, 鍵は environment)
                            ▼
                     db/master.sql  ──(git に載る・diff 可能)──▶ コントリビューターが pull して最新を取得
                            │ tools/build_db.sh / 各ツールが自動生成
                            ▼
              ImasLiveDB/Resources/master.sqlite (binary・gitignore・各自生成)
```

- **CloudKit が source of truth**。`db/master.sql` はその日次スナップショット (テキスト dump・git 管理)。
- binary `master.sqlite` は **gitignore**。`db/master.sql` から各自再生成 (`tools/build_db.sh`、または apply ツールが自動生成)。
- だから**コントリビューターは clone するだけで最新データに対して `--check` できる**。

## データ投入は `tools/apply_data.py` 一本

追加も修正も同じツールで扱う。`data/` 配下を読んで検証 → master.sqlite に反映 → CloudKit へ push する。

- **新規追加**: `data/<種類>/*.json` (`songs` / `setlists` / `events` / `idols` / `units` / `creators` / `unit_versions` / `costumes`) … INSERT
- **既存レコード修正**: `data/fixes/*.json` … UPDATE (`idols` / `songs` / `events` / `shows` / `units` / `brands`)
- 形式は各 `data/<種類>/_template.json` / `data/fixes/_template.json` と [`data/README.md`](../data/README.md) 参照。全ファイルに `source` (出典 URL) 必須。

## コントリビューター

```bash
git pull                              # db/master.sql が日次で更新される
# 追加なら data/<種類>/ に、修正なら data/fixes/ に JSON を追加
python3 tools/apply_data.py --check    # 自己検証 (binary が無ければ db/master.sql から自動生成)
git add ... && PR
```

## オーナー (反映)

```bash
# PR をレビュー (出典確認) 後:
KID="<.claude/skills/sync-new-songs/SKILL.md に書いてある Production の key ID>"
python3 tools/apply_data.py --check  --only <ファイル名>.json                            # そのファイル単体で検証
python3 tools/apply_data.py --apply  --only <ファイル名>.json                            # ローカル master.sqlite に反映
CLOUDKIT_KEY_ID=$KID python3 tools/apply_data.py --apply --push --production --only <ファイル名>.json
# CloudKit に反映 → 翌日の cron が db/master.sql を更新 → 貢献が git にも反映される
```

**`--only` を付けること。** `--apply` は検証エラーが 1 件でもあると `sys.exit(1)` する。
`data/` には push 済みの INSERT 用 JSON が残ったままになりやすく、それが全部
「id は既に存在」で problem 判定になるため、絞らないと自分の変更が push まで到達しない
(2026-08-28 時点で 732 件が該当)。`--only` はパスではなくファイル名で照合する。

**列を NULL に直す修正は `--push` では伝わらない。** `seed_cloudkit.py` は NULL の列を送らず、
操作が forceUpdate なので CloudKit 側の旧値がそのまま残り、翌日の cron で `db/master.sql` が
巻き戻る (2026-09-06、`shows.venue` の NULL 化と `setlist_items.notes` の空文字→NULL で実際に起きた)。
そういう修正は `--apply` の後、対象を id で絞って forceReplace で送る:

```bash
CLOUDKIT_KEY_ID=$KID python3 tools/seed_cloudkit.py --production --tables shows --ids-file <event id の一覧> --replace
```

`--replace` は `--ids/--ids-file` が必須で、`tools/cloudkit_schema.ckdb` と突き合わせて
「CloudKit だけが持つ列」があるテーブルでは止まる (forceReplace は送らなかった列を消すため)。
`--ids` の絞り込み列はテーブルごとに違う (`shows` は **event_id**、`setlist_items` は id、
`song_artists` は song_id)。まとめて直した例: `tools/pending_push_20260906/README.md`。

**複合主キーの列を書き換える修正も、push だけでは伝わらない。** `song_artists` は
(song_id, idol_id, role) が主キーで、CloudKit の recordName にそのまま入る。role を
performer → original に直して push すると **original のレコードが増えるだけ**で、旧 performer は
残り、翌日の export で行が復活する。旧 recordName を `--delete-file` で消すこと
(例: `tools/pending_cloudkit_deletions_765as_roles_20260906.tsv`)。

**鍵の在り処**: key ID は環境変数にも `~/.zshrc` にも無い。`.claude/skills/sync-new-songs/SKILL.md`
の冒頭に Production の値が書いてある (このディレクトリは `.git/info/exclude` で
リポジトリから除外済み)。秘密鍵は `tools/eckey.pem` で、スクリプトが自分で読む。

**スキーマを足した場合は push の前に**、`tools/cloudkit_schema.ckdb` を
Development へ `xcrun cktool import-schema` してから Dashboard で Production へ昇格する。
Production に列が無いうちに push すると弾かれる。

> 2026-09-07: `Song` に `jointBrandIds` / `isCollab` を足した (合同曲)。昇格済み。
>
> 2026-09-13: `Song` に `hasKamisabiCard` を足した (KAMISABI 収録)。
> **Development へは import 済み**。残るは Dashboard の **Deploy Schema Changes** で
> Production へ昇格するところだけ (import-schema は production を受け付けない仕様)。
> 昇格前に songs を push すると弾かれる。
> この import では、積み残していた `Costume` / `CostumeWear` も一緒に development へ入った。

**ckdb を編集したら必ず `xcrun cktool validate-schema` を通すこと。**
2026-09-13 まで、`Creator` と `UnitVersion` の定義が二重に書かれていて
(「export の全文に追記」を繰り返した跡)、`type 'X' is specified multiple times` で
**validate も import も通らない状態が放置されていた**。衣装の 2 型が CloudKit の
どちらの環境にも無かったのはこれが理由。緑を確かめずに「ckdb に足したから済み」と
書くと、この形で何か月も気づかない。

`tools/cloudkit_schema.ckdb` は **export-schema の出力そのまま**にしておく
(並び順まで一致させる)。次に export した人が、本当の差分だけを見られるようにするため。
手順は「export → その全文に追記 → validate → import」で、**部分適用はしない**
(既存の定義を落とす)。

スキーマを変えた時 (列追加等) は、ローカル master.sqlite から `sqlite3 ... .dump > db/master.sql` で
dump を作り直してコミットする (cron はデータのみ更新し、スキーマは db/master.sql 由来のため)。

## events の種別 (`event_type`)

「**この曲、いつぶり?**」に、オタクが自然に付ける但し書き —
「オケマスを除けば 10 年ぶり」「AS の周年では 9th のみ」— を機械で出すための軸。
除外と限定ができて初めて意味のある答えが出るので、**1 イベント = 1 値**で持つ。

| 値 | 意味 | 例 |
|---|---|---|
| `anniversary` | 周年、またはブランドがナンバリングして続けている本公演 | 9th ANNIVERSARY / MILLION LIVE! 14thLIVE / SideM 7th STAGE |
| `orchestra` | オーケストラ・クラシック編成の演奏会 | ORCHESTRA CONCERT 〜SYMPHONY OF FIVE STARS!!!!!〜 |
| `external_event` | アイマス以外が主催する催しの中で行われたステージ | Animelo Summer Live / リスアニ！LIVE / TGS / ニコニコ超会議 / MONACAフェス |
| `birthday` | 生誕・バースデーの催し | 月村手毬 生誕ミニライブ2025 / レトラ BIRTHDAY ONLINE LIVE 2025 |
| `release_event` | 作品・商品のリリースに紐づく催し | 「LIVE THE@TER PERFORMANCE 02」発売イベント / お渡し会 / 舞台挨拶 |
| `mini_live` | ミニライブと名乗る催しのうち、生誕でも発売記念でもないもの | 学園アイドルマスターエキスポミニライブ |
| `broadcast` | 番組・配信そのもの (公演として開かれていない) | THE FIRST TAKE / NHK『シブヤノオト』/ 〜生配信 |
| `live` | 上記以外の、アイマス側が開いた公演 | M@STERS OF IDOL WORLD / CINDERELLA REAL PARTY / SideM GREETING TOUR 2017 |

**未分類は空文字**。「分からない」を `live` に倒すと、分類していないイベントが
自社公演として数えられ、上の但し書きが静かに嘘をつく。だから新規作成 (アプリの
イベント編集・`tools/insert_future_events.py`) も、CloudKit に `eventType` が
無かったときの既定値も **空**にしてある。

### 重なったときの優先順位

上から順に当てる。

1. `broadcast` → 2. `external_event` → 3. `orchestra` → 4. `birthday` →
5. `release_event` → 6. `mini_live` → 7. `anniversary` → 8. `live`

- **`orchestra` が `anniversary` より先** … 「THE IDOLM@STER 20th anniversary ORCHESTRA
  CONCERT」を周年側に入れると「オケマスを除けば」が効かなくなる。
- **`external_event` が `anniversary` より先** … 「7th Anniversary Memorial STAGE!!
  (CygamesFes2018)」のような**他社の催しの中の一コーナー**を周年本公演と同列に数えない。
- **`birthday` が `release_event` より先** … 「月村手毬 生誕ミニライブ2025」は
  購入者限定の形を取っていても、開かれた目的は生誕。
- **`release_event` が `mini_live` より先** … ここを逆にすると「発売記念イベント」が
  *名前にミニライブと書いてあるかどうか*で 2 つに割れる。同じ性格の催しが表記の偶然で
  分かれる軸は、絞っても意味のある答えにならない。逆に言うと `mini_live` は
  「ミニライブなのに発売記念ではないもの」という少数の受け皿で、現状 3 件しかない。

判定はイベント名を根拠にする。名前から決められないものは**空のまま置く**
(推測で埋めない)。「実質ミニライブだろう」のような**名前に書いていない推測で
広げない**こと。

### 入れなかった軸と、その理由

- **ツアー** … ツアーは 1 イベントの性格ではなく、**同じ公演名の連番イベント群**。
  このリポジトリではツアーの各公演地が別 `events` 行になっているので、
  1 行を見ても巡演かは分からない。しかも `tour` を `anniversary` と並ぶ値にすると
  「10thLIVE TOUR Act-1〜4」「CG 5thLIVE TOUR」がまるごと周年から落ち、
  「AS の周年では」の答えが変わる。軸にするなら `events` を束ねる series 列を足す
  ほうで、`event_type` の仕事ではない。
- **配信の有無** … `events.is_streaming` と `shows.stream_platform` が持つ**直交した軸**。
  ここに入れると 876 の「BIRTHDAY ONLINE LIVE」が `birthday` と「配信」のどちらかしか
  選べなくなる。正しい持ち方は `event_type='birthday'` かつ `is_streaming=1`。
  なお `is_streaming` は現状あてにならない (`is_streaming=0` なのに
  `shows.stream_platform` が埋まっている行が 30 件以上ある)。**どちらが正本かは
  未決着**で、`Event.swift` / `Event.kt` の `isStreaming` には
  「互換のため残置。新コードからは参照しない」と書いてある。配信で絞る機能を作る前に
  ここを片付けること。
- **アリーナ / ホールといった会場規模** … `shows.venue_id` から会場マスタで引ける。
- **上演形態 (朗読劇 / ミュージカル)** … 現状ほぼ SideM と CG の数本で、
  その軸で絞っても「意味のある答え」にならない。必要になったら足す。

### `kind` との関係 (畳む予定)

`events.kind` (`live` / `festival` / `release_event`) は `event_type` の**粗い版**に
なっている: `festival` ≒ `external_event`、`kind=release_event` の大半はそのままだが
一部は `birthday` / `mini_live` / `broadcast` に割れ、`kind=live` は
`anniversary` / `orchestra` / `external_event` / `birthday` / `broadcast` / `live` に割れる。
同じことを 2 列で言うのは片方だけ古くなる形なので、`event_type` に一本化する。

移行の順は、**データが先・列の撤去は後**:

1. 全 746 件に `event_type` を行き渡らせる (`data/fixes/` → `--apply --push`)。
   名前から決められない 1 件だけは空のまま残す。
   ここまでは `kind` を読む既存クライアントを壊さない。
2. CloudKit の `Event.eventType` が全レコードに載ったことを確認する
   (旧クライアントは `eventType` を読まないので、この時点では挙動が変わらない)。
3. `kind` を読んでいる箇所を `event_type` に差し替える
   (`event_list_filtering::normalize_kind` / `EventKind` / `EVENT_KINDS` /
   `InfoWidgetData.NEXT_SHOW_KINDS` / `EventRepository` の一覧仕様)。
   ここで「ライブタブに出すのは何か」の定義が `live` + `festival` から
   `external_event` を含むかどうかの判断に変わるので、**この段だけは UX の判断が要る**。
4. `kind` 列と CloudKit の `kind` フィールドを落とす。Room のマイグレーションと
   `db/master.sql` の dump 作り直しが要る (「スキーマを変えた時」の手順)。

3 を飛ばして 4 をやると、`kind` を読む旧バージョンのアプリで一覧が空になる。

### `meta.data_version` (これが落ちるとユーザーに届かない)

アプリの reseed は **bundle 側 `data_version` > 端末側** のときだけ走る
(`AppDatabase.reseedMasterTablesIfNeeded`)。つまり:

- **`meta` が消えた dump を配ると reseed が二度と発火しない。** bundle 側が `0` と読まれ、
  既存ユーザーは無言で旧データのまま固定される。FK ゲートでは検知できない種類の事故。
  `meta` は CloudKit 側に実体が無いので、`export_cloudkit.py` の `PRESERVED_TABLES` で
  refresh 対象から外して既存 dump の値を引き継ぐ。
- **データを入れても `data_version` を上げなければ既存ユーザーには届かない。**
  cron は「マスタに実差分があった回だけ」+1 する (差分判定は `data_version` 行を除いて比較。
  バンプ自体が差分になる循環を避けるため)。手で `--apply --push` した分も、翌日の cron が
  差分を拾って上げるので通常は追加操作は不要。

`tools/build_db.sh` は FK 整合性に加えて `data_version` の存在も検証し、欠けていれば
master.sqlite の生成を失敗させる。

## コミュニティデータ (D1) のバックアップ / スナップショット

マスタ (CloudKit) は日次 cron で `db/master.sql` に落ちるので失っても戻せる。
一方 **D1 は集計系コミュニティ (タグ・投票・お気に入り・予想・いいね) の唯一の正で、
バックアップの仕組みが無かった**。飛ばすとユーザーの投稿が丸ごと消える。

用途が違う 2 つを分けている。**混ぜないこと。**

| | 完全バックアップ | 公開スナップショット |
|---|---|---|
| ツール | `tools/backup_d1.sh` | `tools/export_community_snapshot.py --remote` |
| 出力 | `db_backups_local/d1_<日時>.sql` | `db/community.sql` |
| git | **載せない** (gitignore 済み) | 載せる (diff で履歴が追える) |
| 中身 | 全テーブル・全列 (Apple uid / device_id / 表示名 / 引き継ぎコードを含む) | 「誰が」を含まない集計のみ |
| 目的 | 災害復旧 | 「この時点でどんなタグがあり何が人気だったか」の記録 |

⚠️ **このリポジトリは public。** D1 の生ダンプを git に載せると Apple uid と device_id が
恒久的に公開される。だから完全バックアップは手元 (`db_backups_local/`) にだけ置き、
git に載せる方は識別子を含む列を一切出力しない。`export_community_snapshot.py` は
出力対象の列に `user_id` / `device_id` / `created_by` 等が混ざっていたら
実行前に落ちるようになっている。

```bash
# リリース前に (オーナー)
bash tools/backup_d1.sh                                  # 完全バックアップ → 手元
python3 tools/export_community_snapshot.py --remote      # 公開スナップショット → db/community.sql
python3 tools/export_calls_dashboard.py                  # コールガイド進捗の写し → db/calls_dashboard.json (鍵不要)
git add db/community.sql db/calls_dashboard.json && git commit -m "data(community): リリース時点のスナップショット"

# 動作確認 (誰でも・鍵不要)
python3 tools/export_community_snapshot.py --local

# 復元 (災害時)
npx wrangler d1 execute imas-live-db --remote --file db_backups_local/d1_<日時>.sql
```

> `db/calls_dashboard.json` は Web の `/calls/` の素材。本番の鮮度は `web-deploy.yml` の
> 日次ビルドが export 直前に取り直して担保するので、git 管理分はテスト・ローカルビルド用の
> 写しでよい (docs/ARCHITECTURE-web.md)。

> `wrangler d1 execute --json` は SQL の NULL を文字列 `"null"` として返し、本物の
> 文字列 `'null'` と区別できない。スナップショット生成は値の整形を Python でやらず
> SQLite の `quote()` に任せてこれを回避している (`export_community_snapshot.py` の注記)。

## 日次自動エクスポート (GitHub Actions)

`.github/workflows/refresh-data.yml` が毎日 CloudKit → `db/master.sql` を出力し、変化があれば自動コミット。
main / develop はどちらも保護ブランチ (PR + オーナー承認必須) なので、bot は**専用ブランチ `bot/data-refresh`**
に push する。**オーナーが `bot/data-refresh` → develop の PR でレビュー&マージ**して取り込む
(データ更新もレビューを通る)。develop → main は通常のリリースマージ。
鍵 (CloudKit S2S) を CI に置くので、**以下のセキュリティ設定が前提**。

### 必要な GitHub 設定 (一度だけ)

1. **Environment "cloudkit" を作成し、secret を登録 + main 限定にする**
   ```bash
   gh secret set CLOUDKIT_KEY_ID --env cloudkit --body "<CloudKit Key ID>"
   gh secret set CLOUDKIT_PRIVATE_KEY --env cloudkit < tools/eckey.pem
   ```
   GitHub UI → Settings → Environments → cloudkit → **Deployment branches: Selected → `main` のみ**。
   schedule は既定ブランチ(main)で走るため鍵を取得でき、feature ブランチ / PR で走る他ワークフローからは取得できない。

2. **main / develop の branch protection**: 両方とも PR 必須 + 承認必須 + **Code Owners レビュー必須**
   (`.github/CODEOWNERS` の `* @owner` で全 PR をオーナー承認必須に)。
   bot は保護ブランチへ直接 push せず `bot/data-refresh` へ出すので bypass 設定は不要。

3. **CODEOWNERS** (`.github/CODEOWNERS`): `* @owner` で全ファイル + `/.github/`・`/tools/` を明示。
   secret に触れるワークフロー・反映ツールの改ざんを防ぐ。

4. **`bot/data-refresh`** (保護外): bot が `db/master.sql` を push する専用ブランチ。
   オーナーが develop への PR でレビュー&マージして取り込む。

### この設定で守れること

| 攻撃 | 結果 |
|---|---|
| コントリビューターが別ワークフローで鍵を抜く | ❌ environment が main 限定なので feature ブランチでは鍵が出ない |
| ワークフロー/ツールを改ざんして鍵を抜く | ❌ CODEOWNERS + PR レビュー必須で main に入らない |
| 日次エクスポート | ✅ main の schedule なので鍵を使え、無人で回る |
