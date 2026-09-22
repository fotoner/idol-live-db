package com.fugaif.imaslivedb.data.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey

/**
 * 公演のチケット価格。
 *
 * 「どんな価格の券があるか」を引くためのマスタで、**みんなで共有する事実**。
 * 自分がいくら払ったかは端末ローカルの収支 ([Expense]) 側に持つ。
 *
 * [price] は**税込・手数料抜きの定価**。[isEstimate] は公式に出ていない推定値の札で、
 * 推定を実額と同じ顔で出さないために要る。
 *
 * 席種 ([name]) は自由文字列。S席 / 立見 / アリーナ / 配信 (アーカイブ付き) …と
 * 公演ごとに呼び方が違うので、機械で扱うのは [kind] (live / stream / live_viewing) だけ。
 * 選び方・並び・価格帯の規則は共有コアの `domain/ticket_prices.rs`。
 */
@Entity(
    tableName = "show_tickets",
    indices = [Index(name = "idx_show_tickets_show", value = ["show_id"])]
)
data class ShowTicket(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: String,

    @ColumnInfo(name = "show_id")
    val showId: String,

    /** `live` / `stream` / `live_viewing`。欠けていれば現地扱い。 */
    @ColumnInfo(name = "kind", defaultValue = "'live'")
    val kind: String = "live",

    @ColumnInfo(name = "name")
    val name: String,

    @ColumnInfo(name = "price")
    val price: Long,

    @ColumnInfo(name = "is_estimate", defaultValue = "0")
    val isEstimate: Boolean = false,

    @ColumnInfo(name = "note")
    val note: String? = null,

    @ColumnInfo(name = "sort_order", defaultValue = "0")
    val sortOrder: Long = 0,
)
