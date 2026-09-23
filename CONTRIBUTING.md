# コントリビューションガイド / 参加規約

ImasLiveDB は**非公式ファンメイドの非商用プロジェクト**です。コントリビュート・利用する時点で、以下の規約に同意したものとみなします。

## 1. ライセンス / 利用規約

- 本プロジェクトは **[PolyForm Noncommercial 1.0.0](LICENSE.md)** で提供されます。
- **非商用**であれば、利用・改変・再配布は自由です。
- **商用利用は許可しません**（本人・所属組織問わず）。非公式ファンプロジェクトのためです。
- ソースは公開（source-available）ですが、OSI 準拠の OSS ではありません。
- コントリビュート（PR）した内容は、本プロジェクトで同ライセンスのもと利用されることに同意したものとみなします。

## 2. 非公式・版権の遵守 (絶対)

- 本プロジェクトはいかなる公式運営とも無関係な**非公式ファンメイド**です。
- **キャラクター画像・歌詞・公式ロゴは一切使用しない。**
- ジャケット画像は **MusicKit API 経由のみ**で表示する (画像ファイルを同梱しない)。
- アプリ名・表示に「アイマス」「アイドルマスター」等の固有名称を入れない。

## 3. 開発フロー

メンテナンスはオーナー主導です。基本方針:

- 外部の方は fork して `develop` 向けに PR を出してください。大きめの機能や構造変更は、着手前に Issue で方向性を相談してもらえると手戻りがありません。
- **作業ブランチは `feature/<topic>` で切る**（`develop` 起点。修正は `fix/<topic>`、雑務は `chore/<topic>` でも可）。`main`/`develop` で直接作業しない。完了したら `develop` への PR。
- **iOS を変更したら必ず同セッションで Android に 1:1 で横展開する** (`/sync-ios-to-android`)。片方だけの変更を残さない。
- 大きめの実装後はビルド → 動作確認 → 修正のループを全パスするまで回す。
- コミットは 1 機能 / 1 論理的変更単位。差し戻し (`git revert`) しやすい粒度を保つ。
- コミット時は `git add <file>...` で個別指定する (`git add -A` / `git add .` は使わない)。

詳細な設計規約・ビルド手順は各プラットフォームの `docs/ARCHITECTURE*.md` を参照 (`CLAUDE.md` はオーナー/メンテナ向けの内部メモで `.gitignore` により追跡外。コントリビューターには配布されない)。

## 4. データ修正の流れ

| データ種別 | 方法 |
|---|---|
| **マスタ (アプリから)** | アプリ内 `/edits` フロー → 検証・モデレーション → CloudKit へ反映 → 差分 sync で全端末配信 |
| **マスタ (PR から)** | `data/` に JSON を追加して PR。**追加**は `data/<種類>/`、**修正**は `data/fixes/`（詳細は [`data/README.md`](data/README.md)） |
| **集計系コミュニティ** (タグ / 投票 等) | Worker (D1) 経由。レート制限・device 重複排除あり |

- PR で出す時は送信前に `python3 tools/apply_data.py --check` で自己検証できる (鍵不要)。`--check` は出典の無い投稿を落とす。
- 各エントリに**出典URL (一次ソース) 必須**。オーナーがレビュー後 `--apply --push` で master.sqlite → CloudKit に一括反映。反映済みのファイルは `data/_applied/<種類>/` へ移される (`apply_data.py` はそこを読まない。PR 履歴と合わせた監査ログ)。

- マスタの事実情報 (アイドル名・楽曲情報など) を直す時は、**必ず公式サイトを確認してから**修正する (推測で書き換えて別キャラの情報になる事故を防ぐ)。
- 一括スクリプトでの機械的修正よりも、1 件ずつ判断して直す方を優先する (デグレ防止)。

## 5. スキーマ (DB の構造) を変えたいとき

**コントリビューターは PR を出すところまで。本番への反映はマージ後にオーナーが行います。**
CloudKit の鍵や Dashboard の権限は不要です。

### 変える場所

「列を 1 本足す」でも、層ごとに正本が分かれています。関係する層だけ触ってください。

| 層 | 触るファイル | 本番への反映 |
|---|---|---|
| **CloudKit** (マスタの source of truth) | `tools/cloudkit_schema.ckdb` に**追記** / `tools/lib/ck_records.py` 等の対応表 | マージ後にオーナーが手動 (下記) |
| **端末の SQLite** (iOS / Android) | `db/master.sql` / `imas-core/src/domain/master_schema.sql` / iOS `DatabaseMigrations` / Android Room `Migration` | 不要。アプリ起動時に自動で追加される |
| **Worker (D1)** (タグ・投票などの集計系) | `imas-live-api/migrations/00xx_*.sql` を新規追加 | マージ後にオーナーが手動 (下記) |

### 守ること: **足すだけ**

CloudKit の Production は**列や型を消せず、型も変えられません**。一度流すと戻せないので、

- 列・型の**削除や改名はしない** (使わなくなった列は残したまま読まない)
- 型を変えたいときは**別名の列を足す**
- 新しい record type には `modifiedAt TIMESTAMP QUERYABLE SORTABLE` と `deletedAt TIMESTAMP QUERYABLE SORTABLE` を必ず持たせる
- 端末側も同じく**追加のみ**。`user_marks` (担当・お気に入り) は端末にしか無いデータなので、破壊的な移行は書かない

手元で確かめられます (鍵不要):

```bash
python3 tools/check_ckdb_schema.py --base origin/develop
```

同じ検査が PR の CI (`schema-guard`) でも走り、追加される項目の一覧が job summary に出ます。

### PR に書くこと

PR テンプレートの「スキーマ変更」欄を埋めてください。特に**なぜその列が要るか**と、
**既存データをどう埋めるか** (空のままでよいか、`data/fixes/` で埋めるか) があるとレビューが速くなります。

### マージ後 (オーナー側・参考)

`develop` に `cloudkit_schema.ckdb` か D1 migration の変更が入ると、`schema-guard` が
**「本番スキーマ反映待ち」Issue を自動で起票**します。オーナーはそのチェックリストに沿って

1. CloudKit: `cktool import-schema` で Development へ → Dashboard の **Deploy Schema Changes** で Production へ
2. D1: `wrangler d1 migrations apply --remote` → Worker をデプロイ

を行い、Issue を close します。**マージ時の自動実行はしません** — Production の CloudKit スキーマは
`cktool` から昇格できない仕様であることと、戻せない操作をリリース前の `develop` マージで
確定させないためです。詳細は [`docs/DATA_PIPELINE.md`](docs/DATA_PIPELINE.md)。

## 6. シークレットの取り扱い

- `.dev.vars` / `.env` / `*.p12` / 秘密鍵 / `google-services.json` 内の値などを**平文でコミットしない**。
- ローカル開発用シークレットは `.dev.vars.example` をコピーして `.dev.vars` に記入する (`.dev.vars` は `.gitignore` 済み)。
- 本番シークレットは `wrangler secret put` で Cloudflare 側に登録する。
- 誤って秘密をコミット・push した場合は、ただちにオーナーに連絡し、該当の鍵をローテーションする。

---

不明点はオーナー (リポジトリ管理者) に確認してください。
