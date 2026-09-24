package com.fugaif.imaslivedb.ui.tags

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.LocalFireDepartment
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.community.CommunityApi
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.data.model.Song
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.components.ImasArtwork
import com.fugaif.imaslivedb.ui.components.ImasAvatar
import com.fugaif.imaslivedb.ui.components.ImasEmptyState
import com.fugaif.imaslivedb.ui.components.ImasSectionHeader
import com.fugaif.imaslivedb.ui.components.ImasSegmented
import com.fugaif.imaslivedb.ui.theme.DS
import uniffi.imas_core.relativeTimes

private enum class ActivityTab(val label: DisplayText) {
    SONG(L10n.Tags.activityTabSongs), IDOL(L10n.Tags.activityTabIdols)
}

/** タグ付けの盛り上がり。「伸びてるタグ」「タグが急増中」「最近つけられたタグ」を
 * 曲/アイドルのドメインタブで横断表示する。iOS TagActivityView の移植。 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TagActivityScreen(
    onBack: () -> Unit,
    onSongTagClick: (String) -> Unit,
    onIdolTagClick: (String) -> Unit,
    onSongClick: (String) -> Unit,
    onIdolClick: (String) -> Unit,
    viewModel: TagActivityViewModel = viewModel()
) {
    val context = LocalContext.current
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    var tabIndex by rememberSaveable { mutableIntStateOf(0) }
    val tabs = remember { ActivityTab.entries }
    val selectedDomain = if (tabs[tabIndex] == ActivityTab.SONG) {
        CommunityApi.TagActivityDomain.SONG
    } else {
        CommunityApi.TagActivityDomain.IDOL
    }

    LaunchedEffect(Unit) { viewModel.load(context) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(L10n.Tags.activityTitle.resolve(), fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = L10n.Common.actionBack.resolve())
                    }
                }
            )
        }
    ) { padding ->
        Box(modifier = Modifier.fillMaxSize().padding(padding).background(DS.bg)) {
            val activity = uiState.activity
            when {
                uiState.isLoading && activity == null -> {
                    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        CircularProgressIndicator()
                    }
                }
                activity == null || (activity.trendingTags.isEmpty() && activity.risingEntities.isEmpty() && activity.recent.isEmpty()) -> {
                    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        ImasEmptyState(icon = Icons.Filled.LocalFireDepartment, title = L10n.Tags.activityEmptyTitle.resolve())
                    }
                }
                else -> {
                    val trends = activity.trendingTags.filter { it.domain == selectedDomain }
                    val rises = activity.risingEntities.filter { it.domain == selectedDomain }
                    val events = activity.recent.filter { it.domain == selectedDomain }
                    // 相対時刻の言い回しはコア。一覧ぶんを 1 回で引き、一覧が変わるまで使い回す。
                    val times = remember(events) { relativeTimes(events.map { it.createdAtMs }, System.currentTimeMillis()) }

                    LazyColumn(modifier = Modifier.fillMaxSize(), contentPadding = PaddingValues(bottom = 24.dp)) {
                        item {
                            ImasSegmented(
                                labels = tabs.map { it.label.resolve() },
                                selection = tabIndex,
                                onSelect = { tabIndex = it },
                                modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 10.dp)
                            )
                        }

                        if (trends.isEmpty() && rises.isEmpty() && events.isEmpty()) {
                            item {
                                ImasEmptyState(
                                    icon = Icons.Filled.LocalFireDepartment,
                                    title = L10n.Tags.activityEmptyTitle.resolve(),
                                    message = if (selectedDomain == CommunityApi.TagActivityDomain.SONG) {
                                        L10n.Tags.activityEmptyMessageSongs.resolve()
                                    } else {
                                        L10n.Tags.activityEmptyMessageIdols.resolve()
                                    }
                                )
                            }
                        } else {
                            if (trends.isNotEmpty()) {
                                item { ImasSectionHeader(title = L10n.Tags.activityTrendingHeader, tight = true) }
                                itemsIndexedWithDivider(trends) { idx, trend ->
                                    TrendRow(trend, rank = idx + 1) {
                                        if (selectedDomain == CommunityApi.TagActivityDomain.SONG) {
                                            onSongTagClick(trend.tagId)
                                        } else {
                                            onIdolTagClick(trend.tagId)
                                        }
                                    }
                                }
                            }
                            if (rises.isNotEmpty()) {
                                item { ImasSectionHeader(title = L10n.Tags.activityRisingHeader, tight = true) }
                                itemsIndexedWithDivider(rises) { _, rise ->
                                    RiseRow(
                                        rise = rise,
                                        song = uiState.songs[rise.entityId],
                                        idol = uiState.idols[rise.entityId],
                                        onClick = {
                                            if (rise.domain == CommunityApi.TagActivityDomain.SONG) onSongClick(rise.entityId)
                                            else onIdolClick(rise.entityId)
                                        }
                                    )
                                }
                            }
                            if (events.isNotEmpty()) {
                                item { ImasSectionHeader(title = L10n.Tags.activityRecentHeader, tight = true) }
                                itemsIndexedWithDivider(events) { index, event ->
                                    RecentRow(
                                        event = event,
                                        timeText = times.getOrElse(index) { "" },
                                        song = uiState.songs[event.entityId],
                                        idol = uiState.idols[event.entityId],
                                        onClick = {
                                            if (event.domain == CommunityApi.TagActivityDomain.SONG) onSongClick(event.entityId)
                                            else onIdolClick(event.entityId)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private fun <T> androidx.compose.foundation.lazy.LazyListScope.itemsIndexedWithDivider(
    list: List<T>,
    content: @Composable (Int, T) -> Unit
) {
    items(list.size) { idx ->
        content(idx, list[idx])
        if (idx < list.size - 1) {
            HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
        }
    }
}

@Composable
private fun TrendRow(trend: CommunityApi.TagActivityTrend, rank: Int, onClick: () -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        TagRankBadge(rank)
        TagColorDot(trend.tagColor, size = 10.dp)
        Text(
            trend.tagName,
            style = androidx.compose.material3.MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.SemiBold,
            color = DS.ink,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            modifier = Modifier.weight(1f)
        )
        Column(horizontalAlignment = Alignment.End) {
            Text(L10n.Tags.activityTrendingRecent(count = trend.recentCount).resolve(), style = androidx.compose.material3.MaterialTheme.typography.labelMedium, fontWeight = FontWeight.SemiBold, color = DS.ink)
            Text(L10n.Tags.activityTrendingTotal(count = trend.totalCount).resolve(), style = androidx.compose.material3.MaterialTheme.typography.labelSmall, color = DS.ink3)
        }
        Icon(Icons.Filled.ChevronRight, contentDescription = null, tint = DS.ink3, modifier = Modifier.height(16.dp))
    }
}

@Composable
private fun RiseRow(
    rise: CommunityApi.TagActivityRise,
    song: Song?,
    idol: Idol?,
    onClick: () -> Unit
) {
    val resolved = if (rise.domain == CommunityApi.TagActivityDomain.SONG) song != null else idol != null
    Row(
        modifier = Modifier.fillMaxWidth()
            .clickable(enabled = resolved, onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        EntityLead(domain = rise.domain, song = song, idol = idol)
        Column(modifier = Modifier.weight(1f)) {
            Text(
                entityName(rise.domain, song, idol).resolve(),
                style = androidx.compose.material3.MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.SemiBold,
                color = DS.ink,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
            Text(
                L10n.Tags.activityRisingTag(name = rise.tagName).resolve(),
                style = androidx.compose.material3.MaterialTheme.typography.labelMedium,
                color = DS.ink2,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        }
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(3.dp)) {
            Icon(Icons.Filled.ArrowUpward, contentDescription = null, tint = DS.favorite, modifier = Modifier.height(14.dp))
            Text(L10n.Tags.activityRisingCount(count = rise.recentCount).resolve(), style = androidx.compose.material3.MaterialTheme.typography.labelMedium, fontWeight = FontWeight.Bold, color = DS.favorite)
        }
        Icon(Icons.Filled.ChevronRight, contentDescription = null, tint = DS.ink3, modifier = Modifier.height(16.dp))
    }
}

@Composable
private fun RecentRow(
    event: CommunityApi.TagActivityEvent,
    timeText: String,
    song: Song?,
    idol: Idol?,
    onClick: () -> Unit
) {
    val resolved = if (event.domain == CommunityApi.TagActivityDomain.SONG) song != null else idol != null
    Row(
        modifier = Modifier.fillMaxWidth()
            .clickable(enabled = resolved, onClick = onClick)
            .padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        EntityLead(domain = event.domain, song = song, idol = idol)
        Column(modifier = Modifier.weight(1f)) {
            Text(
                entityName(event.domain, song, idol).resolve(),
                style = androidx.compose.material3.MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.SemiBold,
                color = DS.ink,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
            Text(
                L10n.Tags.activityRecentTagged(name = event.tagName).resolve(),
                style = androidx.compose.material3.MaterialTheme.typography.labelMedium,
                color = DS.ink2,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        }
        Text(timeText, style = androidx.compose.material3.MaterialTheme.typography.labelSmall, color = DS.ink3)
    }
}

@Composable
private fun EntityLead(domain: CommunityApi.TagActivityDomain, song: Song?, idol: Idol?) {
    when (domain) {
        CommunityApi.TagActivityDomain.SONG ->
            ImasArtwork(title = song?.title ?: "?", size = 40.dp, imageUrl = song?.artworkUrl)
        CommunityApi.TagActivityDomain.IDOL ->
            ImasAvatar(label = idol?.shortName ?: "?", seed = idol?.color, brand = idol?.brandId, size = 40.dp)
    }
}

/** 曲名・アイドル名はデータ。手元の DB からまだ引けていない間だけ「読み込み中」の文言を出す。 */
private fun entityName(domain: CommunityApi.TagActivityDomain, song: Song?, idol: Idol?): DisplayText = when (domain) {
    CommunityApi.TagActivityDomain.SONG -> song?.title?.let { DisplayText.Verbatim(it) } ?: L10n.Tags.activityLoadingSong
    CommunityApi.TagActivityDomain.IDOL -> idol?.name?.let { DisplayText.Verbatim(it) } ?: L10n.Tags.activityLoadingIdol
}
