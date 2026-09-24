package com.fugaif.imaslivedb.ui.filtered

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class FilteredIdolsUiState(
    /** 画面タイトル。文言の値で持ち、画面で resolve() する (言語を切り替えても旧言語が残らない)。 */
    val title: DisplayText = DisplayText.Verbatim(""),
    val idols: List<Idol> = emptyList(),
    val isLoading: Boolean = true
)

/**
 * 絞り込んだアイドル一覧 (iOS `FilteredIdolsView`)。
 *
 * ブランドだけは一覧画面と同じ母集団 (外部ゲスト演者を除く) を使う。
 * 星座・出身地・血液型はプロフィールの属性から辿る一覧なので、
 * 「同じ属性の人を全員出す」ためにゲストも落とさない (母集団の違いはリポジトリ側の KDoc に書いた)。
 */
class FilteredIdolsViewModel(
    app: Application,
    private val kind: String,
    private val value: String
) : AndroidViewModel(app) {

    private val idols = AppModule.from(app).idolRepository

    private val _uiState = MutableStateFlow(FilteredIdolsUiState(title = DisplayText.Verbatim(value)))
    val uiState: StateFlow<FilteredIdolsUiState> = _uiState.asStateFlow()

    init {
        viewModelScope.launch { load() }
    }

    private suspend fun load() {
        when (kind) {
            IdolFilterKind.BRAND -> {
                // 表示名が引けないブランド (同期前・未知 id) でも一覧そのものは出す。
                val label = idols.fetchBrand(value)?.shortName ?: value
                emit(L10n.Filtered.idolsTitleBrand(brand = label), idols.fetchIdolsForList(value))
            }
            // 星座・出身地・血液型の値はデータ (訳さない)。文の形だけカタログから引く。
            IdolFilterKind.CONSTELLATION ->
                emit(L10n.Filtered.idolsTitleConstellation(constellation = value), idols.fetchIdolsByConstellation(value))
            IdolFilterKind.BIRTH_PLACE ->
                emit(L10n.Filtered.idolsTitleBirthPlace(place = value), idols.fetchIdolsByBirthPlace(value))
            IdolFilterKind.BLOOD_TYPE ->
                emit(L10n.Filtered.idolsTitleBloodType(bloodType = value), idols.fetchIdolsByBloodType(value))
            else -> emit(DisplayText.Verbatim(value), emptyList())
        }
    }

    private fun emit(title: DisplayText, idols: List<Idol>) {
        _uiState.value = FilteredIdolsUiState(title = title, idols = idols, isLoading = false)
    }

    class Factory(
        private val app: Application,
        private val kind: String,
        private val value: String
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T =
            FilteredIdolsViewModel(app, kind, value) as T
    }
}
