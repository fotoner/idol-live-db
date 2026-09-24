package com.fugaif.imaslivedb.ui.mastery

import androidx.compose.foundation.background
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.clickable
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.i18n.DisplayLocale
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.components.*
import com.fugaif.imaslivedb.ui.theme.*
import uniffi.imas_core.MasteryAxis
import uniffi.imas_core.MasteryBulkScope
import uniffi.imas_core.MasteryGroup
import uniffi.imas_core.MasteryGroupSort
import uniffi.imas_core.MasteryProgressFilter
import java.text.NumberFormat

/** 群の分け方のセグメント ([AXES] と同じ並び)。文言は画面で resolve() する。 */
private val AXIS_LABELS = listOf(L10n.Mastery.listAxisSeries, L10n.Mastery.listAxisUnit, L10n.Mastery.listAxisYear)
/** 名前の絞り込み欄のプレースホルダ ([AXES] と同じ並び)。 */
private val NAME_FILTER_PROMPTS =
    listOf(L10n.Mastery.listNameFilterSeries, L10n.Mastery.listNameFilterUnit, L10n.Mastery.listNameFilterYear)
private val AXES = listOf(MasteryAxis.SERIES, MasteryAxis.UNIT, MasteryAxis.YEAR)

fun progressLabel(v: MasteryProgressFilter): DisplayText = when (v) {
    MasteryProgressFilter.ALL -> L10n.Mastery.filterProgressAll
    MasteryProgressFilter.HEARD_BUT_UNSET -> L10n.Mastery.filterProgressHeardButUnset
    MasteryProgressFilter.HAS_UNSET -> L10n.Mastery.filterProgressHasUnset
    MasteryProgressFilter.UNTOUCHED -> L10n.Mastery.filterProgressUntouched
    MasteryProgressFilter.COMPLETE -> L10n.Mastery.filterProgressComplete
}

fun sortLabel(v: MasteryGroupSort): DisplayText = when (v) {
    MasteryGroupSort.SONG_COUNT -> L10n.Mastery.filterSortSongCount
    MasteryGroupSort.PROGRESS_ASC -> L10n.Mastery.filterSortProgressAsc
    MasteryGroupSort.PROGRESS_DESC -> L10n.Mastery.filterSortProgressDesc
    MasteryGroupSort.NAME -> L10n.Mastery.filterSortName
}

/**
 * 習熟度ダッシュボード。iOS `MasteryView` の移植。
 *
 * 体裁は回収ダッシュボード (`StatsScreen`) に倣う — 同じ「全体の進捗 + 群別の進捗 +
 * 対象の一覧」の形なので、そこだけ別の組み方にすると進捗の見せ方が 2 通りになる。
 *
 * ⚠️ 群の一覧は **[LazyColumn]**。ユニット軸は 1,000 群を超えるので、
 * 非遅延の Column に積むと開いた瞬間に固まる。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MasteryScreen(
    onOpenSong: (String) -> Unit,
    viewModel: MasteryViewModel = viewModel(),
) {
    val state by viewModel.uiState.collectAsState()
    val detail by viewModel.detail.collectAsState()
    var showFilter by remember { mutableStateOf(false) }
    // 長押しされた群 (null = シートを出さない)。まだ付けていない曲だけをまとめて付ける。
    var bulkTarget by remember { mutableStateOf<MasteryGroup?>(null) }

    // 群の詳細はナビを増やさず画面内で差し替える (StatsScreen と同じ流儀)。
    detail?.let { d ->
        MasteryGroupDetailScreen(
            group = d.group, scale = state.scale, songs = d.songs,
            collectedIds = d.collectedIds,
            onBack = viewModel::closeGroup,
            onOpenSong = onOpenSong,
            onSetLevel = viewModel::setMastery,
            onBulk = { scope, level -> viewModel.applyBulk(d.group, scope, level) },
        )
        return
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(L10n.Mastery.listTitle.resolve(), fontWeight = FontWeight.Bold) },
                actions = {
                    IconButton(onClick = { showFilter = true }) {
                        Icon(Icons.Filled.FilterList, L10n.Mastery.listFilterA11y.resolve(),
                             tint = if (state.isFilterActive) DS.ink else DS.ink2)
                    }
                }
            )
        }
    ) { padding ->
        if (state.isLoading) {
            Box(Modifier.fillMaxSize().padding(padding), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        } else {
            LazyColumn(Modifier.fillMaxSize().padding(padding)) {
                item { SummarySection(state) }
                item { GroupHeader(state, viewModel) }
                itemsIndexed(state.groups) { index, group ->
                    // 右スワイプでも長押しでも同じ一括更新を出す。
                    // iOS は右スワイプに段ごとのボタンが並ぶが、Compose のスワイプは
                    // 向きしか区別できないので、段を選ぶのはシートに任せる。
                    MasterySwipeRow(
                        onStart = { bulkTarget = group },
                        startLabel = L10n.Mastery.listGroupBulkSwipe.resolve(),
                        startColor = DS.fill,
                    ) {
                        GroupRow(group, state,
                                 onClick = { viewModel.openGroup(group) },
                                 onLongClick = { bulkTarget = group })
                    }
                    if (index < state.groups.size - 1) {
                        HorizontalDivider(Modifier.padding(start = 16.dp), color = DS.sep)
                    }
                }
                if (state.groups.isEmpty()) {
                    item {
                        ImasEmptyState(Icons.Filled.FilterList, L10n.Mastery.listEmptyTitle.resolve(),
                                       L10n.Mastery.listEmptyMessage.resolve())
                    }
                }
                item { Spacer(Modifier.height(24.dp)) }
            }
        }
    }

    bulkTarget?.let { group ->
        UnsetBulkSheet(group, state.scale,
                       onPick = { level ->
                           viewModel.applyBulk(group, MasteryBulkScope.UNSET_ONLY, level)
                           bulkTarget = null
                       },
                       onDismiss = { bulkTarget = null })
    }

    if (showFilter) {
        MasteryFilterSheet(state, viewModel) { showFilter = false }
    }
}

/**
 * 群の長押しで出す一括更新。**未設定の曲だけ**を対象にする。
 *
 * 既に付いている記録に触らない操作だけを置いているので、誤って押しても失うものがない。
 * 段を塗り替える/未設定に戻すのは、直前の 1 回を戻せる群の詳細に残す。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun UnsetBulkSheet(group: MasteryGroup, scale: MasteryScale,
                           onPick: (UByte) -> Unit, onDismiss: () -> Unit) {
    val unset = group.levels.count { it.toInt() == 0 }
    ModalBottomSheet(onDismissRequest = onDismiss, containerColor = DS.bg) {
        Column(Modifier.padding(horizontal = 16.dp).padding(bottom = 24.dp)) {
            Text(group.label, fontSize = 17.sp, fontWeight = FontWeight.Bold, color = DS.ink, maxLines = 2)
            Spacer(Modifier.height(12.dp))
            if (unset == 0) {
                Text(L10n.Mastery.bulkAllSet.resolve(), fontSize = 13.sp, color = DS.ink2)
            } else {
                Text(L10n.Mastery.bulkUnsetOnly(count = unset).resolve(), fontSize = 12.sp, color = DS.ink2)
                Spacer(Modifier.height(6.dp))
                for (i in scale.steps.toInt() downTo 1) {
                    val level = i.toUByte()
                    Row(
                        Modifier.fillMaxWidth().clickable { onPick(level) }.padding(vertical = 12.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(12.dp),
                    ) {
                        Box(Modifier.size(14.dp).clip(RoundedCornerShape(4.dp))
                                .background(MasteryPalette.fill(level, scale.steps)))
                        Text(scale.label(level), fontSize = 15.sp, color = DS.ink)
                    }
                }
            }
        }
    }
}

@Composable
private fun SummarySection(state: MasteryUiState) {
    val s = state.summary
    Column {
        ImasSectionHeader(L10n.Mastery.listSummaryHeader, tight = true)
        Row(
            Modifier.padding(horizontal = 16.dp).fillMaxWidth()
                .clip(RoundedCornerShape(14.dp)).background(DS.surface).padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            MasteryRing(s.percent.toInt() / 100.0, Modifier.size(92.dp))
            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                Row(verticalAlignment = Alignment.Bottom) {
                    Text(groupedCount(s.setCount), fontSize = 30.sp, fontWeight = FontWeight.Bold, color = DS.ink)
                    // 先頭の空白は大きな数字との間隔 (文言の外に置く)
                    Text(" " + L10n.Mastery.summaryTotalSongs(count = s.total.toInt()).resolve(),
                         fontSize = 15.sp, color = DS.ink2)
                }
                Text(L10n.Mastery.summarySetSongs.resolve(), fontSize = 13.sp, color = DS.ink2)
                Text(L10n.Mastery.summaryDoneSongs(level = state.scale.label(state.scale.steps),
                                                   count = s.doneCount.toInt()).resolve(),
                     fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = DS.ink3)
            }
        }
        Spacer(Modifier.height(12.dp))
        ImasListContainer {
            Column(Modifier.padding(horizontal = 16.dp).fillMaxWidth()
                       .clip(RoundedCornerShape(14.dp)).background(DS.surface)) {
                for (level in state.scale.steps.toInt() downTo 1) {
                    val c = state.stageCounts.getOrElse(level - 1) { 0 }
                    ImasStatBar(state.scale.label(level.toUByte()), "$c",
                                c * 100.0 / maxOf(state.scopedCount, 1))
                }
            }
        }
        Spacer(Modifier.height(20.dp))
    }
}

@Composable
private fun GroupHeader(state: MasteryUiState, vm: MasteryViewModel) {
    Column {
        ImasSectionHeader(L10n.Mastery.listGroupsHeader, count = L10n.Mastery.listGroupsCount(count = state.groups.size),
                          tight = true)

        // ブランドは**常に見える位置**に置く。この一覧はブランドで絞らないと
        // 群が数百件並んで用を成さないので、シートの中に畳んではいけない。
        Row(
            Modifier.horizontalScroll(rememberScrollState()).padding(horizontal = 16.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            ImasFilterChip(L10n.Mastery.listBrandAll.resolve(), state.brandIds.isEmpty(), { vm.clearBrands() })
            state.brands.forEach { b ->
                ImasFilterChip(b.shortName, state.brandIds.contains(b.id),
                               { vm.toggleBrand(b.id) }, brand = b.id)
            }
        }
        Spacer(Modifier.height(8.dp))

        ImasSegmented(AXIS_LABELS.map { it.resolve() }, AXES.indexOf(state.axis), { vm.setAxis(AXES[it]) },
                      Modifier.padding(horizontal = 16.dp))
        Spacer(Modifier.height(8.dp))

        NameFilterField(NAME_FILTER_PROMPTS[AXES.indexOf(state.axis)].resolve(),
                        state.nameFilter, vm::setNameFilter,
                        Modifier.padding(horizontal = 16.dp))
        Spacer(Modifier.height(8.dp))
    }
}

/**
 * 群 1 行。タップで中の曲一覧へ、**長押しでまだ付けていない曲だけをまとめて**付けられる。
 *
 * 「このシリーズは一通り聞いた」を一覧から 2 手で終わらせるための口。
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun GroupRow(g: MasteryGroup, state: MasteryUiState,
                     onClick: () -> Unit, onLongClick: () -> Unit) {
    Row(
        Modifier.fillMaxWidth().background(DS.surface)
            .combinedClickable(onClick = onClick, onLongClick = onLongClick)
            .padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        ImasLeadBar(height = 36.dp)
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
            Text(g.label, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink, maxLines = 2)
            Text(subtitle(g, state), fontSize = 12.sp, color = DS.ink2, maxLines = 1)
        }
        ImasMetricBadge("${g.percent}", "%", emphasized = g.percent > 0u)
    }
}

@Composable
private fun subtitle(g: MasteryGroup, state: MasteryUiState): String {
    val parts = mutableListOf<String>()
    if (g.discCount > 1u) parts += L10n.Mastery.listGroupDiscs(count = g.discCount.toInt()).resolve()
    parts += L10n.Mastery.listGroupSongs(count = g.total.toInt()).resolve()
    val unset = g.levels.count { it.toInt() == 0 }
    if (unset > 0) parts += L10n.Mastery.listGroupUnset(songs = unset).resolve()
    // 「聴いたのにまだ未設定」は覚える優先度が高いので、そこだけ名指しで出す。
    if (g.heardButUnsetCount > 0u) {
        parts += L10n.Mastery.listGroupHeardButUnset(songs = g.heardButUnsetCount.toInt()).resolve()
    } else if (g.collectedCount > 0u) {
        parts += L10n.Mastery.listGroupHeard(songs = g.collectedCount.toInt()).resolve()
    }
    if (g.doneCount > 0u) parts += "${state.scale.label(state.scale.steps)} ${g.doneCount}"
    return parts.joinToString(L10n.Mastery.listGroupSeparator.resolve())
}

/**
 * 進み具合の大きな数字 (段階を付けた曲数)。隣の「/ N曲」(count 引数なので 1,234 のように
 * 桁区切りが付く) と書式を揃える (iOS の Text("\(n)") も桁区切りが付く)。群の詳細画面でも使う。
 */
@Composable
internal fun groupedCount(value: UInt): String =
    NumberFormat.getIntegerInstance(DisplayLocale.of(LocalContext.current).formattingLocale)
        .format(value.toLong())

/** 全体の進み具合のリング。回収率の CollectionRing と同じ寸法・描き方。 */
@Composable
fun MasteryRing(fraction: Double, modifier: Modifier = Modifier) {
    val t = ImasTheme.derive(null, null, dark = true)
    val clamped = fraction.coerceIn(0.0, 1.0)
    Box(modifier, contentAlignment = Alignment.Center) {
        CircularProgressIndicator(
            progress = { 1f }, modifier = Modifier.fillMaxSize(),
            color = DS.fill, strokeWidth = 10.dp, trackColor = Color.Transparent,
        )
        CircularProgressIndicator(
            progress = { clamped.toFloat() }, modifier = Modifier.fillMaxSize(),
            color = t.accent, strokeWidth = 10.dp, trackColor = Color.Transparent,
        )
        Text("${(clamped * 100).toInt()}%", fontSize = 18.sp,
             fontWeight = FontWeight.Bold, color = DS.ink)
    }
}

/** 名前絞り込み (iOS NameFilterField の移植)。虫眼鏡ではなくフィルタのアイコン。 */
@Composable
fun NameFilterField(prompt: String, text: String, onChange: (String) -> Unit, modifier: Modifier = Modifier) {
    Row(
        modifier.fillMaxWidth().clip(RoundedCornerShape(50)).background(DS.fill)
            .padding(horizontal = 14.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Icon(Icons.Filled.FilterList, null, tint = DS.ink3, modifier = Modifier.size(16.dp))
        Box(Modifier.weight(1f)) {
            if (text.isEmpty()) Text(prompt, fontSize = 15.sp, color = DS.ink3)
            BasicTextField(
                value = text, onValueChange = onChange, singleLine = true,
                textStyle = TextStyle(fontSize = 15.sp, color = DS.ink),
                cursorBrush = SolidColor(DS.ink),
                modifier = Modifier.fillMaxWidth(),
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun MasteryFilterSheet(state: MasteryUiState, vm: MasteryViewModel, onDismiss: () -> Unit) {
    ModalBottomSheet(onDismissRequest = onDismiss, containerColor = DS.bg) {
        Column(Modifier.padding(horizontal = 16.dp).padding(bottom = 24.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(L10n.Mastery.filterTitle.resolve(), fontSize = 17.sp, fontWeight = FontWeight.Bold, color = DS.ink)
                Spacer(Modifier.weight(1f))
                TextButton(onClick = { vm.resetFilters() }, enabled = state.isFilterActive) {
                    Text(L10n.Mastery.filterActionReset.resolve())
                }
            }
            Spacer(Modifier.height(12.dp))

            Text(L10n.Mastery.filterSectionProgress.resolve(), fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            Row(Modifier.horizontalScroll(rememberScrollState()),
                horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                listOf(MasteryProgressFilter.ALL, MasteryProgressFilter.HEARD_BUT_UNSET,
                       MasteryProgressFilter.HAS_UNSET, MasteryProgressFilter.UNTOUCHED,
                       MasteryProgressFilter.COMPLETE).forEach { v ->
                    ImasFilterChip(progressLabel(v).resolve(), state.progress == v, { vm.setProgress(v) })
                }
            }
            Spacer(Modifier.height(16.dp))

            Text(L10n.Mastery.filterSectionSort.resolve(), fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            Row(Modifier.horizontalScroll(rememberScrollState()),
                horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                listOf(MasteryGroupSort.SONG_COUNT, MasteryGroupSort.PROGRESS_ASC,
                       MasteryGroupSort.PROGRESS_DESC, MasteryGroupSort.NAME).forEach { v ->
                    ImasFilterChip(sortLabel(v).resolve(), state.sort == v, { vm.setSort(v) })
                }
            }
        }
    }
}
