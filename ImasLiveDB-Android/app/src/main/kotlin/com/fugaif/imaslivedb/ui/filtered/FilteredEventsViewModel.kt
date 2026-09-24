package com.fugaif.imaslivedb.ui.filtered

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.fugaif.imaslivedb.data.model.EventWithDateRange
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class FilteredEventsUiState(
    /** 画面タイトル。文言の値で持ち、画面で resolve() する (言語を切り替えても旧言語が残らない)。 */
    val title: DisplayText = DisplayText.Verbatim(""),
    val events: List<EventWithDateRange> = emptyList(),
    val isLoading: Boolean = true
)

/**
 * 「◯◯のライブ」「N年のライブ」(iOS `FilteredEventsView`)。
 *
 * どちらの条件でも母集団は kind=live/festival に限る (ラジオや発売記念イベントは
 * ライブ一覧の絞り込み先には出さない) — 判断はリポジトリ側にあり、ここは条件を選ぶだけ。
 */
class FilteredEventsViewModel(
    app: Application,
    private val kind: String,
    private val value: String
) : AndroidViewModel(app) {

    private val events = AppModule.from(app).eventRepository

    private val _uiState = MutableStateFlow(FilteredEventsUiState(title = DisplayText.Verbatim(value)))
    val uiState: StateFlow<FilteredEventsUiState> = _uiState.asStateFlow()

    init {
        viewModelScope.launch { load() }
    }

    private suspend fun load() {
        when (kind) {
            EventFilterKind.BRAND -> {
                // 表示名が引けないブランド (同期前・未知 id) でも一覧そのものは出す。
                val label = events.fetchBrand(value)?.shortName ?: value
                emit(L10n.Filtered.eventsTitleBrand(brand = label), events.fetchEventsWithDateByBrand(value))
            }
            EventFilterKind.YEAR -> {
                val year = value.toIntOrNull()
                if (year == null) emit(DisplayText.Verbatim(value), emptyList())
                else emit(L10n.Filtered.eventsTitleYear(year = year), events.fetchEventsWithDateByYear(year))
            }
            else -> emit(DisplayText.Verbatim(value), emptyList())
        }
    }

    private fun emit(title: DisplayText, events: List<EventWithDateRange>) {
        _uiState.value = FilteredEventsUiState(title = title, events = events, isLoading = false)
    }

    class Factory(
        private val app: Application,
        private val kind: String,
        private val value: String
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T =
            FilteredEventsViewModel(app, kind, value) as T
    }
}
