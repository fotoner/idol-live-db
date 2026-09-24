package com.fugaif.imaslivedb.ui.idols

import android.app.Application
import android.content.Context
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.fugaif.imaslivedb.data.local.localWrite
import com.fugaif.imaslivedb.data.model.Brand
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.data.model.UserMark
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import uniffi.imas_core.IdolListFilterCriteria

enum class IdolDisplayMode { IDOL_NAME, CV_NAME }
enum class IdolListMode { LIST, GRID }

/**
 * ブランド内サブカテゴリ属性 (idols.attribute) の定義。(内部値, 表示ラベル)。
 * iOS `FilterSheet.swift` の `brandAttributes` と同一。
 * 表示ラベルの対応表は imas-core に無く、iOS も Swift 定数として持っているのでここに残す。
 * ラベルはカタログの文言 (i18n/catalog/idols.json の attribute.*)。英字の名前 (Sol 等) は訳さないのでそのまま。
 */
val IDOL_BRAND_ATTRIBUTES: Map<String, List<Pair<String, DisplayText>>> = mapOf(
    "cg" to listOf(
        "cute" to L10n.Idols.attributeCute,
        "cool" to L10n.Idols.attributeCool,
        "passion" to L10n.Idols.attributePassion
    ),
    "ml" to listOf(
        "princess" to L10n.Idols.attributePrincess,
        "fairy" to L10n.Idols.attributeFairy,
        "angel" to L10n.Idols.attributeAngel
    ),
    "765as" to listOf(
        "princess" to L10n.Idols.attributePrincess,
        "fairy" to L10n.Idols.attributeFairy,
        "angel" to L10n.Idols.attributeAngel
    ),
    "sidem" to listOf(
        "intelli" to L10n.Idols.attributeIntelli,
        "physical" to L10n.Idols.attributePhysical,
        "mental" to L10n.Idols.attributeMental
    ),
    "sc" to listOf(
        "sol" to DisplayText.Verbatim("Sol"),
        "luna" to DisplayText.Verbatim("Luna"),
        "stella" to DisplayText.Verbatim("Stella")
    )
)

/**
 * 並び順の表示名 (カタログの文言 sort_order.*)。保存値は enum の name のままで変えない。
 * ja はコアの表示名 ([IdolSortOrder.label]) と同じ文字列。ko は「〜순」まで含む。
 */
val IdolSortOrder.labelText: DisplayText
    get() = when (this) {
        IdolSortOrder.OFFICIAL -> L10n.Idols.sortOrderOfficial
        IdolSortOrder.NAME_KANA -> L10n.Idols.sortOrderNameKana
        IdolSortOrder.AGE -> L10n.Idols.sortOrderAge
        IdolSortOrder.HEIGHT -> L10n.Idols.sortOrderHeight
        IdolSortOrder.WEIGHT -> L10n.Idols.sortOrderWeight
        IdolSortOrder.BIRTHDAY -> L10n.Idols.sortOrderBirthday
        IdolSortOrder.DEBUT -> L10n.Idols.sortOrderDebut
    }

data class IdolListUiState(
    val idols: List<Idol> = emptyList(),
    val brands: List<Brand> = emptyList(),
    /** idol_id → 現役CV名 (name/nameKana に加えて検索対象にする)。 */
    val castNames: Map<String, String> = emptyMap(),
    val selectedBrandIds: Set<String> = emptySet(),
    val selectedAttribute: String? = null,
    val searchText: String = "",
    val collapsedBrands: Set<String> = emptySet(),
    val displayMode: IdolDisplayMode = IdolDisplayMode.IDOL_NAME,
    val showCV: Boolean = false,
    val listMode: IdolListMode = IdolListMode.LIST,
    val requireMyPick: Boolean = false,
    val requireFavorite: Boolean = false,
    val requireNote: Boolean = false,
    /** 並び順。公式順以外はブランドの区切りを外した通し表示になる。 */
    val sortOrder: IdolSortOrder = IdolSortOrder.OFFICIAL,
    /** null = sortOrder の既定方向、true=昇順、false=降順。 */
    val sortAscending: Boolean? = null,
    val pickIds: Set<String> = emptySet(),
    val favoriteIds: Set<String> = emptySet(),
    val noteIds: Set<String> = emptySet(),
    /** 絞り込み + 並べ替え済みの表示対象 ([rebuilt] が再計算して持つ)。 */
    val filteredIdols: List<Idol> = emptyList(),
    /** 行に添える指標 (idol id → ラベル)。並べ替えと一緒にコアが返す。無い人は出さない。 */
    val metricById: Map<String, String> = emptyMap(),
    /** ブランド別セクション。公式順以外 (通し並び) では空。 */
    val groupedByBrand: Map<String, List<Idol>> = emptyMap(),
    /** 1 人以上残っているブランドだけを公式の並び順で。 */
    val visibleBrands: List<Brand> = emptyList(),
    val isLoading: Boolean = false,
    val isRefreshing: Boolean = false
) {
    val activeFilterCount: Int
        get() = (if (selectedBrandIds.isEmpty()) 0 else 1) +
            (if (selectedAttribute != null) 1 else 0) +
            (if (requireMyPick) 1 else 0) +
            (if (requireFavorite) 1 else 0) +
            (if (requireNote) 1 else 0)

    val filterBadgeCount: Int
        get() = activeFilterCount +
            (if (displayMode != IdolDisplayMode.IDOL_NAME) 1 else 0) +
            (if (sortOrder != IdolSortOrder.OFFICIAL) 1 else 0)
}

/**
 * 絞り込み + 並び替え + ブランド別グループ化を再計算した state を返す
 * (iOS `IdolListViewModel.rebuild` 相当)。
 *
 * 判定本体は imas-core の domain/idol_list_filtering.rs で、ここは射影 → FFI →
 * index 引き直しだけ。Composable 本体で算出すると再コンポーズのたびに全件射影が
 * 走るため、状態が変わった時だけここで計算して state に持たせる。
 */
private fun IdolListUiState.rebuilt(): IdolListUiState {
    val criteria = IdolListFilterCriteria(
        selectedBrandIds = selectedBrandIds.toList(),
        selectedAttribute = selectedAttribute,
        requireMyPick = requireMyPick,
        myPickIds = pickIds.toList(),
        requireFavorite = requireFavorite,
        favoriteIds = favoriteIds.toList(),
        requireNote = requireNote,
        noteIds = noteIds.toList(),
        searchText = searchText,
        // CV 名は現任の声優 (声優の履歴 idol_voice_actors からコアが選ぶ。iOS と同じ)。
        castNames = castNames
    )
    val sorted = sortIdols(filterIdols(idols, criteria), sortOrder, sortAscending)
    val filtered = sorted.idols
    // 公式順以外はブランドの区切りを外した通し並びにする
    // (身長順・年齢順はブランドを跨いで初めて意味を持つ指標のため)。
    val grouped = if (sortOrder.keepsBrandGrouping) filtered.groupBy { it.brandId } else emptyMap()
    return copy(
        filteredIdols = filtered,
        metricById = sorted.metricById,
        groupedByBrand = grouped,
        // grouped に載るのは必ず 1 件以上なので、キー有無で表示ブランドを判定できる。
        visibleBrands = brands.filter { grouped.containsKey(it.id) }
    )
}

/**
 * アイドル一覧の ViewModel。iOS `IdolListViewModel` + `IdolListView` の @AppStorage 相当。
 * 絞り込み・並べ替え・グルーピングは状態が変わるたびに [rebuilt] で算出して state に載せる
 * (Composable 側は結果を読むだけ。ViewModel が `_uiState.value` を直読みする導出関数を
 * 持つと Compose の依存追跡が壊れ空表示になるため、そういった関数は置かない)。
 */
class IdolListViewModel(app: Application) : AndroidViewModel(app) {

    private val repo = AppModule.from(app).idolRepository
    private val statsRepo = AppModule.from(app).statsRepository
    private val marksRepo = AppModule.from(app).userMarkRepository
    private val syncEngine = AppModule.from(app).syncEngine
    private val prefs = app.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    /**
     * 設定の「既定のブランド」を初期選択にする (iOS `IdolListView` の onAppear と同じ)。
     *
     * 保存先は設定画面の SharedPreferences (`imas_settings` / `default_brand_id`) なので、
     * この画面の prefs とは別ファイルから読む。空文字は「すべて」なので選択なしのまま。
     * 初期値としてしか使わない — 一度でも選び直したらそちらが正で、
     * 画面へ戻るたびに既定へ引き戻さない。
     */
    private val defaultBrandIds: Set<String> =
        app.getSharedPreferences(SETTINGS_PREFS_NAME, Context.MODE_PRIVATE)
            .getString(KEY_DEFAULT_BRAND, "")
            ?.takeIf { it.isNotEmpty() }
            ?.let { setOf(it) }
            ?: emptySet()

    private val _uiState = MutableStateFlow(
        IdolListUiState(
            isLoading = true,
            selectedBrandIds = defaultBrandIds,
            displayMode = if (prefs.getString(KEY_DISPLAY_MODE, null) == VALUE_CV) {
                IdolDisplayMode.CV_NAME
            } else {
                IdolDisplayMode.IDOL_NAME
            },
            showCV = prefs.getBoolean(KEY_SHOW_CV, false),
            listMode = if (prefs.getString(KEY_LIST_MODE, null) == VALUE_GRID) {
                IdolListMode.GRID
            } else {
                IdolListMode.LIST
            },
            sortOrder = runCatching {
                IdolSortOrder.valueOf(prefs.getString(KEY_SORT_ORDER, null) ?: IdolSortOrder.OFFICIAL.name)
            }.getOrDefault(IdolSortOrder.OFFICIAL),
            sortAscending = when (prefs.getInt(KEY_SORT_ASCENDING, 0)) {
                1 -> true
                2 -> false
                else -> null
            }
        )
    )
    val uiState: StateFlow<IdolListUiState> = _uiState.asStateFlow()

    init {
        load()
        refreshMarks()
    }

    private fun load() {
        viewModelScope.launch {
            val brands = statsRepo.fetchBrands()
            val idols = repo.fetchIdolsForList()
            val castNames = repo.fetchIdolCastNames()
            _uiState.value = _uiState.value.copy(
                brands = brands,
                idols = idols,
                castNames = castNames,
                isLoading = false
            ).rebuilt()
        }
    }

    fun refreshMarks() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                pickIds = marksRepo.pickedIdolIds(),
                favoriteIds = marksRepo.favoriteIdolIds(),
                noteIds = marksRepo.notedIdolIds()
            ).rebuilt()
        }
    }

    /** Pull-to-refresh: 増分同期してから再読込。 */
    fun refresh() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isRefreshing = true)
            runCatching { syncEngine.requestSync().await() }
            load()
            refreshMarks()
            _uiState.value = _uiState.value.copy(isRefreshing = false)
        }
    }

    // マーク切り替えは「担当のみ」「お気に入りのみ」絞り込み中の表示対象そのものを変えるので
    // 集合の更新と同時に再計算する。
    fun toggleMyPick(idolId: String) {
        viewModelScope.launch {
            // 知らせの操作名 (localWrite の action は String) はこの時点の言語で文字列にする
            val action = L10n.Idols.writeActionTogglePick.resolve(getApplication<Application>())
            val now = localWrite(action) { marksRepo.toggle(UserMark.IDOL, idolId, UserMark.PICK) }
                ?: return@launch
            val current = _uiState.value.pickIds.toMutableSet()
            if (now) current.add(idolId) else current.remove(idolId)
            _uiState.value = _uiState.value.copy(pickIds = current).rebuilt()
        }
    }

    // お気に入りのトグルは一覧の行から撤去済み (2026-09、iOS と同じ)。詳細画面の
    // トグルが別に持っているので、ここには残さない (使わない操作を残すと二重管理になる)。
    // favoriteIds 自体はグリッド表示・絞り込みが引き続き使うので消さない。

    fun setSearchText(text: String) {
        _uiState.value = _uiState.value.copy(searchText = text).rebuilt()
    }

    fun toggleBrandCollapse(brandId: String) {
        val current = _uiState.value.collapsedBrands.toMutableSet()
        if (!current.add(brandId)) current.remove(brandId)
        _uiState.value = _uiState.value.copy(collapsedBrands = current)
    }

    fun setListMode(mode: IdolListMode) {
        prefs.edit().putString(KEY_LIST_MODE, if (mode == IdolListMode.GRID) VALUE_GRID else VALUE_LIST).apply()
        _uiState.value = _uiState.value.copy(listMode = mode)
    }

    /** ツールバーの「フィルタを解除」相当: ブランド/属性/表示形式のみリセット (マイマークは維持)。 */
    fun clearQuickFilters() {
        prefs.edit().putString(KEY_DISPLAY_MODE, VALUE_IDOL).apply()
        _uiState.value = _uiState.value.copy(
            selectedBrandIds = emptySet(),
            selectedAttribute = null,
            displayMode = IdolDisplayMode.IDOL_NAME
        ).rebuilt()
    }

    /** フィルタシートの「適用」。 */
    fun applyFilterSheet(
        brandIds: Set<String>,
        attribute: String?,
        displayMode: IdolDisplayMode,
        showCV: Boolean,
        requireMyPick: Boolean,
        requireFavorite: Boolean,
        requireNote: Boolean,
        sortOrder: IdolSortOrder,
        sortAscending: Boolean?
    ) {
        prefs.edit()
            .putString(KEY_DISPLAY_MODE, if (displayMode == IdolDisplayMode.CV_NAME) VALUE_CV else VALUE_IDOL)
            .putBoolean(KEY_SHOW_CV, showCV)
            .putString(KEY_SORT_ORDER, sortOrder.name)
            .putInt(KEY_SORT_ASCENDING, if (sortAscending == null) 0 else if (sortAscending) 1 else 2)
            .apply()
        _uiState.value = _uiState.value.copy(
            selectedBrandIds = brandIds,
            selectedAttribute = attribute,
            displayMode = displayMode,
            showCV = showCV,
            requireMyPick = requireMyPick,
            requireFavorite = requireFavorite,
            requireNote = requireNote,
            sortOrder = sortOrder,
            sortAscending = sortAscending
        ).rebuilt()
    }

    companion object {
        private const val PREFS_NAME = "idol_list_prefs"

        /** 設定画面 (SettingsViewModel) が既定ブランドを書いている SharedPreferences。 */
        private const val SETTINGS_PREFS_NAME = "imas_settings"
        private const val KEY_DEFAULT_BRAND = "default_brand_id"
        private const val KEY_DISPLAY_MODE = "display_mode"
        private const val KEY_SHOW_CV = "show_cv"
        private const val KEY_LIST_MODE = "list_mode"
        private const val KEY_SORT_ORDER = "sort_order"
        private const val KEY_SORT_ASCENDING = "sort_ascending"
        private const val VALUE_CV = "cv"
        private const val VALUE_IDOL = "idol"
        private const val VALUE_GRID = "grid"
        private const val VALUE_LIST = "list"
    }
}
