package com.fugaif.imaslivedb.ui.events

import android.content.Context
import androidx.lifecycle.ViewModel
import uniffi.imas_core.PerformerNameMode
import uniffi.imas_core.SetlistDisplayMode
import uniffi.imas_core.SetlistRowMetaRecord
import uniffi.imas_core.ShowCollectionRecord
import uniffi.imas_core.ShowCostumeRecord
import androidx.lifecycle.viewModelScope
import com.fugaif.imaslivedb.data.model.PerformerRow
import com.fugaif.imaslivedb.data.model.SetlistRow
import com.fugaif.imaslivedb.data.model.Show
import com.fugaif.imaslivedb.data.model.ShowTicket
import com.fugaif.imaslivedb.di.AppModule
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class SetlistSection(
    val sectionName: String,
    val items: List<SetlistRow>
)

data class SetlistUiState(
    val isLoading: Boolean = true,
    val show: Show? = null,
    val brandId: String? = null,
    val setlist: List<SetlistRow> = emptyList(),
    val performersByItemId: Map<String, List<PerformerRow>> = emptyMap(),
    /** この公演で着られた衣装 (進行順)。畳み方も並びも共有コアが決めている。 */
    val costumes: List<ShowCostumeRecord> = emptyList(),
    /**
     * この公演の券種 (マスタ・生の行)。「どんな価格の券があったか」を出す。
     * 絞り込み・並び・価格帯の判断は画面側で共有コア (`ticketsForKind` 等) へ委ねる。
     */
    val tickets: List<ShowTicket> = emptyList(),
    /**
     * setlist_items.id → 行の添え物 (名義・ユニットの札・全員・何回目・いつぶり・自分の回収)。
     * **中身を決めるのは共有コア。** 画面はキーで引いて出すだけ。
     */
    val rowMetaByItemId: Map<String, SetlistRowMetaRecord> = emptyMap(),
    /**
     * 公演の頭に出す「自分の回収」の要約 (この公演で N 曲回収 / 未回収 N 曲)。
     * **出すかどうかも文言も共有コアが決める。** null なら何も出さない
     * (参加記録が無い人・回収の対象でない催し・シンプル表示)。
     */
    val collectionSummary: ShowCollectionRecord? = null
) {
    val sections: List<SetlistSection>
        get() {
            val result = mutableListOf<SetlistSection>()
            for (item in setlist) {
                val sectionName = item.section ?: "本編"
                if (result.lastOrNull()?.sectionName == sectionName) {
                    val last = result.last()
                    result[result.lastIndex] = last.copy(items = last.items + item)
                } else {
                    result.add(SetlistSection(sectionName = sectionName, items = listOf(item)))
                }
            }
            return result
        }
}

class SetlistViewModel : ViewModel() {

    private val _uiState = MutableStateFlow(SetlistUiState())
    val uiState: StateFlow<SetlistUiState> = _uiState.asStateFlow()

    /**
     * @param nameMode 歌唱者をどの名前で出すか。**行の添え物の中身が変わる**ので、
     *   設定が変わったら呼び直すこと (画面側が設定を鍵にした LaunchedEffect で呼ぶ)。
     * @param displayMode どこまで詳しく出すか。履歴の札・回収の札・要約を出すかどうかも
     *   コアがこれで決める。
     * @param includeStreamInCollection 設定「配信参加も回収に含める」の現在値。
     *   **回収の答えが変わる**ので、参加記録の付け外しと同じく変わったら呼び直すこと。
     */
    fun load(
        context: Context,
        showId: String,
        nameMode: PerformerNameMode,
        displayMode: SetlistDisplayMode,
        includeStreamInCollection: Boolean
    ) {
        viewModelScope.launch {
            val module = AppModule.from(context)
            val show = module.eventRepository.fetchShow(showId)
            val brandId = show?.eventId?.let { module.eventRepository.fetchEvent(it)?.brandId }
            // 画面の 2 つの半分 (曲と出演者) は同じ所有者から読む。DAO を直接叩くと
            // どちらの経路がいつ更新されるかがリポジトリの外に散り、片方だけ古い値を
            // 表示する事故に戻る。
            val setlist = module.eventRepository.fetchSetlist(showId)
            // 曲ごとのグループ化と並びは共有コア (showSetlistPerformers) が持つ。
            val performersByItemId = module.eventRepository.fetchPerformersByItem(showId)
            val costumes = module.eventRepository.fetchShowCostumes(showId)
            val tickets = module.showTicketRepository.forShow(showId)
            // 名義も「いつぶりか」も「自分の回収」も共有コアが決める。ここは受け取って配るだけ。
            val rowMeta = module.eventRepository.fetchSetlistRowMeta(
                showId, nameMode, displayMode, includeStreamInCollection
            )

            _uiState.value = SetlistUiState(
                isLoading = false,
                show = show,
                brandId = brandId,
                setlist = setlist,
                performersByItemId = performersByItemId,
                costumes = costumes,
                tickets = tickets,
                rowMetaByItemId = rowMeta.rowsByItemId,
                collectionSummary = rowMeta.collection
            )
        }
    }
}
