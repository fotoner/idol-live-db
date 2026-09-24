package com.fugaif.imaslivedb.ui.songs

import android.app.Application
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.model.Brand
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.data.model.SongCollectFilter
import com.fugaif.imaslivedb.data.model.SongMyMarkFilter
import com.fugaif.imaslivedb.data.model.SongSearchFilter
import com.fugaif.imaslivedb.data.model.SongSortOrder
import com.fugaif.imaslivedb.data.model.Vocab
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.components.ImasFilterChip
import com.fugaif.imaslivedb.ui.components.ImasSegmented
import com.fugaif.imaslivedb.ui.components.NameFilterField
import com.fugaif.imaslivedb.ui.theme.DS
import com.fugaif.imaslivedb.ui.theme.brandColor
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

/** 曲タイプの絞り込み。今までどおり先頭の 3 種 (ソロ / ユニット / 全体曲)。語はコアの vocabulary。 */
private val SONG_TYPES: List<Pair<String, String>>
    get() = Vocab.table.songTypes.take(3).map { it.value to it.shortLabel }

/** フィルタシートで開いている「ページ」。[FilterPickerPage] の push/pop 相当。 */
private enum class FilterPage { MAIN, IDOLS, SERIES, CD_SERIES, LIVE }

/** ピッカーの候補 (ブランド/アイドル/シリーズ/CDシリーズ/ライブ名) をまとめて読む。 */
data class SongFilterOptions(
    val brands: List<Brand> = emptyList(),
    val idols: List<Idol> = emptyList(),
    val cdSeries: List<String> = emptyList(),
    val seriesGroups: List<String> = emptyList(),
    val eventNames: List<String> = emptyList()
)

class SongFilterOptionsViewModel(app: Application) : AndroidViewModel(app) {
    private val _options = MutableStateFlow(SongFilterOptions())
    val options: StateFlow<SongFilterOptions> = _options.asStateFlow()

    init {
        val module = AppModule.from(app)
        viewModelScope.launch {
            _options.value = SongFilterOptions(
                brands = runCatching { module.statsRepository.fetchBrands() }.getOrDefault(emptyList()),
                idols = runCatching { module.idolRepository.fetchIdolsForList() }.getOrDefault(emptyList()),
                cdSeries = runCatching { module.songRepository.fetchCdSeriesList() }.getOrDefault(emptyList()),
                seriesGroups = runCatching { module.songRepository.fetchSeriesGroupList() }.getOrDefault(emptyList()),
                eventNames = runCatching { module.songRepository.fetchEventNames() }.getOrDefault(emptyList())
            )
        }
    }
}

/**
 * 曲一覧のフィルタシート (iOS `SongFilterView` の移植)。
 *
 * 編集中の値はすべてこのシートのローカル状態に持ち、「適用」でまとめて返す。
 * 触るたびに一覧を引き直さないのは、条件を 2〜3 個いじる間ずっと再取得が走るのを避けるため。
 */
@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
fun SongFilterSheet(
    currentFilter: SongSearchFilter,
    currentSortOrder: SongSortOrder,
    currentSortAscending: Boolean?,
    currentShowOtherBrand: Boolean,
    currentCollectFilter: SongCollectFilter,
    currentMyMarkFilter: SongMyMarkFilter,
    currentListMode: SongListMode,
    onDismiss: () -> Unit,
    onApply: (
        filter: SongSearchFilter,
        sortOrder: SongSortOrder,
        sortAscending: Boolean?,
        showOtherBrand: Boolean,
        collectFilter: SongCollectFilter,
        myMarkFilter: SongMyMarkFilter,
        listMode: SongListMode
    ) -> Unit,
    optionsViewModel: SongFilterOptionsViewModel = viewModel()
) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)
    val options by optionsViewModel.options.collectAsState()

    var page by remember { mutableStateOf(FilterPage.MAIN) }
    var listMode by remember { mutableStateOf(currentListMode) }
    var selectedSort by remember { mutableStateOf(currentSortOrder) }
    var sortAscending by remember { mutableStateOf(currentSortAscending) }
    var brandIds by remember { mutableStateOf(currentFilter.brandIds) }
    var idolIds by remember { mutableStateOf(currentFilter.idolIds.orEmpty().toSet()) }
    var songwriter by remember { mutableStateOf(currentFilter.songwriter.orEmpty()) }
    var seriesGroup by remember { mutableStateOf(currentFilter.seriesGroup) }
    var cdSeries by remember { mutableStateOf(currentFilter.cdSeries) }
    var liveName by remember { mutableStateOf(currentFilter.liveName) }
    var songType by remember { mutableStateOf(currentFilter.songType) }
    var includeRemixes by remember { mutableStateOf(currentFilter.includeRemixes) }
    var excludeLiveOnly by remember { mutableStateOf(currentFilter.excludeLiveOnly) }
    var kamisabiOnly by remember { mutableStateOf(currentFilter.kamisabiOnly) }
    var showOtherBrand by remember { mutableStateOf(currentShowOtherBrand) }
    var collectFilter by remember { mutableStateOf(currentCollectFilter) }
    var myMarkFilter by remember { mutableStateOf(currentMyMarkFilter) }

    val selectedIdolNames = remember(options.idols, idolIds) {
        options.idols.filter { idolIds.contains(it.id) }.map { it.name }
    }

    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState) {
        when (page) {
            FilterPage.IDOLS -> IdolMultiPickerPage(
                idols = options.idols,
                brands = options.brands,
                selected = idolIds,
                onBack = { page = FilterPage.MAIN },
                onToggle = { id -> idolIds = if (idolIds.contains(id)) idolIds - id else idolIds + id },
                onClear = { idolIds = emptySet() }
            )
            FilterPage.SERIES -> SingleValuePickerPage(
                title = L10n.Songs.filterSeriesHeader,
                items = options.seriesGroups,
                selected = seriesGroup,
                onBack = { page = FilterPage.MAIN },
                onSelect = { seriesGroup = it; page = FilterPage.MAIN }
            )
            FilterPage.CD_SERIES -> SingleValuePickerPage(
                title = L10n.Songs.filterCdSeriesHeader,
                items = options.cdSeries,
                selected = cdSeries,
                onBack = { page = FilterPage.MAIN },
                onSelect = { cdSeries = it; page = FilterPage.MAIN }
            )
            FilterPage.LIVE -> SingleValuePickerPage(
                title = L10n.Songs.filterLivePickerTitle,
                items = options.eventNames,
                selected = liveName,
                onBack = { page = FilterPage.MAIN },
                onSelect = { liveName = it; page = FilterPage.MAIN }
            )
            FilterPage.MAIN -> Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .verticalScroll(rememberScrollState())
                    .padding(bottom = 32.dp)
            ) {
                Text(
                    text = L10n.Songs.filterTitle.resolve(),
                    style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)
                )

                HorizontalDivider()

                // 表示形式
                SectionLabel(L10n.Songs.filterListModeHeader.resolve())
                ImasSegmented(
                    labels = listOf(
                        L10n.Songs.filterListModeSongs.resolve(),
                        L10n.Songs.filterListModeAlbums.resolve(),
                        L10n.Songs.filterListModeSeries.resolve()
                    ),
                    selection = SongListMode.entries.indexOf(listMode),
                    onSelect = { listMode = SongListMode.entries[it] },
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp)
                )

                // 楽曲表示にしか効かない条件は、表示形式がアルバム/シリーズのときは出さない
                // (集計カードには回収もマイマークも掛からないので、出すと効かない設定になる)。
                val songsMode = listMode == SongListMode.SONGS

                if (songsMode) {
                    Spacer(modifier = Modifier.height(8.dp))
                    HorizontalDivider()

                    // 現地回収
                    SectionLabel(L10n.Songs.filterCollectHeader.resolve())
                    ChipRow {
                        SongCollectFilter.entries.forEach { cf ->
                            ImasFilterChip(
                                label = cf.label.resolve(),
                                selected = collectFilter == cf,
                                onClick = { collectFilter = cf }
                            )
                        }
                    }

                    HorizontalDivider()

                    // マイマーク (AND 条件)
                    SectionLabel(L10n.Songs.filterMyMarkHeader.resolve())
                    SwitchRow(
                        title = L10n.Songs.filterMyMarkMyPick.resolve(),
                        subtitle = L10n.Songs.filterMyMarkMyPickCaption.resolve(),
                        checked = myMarkFilter.requireMyPick,
                        tint = DS.pick,
                        onCheckedChange = { myMarkFilter = myMarkFilter.copy(requireMyPick = it) }
                    )
                    SwitchRow(
                        title = L10n.Songs.filterMyMarkFavorite.resolve(),
                        checked = myMarkFilter.requireFavorite,
                        tint = DS.favorite,
                        onCheckedChange = { myMarkFilter = myMarkFilter.copy(requireFavorite = it) }
                    )
                    SwitchRow(
                        title = L10n.Songs.filterMyMarkNote.resolve(),
                        checked = myMarkFilter.requireNote,
                        tint = DS.warning,
                        onCheckedChange = { myMarkFilter = myMarkFilter.copy(requireNote = it) }
                    )
                    // 上の 3 つ全体にかかる注記。1 つのトグルの subtitle に置くと
                    // 「その項目だけが AND」と読めてしまう (iOS はセクションの footer)。
                    Text(
                        L10n.Songs.filterMyMarkFooter.resolve(),
                        fontSize = 11.sp,
                        color = DS.ink3,
                        modifier = Modifier.padding(horizontal = 20.dp, vertical = 4.dp)
                    )

                    HorizontalDivider()

                    // 並び順
                    SectionLabel(L10n.Songs.filterSortHeader.resolve())
                    ChipRow {
                        SongSortOrder.entries.forEach { order ->
                            ImasFilterChip(
                                label = order.label.resolve(),
                                selected = selectedSort == order,
                                onClick = {
                                    // 並び順を変えたら方向は新しい並び順の既定へ戻す
                                    // (「多い順」のまま五十音順に切り替わると ん から始まって驚く)。
                                    if (selectedSort != order) sortAscending = null
                                    selectedSort = order
                                }
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                    ChipRow {
                        ImasFilterChip(
                            label = L10n.Songs.sortDefault.resolve(),
                            selected = sortAscending == null,
                            onClick = { sortAscending = null }
                        )
                        ImasFilterChip(
                            label = L10n.Songs.sortAscending.resolve(),
                            selected = sortAscending == true,
                            onClick = { sortAscending = true }
                        )
                        ImasFilterChip(
                            label = L10n.Songs.sortDescending.resolve(),
                            selected = sortAscending == false,
                            onClick = { sortAscending = false }
                        )
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                }

                HorizontalDivider()

                // ブランド (複数選択 = OR)
                SectionLabel(L10n.Songs.filterBrandHeader.resolve())
                FlowRow(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    ImasFilterChip(label = L10n.Songs.filterAll.resolve(), selected = brandIds.isEmpty(), onClick = { brandIds = emptySet() })
                    options.brands.forEach { brand ->
                        ImasFilterChip(
                            label = brand.shortName,
                            selected = brandIds.contains(brand.id),
                            tintColor = brandColor(brand.id),
                            onClick = {
                                brandIds =
                                    if (brandIds.contains(brand.id)) brandIds - brand.id else brandIds + brand.id
                            }
                        )
                    }
                }
                Spacer(modifier = Modifier.height(8.dp))

                if (songsMode) {
                    HorizontalDivider()

                    SwitchRow(
                        title = L10n.Songs.filterLiveOnlyTitle.resolve(),
                        subtitle = L10n.Songs.filterLiveOnlyCaption.resolve(),
                        checked = excludeLiveOnly,
                        onCheckedChange = { excludeLiveOnly = it }
                    )
                    SwitchRow(
                        title = L10n.Songs.filterOtherBrandTitle.resolve(),
                        subtitle = L10n.Songs.filterOtherBrandCaption.resolve(),
                        checked = showOtherBrand,
                        onCheckedChange = { showOtherBrand = it }
                    )
                    SwitchRow(
                        title = L10n.Songs.filterRemixTitle.resolve(),
                        subtitle = L10n.Songs.filterRemixCaption.resolve(),
                        checked = includeRemixes,
                        onCheckedChange = { includeRemixes = it }
                    )
                    SwitchRow(
                        title = L10n.Songs.filterKamisabiToggleAndroid.resolve(),
                        subtitle = L10n.Songs.filterKamisabiCaptionAndroid.resolve(),
                        checked = kamisabiOnly,
                        onCheckedChange = { kamisabiOnly = it }
                    )

                    HorizontalDivider()

                    // 曲タイプ
                    SectionLabel(L10n.Songs.filterSongTypeHeader.resolve())
                    ChipRow {
                        ImasFilterChip(label = L10n.Songs.filterAll.resolve(), selected = songType == null, onClick = { songType = null })
                        SONG_TYPES.forEach { (value, label) ->
                            ImasFilterChip(
                                label = label,
                                selected = songType == value,
                                onClick = { songType = if (songType == value) null else value }
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(8.dp))

                    HorizontalDivider()

                    // アイドル (複数選択)
                    PickerRow(
                        label = L10n.Songs.filterIdolHeader.resolve(),
                        value = if (selectedIdolNames.isEmpty()) {
                            null
                        } else {
                            // 全員ぶん並べると行が伸びるので、3 人までは名前・それ以上は人数。
                            if (selectedIdolNames.size <= 3) {
                                selectedIdolNames.joinToString("・")
                            } else {
                                L10n.Songs.filterIdolSummaryMore(
                                    names = selectedIdolNames.take(2).joinToString("・"),
                                    count = selectedIdolNames.size - 2
                                ).resolve()
                            }
                        },
                        onClick = { page = FilterPage.IDOLS }
                    )

                    // 作詞 / 作曲 / 編曲
                    SectionLabel(L10n.Songs.filterCreatorHeader.resolve())
                    NameFilterField(
                        prompt = L10n.Songs.filterCreatorPlaceholder.resolve(),
                        value = songwriter,
                        onValueChange = { songwriter = it }
                    )

                    HorizontalDivider()

                    PickerRow(label = L10n.Songs.filterSeriesHeader.resolve(), value = seriesGroup, onClick = { page = FilterPage.SERIES })
                    PickerRow(label = L10n.Songs.filterCdSeriesHeader.resolve(), value = cdSeries, onClick = { page = FilterPage.CD_SERIES })
                    PickerRow(label = L10n.Songs.filterLiveHeader.resolve(), value = liveName, onClick = { page = FilterPage.LIVE })
                }

                HorizontalDivider()

                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    TextButton(
                        onClick = {
                            listMode = SongListMode.SONGS
                            selectedSort = SONG_LIST_DEFAULT_SORT
                            sortAscending = null
                            brandIds = emptySet()
                            idolIds = emptySet()
                            songwriter = ""
                            seriesGroup = null
                            cdSeries = null
                            liveName = null
                            songType = null
                            includeRemixes = false
                            excludeLiveOnly = true
                            kamisabiOnly = false
                            showOtherBrand = false
                            collectFilter = SongCollectFilter.ALL
                            myMarkFilter = SongMyMarkFilter()
                        },
                        modifier = Modifier.weight(1f)
                    ) {
                        Text(L10n.Songs.filterResetAndroid.resolve())
                    }
                    Button(
                        onClick = {
                            onApply(
                                currentFilter.copy(
                                    brandIds = brandIds,
                                    idolIds = idolIds.takeIf { it.isNotEmpty() }?.toList(),
                                    songwriter = songwriter.ifBlank { null },
                                    seriesGroup = seriesGroup,
                                    cdSeries = cdSeries,
                                    liveName = liveName,
                                    songType = songType,
                                    includeRemixes = includeRemixes,
                                    excludeLiveOnly = excludeLiveOnly,
                                    kamisabiOnly = kamisabiOnly
                                ),
                                selectedSort,
                                sortAscending,
                                showOtherBrand,
                                collectFilter,
                                myMarkFilter,
                                listMode
                            )
                        },
                        modifier = Modifier.weight(1f)
                    ) {
                        Text(L10n.Songs.filterApply.resolve())
                    }
                }
            }
        }
    }
}

@Composable
private fun SectionLabel(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.labelLarge,
        color = DS.ink2,
        modifier = Modifier.padding(horizontal = 16.dp, vertical = 10.dp)
    )
}

/**
 * チップ置き場。セクションごとに同じ余白で並べる。
 * 並び順のように 5 個並ぶ列があるので、はみ出したら折り返す (横スクロールにすると
 * 端のチップが隠れて「並び順が 3 つしかない」ように見える)。
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun ChipRow(content: @Composable () -> Unit) {
    FlowRow(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        content()
    }
}

/** 選択ページへ降りる行。選択中はその値を、未選択なら「選択なし」を出す。 */
@Composable
private fun PickerRow(label: String, value: String?, onClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(text = label, style = MaterialTheme.typography.bodyMedium, color = DS.ink)
        Spacer(modifier = Modifier.weight(1f))
        Text(
            text = value ?: L10n.Songs.filterNone.resolve(),
            style = MaterialTheme.typography.bodyMedium,
            color = if (value == null) DS.ink3 else DS.ink2,
            maxLines = 1
        )
        Icon(Icons.Filled.ChevronRight, contentDescription = null, tint = DS.ink3)
    }
    HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
}

@Composable
private fun SwitchRow(
    title: String,
    subtitle: String? = null,
    checked: Boolean,
    tint: Color? = null,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(text = title, style = MaterialTheme.typography.bodyMedium)
            if (subtitle != null) {
                Text(text = subtitle, style = MaterialTheme.typography.bodySmall, color = DS.ink2)
            }
        }
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange,
            colors = if (tint != null) {
                SwitchDefaults.colors(checkedTrackColor = tint, checkedThumbColor = DS.surface)
            } else {
                SwitchDefaults.colors()
            }
        )
    }
}

private val SongSortOrder.label: DisplayText
    get() = when (this) {
        SongSortOrder.TITLE_KANA -> L10n.Songs.sortTitleKana
        SongSortOrder.RELEASE_DATE -> L10n.Songs.sortReleaseDate
        SongSortOrder.PERFORMANCE_COUNT -> L10n.Songs.sortPerformanceCount
        SongSortOrder.COLLECTED_COUNT -> L10n.Songs.sortCollectedCount
        SongSortOrder.COLLECTED_RATE -> L10n.Songs.sortCollectedRate
    }

private val SongCollectFilter.label: DisplayText
    get() = when (this) {
        SongCollectFilter.ALL -> L10n.Songs.filterCollectAll
        SongCollectFilter.COLLECTED -> L10n.Songs.filterCollectCollected
        SongCollectFilter.UNCOLLECTED -> L10n.Songs.filterCollectUncollected
    }
