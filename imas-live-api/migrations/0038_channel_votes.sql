-- チャンネル (アイマス / ボカロ) のアイドル別投票 v1
--
-- イントロクイズ側で遊んで貯まる「投票ポイント」の使い道。既存の polls とは別物:
--   polls        = ユーザーがお題を立てて、1 お題につき 3 票まで (無料の人気投票)
--   channel_vote = 遊んで貯めたポイントを好きなだけ注ぎ込む (通貨)
-- 主キーの形が違う (polls は 1 人 1 票なので (poll, entity, user)) ため、
-- 票数を持てる別テーブルにする。
--
-- **月ごとに区切る。** 累計だと最初の数か月で順位が決まって二度と動かず、
-- 後から入った人に投票する理由が無くなる。ポイントは遊ぶと貯まるので、
-- 累計順位は「誰が一番遊んだか」に近づく。
--
-- period は **JST の暦月** ('YYYY-MM')。書き込み側は必ずサーバーが決める
-- (クライアントに選ばせると過去の月へ詰め込める)。

CREATE TABLE IF NOT EXISTS channel_vote_totals (
  period      TEXT NOT NULL,               -- 'YYYY-MM' (JST)
  channel_id  TEXT NOT NULL,               -- 'imas' / 'vocaloid' (不透明キー)
  entity_id   TEXT NOT NULL,               -- アイドルのキー (不透明キー)
  votes       INTEGER NOT NULL DEFAULT 0,
  updated_at  TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (period, channel_id, entity_id)
);

-- ランキングはこの索引 1 本で引く (集計を走らせない)。
CREATE INDEX IF NOT EXISTS idx_channel_vote_totals_rank
  ON channel_vote_totals(period, channel_id, votes DESC);

-- 端末ごとの内訳。「自分が誰にどれだけ入れたか」の表示と、
-- 不正が見つかったときに巻き戻せるようにするために持つ。
CREATE TABLE IF NOT EXISTS device_channel_votes (
  period      TEXT NOT NULL,
  channel_id  TEXT NOT NULL,
  entity_id   TEXT NOT NULL,
  device_id   TEXT NOT NULL,
  votes       INTEGER NOT NULL DEFAULT 0,
  updated_at  TEXT NOT NULL DEFAULT (datetime('now')),
  PRIMARY KEY (period, channel_id, entity_id, device_id)
);

CREATE INDEX IF NOT EXISTS idx_device_channel_votes_mine
  ON device_channel_votes(device_id, period, channel_id);
