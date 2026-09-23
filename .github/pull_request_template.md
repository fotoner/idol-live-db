## 概要

<!-- 何を・なぜ変えたか。関連 Issue があれば #番号 -->

## 変更の種類

- [ ] 機能追加・改善
- [ ] 不具合修正
- [ ] データ追加・修正 (`data/`)
- [ ] スキーマ変更 (CloudKit / 端末 SQLite / D1) → 下の「スキーマ変更」欄も記入
- [ ] その他

## 確認したこと

- [ ] iOS と Android の両方に反映した (片方だけの場合は理由を書く)
- [ ] ビルド・動作確認した (スクリーンショットがあると助かります)
- [ ] データ変更は `python3 tools/apply_data.py --check` が通る

## スキーマ変更 (該当する場合のみ)

<!-- 本番への反映はマージ後にオーナーが行います。CONTRIBUTING.md「5. スキーマを変えたいとき」参照 -->

- 追加する列・型:
- なぜ必要か:
- 既存データの埋め方: <!-- 空のままでよい / data/fixes/ で埋める / 別 PR で投入 など -->
- [ ] 追加のみ (削除・改名・型変更なし)。`python3 tools/check_ckdb_schema.py --base origin/develop` が通る
- [ ] 端末 SQLite を変えた場合: `db/master.sql`・`master_schema.sql`・iOS/Android の移行を対で更新した
