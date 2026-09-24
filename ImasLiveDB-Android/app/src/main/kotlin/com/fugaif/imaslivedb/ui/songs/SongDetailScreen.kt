package com.fugaif.imaslivedb.ui.songs

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material.icons.filled.OndemandVideo
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Stop
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.lifecycle.viewmodel.compose.viewModel
import coil3.compose.SubcomposeAsyncImage
import com.fugaif.imaslivedb.data.auth.AuthState
import com.fugaif.imaslivedb.data.auth.shouldPromptLogin
import com.fugaif.imaslivedb.data.auth.showEditAffordance
import com.fugaif.imaslivedb.data.auth.startCommunityEdit
import com.fugaif.imaslivedb.data.model.CoOccurringSong
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.data.model.PerformanceHistoryRow
import com.fugaif.imaslivedb.data.model.Song
import com.fugaif.imaslivedb.data.model.SongVideo
import com.fugaif.imaslivedb.data.model.SongPerformanceEvidence
import com.fugaif.imaslivedb.data.model.SongSingerTally
import com.fugaif.imaslivedb.data.model.Vocab
import com.fugaif.imaslivedb.player.AudioPreviewManager
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.coreText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.components.ArtworkImage
import com.fugaif.imaslivedb.ui.components.CommunityLoginPromptDialog
import com.fugaif.imaslivedb.ui.edit.RecordHistorySheet
import com.fugaif.imaslivedb.ui.edit.SongEditScreen
import com.fugaif.imaslivedb.ui.edit.VideoEditSheet
import com.fugaif.imaslivedb.ui.components.ImasArtwork
import com.fugaif.imaslivedb.ui.components.ImasAvatar
import com.fugaif.imaslivedb.ui.components.ImasEmptyState
import com.fugaif.imaslivedb.ui.components.IdolGridSection
import com.fugaif.imaslivedb.ui.components.ImasLabeledRow
import com.fugaif.imaslivedb.ui.components.ImasLeadBar
import com.fugaif.imaslivedb.ui.components.ImasSectionHeader
import com.fugaif.imaslivedb.ui.components.ImasSegmented
import com.fugaif.imaslivedb.ui.components.ImasStatTile
import com.fugaif.imaslivedb.ui.tags.SongTagPickerSheet
import com.fugaif.imaslivedb.ui.tags.TagDetailScreen
import com.fugaif.imaslivedb.ui.theme.AppPreferences
import com.fugaif.imaslivedb.ui.theme.DS
import com.fugaif.imaslivedb.ui.theme.ImasTheme
import com.fugaif.imaslivedb.ui.theme.hexToColor
import com.fugaif.imaslivedb.ui.filtered.SongFilterKind
import uniffi.imas_core.youtubeVideoRefs
import uniffi.imas_core.kamisabiCardLabel
import uniffi.imas_core.kamisabiCompletionLabel
import uniffi.imas_core.shortYearMonth
import uniffi.imas_core.splitCreditNames

/**
 * 楽曲詳細。iOS の SongSheetContent (大ジャケ hero + ImasSegmented 3 タブ
 * [情報・歌唱/披露履歴/コミュニティ]) の構成を 1:1 で写す。
 *
 * 関連楽曲/似ているタグ楽曲のタップ、タグタップでのタグ詳細表示は、
 * AppNavigation.kt の NavHost を経由せず画面内のローカル状態で完結させている
 * (このスクリーンの担当範囲外であるナビゲーション配線ファイルを変更しないため)。
 * そのため戻るボタンは常に呼び出し元 (曲一覧等) に戻り、iOS のような
 * 「開いた曲ごとの push 履歴」の再現はしていない。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SongDetailScreen(
    songId: String,
    onBack: () -> Unit,
    onUnitClick: (String) -> Unit,
    onIdolClick: (String) -> Unit,
    onShowClick: (String) -> Unit,
    onPollClick: (String) -> Unit = {},
    /**
     * 楽曲情報の行から「同じ条件の楽曲一覧」へ (kind, value は
     * [com.fugaif.imaslivedb.ui.filtered.SongFilterKind] の定義に従う)。
     */
    onFilteredSongsClick: (String, String) -> Unit = { _, _ -> },
    viewModel: SongDetailViewModel = viewModel(key = songId)
) {
    val context = LocalContext.current
    val uiState by viewModel.uiState.collectAsState()
    var showTagPicker by rememberSaveable { mutableStateOf(false) }
    var showPenlightSheet by rememberSaveable { mutableStateOf(false) }
    var currentSongId by rememberSaveable(songId) { mutableStateOf(songId) }
    var tagDetailId by rememberSaveable { mutableStateOf<String?>(null) }
    var showMenu by remember { mutableStateOf(false) }
    var showLoginPrompt by rememberSaveable { mutableStateOf(false) }
    var showSongEdit by remember { mutableStateOf(false) }
    var showRecordHistory by remember { mutableStateOf(false) }
    var showVideoSheet by remember { mutableStateOf(false) }
    var editingVideo by remember { mutableStateOf<SongVideo?>(null) }
    // 曲そのものを編集した後は VM を素直に読み直す。ViewModel はこの画面の担当範囲外なので
    // 差分反映のための API を足さず、再読込のきっかけだけ画面側で持つ。
    var reloadToken by remember { mutableStateOf(0) }
    val authState by AppModule.from(context).authService.state.collectAsState()
    // 権限フラグは認証状態が変わった時だけコアへ問い合わせる。extension property は 1 回ごとに
    // JNA を跨ぐので、メニューを開くたび・再コンポーズのたびに呼ばない
    // (詳細は data/auth/EditPermission.kt のヘッダ)。
    val canEditHere = remember(authState) { authState.showEditAffordance }

    // 投稿/編集導線の共通ゲート。iOS DetailSheet.handle(intent) と同じで、
    // 「開く/書き込む」操作は全部ここを通す。
    // シート側 (VideoEditSheet / PenlightVoteSheet) に権限判定は無いので、
    // ここで止めないとフォームに入力させた末に 401/403 で落ちる。
    //
    // BAN 済みは iOS の .ignore と同じく無反応 (onBanned 既定)。この画面の編集導線は
    // showEditAffordance で全部隠れているので、押せるのはタグチップだけ。
    fun startCommunityEdit(present: () -> Unit) =
        authState.startCommunityEdit(promptLogin = { showLoginPrompt = true }, present = present)

    LaunchedEffect(currentSongId, reloadToken) { viewModel.load(context, currentSongId) }

    if (tagDetailId != null) {
        // タグ詳細をこの画面内で表示 (別 route を経由しない, 上記コメント参照)。
        TagDetailScreen(
            tagId = tagDetailId!!,
            onBack = { tagDetailId = null },
            onSongClick = { id -> tagDetailId = null; currentSongId = id }
        )
        return
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(uiState.song?.title ?: "", maxLines = 1, overflow = TextOverflow.Ellipsis) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = L10n.Common.actionBack.resolve())
                    }
                },
                actions = {
                    val song = uiState.song
                    IconButton(onClick = { showMenu = true }) {
                        Icon(Icons.Filled.MoreVert, contentDescription = L10n.Songs.detailMenuMoreA11y.resolve())
                    }
                    DropdownMenu(expanded = showMenu, onDismissRequest = { showMenu = false }) {
                        DropdownMenuItem(
                            text = { Text(L10n.Songs.detailMenuLyricsSiteAndroid.resolve()) },
                            onClick = {
                                showMenu = false
                                openUrl(context, lyricsUrl(song))
                            }
                        )
                        if (!song?.appleMusicId.isNullOrEmpty()) {
                            DropdownMenuItem(
                                text = { Text(L10n.Songs.detailMenuAppleMusic.resolve()) },
                                onClick = {
                                    showMenu = false
                                    openUrl(context, "https://music.apple.com/jp/song/${song!!.appleMusicId}")
                                }
                            )
                        }
                        // 編集導線。BAN 済みには出さない (押しても 403 になるだけ)。判定はコア。
                        if (song != null && canEditHere) {
                            DropdownMenuItem(
                                text = { Text(L10n.Songs.detailMenuEdit.resolve()) },
                                onClick = {
                                    showMenu = false
                                    startCommunityEdit { showSongEdit = true }
                                }
                            )
                        }
                        DropdownMenuItem(
                            text = { Text(L10n.Songs.detailMenuEditHistory.resolve()) },
                            onClick = {
                                showMenu = false
                                showRecordHistory = true
                            }
                        )
                    }
                }
            )
        }
    ) { padding ->
        val song = uiState.song
        if (uiState.isLoading || song == null) {
            Box(Modifier.fillMaxSize().padding(padding), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        } else {
            SongSheetContent(
                state = uiState, song = song,
                modifier = Modifier.fillMaxSize().padding(padding),
                authState = authState,
                onIdolClick = onIdolClick, onShowClick = onShowClick,
                onSongClick = { id -> currentSongId = id },
                onToggleFavorite = viewModel::toggleFavorite,
                onToggleCardOwned = viewModel::toggleCardOwned,
                // 外す方向はゲートしない (iOS も自分が付けたタグの取り消しは contextMenu で素通し)。
                // 付ける方向だけ共通ゲートを通す — チップのタップはタグ投票の書き込みなので、
                // ボタンを隠すだけでは未ログイン/BAN 済みが投票し続けられてしまう。
                onToggleTag = { tag ->
                    if (tag.mine) viewModel.toggleTag(tag) else startCommunityEdit { viewModel.toggleTag(tag) }
                },
                onOpenTagPicker = { startCommunityEdit { showTagPicker = true } },
                onTagDetailClick = { tagDetailId = it },
                onCreateVideo = { startCommunityEdit { editingVideo = null; showVideoSheet = true } },
                onEditVideo = { video -> startCommunityEdit { editingVideo = video; showVideoSheet = true } },
                onOpenPenlightVote = { startCommunityEdit { showPenlightSheet = true } },
                onUnitClick = onUnitClick,
                onPollClick = onPollClick,
                onFilteredSongsClick = onFilteredSongsClick
            )
        }
    }

    if (showTagPicker) {
        SongTagPickerSheet(
            songId = currentSongId,
            alreadyAppliedTagIds = uiState.tags.filter { it.mine }.map { it.id }.toSet(),
            onDismiss = { showTagPicker = false },
            onApplied = { viewModel.onTagsApplied() }
        )
    }

    if (showPenlightSheet) {
        PenlightVoteSheet(
            songId = currentSongId,
            onDismiss = { showPenlightSheet = false },
            onVoted = { viewModel.onPenlightVoted() }
        )
    }

    if (showVideoSheet) {
        VideoEditSheet(
            songId = currentSongId,
            existing = editingVideo,
            onDismiss = { showVideoSheet = false },
            // 参考動画は VM に差分反映の口が無いので、保存後に読み直して一覧へ載せる。
            onSaved = { reloadToken++ }
        )
    }

    // 編集フォームはフルスクリーン Dialog に載せる (RecentEditsScreen → SetlistEditScreen と同じ)。
    val editingSong = uiState.song
    if (showSongEdit && editingSong != null) {
        Dialog(
            onDismissRequest = { showSongEdit = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            SongEditScreen(
                original = editingSong,
                onDismiss = { showSongEdit = false },
                onSaved = { showSongEdit = false; reloadToken++ }
            )
        }
    }

    if (showRecordHistory) {
        RecordHistorySheet(
            recordType = "Song",
            recordName = currentSongId,
            onDismiss = { showRecordHistory = false }
        )
    }

    if (showLoginPrompt) {
        CommunityLoginPromptDialog(
            message = L10n.Songs.detailLoginDialog.resolve(),
            onDismiss = { showLoginPrompt = false }
        )
    }
}

private fun lyricsUrl(song: Song?): String {
    if (song == null) return "https://www.uta-net.com"
    if (!song.lyricsUrl.isNullOrEmpty()) return song.lyricsUrl
    val encoded = java.net.URLEncoder.encode(song.title, "UTF-8")
    return "https://www.uta-net.com/search/?Keyword=$encoded"
}

private fun openUrl(context: android.content.Context, url: String) {
    runCatching {
        context.startActivity(android.content.Intent(android.content.Intent.ACTION_VIEW, android.net.Uri.parse(url)))
    }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun SongSheetContent(
    state: SongDetailUiState,
    song: Song,
    modifier: Modifier,
    authState: AuthState,
    onIdolClick: (String) -> Unit,
    onShowClick: (String) -> Unit,
    onSongClick: (String) -> Unit,
    onToggleFavorite: () -> Unit,
    onToggleCardOwned: () -> Unit,
    onToggleTag: (com.fugaif.imaslivedb.data.community.CommunityApi.SongTag) -> Unit,
    onOpenTagPicker: () -> Unit,
    onTagDetailClick: (String) -> Unit,
    onCreateVideo: () -> Unit,
    onEditVideo: (SongVideo) -> Unit,
    onOpenPenlightVote: () -> Unit,
    onUnitClick: (String) -> Unit,
    onPollClick: (String) -> Unit,
    onFilteredSongsClick: (String, String) -> Unit
) {
    // 配色シード: ソロ (歌唱1人) はその個人カラー、それ以外はブランド色。
    val seed = if (state.originalArtists.size == 1) state.originalArtists.first().color else null
    val t = ImasTheme.forBrand(seed, song.brandId)
    var segment by rememberSaveable(song.id) { mutableIntStateOf(0) }

    Column(modifier = modifier.verticalScroll(rememberScrollState())) {
        Hero(song, state.originalArtists, state.isFavorite, t, onToggleFavorite)
        ImasSegmented(
            labels = listOf(
                L10n.Songs.detailTabInfo.resolve(),
                L10n.Songs.detailTabHistory.resolve(),
                L10n.Songs.detailTabCommunity.resolve()
            ),
            selection = segment, onSelect = { segment = it },
            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 12.dp)
        )
        when (segment) {
            0 -> InfoTab(
                song, state, seed, onIdolClick, onUnitClick, onSongClick, onShowClick,
                onRegisterAttendance = { segment = 1 },
                onFilteredSongsClick = onFilteredSongsClick,
                onToggleCardOwned = onToggleCardOwned
            )
            1 -> HistoryTab(
                state.performanceHistory, state.performanceEvidence, seed, song.brandId,
                onShowClick, onSongClick, onIdolClick
            )
            else -> CommunityTab(
                state, seed, song.brandId, authState, onSongClick,
                onToggleTag, onOpenTagPicker, onTagDetailClick,
                onCreateVideo, onEditVideo,
                onOpenPenlightVote, onPollClick
            )
        }
        Box(Modifier.size(24.dp))
    }
}

@Composable
private fun Hero(
    song: Song,
    originalArtists: List<Idol>,
    isFavorite: Boolean,
    t: ImasTheme,
    onToggleFavorite: () -> Unit
) {
    val artistLine = when {
        originalArtists.isNotEmpty() -> originalArtists.joinToString(" / ") { it.name }
        !song.singerLabel.isNullOrEmpty() -> song.singerLabel
        !song.unitName.isNullOrEmpty() -> song.unitName
        else -> null
    }
    val playbackState by AudioPreviewManager.playbackState.collectAsState()
    val isPreviewing = playbackState.isPlaying(song.id)
    Column(
        modifier = Modifier.fillMaxWidth().background(t.heroSurface).padding(top = 16.dp, bottom = 16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        ArtworkImage(url = song.artworkUrl, size = 168.dp, previewUrl = song.previewUrl, songTitle = song.title, songId = song.id)
        Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.padding(horizontal = 16.dp)) {
            Text(song.title, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = DS.ink,
                textAlign = TextAlign.Center, maxLines = 2, overflow = TextOverflow.Ellipsis)
            if (artistLine != null) {
                Text(artistLine, fontSize = 15.sp, color = DS.ink2, textAlign = TextAlign.Center,
                    maxLines = 2, overflow = TextOverflow.Ellipsis, modifier = Modifier.padding(top = 2.dp))
            }
            if (song.hasKamisabiCard) {
                // 語はコアの kamisabiCardLabel() をそのまま出す。iOS / Web と語がバラバラだった
                // (RedTeam M-6) ので、ここで新しい文言を作らない。
                Text(
                    coreText(kamisabiCardLabel()), fontSize = 12.sp, fontWeight = FontWeight.SemiBold, color = t.onAccent,
                    modifier = Modifier.padding(top = 6.dp)
                        .clip(RoundedCornerShape(8.dp))
                        .background(t.accent)
                        .padding(horizontal = 10.dp, vertical = 3.dp)
                )
            }
        }
        Row(
            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            val canPlay = !song.previewUrl.isNullOrEmpty()
            Row(
                modifier = Modifier.weight(1f)
                    .clip(RoundedCornerShape(12.dp))
                    .background(if (canPlay) t.accent else t.accent.copy(alpha = 0.5f))
                    .then(if (canPlay) Modifier.clickable {
                        AudioPreviewManager.togglePreview(song.previewUrl!!, song.id)
                    } else Modifier)
                    .padding(vertical = 11.dp),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    if (isPreviewing) Icons.Filled.Stop else Icons.Filled.PlayArrow,
                    contentDescription = null, tint = t.onAccent, modifier = Modifier.size(18.dp)
                )
                Text(
                    (if (isPreviewing) L10n.Songs.detailStop else L10n.Songs.detailPlay).resolve(),
                    fontSize = 15.sp, fontWeight = FontWeight.SemiBold,
                    color = t.onAccent, modifier = Modifier.padding(start = 6.dp)
                )
            }
            Row(
                modifier = Modifier.weight(1f)
                    .clip(RoundedCornerShape(12.dp))
                    .background(t.chipBg)
                    .clickable(onClick = onToggleFavorite)
                    .padding(vertical = 11.dp),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    Icons.Filled.Star, contentDescription = null,
                    tint = if (isFavorite) DS.favorite else t.accent, modifier = Modifier.size(18.dp)
                )
                Text(
                    (if (isFavorite) L10n.Songs.detailFavoriteOn else L10n.Songs.detailFavoriteOff).resolve(),
                    fontSize = 15.sp, fontWeight = FontWeight.SemiBold,
                    color = if (isFavorite) DS.favorite else t.accent, modifier = Modifier.padding(start = 6.dp)
                )
            }
        }
    }
}

/**
 * songs.song_type の生値 → 表示ラベル。
 * 曲一覧の絞り込みチップと絞り込み一覧のタイトルも同じラベルを出すので internal で共有する
 * (画面ごとに書き直すと、同じ生値が二通りの日本語で出る)。
 */
internal fun songTypeLabel(songType: String): String = Vocab.songType(songType)?.shortLabel ?: songType

private fun formatDuration(sec: Int?): String? {
    if (sec == null || sec <= 0) return null
    return "%d:%02d".format(sec / 60, sec % 60)
}

@Composable
private fun InfoTab(
    song: Song,
    state: SongDetailUiState,
    seed: String?,
    onIdolClick: (String) -> Unit,
    onUnitClick: (String) -> Unit,
    onSongClick: (String) -> Unit,
    onShowClick: (String) -> Unit,
    onRegisterAttendance: () -> Unit,
    onFilteredSongsClick: (String, String) -> Unit,
    onToggleCardOwned: () -> Unit
) {
    val artistLine = when {
        state.originalArtists.isNotEmpty() -> state.originalArtists.joinToString(" / ") { it.name }
        !song.singerLabel.isNullOrEmpty() -> song.singerLabel
        !song.unitName.isNullOrEmpty() -> song.unitName
        else -> null
    }
    Column(modifier = Modifier.padding(top = 12.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
        // 披露統計
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Row(Modifier.fillMaxWidth().padding(horizontal = 16.dp), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                ImasStatTile(Icons.Filled.Mic, "${state.performanceHistory.size}", L10n.Songs.infoStatPerformances.resolve(),
                    unit = L10n.Songs.detailStatUnitTimes.resolve(),
                    seed = seed, brand = song.brandId, modifier = Modifier.weight(1f))
                ImasStatTile(Icons.Filled.CheckCircle, "${state.collectedShows.size}", L10n.Songs.infoStatCollected.resolve(),
                    unit = L10n.Songs.detailStatUnitShows.resolve(),
                    seed = seed, brand = song.brandId, modifier = Modifier.weight(1f))
            }
            Row(
                modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp)
                    .clip(RoundedCornerShape(12.dp)).background(DS.fill)
                    .clickable(onClick = onRegisterAttendance)
                    .padding(vertical = 12.dp),
                horizontalArrangement = Arrangement.Center, verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Filled.Add, contentDescription = null, tint = DS.ink2, modifier = Modifier.size(16.dp))
                Text(L10n.Songs.infoRegisterAttendance.resolve(), fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2,
                    modifier = Modifier.padding(start = 6.dp))
            }
            if (state.collectedShows.isNotEmpty()) {
                Column(Modifier.padding(horizontal = 16.dp)) {
                    state.collectedShows.forEachIndexed { idx, show ->
                        if (idx > 0) HorizontalDivider(color = DS.sep)
                        Row(
                            modifier = Modifier.fillMaxWidth().clickable { onShowClick(show.id) }
                                .padding(vertical = 10.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(Icons.Filled.CheckCircle, contentDescription = null, tint = DS.success, modifier = Modifier.size(16.dp))
                            Column(Modifier.weight(1f).padding(start = 10.dp)) {
                                Text(AppPreferences.eventDisplayName(show.eventName), fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink,
                                    maxLines = 1, overflow = TextOverflow.Ellipsis)
                                Text(listOf(show.name, show.date).filter { it.isNotEmpty() }.joinToString(" ・ "),
                                    fontSize = 12.sp, color = DS.ink2, maxLines = 1, overflow = TextOverflow.Ellipsis)
                            }
                        }
                    }
                }
            }
        }
        // KAMISABI カード所持 (収録曲のみ)
        if (song.hasKamisabiCard) {
            Column {
                ImasSectionHeader(L10n.Songs.detailKamisabiHeader, tight = true)
                Row(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(L10n.Songs.detailKamisabiToggle.resolve(), fontSize = 15.sp, color = DS.ink)
                        // 分母はこの曲のブランド (商品) 単位。KAMISABI は ML/SideM/シャニの
                        // 別商品なので合算しない (RedTeam H-3/H-4)。言い回しも
                        // kamisabiCompletionLabel() をそのまま出す (「枚」ではなく「曲」で数える)。
                        state.kamisabiCompletion?.let { completion ->
                            Text(kamisabiCompletionLabel(completion), fontSize = 12.sp, color = DS.ink2)
                        }
                    }
                    Switch(checked = state.isCardOwned, onCheckedChange = { onToggleCardOwned() })
                }
                HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
            }
        }
        // 楽曲情報
        Column {
            ImasSectionHeader(L10n.Songs.infoSectionHeader, tight = true)
            // 「よみ」は検索で使う値。画面に出しておかないと、間違っていても
            // 「この曲が出てこない」としか思われず直しようがない (機械生成ぶんが混ざっている)。
            InfoRow(L10n.Songs.infoRowKana, song.titleKana)
            InfoRow(L10n.Songs.infoRowArtist, artistLine)
            // 以降、値そのものが「同じ条件の曲の集合」を指す行は一覧へ抜けられるようにする。
            // ここが唯一の入口の条件もある (シリーズや作家は一覧の絞り込み UI に無い)。
            state.brand?.let { brand ->
                FilterRow(L10n.Songs.infoRowBrand, brand.shortName, seed, song.brandId) {
                    onFilteredSongsClick(SongFilterKind.BRAND, brand.id)
                }
            }
            if (song.songType.isNotEmpty() && song.songType != "unknown") {
                FilterRow(L10n.Songs.infoRowType, coreText(songTypeLabel(song.songType)), seed, song.brandId) {
                    onFilteredSongsClick(SongFilterKind.SONG_TYPE, song.songType)
                }
            }
            // 「YYYY-...」から年だけ取れたときにリリース年の一覧へ。年が読めない表記
            // (未定・年だけ等) は押せない普通の行に落とす — 行き先が作れないため。
            val releaseYear = song.releaseDate?.take(4)?.takeIf { it.length == 4 && it.toIntOrNull() != null }
            if (releaseYear != null) {
                FilterRow(L10n.Songs.infoRowReleaseDate, song.releaseDate, seed, song.brandId) {
                    onFilteredSongsClick(SongFilterKind.RELEASE_YEAR, releaseYear)
                }
            } else {
                InfoRow(L10n.Songs.infoRowReleaseDate, song.releaseDate)
            }
            InfoRow(L10n.Songs.infoRowDuration, formatDuration(song.durationSec))
            // クレジットは 1 欄に複数名が入るので、行ごとではなく名前ごとに押せるようにする。
            CreditRow(L10n.Songs.infoRowComposer, song.composer, seed, song.brandId, onFilteredSongsClick)
            CreditRow(L10n.Songs.infoRowLyricist, song.lyricist, seed, song.brandId, onFilteredSongsClick)
            CreditRow(L10n.Songs.infoRowArranger, song.arranger, seed, song.brandId, onFilteredSongsClick)
            song.seriesGroup?.takeIf { it.isNotEmpty() }?.let { series ->
                FilterRow(L10n.Songs.infoRowSeries, series, seed, song.brandId) {
                    onFilteredSongsClick(SongFilterKind.SERIES_GROUP, series)
                }
            }
            song.cdSeries?.takeIf { it.isNotEmpty() }?.let { cdSeries ->
                FilterRow(L10n.Songs.infoRowCdSeries, cdSeries, seed, song.brandId) {
                    onFilteredSongsClick(SongFilterKind.CD_SERIES, cdSeries)
                }
            }
            InfoRow(L10n.Songs.infoRowCdTitle, song.cdTitle)
            if (state.unit != null) {
                ImasLabeledRow(key = L10n.Songs.infoRowUnit.resolve(), value = state.unit.name, tappable = true, seed = seed,
                    brand = song.brandId,
                    onClick = { onUnitClick(state.unit.id) })
                HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
            }
        }
        // 歌唱アイドル
        if (state.originalArtists.isNotEmpty()) {
            IdolGridSection(L10n.Songs.infoSingersHeader.resolve(), state.originalArtists, onIdolClick)
        }
        // ライブ歌唱歴
        if (state.performerArtists.isNotEmpty()) {
            IdolGridSection(L10n.Songs.infoLiveSingersHeader.resolve(), state.performerArtists, onIdolClick)
        }
        // 関連楽曲 (同シリーズ/ユニット/原唱共有)
        if (state.relatedSongs.isNotEmpty()) {
            RelatedSongsSection(L10n.Songs.infoRelatedHeader, state.relatedSongs, seed, song.brandId, badge = null,
                onSongClick = onSongClick)
        }
    }
}

/**
 * 値が「同じ条件の曲の集合」を指す行。押すと絞り込み一覧へ抜ける。
 * 押せる見た目 (accent 文字 + 矢印) は tappable が出す。
 */
@Composable
private fun FilterRow(key: DisplayText, value: String?, seed: String?, brand: String?, onClick: () -> Unit) {
    if (value.isNullOrEmpty()) return
    ImasLabeledRow(key = key.resolve(), value = value, tappable = true, seed = seed, brand = brand, onClick = onClick)
    HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
}

/**
 * クレジット行 (作曲 / 作詞 / 編曲)。欄を人ごとに割って、名前 1 つずつを
 * 「その人が関わった楽曲」へのリンクにする。
 *
 * 欄の割り方はコア (`splitCreditNames`) が唯一の正 — 括弧の外は 5 種類の区切りで割り、
 * 括弧の中は `・` と `、` だけで割る (`,` `/` は社名の一部)。ここで書き直すと
 * 一覧側の突き合わせ (コアの songsByCreator) とずれて、同じ人が
 * 二通りに分かれるか一覧が 0 件になる。
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun CreditRow(
    key: DisplayText,
    value: String?,
    seed: String?,
    brand: String?,
    onFilteredSongsClick: (String, String) -> Unit
) {
    if (value.isNullOrEmpty()) return
    // 空白だけの断片 (欄が "/" だけ等) は人名ではないので落とす。ルート引数が空になると
    // 行き先のパスが組み立たず、押した瞬間に落ちる。
    val names = remember(value) { splitCreditNames(value).filter { it.isNotBlank() } }
    if (names.isEmpty()) return
    val t = ImasTheme.forBrand(seed, brand)
    Row(
        modifier = Modifier.fillMaxWidth().background(DS.surface).padding(horizontal = 16.dp, vertical = 11.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(key.resolve(), fontSize = 15.sp, color = DS.ink2)
        Box(Modifier.weight(1f))
        // 名前は右寄せで「A / B」と並べる。区切りの "/" は押せない (人ではないので)。
        FlowRow(
            horizontalArrangement = Arrangement.spacedBy(4.dp),
            verticalArrangement = Arrangement.spacedBy(2.dp)
        ) {
            names.forEachIndexed { index, name ->
                if (index > 0) Text("/", fontSize = 15.sp, color = DS.ink3)
                Text(
                    name, fontSize = 15.sp, color = t.accent,
                    modifier = Modifier.clickable { onFilteredSongsClick(SongFilterKind.CREATOR, name) }
                )
            }
        }
    }
    HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
}

@Composable
private fun InfoRow(key: DisplayText, value: String?) {
    if (value.isNullOrEmpty()) return
    ImasLabeledRow(key = key.resolve(), value = value)
    HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
}

@Composable
private fun RelatedSongsSection(
    title: DisplayText,
    songs: List<Song>,
    seed: String?,
    brand: String?,
    badge: Map<String, Int>?,
    onSongClick: (String) -> Unit
) {
    Column {
        ImasSectionHeader(title, count = DisplayText.Verbatim("${songs.size}"))
        Column(Modifier.padding(horizontal = 16.dp)) {
            songs.forEachIndexed { idx, s ->
                if (idx > 0) HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 44.dp))
                Row(
                    modifier = Modifier.fillMaxWidth().clickable { onSongClick(s.id) }.padding(vertical = 9.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    ImasArtwork(title = s.title, seed = seed, brand = brand, size = 44.dp, imageUrl = s.artworkUrl)
                    Column(Modifier.weight(1f).padding(start = 12.dp)) {
                        Text(s.title, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink,
                            maxLines = 1, overflow = TextOverflow.Ellipsis)
                        val sub = s.singerLabel ?: s.unitName
                        if (!sub.isNullOrEmpty()) {
                            Text(sub, fontSize = 12.sp, color = DS.ink2, maxLines = 1, overflow = TextOverflow.Ellipsis)
                        }
                    }
                    val b = badge?.get(s.id)
                    if (b != null) {
                        Text(L10n.Songs.communitySimilarSharedTags(count = b).resolve(), fontSize = 12.sp,
                            fontWeight = FontWeight.SemiBold, color = DS.ink3,
                            modifier = Modifier.padding(end = 4.dp))
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalLayoutApi::class, ExperimentalFoundationApi::class)
@Composable
private fun CommunityTab(
    state: SongDetailUiState, seed: String?, brand: String?, authState: AuthState,
    onSongClick: (String) -> Unit,
    onToggleTag: (com.fugaif.imaslivedb.data.community.CommunityApi.SongTag) -> Unit,
    onOpenTagPicker: () -> Unit,
    onTagDetailClick: (String) -> Unit,
    onCreateVideo: () -> Unit,
    onEditVideo: (SongVideo) -> Unit,
    onOpenPenlightVote: () -> Unit,
    onPollClick: (String) -> Unit
) {
    val context = LocalContext.current
    // 権限フラグは認証状態が変わった時だけコアへ問い合わせる。
    // extension property は毎回 EditPermissionRules を RustBuffer に詰めて JNA を跨ぐので、
    // 参考動画 1 件ごと・再コンポーズごとに呼ぶと (要素数ぶんの FFI) スクロール中ずっと積み上がる。
    val canEditHere = remember(authState) { authState.showEditAffordance }
    val needsLogin = remember(authState) { authState.shouldPromptLogin }
    Column(modifier = Modifier.padding(top = 12.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
        state.song?.let { song ->
            com.fugaif.imaslivedb.ui.polls.PollAchievementBadges(entityId = song.id, onOpenPoll = onPollClick)
        }
        if (needsLogin) {
            Row(
                modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp)
                    .clip(RoundedCornerShape(12.dp)).background(DS.fill).padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(L10n.Songs.detailLoginPrompt.resolve(), fontSize = 12.5.sp, color = DS.ink2)
            }
        }
        // タグ (集計系コミュニティ・Worker D1)。タップで自分の投票をトグル、長押しでタグ詳細、+ で全タグから追加。
        Column {
            Row(verticalAlignment = Alignment.CenterVertically) {
                ImasSectionHeader(
                    L10n.Songs.communityTagsHeader, count = DisplayText.Verbatim("${state.tags.size}"),
                    modifier = Modifier.weight(1f)
                )
                if (canEditHere) {
                    IconButton(onClick = onOpenTagPicker, modifier = Modifier.padding(end = 8.dp)) {
                        Icon(Icons.Filled.Add, contentDescription = L10n.Songs.communityTagsAdd.resolve(), tint = DS.ink2)
                    }
                }
            }
            if (state.tags.isEmpty()) {
                Text(L10n.Songs.communityTagsEmptyTitle.resolve(), fontSize = 13.sp, color = DS.ink3,
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp))
            } else {
                FlowRow(
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    state.tags.forEach { tag ->
                        val bg = if (tag.mine) DS.pick.copy(alpha = 0.18f) else DS.fill
                        val fg = if (tag.mine) DS.pick else DS.ink
                        Row(
                            modifier = Modifier.clip(RoundedCornerShape(999.dp)).background(bg)
                                .combinedClickable(
                                    onClick = { onToggleTag(tag) },
                                    onLongClick = { onTagDetailClick(tag.id) }
                                )
                                .padding(horizontal = 12.dp, vertical = 6.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(tag.name, fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = fg)
                            if (tag.voteCount > 0) {
                                Text(" ${tag.voteCount}", fontSize = 12.sp, color = DS.ink3)
                            }
                        }
                    }
                }
            }
        }
        // この曲が好きな人にはこれも (タグが似ている楽曲, サーバ算出)
        if (state.similarTagSongs.isNotEmpty()) {
            RelatedSongsSection(
                L10n.Songs.communitySimilarHeader, state.similarTagSongs, seed, brand, state.similarSharedTags, onSongClick
            )
        }
        // ペンライト投票 (集計系・Worker D1)
        Column {
            Row(verticalAlignment = Alignment.CenterVertically) {
                ImasSectionHeader(
                    L10n.Songs.communityPenlightHeaderAndroid,
                    count = state.penlight?.totalVotes?.let { L10n.Songs.communityPenlightVotes(count = it) },
                    modifier = Modifier.weight(1f)
                )
                if (canEditHere) {
                    IconButton(onClick = onOpenPenlightVote, modifier = Modifier.padding(end = 8.dp)) {
                        Icon(Icons.Filled.Add, contentDescription = L10n.Songs.communityPenlightVote.resolve(), tint = DS.ink2)
                    }
                }
            }
            val sets = state.penlight?.topSets ?: emptyList()
            if (sets.isEmpty()) {
                ImasEmptyState(Icons.Filled.Star, L10n.Songs.communityPenlightEmptyTitle.resolve(),
                    L10n.Songs.communityPenlightEmptyMessage.resolve(), seed = seed, brand = brand)
            } else {
                sets.take(5).forEach { ps ->
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 6.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        ps.colors.take(4).forEach { hex ->
                            Box(Modifier.size(20.dp).clip(RoundedCornerShape(5.dp))
                                .background(hexToColor(hex)))
                        }
                        Box(Modifier.weight(1f))
                        Text("${ps.count}", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2)
                    }
                }
            }
        }
        // 参考動画 (構造化コミュニティ・CloudKit 直書き。POST /edits 経由で全ユーザーが投稿/編集可能)
        Column {
            Row(verticalAlignment = Alignment.CenterVertically) {
                ImasSectionHeader(
                    L10n.Songs.communityVideosHeader, count = DisplayText.Verbatim("${state.songVideos.size}"),
                    modifier = Modifier.weight(1f)
                )
                if (canEditHere) {
                    IconButton(onClick = onCreateVideo, modifier = Modifier.padding(end = 8.dp)) {
                        Icon(Icons.Filled.Add, contentDescription = L10n.Songs.communityVideosAddA11y.resolve(), tint = DS.ink2)
                    }
                }
            }
            if (state.songVideos.isEmpty()) {
                ImasEmptyState(Icons.Filled.OndemandVideo, L10n.Songs.communityVideosEmptyTitle.resolve(),
                    L10n.Songs.communityVideosEmptyMessageAndroid.resolve(), seed = seed, brand = brand)
            } else {
                // id とサムネイルの URL はコアが読む (一覧で 1 回)。
                val refs = remember(state.songVideos) { youtubeVideoRefs(state.songVideos.map { it.youtubeUrl }) }
                state.songVideos.forEachIndexed { index, video ->
                    val ref = refs.getOrNull(index)
                    Row(
                        modifier = Modifier.fillMaxWidth().clickable {
                            openUrl(context, video.youtubeUrl)
                        }.padding(horizontal = 16.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(Modifier.size(56.dp).clip(RoundedCornerShape(9.dp)).background(DS.fill), contentAlignment = Alignment.Center) {
                            ref?.thumbnailUrl?.let { thumbnail ->
                                // 高解像度 (maxresdefault) が無い動画は mqdefault に落とす (iOS と同じ)。
                                SubcomposeAsyncImage(
                                    model = thumbnail,
                                    contentDescription = video.videoTitle,
                                    contentScale = ContentScale.Crop,
                                    modifier = Modifier.size(56.dp).clip(RoundedCornerShape(9.dp)),
                                    error = {
                                        ref.fallbackThumbnailUrl?.let { fallback ->
                                            SubcomposeAsyncImage(
                                                model = fallback,
                                                contentDescription = video.videoTitle,
                                                contentScale = ContentScale.Crop,
                                                modifier = Modifier.size(56.dp).clip(RoundedCornerShape(9.dp))
                                            )
                                        }
                                    }
                                )
                            }
                            Icon(Icons.Filled.PlayArrow, null, tint = Color.White, modifier = Modifier.size(22.dp))
                        }
                        Column(Modifier.weight(1f).padding(start = 12.dp)) {
                            Text(video.videoTitle ?: video.youtubeUrl, fontSize = 15.sp, color = DS.ink, maxLines = 1, overflow = TextOverflow.Ellipsis)
                            if (!video.note.isNullOrEmpty()) {
                                Text(video.note, fontSize = 12.sp, color = DS.ink2, maxLines = 1, overflow = TextOverflow.Ellipsis)
                            }
                            if (!video.authorDisplayName.isNullOrEmpty()) {
                                Text(L10n.Songs.communityVideosAuthor(name = video.authorDisplayName).resolve(),
                                    fontSize = 11.sp, color = DS.ink3)
                            }
                        }
                        if (canEditHere) {
                            IconButton(onClick = { onEditVideo(video) }, modifier = Modifier.size(28.dp)) {
                                Icon(Icons.Filled.Edit, contentDescription = L10n.Songs.communityVideosEditA11y.resolve(), tint = DS.ink2,
                                    modifier = Modifier.size(16.dp))
                            }
                        }
                    }
                    HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
                }
            }
        }
    }
}

/**
 * 「披露履歴」タブ。総披露 / 初披露 / 最終披露、披露実績から出した歌唱者と共起曲、
 * そして公演ごとの履歴一覧。
 *
 * 節の並びは「集計 → 集計 → 集計 → 生ログ」。人気曲の履歴は 100 行を超えるので、
 * 要約を先に置かないと集計まで辿り着けない (iOS の SongHistoryTab と同じ並び)。
 */
@Composable
private fun HistoryTab(
    history: List<PerformanceHistoryRow>,
    evidence: SongPerformanceEvidence,
    seed: String?,
    brand: String?,
    onShowClick: (String) -> Unit,
    onSongClick: (String) -> Unit,
    onIdolClick: (String) -> Unit
) {
    if (history.isEmpty()) {
        ImasEmptyState(Icons.Filled.MusicNote, L10n.Songs.historyEmptyTitle.resolve(),
            L10n.Songs.historyEmptyMessage.resolve(), seed = seed, brand = brand)
        return
    }
    Column(modifier = Modifier.padding(top = 8.dp)) {
        val sortedByDateAsc = history.sortedBy { it.date }
        Row(
            Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            ImasStatTile(Icons.Filled.Mic, "${history.size}", L10n.Songs.historyStatTotal.resolve(),
                unit = L10n.Songs.detailStatUnitTimes.resolve(), seed = seed, brand = brand, modifier = Modifier.weight(1f))
            ImasStatTile(Icons.Filled.CalendarMonth, shortYearMonth(date = sortedByDateAsc.first().date),
                L10n.Songs.historyStatFirst.resolve(), seed = seed, brand = brand, modifier = Modifier.weight(1f))
            ImasStatTile(Icons.Filled.CalendarMonth, shortYearMonth(date = sortedByDateAsc.last().date),
                L10n.Songs.historyStatLast.resolve(), seed = seed, brand = brand, modifier = Modifier.weight(1f))
        }
        // 披露実績がまだ 1 度も無い曲でだけ中身が空になり、節ごと消える。
        SingersSection(evidence.singers, onIdolClick)
        CoOccurringSection(evidence.coOccurring, seed, brand, onSongClick)
        ImasSectionHeader(L10n.Songs.historyLogHeader, count = L10n.Songs.historyLogCount(count = history.size), tight = true)
        history.forEach { row ->
            Row(
                modifier = Modifier.fillMaxWidth().clickable { onShowClick(row.showId) }
                    .padding(horizontal = 16.dp, vertical = 10.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                ImasLeadBar(seedHex = seed, brandId = brand, height = 34.dp)
                Column(Modifier.weight(1f).padding(start = 12.dp)) {
                    Text(AppPreferences.eventDisplayName(row.eventName), fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink,
                        maxLines = 1, overflow = TextOverflow.Ellipsis)
                    Text(listOf(row.showName, row.date).filter { it.isNotEmpty() }.joinToString(" ・ "),
                        fontSize = 12.sp, color = DS.ink2, maxLines = 1, overflow = TextOverflow.Ellipsis)
                }
            }
            HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
        }
    }
}

/**
 * 「この曲を歌った人」。歌った回数の多い順。
 *
 * 副題が根拠。「よく歌う人」ではなく「何回歌ったか」を出す
 * (回数を隠して傾向だけ書くと、外れたときに嘘になる)。
 */
@Composable
private fun SingersSection(
    rows: List<SongSingerTally>,
    onIdolClick: (String) -> Unit
) {
    if (rows.isEmpty()) return
    Column {
        ImasSectionHeader(L10n.Songs.historySingersHeader, tight = true)
        // 分母 (全 N 回) は上のサマリタイル「総披露」と同じ数え方。同じ画面に単位の違う
        // 数字 (共起節は公演数) が並ぶので、どちらなのかを言っておく。
        EvidenceNote(L10n.Songs.historySingersNote)
        Column(Modifier.padding(horizontal = 16.dp)) {
            rows.forEachIndexed { idx, row ->
                if (idx > 0) HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 48.dp))
                Row(
                    modifier = Modifier.fillMaxWidth().clickable { onIdolClick(row.idol.id) }
                        .padding(vertical = 9.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    ImasAvatar(label = row.idol.shortName, seed = row.idol.color, brand = row.idol.brandId, size = 36.dp)
                    Column(Modifier.weight(1f).padding(start = 12.dp)) {
                        Text(row.idol.name, fontSize = 15.sp, color = DS.ink,
                            maxLines = 1, overflow = TextOverflow.Ellipsis)
                        Text(L10n.Songs.historySingersTimes(times = row.times, total = row.total).resolve(),
                            fontSize = 12.sp, color = DS.ink2,
                            maxLines = 1, overflow = TextOverflow.Ellipsis)
                    }
                }
            }
        }
    }
}

/**
 * 「同じ公演で歌われた曲」。一緒に来た**公演数**の多い順。
 *
 * 行の形は [RelatedSongsSection] と同じだが、副題は歌唱表記ではなく**根拠の回数**。
 * この行が並んでいる理由そのものが回数なので、歌唱表記よりそちらを副題の位置に置く。
 */
@Composable
private fun CoOccurringSection(
    rows: List<CoOccurringSong>,
    seed: String?,
    brand: String?,
    onSongClick: (String) -> Unit
) {
    if (rows.isEmpty()) return
    Column {
        ImasSectionHeader(L10n.Songs.historyCoOccurringHeader, tight = true)
        // ⚠️ ここだけ単位が「公演」。1 公演で 2 回演奏されても 1 と数えるため、相手の曲を
        // 開いた先の「総披露 N 回」(セトリ行数) より小さい数になる (同梱 master で 48 曲が
        // このズレを持つ。例: 初 = 39 公演 / 64 回)。単位を書かないと「どちらが本当の回数か」
        // が読み手に判断できない。
        EvidenceNote(L10n.Songs.historyCoOccurringNote)
        Column(Modifier.padding(horizontal = 16.dp)) {
            rows.forEachIndexed { idx, row ->
                if (idx > 0) HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 56.dp))
                Row(
                    modifier = Modifier.fillMaxWidth().clickable { onSongClick(row.song.id) }
                        .padding(vertical = 9.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    ImasArtwork(title = row.song.title, seed = seed, brand = brand, size = 44.dp,
                        imageUrl = row.song.artworkUrl)
                    Column(Modifier.weight(1f).padding(start = 12.dp)) {
                        Text(row.song.title, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink,
                            maxLines = 1, overflow = TextOverflow.Ellipsis)
                        // 分母まで出す。12/15 (ほぼ必ず一緒) と 12/300 (たまたま) は別物で、
                        // 回数だけだと読み手が区別できない。単位は「回」ではなく「公演」
                        // (歌唱者行の「全 N 回」= セトリ行数とは別の数え方なので語を分ける)。
                        Text(L10n.Songs.historyCoOccurringRow(together = row.together, performances = row.performances).resolve(),
                            fontSize = 12.sp, color = DS.ink2,
                            maxLines = 1, overflow = TextOverflow.Ellipsis)
                    }
                }
            }
        }
    }
}

/** 集計の但し書き。回数だけ並べると「予想」と読まれうるので、過去の実績だと明示する。 */
@Composable
private fun EvidenceNote(text: DisplayText) {
    Text(text.resolve(), fontSize = 12.sp, color = DS.ink3,
        modifier = Modifier.padding(horizontal = 16.dp, vertical = 2.dp))
}
