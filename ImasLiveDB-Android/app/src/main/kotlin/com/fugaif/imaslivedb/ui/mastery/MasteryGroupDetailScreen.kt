package com.fugaif.imaslivedb.ui.mastery

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.MoreHoriz
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fugaif.imaslivedb.data.model.Song
import com.fugaif.imaslivedb.ui.components.*
import com.fugaif.imaslivedb.ui.theme.*
import uniffi.imas_core.MasteryBulkScope
import uniffi.imas_core.MasteryGroup

/**
 * 群の中の曲一覧。**段階を変えるのはここ**。iOS `MasteryGroupDetailView` の移植。
 *
 * ⚠️ 曲一覧は [LazyColumn]。最大の群は 650 曲 (ユニット軸の「その他」) あり、
 * 非遅延だとジャケ写つきの行を全部一度に組んで開いた瞬間に固まる。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MasteryGroupDetailScreen(
    group: MasteryGroup,
    scale: MasteryScale,
    songs: List<Song>,
    levels: Map<String, UByte>,
    collectedIds: Set<String>,
    onBack: () -> Unit,
    onOpenSong: (String) -> Unit,
    onSetLevel: (String, UByte) -> Unit,
    onBulk: (MasteryBulkScope, UByte) -> Unit,
) {
    var levelFilter by remember { mutableStateOf<UByte?>(null) }
    var heardOnly by remember { mutableStateOf(false) }
    var showBulk by remember { mutableStateOf(false) }
    var editing by remember { mutableStateOf<Song?>(null) }

    val levelOf: (Song) -> UByte = { levels[it.id] ?: 0u }
    val shown = songs.filter { song ->
        when {
            heardOnly -> levelOf(song).toInt() == 0 && song.id in collectedIds
            levelFilter != null -> levelOf(song) == levelFilter
            else -> true
        }
    }
    val heardUnset = songs.count { levelOf(it).toInt() == 0 && it.id in collectedIds }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(group.label, fontWeight = FontWeight.Bold, maxLines = 1) },
                navigationIcon = {
                    IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, "戻る") }
                },
                actions = {
                    IconButton(onClick = { showBulk = true }) {
                        Icon(Icons.Filled.MoreHoriz, "まとめて変える")
                    }
                }
            )
        }
    ) { padding ->
        LazyColumn(Modifier.fillMaxSize().padding(padding)) {
            item {
                Column {
                    ImasSectionHeader("このグループの習熟度", tight = true)
                    Row(
                        Modifier.padding(horizontal = 16.dp).fillMaxWidth()
                            .clip(RoundedCornerShape(14.dp)).background(DS.surface).padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(16.dp),
                    ) {
                        MasteryRing(group.percent.toInt() / 100.0, Modifier.size(92.dp))
                        Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                            Row(verticalAlignment = Alignment.Bottom) {
                                Text("${group.levels.count { it.toInt() > 0 }}",
                                     fontSize = 30.sp, fontWeight = FontWeight.Bold, color = DS.ink)
                                Text(" / ${group.total}曲", fontSize = 15.sp, color = DS.ink2)
                            }
                            Text("段階を付けた曲", fontSize = 13.sp, color = DS.ink2)
                            Text("${scale.label(scale.steps)} ${group.doneCount} 曲",
                                 fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = DS.ink3)
                        }
                    }
                    Spacer(Modifier.height(12.dp))

                    Row(
                        Modifier.horizontalScroll(rememberScrollState()).padding(horizontal = 16.dp),
                        horizontalArrangement = Arrangement.spacedBy(8.dp),
                    ) {
                        if (heardUnset > 0) {
                            ImasFilterChip("聴いたのに未設定 $heardUnset", heardOnly, {
                                heardOnly = !heardOnly
                                if (heardOnly) levelFilter = null
                            }, icon = Icons.Filled.Check)
                        }
                        for (i in 0..scale.steps.toInt()) {
                            val level = i.toUByte()
                            val count = songs.count { levelOf(it) == level }
                            ImasFilterChip("${scale.shortLabel(level)} $count",
                                           levelFilter == level, {
                                levelFilter = if (levelFilter == level) null else level
                                if (levelFilter != null) heardOnly = false
                            })
                        }
                    }
                    Spacer(Modifier.height(12.dp))
                    ImasSectionHeader("収録曲",
                        count = if (levelFilter == null && !heardOnly) "${songs.size}曲"
                                else "${shown.size} / ${songs.size}曲",
                        tight = true)
                }
            }

            items(shown.size) { index ->
                val song = shown[index]
                SongMasteryRow(song, levelOf(song), scale, song.id in collectedIds,
                               onClick = { onOpenSong(song.id) },
                               onLongClick = { editing = song })
                if (index < shown.size - 1) {
                    HorizontalDivider(Modifier.padding(start = 70.dp), color = DS.sep)
                }
            }
            item { Spacer(Modifier.height(24.dp)) }
        }
    }

    editing?.let { song ->
        MasteryLevelPickerSheet(song.title, levelOf(song), scale,
                         onPick = { onSetLevel(song.id, it); editing = null },
                         onDismiss = { editing = null })
    }

    if (showBulk) {
        BulkSheet(group, scale, onPick = { scope, level -> onBulk(scope, level); showBulk = false },
                  onDismiss = { showBulk = false })
    }
}

/**
 * 曲 1 行。段階は**長押しでピッカー**。
 *
 * iOS は行を左スワイプして swipe actions を出すが、Android の一覧に同じ手つきは無い
 * (`SwipeToDismissBox` は消す操作の合図になる)。ここは長押しに置き換える。
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun SongMasteryRow(
    song: Song, level: UByte, scale: MasteryScale, collected: Boolean,
    onClick: () -> Unit, onLongClick: () -> Unit,
) {
    Row(
        Modifier.fillMaxWidth().background(DS.surface)
            .combinedClickable(onClick = onClick, onLongClick = onLongClick)
            .padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        ImasArtwork(title = song.title, brand = song.brandId, size = 36.dp, imageUrl = song.artworkUrl)
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(2.dp)) {
            Text(song.title, fontSize = 15.sp, color = DS.ink, maxLines = 1)
            val sub = song.unitName ?: song.singerLabel
            if (!sub.isNullOrEmpty()) Text(sub, fontSize = 12.sp, color = DS.ink2, maxLines = 1)
        }
        if (collected) {
            // 現地で聴いた曲。既存の一覧と同じ ✓ の意味で揃える。
            Icon(Icons.Filled.Check, "現地で聴いた", tint = DS.success, modifier = Modifier.size(14.dp))
        }
        MasteryChip(level, scale, showsUnset = true)
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MasteryLevelPickerSheet(title: String, current: UByte, scale: MasteryScale,
                            onPick: (UByte) -> Unit, onDismiss: () -> Unit) {
    ModalBottomSheet(onDismissRequest = onDismiss, containerColor = DS.bg) {
        Column(Modifier.padding(horizontal = 16.dp).padding(bottom = 24.dp)) {
            Text(title, fontSize = 17.sp, fontWeight = FontWeight.Bold, color = DS.ink, maxLines = 2)
            Spacer(Modifier.height(12.dp))
            for (i in 0..scale.steps.toInt()) {
                val level = i.toUByte()
                Row(
                    Modifier.fillMaxWidth().clickable { onPick(level) }.padding(vertical = 12.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    Box(Modifier.size(14.dp).clip(RoundedCornerShape(4.dp))
                            .background(MasteryPalette.fill(level, scale.steps)))
                    Text(scale.label(level), fontSize = 15.sp, color = DS.ink)
                    Spacer(Modifier.weight(1f))
                    if (level == current) Icon(Icons.Filled.Check, null, tint = DS.ink2)
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun BulkSheet(group: MasteryGroup, scale: MasteryScale,
                      onPick: (MasteryBulkScope, UByte) -> Unit, onDismiss: () -> Unit) {
    val unset = group.levels.count { it.toInt() == 0 }
    ModalBottomSheet(onDismissRequest = onDismiss, containerColor = DS.bg) {
        Column(Modifier.padding(horizontal = 16.dp).padding(bottom = 24.dp)) {
            if (unset > 0) {
                Text("未設定の $unset 曲だけ", fontSize = 12.sp, color = DS.ink2)
                Spacer(Modifier.height(6.dp))
                Row(Modifier.horizontalScroll(rememberScrollState()),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    for (i in 1..scale.steps.toInt()) {
                        ImasFilterChip(scale.label(i.toUByte()), false,
                            { onPick(MasteryBulkScope.UNSET_ONLY, i.toUByte()) })
                    }
                }
                Spacer(Modifier.height(16.dp))
            }
            Text("この ${group.total} 曲すべて", fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            Row(Modifier.horizontalScroll(rememberScrollState()),
                horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                for (i in 1..scale.steps.toInt()) {
                    ImasFilterChip(scale.label(i.toUByte()), false,
                        { onPick(MasteryBulkScope.ALL, i.toUByte()) })
                }
                ImasFilterChip("未設定に戻す", false, { onPick(MasteryBulkScope.ALL, 0u) })
            }
        }
    }
}

/** 行に出す現在の段階。未設定は既定では出さない (一覧が段階の色でうるさくならないように)。 */
@Composable
fun MasteryChip(level: UByte, scale: MasteryScale, showsUnset: Boolean = false) {
    if (level.toInt() == 0 && !showsUnset) return
    val bg = MasteryPalette.fill(level, scale.steps)
    Text(
        scale.shortLabel(level),
        fontSize = 10.sp, fontWeight = FontWeight.Bold,
        color = MasteryPalette.ink(level, scale.steps),
        modifier = Modifier.clip(RoundedCornerShape(6.dp)).background(bg)
            .padding(horizontal = 8.dp, vertical = 3.dp),
    )
}
