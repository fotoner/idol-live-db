package com.fugaif.imaslivedb.ui.events

import android.content.Context
import androidx.compose.foundation.BorderStroke
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
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.List
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material.icons.filled.Verified
import androidx.compose.material.icons.outlined.RadioButtonUnchecked
import androidx.compose.material.icons.outlined.ThumbUp
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.auth.canEdit
import com.fugaif.imaslivedb.data.auth.showEditAffordance
import com.fugaif.imaslivedb.data.auth.startCommunityEdit
import com.fugaif.imaslivedb.data.model.AttendanceType
import com.fugaif.imaslivedb.data.model.JstDay
import com.fugaif.imaslivedb.data.model.PerformerRow
import com.fugaif.imaslivedb.data.model.SetlistRow
import com.fugaif.imaslivedb.data.model.Show
import com.fugaif.imaslivedb.data.model.UserMark
import com.fugaif.imaslivedb.data.model.VenueDirectory
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.ui.components.ArtworkImage
import com.fugaif.imaslivedb.ui.components.CommunityLoginPromptDialog
import com.fugaif.imaslivedb.ui.components.GradientHeader
import com.fugaif.imaslivedb.ui.components.ImasEmptyState
import com.fugaif.imaslivedb.ui.components.ImasLabeledRow
import com.fugaif.imaslivedb.ui.components.ImasSectionHeader
import com.fugaif.imaslivedb.ui.components.ImasTagChip
import com.fugaif.imaslivedb.ui.components.PerformerChip
import com.fugaif.imaslivedb.ui.edit.SetlistEditScreen
import com.fugaif.imaslivedb.ui.filtered.ShowFilterKind
import com.fugaif.imaslivedb.ui.share.SetlistCommentComposeSheet
import com.fugaif.imaslivedb.ui.theme.AppPreferences
import com.fugaif.imaslivedb.ui.theme.BrandPalette
import com.fugaif.imaslivedb.ui.theme.DS
import com.fugaif.imaslivedb.ui.theme.ImasTheme
import uniffi.imas_core.CollectionBadgeRecord
import uniffi.imas_core.CollectionBadgeRole
import uniffi.imas_core.PerformerNameMode
import uniffi.imas_core.SetlistDisplayMode
import uniffi.imas_core.SetlistRowMetaRecord
import uniffi.imas_core.setlistDisplayModeIsCompact
import uniffi.imas_core.setlistDisplayModeFromStored
import uniffi.imas_core.setlistDisplayModes
import uniffi.imas_core.ShowCollectionRecord
import uniffi.imas_core.ShowCostumeRecord
import com.fugaif.imaslivedb.ui.theme.brandColor
import com.fugaif.imaslivedb.ui.theme.displayName
import com.fugaif.imaslivedb.ui.theme.joined
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class, ExperimentalFoundationApi::class)
@Composable
fun SetlistScreen(
    showId: String,
    onBack: () -> Unit,
    onSongClick: (String) -> Unit,
    onIdolClick: (String) -> Unit,
    /**
     * 会場/日付の行から「同じ会場・同じ日の公演一覧」へ (kind, value は
     * [com.fugaif.imaslivedb.ui.filtered.ShowFilterKind] の定義に従う)。
     */
    onFilteredShowsClick: (String, String) -> Unit = { _, _ -> },
    viewModel: SetlistViewModel = viewModel(key = showId)
) {
    val context = LocalContext.current
    val uiState by viewModel.uiState.collectAsState()
    val module = remember(context) { AppModule.from(context) }
    val marks = module.userMarkRepository
    val likeService = remember(context) { SetlistLikeService.get(context) }
    val authState by module.authService.state.collectAsState()
    // 権限フラグは認証状態が変わった時だけコアへ問い合わせる (data/auth/EditPermission.kt のヘッダ参照)。
    val canShowEditActions = remember(authState) { authState.showEditAffordance }
    val isSignedIn = remember(authState) { authState.canEdit }
    val scope = rememberCoroutineScope()

    // 会場名は「公演日時点の名前」で出す (改名前の公演は当時名)。解決には会場マスタが要るが、
    // この画面の担当範囲外である ViewModel は変えないのでここで 1 回だけ読む
    // (244 施設ぶんの小さなマスタで、公演ごとの引き直しはしない)。
    var venues by remember { mutableStateOf(VenueDirectory.EMPTY) }
    LaunchedEffect(Unit) { venues = module.eventRepository.fetchVenueDirectory() }

    // 歌唱者をどの名前で出すか。設定画面と同じ 1 箇所から読む。
    // **行の添え物 (名義) の中身がこれで変わる**ので、読み込みの鍵に入れて
    // 設定変更に画面を開き直さずに追従させる。
    val performerName = AppPreferences.performerName

    // 表示の詳しさは公演をまたいで保持する。「1 枚のスクショに収めたい」人は
    // 次の公演でも同じ見方をするので、画面を離れるたびに戻ると毎回押し直しになる。
    // **保存値からモードを決めるのも、旧 Bool からの移行も共有コアが担う。**
    var displayMode by remember { mutableStateOf(SetlistViewPrefs.displayMode(context)) }
    // 曲名と歌唱者だけに絞る形か。どのモードがそれに当たるかもコアが決める。
    val simpleMode = setlistDisplayModeIsCompact(displayMode)

    // --- マーク (参加 / お気に入り / メモ / 座席)。実体は Room なのでここで読み書きする ---
    var attendance by remember(showId) { mutableStateOf<AttendanceType?>(null) }
    var favoriteOn by remember(showId) { mutableStateOf(false) }
    var note by remember(showId) { mutableStateOf<String?>(null) }
    var seat by remember(showId) { mutableStateOf<String?>(null) }
    // 参加を付け外しすると回収の札と要約が変わるので、行の添え物を読み直す鍵に使う。
    var attendanceVersion by remember(showId) { mutableStateOf(0) }

    suspend fun reloadMarks() {
        attendance = marks.attendance(UserMark.SHOW, showId)
        favoriteOn = marks.isOn(UserMark.SHOW, showId, UserMark.FAVORITE)
        note = marks.note(UserMark.SHOW, showId)
        seat = marks.seat(UserMark.SHOW, showId)
    }
    LaunchedEffect(showId) { reloadMarks() }

    // 参加の付け外し・「配信も回収に含める」設定でも回収の札と要約が変わるので、
    // 表示モード・歌唱者の設定と同じ扱いで読み直しの鍵に入れる。
    LaunchedEffect(
        showId, performerName, displayMode, attendanceVersion, AppPreferences.includeStreamInCollection
    ) {
        viewModel.load(
            context, showId, performerName, displayMode, AppPreferences.includeStreamInCollection
        )
    }

    // --- 「良かった」投票 (post-vote)。セトリが埋まっている公演だけ取りに行く ---
    var likes by remember(showId) { mutableStateOf<Map<String, SetlistLikeService.LikeEntry>>(emptyMap()) }
    val hasSetlist = uiState.setlist.isNotEmpty()
    LaunchedEffect(showId, hasSetlist) {
        if (hasSetlist) likes = likeService.fetch(showId).associateBy { it.songId }
    }

    // セトリ編集シートに渡すイベント名 (編集画面の見出し)。
    var eventName by remember(showId) { mutableStateOf("") }
    LaunchedEffect(uiState.show?.eventId) {
        val id = uiState.show?.eventId ?: return@LaunchedEffect
        eventName = module.eventRepository.fetchEvent(id)?.name.orEmpty()
    }

    var menuOpen by remember { mutableStateOf(false) }
    var showAttendanceDialog by remember { mutableStateOf(false) }
    var showEditDialog by remember { mutableStateOf(false) }
    var showHistorySheet by remember { mutableStateOf(false) }
    var showLoginPrompt by remember { mutableStateOf(false) }

    /** 編集導線の共通ゲート。未ログインならログイン誘導、BAN は無反応 (導線自体を隠している)。 */
    fun startEdit() {
        authState.startCommunityEdit(promptLogin = { showLoginPrompt = true }) { showEditDialog = true }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(uiState.show?.name ?: "") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "戻る")
                    }
                },
                actions = {
                    IconButton(onClick = { menuOpen = true }) {
                        Icon(Icons.Filled.MoreVert, contentDescription = "その他")
                    }
                    DropdownMenu(expanded = menuOpen, onDismissRequest = { menuOpen = false }) {
                        // 3 値なのでトグルではなく選ぶ形にする。メニューの中なので
                        // 画面の行は 1 行も増えず、いま選んでいるものにチェックが付く。
                        // 並びも文言もコア (setlistDisplayModes) が持つ。
                        setlistDisplayModes().forEach { option ->
                            DropdownMenuItem(
                                text = { Text(option.label) },
                                leadingIcon = {
                                    Icon(
                                        if (option.mode == displayMode) Icons.Filled.Check
                                        else Icons.AutoMirrored.Filled.List,
                                        null
                                    )
                                },
                                onClick = {
                                    menuOpen = false
                                    displayMode = option.mode
                                    SetlistViewPrefs.setDisplayMode(context, option.raw)
                                }
                            )
                        }
                        if (canShowEditActions) {
                            DropdownMenuItem(
                                text = { Text("セトリを編集") },
                                leadingIcon = { Icon(Icons.Filled.Edit, null) },
                                onClick = { menuOpen = false; startEdit() }
                            )
                        }
                        DropdownMenuItem(
                            text = { Text("セトリの編集履歴") },
                            leadingIcon = { Icon(Icons.Filled.History, null) },
                            onClick = { menuOpen = false; showHistorySheet = true }
                        )
                    }
                }
            )
        }
    ) { innerPadding ->
        if (uiState.isLoading) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding),
                contentAlignment = Alignment.Center
            ) {
                CircularProgressIndicator()
            }
        } else {
            val isCharacterLive = uiState.show?.isCharacterLive ?: false
            val seedHex = BrandPalette.hex(uiState.brandId)
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding)
            ) {
                item {
                    if (simpleMode) {
                        // シンプル表示ではヒーローと会場カードを畳み、会場・日付の 1 行に落とす。
                        // ここが 250dp 前後あり、残したままだと 20 曲超のセトリが 1 枚の
                        // スクショに収まらない (シンプル表示を作った意味が無くなる)。
                        Column(Modifier.padding(start = 16.dp, end = 16.dp, top = 12.dp, bottom = 4.dp)) {
                            Text(
                                uiState.show?.name ?: "",
                                style = MaterialTheme.typography.titleMedium,
                                fontWeight = FontWeight.Bold,
                                color = DS.ink
                            )
                            uiState.show?.let { show ->
                                val sub = listOfNotNull(
                                    venues.displayName(show) ?: show.venue?.takeIf { it.isNotBlank() },
                                    show.date.takeIf { it.isNotBlank() }
                                ).joinToString(" ・ ")
                                if (sub.isNotEmpty()) {
                                    Text(sub, style = MaterialTheme.typography.bodySmall, color = DS.ink2)
                                }
                            }
                        }
                    } else {
                        Box(modifier = Modifier.fillMaxWidth()) {
                            GradientHeader(color = brandColor(uiState.brandId), height = 88.dp)
                            Column(modifier = Modifier.padding(start = 16.dp, end = 16.dp, top = 40.dp, bottom = 8.dp)) {
                                Text(
                                    uiState.show?.name ?: "",
                                    style = MaterialTheme.typography.titleLarge,
                                    fontWeight = FontWeight.Bold,
                                    color = DS.ink
                                )
                                uiState.show?.date?.let { d ->
                                    Text(d, style = MaterialTheme.typography.bodySmall, color = DS.ink2)
                                }
                            }
                        }
                    }
                }
                if (!simpleMode) {
                    uiState.show?.let { show ->
                        item(key = "venue_date") {
                            VenueDateCard(
                                show = show,
                                venues = venues,
                                brandId = uiState.brandId,
                                onFilteredShowsClick = onFilteredShowsClick
                            )
                        }
                        if (uiState.costumes.isNotEmpty()) {
                            item(key = "costumes") {
                                CostumeCard(costumes = uiState.costumes, brandId = uiState.brandId)
                            }
                        }
                        item(key = "mark_bar") {
                            UserMarkBar(
                                attendedLabel = attendance?.let { "参加 (${it.label})" } ?: "参加",
                                attendedOn = attendance != null,
                                onAttendedClick = { showAttendanceDialog = true },
                                favoriteOn = favoriteOn,
                                onFavoriteClick = {
                                    scope.launch {
                                        favoriteOn = marks.toggle(UserMark.SHOW, showId, UserMark.FAVORITE)
                                    }
                                },
                                note = note,
                                onNoteChange = { text ->
                                    scope.launch {
                                        marks.setNote(UserMark.SHOW, showId, text)
                                        note = marks.note(UserMark.SHOW, showId)
                                    }
                                },
                                seat = seat,
                                onSeatChange = { text ->
                                    scope.launch {
                                        marks.setSeat(UserMark.SHOW, showId, text)
                                        seat = marks.seat(UserMark.SHOW, showId)
                                    }
                                },
                                seed = seedHex,
                                modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)
                            )
                        }
                    }
                }

                if (!hasSetlist) {
                    item(key = "empty") {
                        // 公演前かどうかで文言と導線を変える。「今日」は JST 固定 (JstDay) —
                        // 端末ローカルの TZ で判定すると海外にいるユーザーだけ 1 日ずれる。
                        // 未来の公演に「セトリを追加」を出しても、まだ書ける中身が無い。
                        val isFuture = uiState.show?.date?.let { JstDay.isTodayOrLater(it) } ?: false
                        val canAdd = canShowEditActions && !isFuture
                        ImasEmptyState(
                            icon = Icons.Filled.MusicNote,
                            title = if (isFuture) "公演前です" else "セトリ未登録",
                            message = if (isFuture) "セトリは公演後に登録されます"
                            else "このライブのセトリはまだ登録されていません。ログインして編集に参加できます",
                            seed = seedHex,
                            actionTitle = if (canAdd) "セトリを追加" else null,
                            onAction = if (canAdd) ({ startEdit() }) else null
                        )
                    }
                }

                // 投票導線。シンプル表示では出さない — 行に 👍 自体が無く、
                // スクショに誘導文が写り込むだけになる。
                if (hasSetlist && !simpleMode) {
                    item(key = "vote_note") {
                        VoteHintRow(isSignedIn = isSignedIn, onLoginClick = { showLoginPrompt = true })
                    }
                }

                // 自分の回収の要約。セトリの真上に置いて、この下の並びの読み方を先に言う。
                // 出すかどうかも文言も共有コアが決める (null なら何も出さない)。
                uiState.collectionSummary?.let { summary ->
                    item(key = "collection_summary") {
                        CollectionSummaryRow(summary = summary)
                    }
                }

                uiState.sections.forEach { section ->
                    stickyHeader(key = section.sectionName) {
                        Surface(
                            color = DS.surface2,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Text(
                                text = section.sectionName,
                                style = MaterialTheme.typography.labelLarge,
                                color = DS.ink2,
                                modifier = Modifier.padding(horizontal = 16.dp, vertical = 6.dp)
                            )
                        }
                    }

                    section.items.forEachIndexed { index, item ->
                        item(key = item.id) {
                            val performers = uiState.performersByItemId[item.id] ?: emptyList()
                            val meta = uiState.rowMetaByItemId[item.id]
                            if (simpleMode) {
                                SetlistSimpleRow(
                                    item = item,
                                    displayNumber = index + 1,
                                    performerLabel = meta?.performerLabel.orEmpty(),
                                    historyBadges = meta?.historyBadges.orEmpty(),
                                    brandHex = BrandPalette.hex(item.songBrandId) ?: seedHex,
                                    onClick = { onSongClick(item.songId) }
                                )
                            } else {
                                SetlistItemRow(
                                    item = item,
                                    displayNumber = index + 1,
                                    performers = performers,
                                    unitNames = meta?.unitNames.orEmpty(),
                                    historyBadges = meta?.historyBadges.orEmpty(),
                                    collectionBadges = meta?.collectionBadges.orEmpty(),
                                    performerName = performerName,
                                    isCharacterLive = isCharacterLive,
                                    showName = uiState.show?.name,
                                    showDate = uiState.show?.date,
                                    // 感想カードの差し色。公演のブランドカラーを hex で渡す
                                    // (ブランド ID のままだと色エンジンがニュートラルへ落ちる)。
                                    seed = seedHex,
                                    likeEntry = likes[item.songId],
                                    onToggleLike = {
                                        toggleLike(
                                            scope = scope,
                                            likeService = likeService,
                                            showId = showId,
                                            songId = item.songId,
                                            current = likes[item.songId],
                                            onResult = { likes = likes + (it.songId to it) },
                                            onRequireLogin = { showLoginPrompt = true }
                                        )
                                    },
                                    onSongClick = { onSongClick(item.songId) },
                                    onIdolClick = { idolId -> onIdolClick(idolId) }
                                )
                            }
                            HorizontalDivider(modifier = Modifier.padding(start = if (simpleMode) 38.dp else 72.dp))
                        }
                    }
                }
            }
        }
    }

    if (showAttendanceDialog) {
        AttendanceDialog(
            current = attendance,
            onDismiss = { showAttendanceDialog = false },
            onSelect = { type ->
                showAttendanceDialog = false
                scope.launch {
                    marks.setAttendance(UserMark.SHOW, showId, type)
                    reloadMarks()
                    attendanceVersion++
                }
            }
        )
    }

    if (showLoginPrompt) {
        CommunityLoginPromptDialog(
            message = "セトリの編集や 👍 での投票にはログインが必要です。",
            onDismiss = { showLoginPrompt = false }
        )
    }

    val editingShow = uiState.show
    if (showEditDialog && editingShow != null) {
        Dialog(
            onDismissRequest = { showEditDialog = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            SetlistEditScreen(
                show = editingShow,
                eventName = eventName,
                onDismiss = { showEditDialog = false },
                onSaved = {
                    showEditDialog = false
                    viewModel.load(
                        context, showId, performerName, displayMode,
                        AppPreferences.includeStreamInCollection
                    )
                }
            )
        }
    }

    if (showHistorySheet) {
        SetlistEditHistorySheet(
            showId = showId,
            showName = uiState.show?.name.orEmpty(),
            onDismiss = { showHistorySheet = false }
        )
    }
}

/**
 * 👍 のトグル。押した瞬間の状態から反転を決め、サーバが返した確定値で行を更新する。
 *
 * 送信前に「ログインしているか」を見て弾かないのは意図的 — セッション更新中の一瞬に
 * トークンが空になることがあり、そこで先回りして落とすと投票が無言で失敗する。
 * 認証が要るという判断はサーバの 401 に任せ、返ってきたときだけログイン誘導を出す。
 */
private fun toggleLike(
    scope: kotlinx.coroutines.CoroutineScope,
    likeService: SetlistLikeService,
    showId: String,
    songId: String,
    current: SetlistLikeService.LikeEntry?,
    onResult: (SetlistLikeService.LikeEntry) -> Unit,
    onRequireLogin: () -> Unit
) {
    scope.launch {
        try {
            val liked = current?.hasUserLiked == true
            val result = if (liked) likeService.unlike(showId, songId)
            else likeService.like(showId, songId)
            onResult(result)
        } catch (e: SetlistLikeService.Unauthorized) {
            onRequireLogin()
        } catch (e: Exception) {
            // 通信断などは黙る。次回 fetch で正しい状態に戻る。
        }
    }
}

/** シンプル表示のオン/オフを端末に残す。画面をまたいで見方を保つためだけの 1 bit。 */
/**
 * セトリの詳しさを端末に残す。画面をまたいで見方を保つためだけの設定。
 *
 * 3 値にする前は [KEY_SIMPLE] という Bool 1 つだった。新しい鍵がまだ無い端末は
 * その Bool から移行するが、**その判断はコア (setlistDisplayModeFromStored) が持つ**
 * — iOS と Android で別々に書くと片方だけ移行しそこねる。
 */
private object SetlistViewPrefs {
    private const val PREFS_NAME = "setlist_view_prefs"
    private const val KEY_SIMPLE = "simple_mode"
    private const val KEY_MODE = "display_mode"

    fun displayMode(context: Context): SetlistDisplayMode {
        val prefs = context.applicationContext
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return setlistDisplayModeFromStored(
            prefs.getString(KEY_MODE, null),
            prefs.getBoolean(KEY_SIMPLE, false)
        )
    }

    fun setDisplayMode(context: Context, raw: String) {
        context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit().putString(KEY_MODE, raw).apply()
    }
}

/**
 * この公演への参加形態を選ぶダイアログ。
 *
 * 現地 / 配信 / LV の 3 形態を常に出す (`AttendanceType.options`)。開催情報の
 * has_streaming / has_live_viewing でフィルタしないのは、その列が欠落しやすく、
 * 「過去に LV 参加したのに記録できない」ほうが体験上の損失が大きいから
 * (iOS `AttendanceAvailability` と同じ判断)。選択中の形態をもう一度押すと不参加に戻る。
 */
@Composable
private fun AttendanceDialog(
    current: AttendanceType?,
    onDismiss: () -> Unit,
    onSelect: (AttendanceType?) -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("この公演への参加") },
        text = {
            Column {
                AttendanceType.options().forEach { type ->
                    val on = current == type
                    Text(
                        if (on) "${type.label}で参加 (取り消す)" else "${type.label}で参加",
                        fontSize = 15.sp,
                        fontWeight = if (on) FontWeight.Bold else FontWeight.Normal,
                        color = if (on) DS.ink else DS.ink2,
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { onSelect(if (on) null else type) }
                            .padding(vertical = 12.dp)
                    )
                }
            }
        },
        confirmButton = {},
        dismissButton = { TextButton(onClick = onDismiss) { Text("キャンセル") } }
    )
}

/** 「👍 で投票しよう」の案内 (未ログインならログイン導線)。 */
@Composable
private fun VoteHintRow(isSignedIn: Boolean, onLoginClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .then(if (isSignedIn) Modifier else Modifier.clickable(onClick = onLoginClick))
            .padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Icon(Icons.Filled.ThumbUp, contentDescription = null, tint = DS.pick, modifier = Modifier.size(14.dp))
        Text(
            if (isSignedIn) "良かったと思った曲に 👍 で投票しよう！"
            else "👍 で投票するにはログインが必要です",
            style = MaterialTheme.typography.bodySmall,
            color = DS.ink2
        )
    }
}

/**
 * セトリ行に添える「自分の回収」の札 1 つ。
 *
 * 色は共有コアが付けた [CollectionBadgeRole] で決める — **文字列を見て分岐しない**
 * (札の文言が増えたときに片方だけ色が付かない、という壊れ方をしないため)。
 * 未回収の文字色は枠用の薄い ink3 ではなく ink2 (AA のコントラストを満たすため)。
 */
@Composable
private fun CollectionBadgeChip(badge: CollectionBadgeRecord) {
    val collected = badge.role == CollectionBadgeRole.COLLECTED
    Surface(
        shape = RoundedCornerShape(50),
        color = if (collected) DS.success.copy(alpha = 0.16f) else DS.fill
    ) {
        Text(
            text = badge.text,
            style = MaterialTheme.typography.labelSmall,
            color = if (collected) DS.success else DS.ink2,
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
        )
    }
}

/**
 * 公演の頭に出す「自分の回収」の要約 (「この公演で 12 曲回収・初回収 4 曲」
 * 「このセトリに未回収 7 曲」)。**出すかどうかも文言も共有コアが決める** — ここは
 * `summary.attended` でアイコンと色を選ぶだけ (文言を組み立てない)。
 */
@Composable
private fun CollectionSummaryRow(summary: ShowCollectionRecord) {
    Surface(
        shape = RoundedCornerShape(50),
        color = if (summary.attended) DS.success.copy(alpha = 0.10f) else DS.fill,
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 4.dp)
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(6.dp),
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 8.dp)
        ) {
            Icon(
                imageVector = if (summary.attended) Icons.Filled.Verified else Icons.Outlined.RadioButtonUnchecked,
                contentDescription = null,
                tint = if (summary.attended) DS.success else DS.ink3,
                modifier = Modifier.size(16.dp)
            )
            Text(
                text = summary.label,
                style = MaterialTheme.typography.labelMedium,
                fontWeight = FontWeight.SemiBold,
                color = if (summary.attended) DS.ink else DS.ink2
            )
        }
    }
}

/**
 * 会場 / 日付のカード。どちらも「同じ条件の公演」への入口になる。
 *
 * 会場は ID で持つ (表記ゆれで同じ会場が分断されないように) ので、ID を持たない古い公演では
 * 押せない普通の行に落とす — 生の会場文字列でも引けはするが、押した先が表記ゆれで
 * 分断された一部だけになり、「この会場での公演」という約束を守れないため。
 */
@Composable
private fun VenueDateCard(
    show: Show,
    venues: VenueDirectory,
    brandId: String?,
    onFilteredShowsClick: (String, String) -> Unit
) {
    Column(
        Modifier.padding(horizontal = 16.dp, vertical = 8.dp).fillMaxWidth()
            .clip(RoundedCornerShape(14.dp)).background(DS.surface)
    ) {
        val venueId = show.venueId?.takeIf { it.isNotEmpty() }
        val venueLabel = venues.displayName(show) ?: show.venue
        if (!venueLabel.isNullOrEmpty()) {
            ImasLabeledRow(
                key = "会場", value = venueLabel, brand = brandId,
                tappable = venueId != null,
                onClick = venueId?.let { id -> { onFilteredShowsClick(ShowFilterKind.VENUE, id) } }
            )
            HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
        }
        if (show.date.isNotEmpty()) {
            ImasLabeledRow(
                key = "日付", value = show.date, brand = brandId, tappable = true,
                onClick = { onFilteredShowsClick(ShowFilterKind.DATE, show.date) }
            )
        }
    }
}

/**
 * その公演で着られた衣装。iOS `SetlistView` の衣装セクションと対。
 *
 * **文言はコアが組んだものをそのまま出す。** 「1・5 曲目」「公演のどこか」も
 * 「誰が着たか」も共有コアの `costume_queries` が決めており、ここで組み直すと
 * iOS / Web と表記が割れる。画像は持たない (版権物を配らない方針)。
 */
@Composable
private fun CostumeCard(costumes: List<ShowCostumeRecord>, brandId: String?) {
    Column(Modifier.padding(bottom = 8.dp).fillMaxWidth()) {
        // 見出しは共通の小見出し (iOS の ImasSectionHeader(tight:) と対)。左右の余白は
        // コンポーネント側が持つので、ここで重ねて付けない。
        ImasSectionHeader(title = "衣装 ・ ${costumes.size} 着", tight = true)
        Column(
            Modifier.padding(horizontal = 16.dp).fillMaxWidth()
                .clip(RoundedCornerShape(14.dp)).background(DS.surface)
        ) {
            costumes.forEachIndexed { index, entry ->
                if (index > 0) {
                    HorizontalDivider(color = DS.sep, modifier = Modifier.padding(start = 16.dp))
                }
                Column(Modifier.padding(horizontal = 16.dp, vertical = 10.dp).fillMaxWidth()) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            entry.costume.name,
                            style = MaterialTheme.typography.bodyMedium,
                            fontWeight = FontWeight.SemiBold,
                            color = DS.ink
                        )
                        entry.costume.attribution?.let { attribution ->
                            Spacer(Modifier.width(8.dp))
                            ImasTagChip(text = attribution, brand = brandId)
                        }
                    }
                    entry.wearersLabel?.let {
                        Text(it, style = MaterialTheme.typography.bodySmall, color = DS.ink2)
                    }
                    entry.costume.description?.let {
                        Text(it, style = MaterialTheme.typography.bodySmall, color = DS.ink2)
                    }
                }
            }
        }
    }
}

/**
 * セトリの「シンプル表示」1 行。iOS `SetlistSimpleRowView` の移植。
 *
 * 通常行はジャケ写・👍・出演者チップを載せて 1 曲 80dp 前後になり、20 曲超のライブでは
 * 3 画面ぶんスクロールが要る。この行は公式のセトリ画像と同じ **番号・曲名・演者名だけ**に
 * 絞って 1 曲 40dp 前後に収める。曲名をブランド色で出すので、色だけで所属が読み取れる。
 */
@Composable
private fun SetlistSimpleRow(
    item: SetlistRow,
    displayNumber: Int,
    performerLabel: String,
    /**
     * 披露履歴の札。**出すかどうかはコアが表示モードから決める**ので、
     * シンプル表示では常に空で来る (この行は曲名と歌唱者だけのための形)。
     */
    historyBadges: List<String>,
    brandHex: String?,
    onClick: () -> Unit
) {
    val titleColor = brandHex?.let { ImasTheme.derive(it, null, dark = true).accent } ?: DS.ink
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 12.dp, vertical = 7.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp),
        verticalAlignment = Alignment.Top
    ) {
        // 番号は幅を固定して曲名の頭を揃える (等幅数字。二桁で桁が動くと読みにくい)。
        Text(
            text = displayNumber.toString().padStart(2, '0'),
            fontSize = 12.sp,
            fontFamily = FontFamily.Monospace,
            color = DS.ink3,
            textAlign = TextAlign.End,
            modifier = Modifier.width(22.dp).padding(top = 2.dp)
        )
        Column(Modifier.weight(1f)) {
            Text(
                text = item.songTitle,
                fontSize = 15.sp,
                fontWeight = FontWeight.SemiBold,
                color = titleColor,
                maxLines = 2
            )
            if (performerLabel.isNotEmpty() || historyBadges.isNotEmpty()) {
                // 公式のセトリ画像に倣って ♪ を頭に置く。演者を横に並べると長い名前で
                // 曲名が潰れるので下段に置く。珍しさは演者の後ろに小さく添える
                // (シンプル表示は 1 枚に収めるのが目的なので行を増やさない)。
                Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                    if (performerLabel.isNotEmpty()) {
                        Text(
                            text = "♪ $performerLabel",
                            fontSize = 11.sp,
                            color = DS.ink2,
                            maxLines = 2,
                            modifier = Modifier.weight(1f, fill = false)
                        )
                    }
                    historyBadges.forEach { badge ->
                        Text(text = badge, fontSize = 11.sp, color = DS.ink3, maxLines = 1)
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalLayoutApi::class, ExperimentalFoundationApi::class)
@Composable
private fun SetlistItemRow(
    item: SetlistRow,
    displayNumber: Int,
    performers: List<PerformerRow>,
    /**
     * ユニット名の札に出す名前。**どのユニット名を出すかはコアが決める**
     * (その披露の名義 → 曲の名義 → 顔ぶれ推論)。空なら札を出さない。
     */
    unitNames: List<String>,
    /** 披露履歴の札。出すかどうかもコアが表示モードから決める (詳細表示だけ中身が入る)。 */
    historyBadges: List<String>,
    /**
     * **自分の回収**の札 (「初回収」「回収 3 回目 (2 年ぶり)」「未回収」)。行あたり多くても 1 つ。
     * 中身も出す/出さないも、色に使う `role` も共有コアが決める
     * (`collection_gap` / `setlist_collection_badges`)。ここは並べて role で色分けするだけ
     * (文字列を見て色を決めない)。
     */
    collectionBadges: List<CollectionBadgeRecord> = emptyList(),
    performerName: PerformerNameMode,
    isCharacterLive: Boolean,
    showName: String?,
    showDate: String?,
    seed: String?,
    likeEntry: SetlistLikeService.LikeEntry?,
    onToggleLike: () -> Unit,
    onSongClick: () -> Unit,
    onIdolClick: (String) -> Unit
) {
    // 長押し → 感想カード (曲名 + コメントのシェア画像) を作る。
    // 曲名タップは従来どおり曲詳細なので、行そのものの長押しに逃がしている。
    var showCommentShare by remember { mutableStateOf(false) }

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .combinedClickable(
                // 空タップにリップルだけ出て何も起きないのを避けるため、
                // 行のどこを押しても曲名タップと同じ挙動にしておく。
                onClick = onSongClick,
                onLongClick = { showCommentShare = true }
            )
            .padding(horizontal = 12.dp, vertical = 8.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp),
        verticalAlignment = Alignment.Top
    ) {
        // Position number
        Text(
            text = "$displayNumber",
            style = MaterialTheme.typography.bodySmall,
            color = DS.ink2.copy(alpha = 0.6f),
            modifier = Modifier
                .width(28.dp)
                .padding(top = 2.dp),
            textAlign = TextAlign.End
        )

        // Artwork with preview
        ArtworkImage(
            url = item.artworkUrl,
            size = 44.dp,
            previewUrl = item.previewUrl,
            songTitle = item.songTitle, songId = item.songId
        )

        // Content column
        Column(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            // Song title — tap navigates to SongDetail
            Text(
                text = item.songTitle,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.SemiBold,
                modifier = Modifier.clickable(onClick = onSongClick)
            )

            // ユニット名の札 + 珍しさの札。名前も「いつぶりか」もコアが決めた文字列で、
            // ここは並べるだけ。珍しさは塗りつぶしではなく輪郭だけにして、
            // ユニット名と競わせない (出るのは 3 行に 1 行ほど)。
            if (unitNames.isNotEmpty() || historyBadges.isNotEmpty() || collectionBadges.isNotEmpty()) {
                FlowRow(
                    horizontalArrangement = Arrangement.spacedBy(4.dp),
                    verticalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    unitNames.forEach { name ->
                        Surface(shape = RoundedCornerShape(50), color = DS.sys.copy(alpha = 0.1f)) {
                            Text(
                                text = name,
                                style = MaterialTheme.typography.labelSmall,
                                color = DS.sys,
                                modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                            )
                        }
                    }
                    historyBadges.forEach { badge ->
                        Surface(
                            shape = RoundedCornerShape(50),
                            color = Color.Transparent,
                            border = BorderStroke(1.dp, DS.ink3)
                        ) {
                            Text(
                                text = badge,
                                style = MaterialTheme.typography.labelSmall,
                                color = DS.ink2,
                                modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                            )
                        }
                    }
                    // 自分の回収の札。世の中の履歴 (輪郭) の次に置き、色で「自分の記録」と分ける。
                    // どちらの色かは共有コアが付けた role で決める (文字列を見て分岐しない)。
                    collectionBadges.forEach { badge ->
                        CollectionBadgeChip(badge = badge)
                    }
                }
            }

            // Performer chips in FlowRow
            if (performers.isNotEmpty()) {
                FlowRow(
                    horizontalArrangement = Arrangement.spacedBy(4.dp),
                    verticalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    performers.forEach { performer ->
                        PerformerChip(
                            name = performer.displayName(performerName, isCharacterLive),
                            idolColorHex = performer.idolColor,
                            modifier = Modifier.clickable(enabled = performer.idolId != null) {
                                performer.idolId?.let { onIdolClick(it) }
                            }
                        )
                    }
                }
            }

            // Notes
            if (item.notes != null) {
                Text(
                    text = item.notes,
                    style = MaterialTheme.typography.bodySmall,
                    color = DS.ink2
                )
            }
        }

        LikeButton(entry = likeEntry, onClick = onToggleLike)
    }

    if (showCommentShare) {
        SetlistCommentComposeSheet(
            songTitle = item.songTitle,
            showName = showName,
            showDate = showDate,
            seed = seed,
            artworkUrl = item.artworkUrl,
            onDismiss = { showCommentShare = false }
        )
    }
}

/**
 * 1 曲ぶんの「良かった」ボタン + 票数。
 *
 * 票が 0 の曲でも数字を出さないだけでボタンは常に出す — 押せる曲と押せない曲が
 * 混ざると「この曲には投票できない」と読めてしまうため。
 */
@Composable
private fun LikeButton(entry: SetlistLikeService.LikeEntry?, onClick: () -> Unit) {
    val liked = entry?.hasUserLiked == true
    val count = entry?.likeCount ?: 0
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.padding(top = 2.dp)
    ) {
        IconButton(onClick = onClick, modifier = Modifier.size(40.dp)) {
            Icon(
                if (liked) Icons.Filled.ThumbUp else Icons.Outlined.ThumbUp,
                contentDescription = if (liked) "Good を取り消す" else "この曲が良かった",
                tint = if (liked) DS.pick else DS.ink3,
                modifier = Modifier.size(18.dp)
            )
        }
        if (count > 0) {
            Text("$count", fontSize = 10.sp, color = DS.ink3)
        }
    }
}
