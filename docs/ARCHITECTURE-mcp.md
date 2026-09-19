# ImasLiveDB を LLM から引く口 (`imas-mcp`) アーキテクチャ方針

> iOS は [`ARCHITECTURE.md`](ARCHITECTURE.md)、Android は [`ARCHITECTURE-android.md`](ARCHITECTURE-android.md)、
> Web 出面は [`ARCHITECTURE-web.md`](ARCHITECTURE-web.md)、バックエンド Worker は [`ARCHITECTURE-worker.md`](ARCHITECTURE-worker.md)。
> データ所在・投入の全体像は [`DATA_PIPELINE.md`](DATA_PIPELINE.md)。
> 規則を写経しない考え方は [`SHARED_CORE_STUDY.md`](SHARED_CORE_STUDY.md)。

> 状態: **設計確定・実装中** (2026-09-19 着手)。数値と実例は実装完了後に §9 で埋める。

---

## 1. これは何か / 何をしないか

`imas-mcp` は、**LLM がアイドルマスターのライブ・楽曲データを自然言語で尋ねられるようにする口**。
中身は 2 つの顔を持つ 1 つのバイナリ:

- **MCP サーバ** — `--stdio` で JSON-RPC 2.0 を話す。Claude 等の MCP クライアントから繋ぐ。
- **CLI** — 同じツールを `imas-mcp <tool> --json '{...}'` で人の手からも叩ける。

データは**アプリと同じ `master.sqlite`** をそのまま読む。別の写しを持たない。

やらないこと:

- **歌詞本文を返さない。** JASRAC の許諾は「D1 に置き、一括ダウンロードさせない配信形式」に対して
  下りている (`JASRAC.md`)。ここから本文を出すとその前提を外れる。扱うのは作品コードと掲載有無まで。
- **本番データへ直接書かない。** 新規登録は `data/` に JSON ドラフトを置いて `--check` を通すところまで (§5)。
- **LLM を呼ばない。** これは LLM に**呼ばれる**側。アプリにチャット機能を作る計画ではない
  (推論コストが発生し「ランニングコスト 0」の制約に反する)。

## 2. 絶対制約

1. **ランニングコスト 0**。ローカル版はユーザーの手元で動くので当然 0。リモート公開版 (§8) も
   従量課金の経路を作らない。
2. **判断の唯一の正は imas-core (Rust) の `domain`**。「どの語が当たるか」「何を返すか」
   「何件で切るか」「どう並べるか」はすべて `domain::agent_tools` / `entity_resolution` /
   `proposal` が持つ。アダプタ (`src/agent/`) は入力をほどいて domain を呼び、返った JSON を
   書き出すだけ。**これを崩すと、アプリ・Web・LLM で「同じ質問に違う答え」が出る。**
3. **照合規則はコア一本**。検索の畳み込みは `imas-text-fold` / `domain::text_search_index` /
   `fuzzy_search` が唯一の実体。ツール面で `contains` や `to_lowercase` を書かない。
4. **FFI 面は不変**。新しい `#[uniffi::export]` を足さない (`tests/ffi_surface.rs` が固定している)。
   アダプタと bin は既定 off の `feature = "agent"` で、iOS/Android のビルドには一切入らない。
5. **出典なしの登録を構造で禁じる**。書き込みツールは `source` (一次ソースの URL) を必須引数にする。

## 3. 依存方向

```
   MCP クライアント (Claude 等)        人の手 (デバッグ)
            │ JSON-RPC 2.0 / stdio            │ argv
            ▼                                 ▼
   ┌──────────────────────────────────────────────────┐
   │ imas-core/src/agent/   (driving adapter)          │  feature = "agent" (既定 off)
   │   mcp.rs   … initialize / tools/list / tools/call │
   │   stdio.rs … 行区切り JSON-RPC の入出力            │
   │   cli.rs   … argv → 同じツール                     │
   │   proposal_io.rs … ドラフトを書く / --check を起動 │
   └───────────────┬──────────────────────────────────┘
                   │ 呼ぶだけ (判断を書かない)
   ┌───────────────▼──────────────────────────────────┐
   │ imas-core/src/domain/   (唯一の正・純粋・テスト付) │  feature に関係なく常時コンパイル
   │   agent_tools/lookup.rs  … resolve / search / get_* / vocabulary
   │   agent_tools/browse.rs  … list_* / idol_songs / song_performances / setlist_diff / stats
   │   entity_resolution.rs   … 人の言葉 → エンティティ候補
   │   proposal.rs            … 投入ドラフトの組み立て
   │   (以下は既存) search_queries / idol_queries / song_detail_queries / …
   └───────────────┬──────────────────────────────────┘
                   │ Snapshot
   ┌───────────────▼──────────────────────────────────┐
   │ outbound::sqlite_loader → ImasLiveDB/Resources/master.sqlite (READ ONLY)
   └──────────────────────────────────────────────────┘
```

`domain` 側を feature ゲートしていないのは、**既定の `cargo test` で規則のテストを回すため**。
アダプタと bin だけを切れば iOS/Android のビルドには入らない。

## 4. 返す形の方針 (UI 向けの射影と違う)

アプリ向けの FFI は「添字列を返して呼び手が自国の store で実体化する」形だが、**ここでは使わない**。
読み手は LLM なので、規約はこうする:

- **1 回の呼び出しで、追加の往復なしに文章が書ける形**まで名前を解決して返す。
- 各レコードに必ず `id` を添える (次の呼び出しの手がかり)。
- `null` のフィールドは省く (トークンを食うだけ)。
- 打ち切ったら `truncated: true` と `total: N`。**総数は必ず返す** (「何件ありますか」に答えるため)。
- 語彙外の値は黙って 0 件にせず、取りうる値を並べた `BadArgs` を返す。
  **LLM が空振りに気づけない形にしない。**
- 名前で引いて 2 件以上当たったら勝手に 1 件に決めず、候補を返して選ばせる。

## 5. 新規データ登録 (どこで止めるか)

`DATA_PIPELINE.md` のとおり **CloudKit が source of truth** で、反映にはオーナーの手元にしかない
鍵が要る。LLM の誤りがそのまま全ユーザーへ配信される経路を作らないため、ここからできるのは:

```
LLM → propose_* ツール → data/<種類>/*.json を書く → tools/apply_data.py --check を走らせる
                                                      → 検証結果をそのまま LLM に返す
                     （ここまで。反映はオーナーが --apply --push）
```

- `source` (一次ソースの URL) が無ければドラフトを組まない。
- **`apply_data.py` の検証規則を Rust に写経しない。**写経すると二重管理になり、必ず片方だけ
  書き換わる。ドラフト側が持つのは「JSON の組み立て方」と「出典の必須」まで。値の妥当性は
  `--check` に任せる。
- 結果には必ず「これは提案であって、反映にはオーナーの操作が要る」旨を入れる。
  LLM が「登録できたつもり」になるのを防ぐ。

## 6. なぜ CLI と MCP を 1 つにするか

MCP サーバは stdout に JSON-RPC 以外を 1 バイトも書けないので、中で何が起きているか見えにくい。
同じ dispatch を argv からも叩ける口があれば、`imas-mcp get_song --id ml_xxx` で
**ツールの答えそのものを目で確かめられる**。テストも CLI 経由で書ける。分けて作る理由が無い。

## 7. 使い方

```bash
cd imas-core
cargo build --release --features agent --bin imas-mcp

# MCP クライアントから (例: Claude Code の設定)
#   command: <repo>/imas-core/target/release/imas-mcp
#   args: ["--stdio", "--repo-root", "<repo>"]

# 人の手から
./target/release/imas-mcp tools
./target/release/imas-mcp search --query 春日未来
```

`--read-only` を付けると書き込み (ドラフト作成) ツールを出さない。

## 8. リモート公開 (Phase 2・未着手)

手元に clone した人しか使えないのは惜しいので、誰でも繋げる MCP エンドポイントも出す。
**判断は同じ `domain::agent_tools` を通す** (wasm で呼ぶ) ので、答えがローカル版とズレることはない。

データの渡し方の候補と、選ぶときの軸:

| 案 | データ源 | 難点 |
|---|---|---|
| A: 生テーブル一括 | `web/data/snapshot/tables.json` (9.4MB) | Worker の CPU 時間内にパースしきれない |
| B: 分割済み JSON | `web/data/search/*.json` (732KB) + 個別 `songs/<slug>.json` 等 | 索引の持ち方を設計し直す必要がある |
| C: D1 | D1 に master を置き直す | 読み取り行数が課金対象。過去に無料枠を焼いた経緯がある (`D1` の項) |

**B が本命。** 検索インデックスが 732KB しかなく、Web 出面が既に出力しているものをそのまま使える。
Worker 側は assets binding から読むので追加の課金経路が無い。
ただし「1 回の呼び出しで文章が書ける形まで解決する」(§4) を分割 JSON だけで満たせるかは要検証で、
Phase 1 のツールが実データで何を触っているかを見てから決める。

## 9. 実装の記録

(実装完了後に追記: ツール一覧・実データでの応答例・Snapshot ロード時間・テストの本数)
