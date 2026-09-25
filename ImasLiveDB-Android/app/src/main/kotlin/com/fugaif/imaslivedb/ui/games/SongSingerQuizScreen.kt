package com.fugaif.imaslivedb.ui.games

import android.app.Application
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
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
import androidx.compose.material.icons.filled.Album
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material.icons.filled.Palette
import androidx.compose.material.icons.filled.PlayCircle
import androidx.compose.material.icons.filled.Photo
import androidx.compose.material.icons.filled.QuestionMark
import androidx.compose.material.icons.filled.Sell
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.games.GameKind
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.data.model.SoloOriginalSingerRow
import com.fugaif.imaslivedb.data.model.Song
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.player.AudioPreviewManager
import com.fugaif.imaslivedb.ui.components.ArtworkImage
import com.fugaif.imaslivedb.ui.components.ImasAvatar
import com.fugaif.imaslivedb.ui.components.ImasEmptyState
import com.fugaif.imaslivedb.ui.theme.DS
import kotlin.random.Random
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import uniffi.imas_core.QuizSessionResult
import uniffi.imas_core.QuizTally
import uniffi.imas_core.SongQuizHintKind
import uniffi.imas_core.SongQuizOriginalArtistRow
import uniffi.imas_core.SongQuizSingerRef
import uniffi.imas_core.SongSingerQuizHintState
import uniffi.imas_core.gameProgressBestRatePercent
import uniffi.imas_core.songSingerQuizAnswer
import uniffi.imas_core.songSingerQuizHintState
import uniffi.imas_core.songSingerQuizSession
import uniffi.imas_core.songSingerQuizSessionResult

// =============================================================================
// ソロ曲クイズ (ヒント式段階採点)。iOS SongSingerQuizView の移植。
// 最初は「曲名だけ」で出題し、ヒントを開くほど手がかりが増える代わりに獲得点が下がる。
//
// 母集団 (原唱が単独のソロ曲・外部ゲストや対象外ブランドの除外)、出題抽選、
// 開示段階ごとの点数はすべて imas-core の `domain::quiz_generation` が持つ。
// ここに残すのは Compose の描画・音声再生・シード調達・index → 実体の解決だけ。
// =============================================================================

/** コアが返した 1 問を、画面が描ける形 (Song / Idol 実体) に解決したもの。 */
data class SongQuestion(val song: Song, val answer: Idol, val choices: List<Idol>)

/** 4 択に使うアイドルの射影 (歌手当てなのでプロフィールは要らない)。 */
internal fun Idol.toSongQuizSingerRef(): SongQuizSingerRef =
    SongQuizSingerRef(id = id, brandId = brandId, isExternal = isExternal)

/** `song_artists(role='original')` のソロ曲ぶん 1 行。 */
internal fun SoloOriginalSingerRow.toSongQuizRow(): SongQuizOriginalArtistRow =
    SongQuizOriginalArtistRow(songId = songId, idolId = idolId)

data class SongSingerQuizUiState(
    val isLoading: Boolean = true,
    val questions: List<SongQuestion> = emptyList(),
    val index: Int = 0,
    val selectedId: String? = null,
    /** この問題で開いたヒント (開いた順)。点数はコアがここから算出する。 */
    val opened: List<SongQuizHintKind> = emptyList(),
    /** この問題で出せるヒント (タイルの並び順)。データが無いものは載らない。 */
    val available: List<SongQuizHintKind> = emptyList(),
    /** ブランド id → 短縮名 (ブランドヒントの表示用)。 */
    val brandNames: Map<String, String> = emptyMap(),
    /** 開示範囲・次のヒント・いまの獲得点。コアが返す。 */
    val hintState: SongSingerQuizHintState? = null,
    val tally: QuizTally = QuizTally(asked = 0u, correct = 0u, points = 0u),
    val isLastQuestion: Boolean = false,
    val history: List<QuizHistoryItem> = emptyList(),
    val result: QuizSessionResult? = null,
    val isNewBest: Boolean = false,
    val bestRatePercent: Int = 0
) {
    val question: SongQuestion? get() = questions.getOrNull(index)
}

class SongSingerQuizViewModel(app: Application, private val selectedBrandIds: Set<String>) : AndroidViewModel(app) {
    private val idolRepository = AppModule.from(app).idolRepository
    private val songRepository = AppModule.from(app).songRepository
    private val progressStore = AppModule.from(app).gameProgressStore
    private val stats = AppModule.from(app).statsRepository

    private val _uiState = MutableStateFlow(SongSingerQuizUiState())
    val uiState: StateFlow<SongSingerQuizUiState> = _uiState.asStateFlow()

    /** 出題生成に渡した並び。コアが返す index はこの配列を指す。 */
    private var singers: List<Idol> = emptyList()
    private var rows: List<SoloOriginalSingerRow> = emptyList()
    private var brandNames: Map<String, String> = emptyMap()

    init {
        viewModelScope.launch {
            singers = idolRepository.fetchIdols()
            rows = songRepository.fetchSoloOriginalSingers()
            brandNames = stats.fetchBrands().associate { it.id to it.shortName }
            _uiState.value = withHintState(
                SongSingerQuizUiState(isLoading = false, questions = makeSession(), brandNames = brandNames)
            )
        }
    }

    /** 1 ゲーム分 (全 [QUIZ_SESSION_LENGTH] 問) をまとめて生成する。候補不足なら空。 */
    private suspend fun makeSession(): List<SongQuestion> {
        val questions = songSingerQuizSession(
            rows = rows.map { it.toSongQuizRow() },
            singers = singers.map { it.toSongQuizSingerRef() },
            selectedBrandIds = selectedBrandIds.toList(),
            // シードの調達だけがラッパの責務 (抽選そのものはコアの SplitMix64)。
            seed = Random.Default.nextLong().toULong()
        )
        if (questions.isEmpty()) return emptyList()
        // 曲の実体は出題が決まってから 1 回でまとめて引く (問題ごとに DB を叩かない)。
        val songById = songRepository.fetchSongsByIds(questions.map { it.songId }.distinct()).associateBy { it.id }
        return questions.mapNotNull { q ->
            val song = songById[q.songId] ?: return@mapNotNull null
            SongQuestion(
                song = song,
                answer = singers[q.answer.toInt()],
                choices = q.choices.map { singers[it.toInt()] }
            )
        }
    }

    /**
     * この問題で出せるヒント (iOS `availableHints` と同じ条件)。データが無いもの、
     * 選択肢が全員同じブランドのときのブランドは外す。
     */
    private fun availableHints(q: SongQuestion): List<SongQuizHintKind> = buildList {
        if (!q.song.cdTitle.isNullOrEmpty()) add(SongQuizHintKind.CD)
        if (brandNames[q.answer.brandId] != null && q.choices.map { it.brandId }.toSet().size > 1) {
            add(SongQuizHintKind.BRAND)
        }
        if (!q.answer.color.isNullOrEmpty()) add(SongQuizHintKind.COLOR)
        if (!q.song.artworkUrl.isNullOrEmpty()) add(SongQuizHintKind.ARTWORK)
        if (!q.song.previewUrl.isNullOrEmpty()) add(SongQuizHintKind.PREVIEW)
    }

    /** 開示状態を引き直す。ヒント開封・解答・次問のたびに 1 回だけ呼ぶ。 */
    private fun withHintState(state: SongSingerQuizUiState): SongSingerQuizUiState {
        val q = state.question ?: return state.copy(hintState = null, available = emptyList())
        val available = availableHints(q)
        return state.copy(
            available = available,
            hintState = songSingerQuizHintState(
                opened = state.opened,
                available = available,
                answered = state.selectedId != null
            )
        )
    }

    fun openHint(kind: SongQuizHintKind) {
        val s = _uiState.value
        val song = s.question?.song ?: return
        if (s.selectedId != null || s.opened.contains(kind)) return
        // 開けるか (試聴はジャケットの後) はコアが返すヒント一覧で決まる。
        val option = s.hintState?.hints?.firstOrNull { it.kind == kind } ?: return
        if (option.locked) return
        _uiState.value = withHintState(s.copy(opened = s.opened + kind))
        if (kind == SongQuizHintKind.PREVIEW) {
            song.previewUrl?.takeIf { it.isNotEmpty() }?.let {
                AudioPreviewManager.togglePreview(it, song.id)
            }
        }
    }

    fun pick(idol: Idol) {
        val s = _uiState.value
        val q = s.question ?: return
        if (s.selectedId != null) return
        AudioPreviewManager.stop()
        val outcome = songSingerQuizAnswer(
            opened = s.opened,
            pickedIdolId = idol.id,
            answerIdolId = q.answer.id,
            before = s.tally
        )
        val history = s.history + QuizHistoryItem(
            id = "${outcome.tally.asked}-${q.song.id}",
            index = outcome.tally.asked.toInt(),
            subjectTitle = q.song.title, subjectSubtitle = q.song.cdTitle,
            answer = q.answer, picked = idol,
            earnedPoints = outcome.earnedPoints.toInt(),
            revealedHints = outcome.revealedHints.toInt()
        )
        _uiState.value = withHintState(
            s.copy(
                selectedId = idol.id,
                tally = outcome.tally,
                isLastQuestion = outcome.isLastQuestion,
                history = history
            )
        )
    }

    fun nextQuestion() {
        AudioPreviewManager.stop()
        val s = _uiState.value
        _uiState.value = withHintState(s.copy(index = s.index + 1, selectedId = null, opened = emptyList()))
    }

    fun finish() {
        val s = _uiState.value
        val result = songSingerQuizSessionResult(s.tally)
        // 保存 → 保存後の記録から自己ベスト率を読む、の順で組む (更新判定は保存側の担当)。
        val update = progressStore.recordResult(
            GameKind.songSingerQuiz, score = result.points.toInt(), outOf = result.outOf.toInt()
        )
        _uiState.value = s.copy(
            result = result,
            isNewBest = update.isNewBest,
            // まだ記録が無ければ今回の率で代用する。
            bestRatePercent = gameProgressBestRatePercent(update.record) ?: result.ratePercent.toInt()
        )
    }

    fun restart() {
        AudioPreviewManager.stop()
        viewModelScope.launch {
            _uiState.value = withHintState(
                SongSingerQuizUiState(isLoading = false, questions = makeSession(), brandNames = brandNames)
            )
        }
    }

    class Factory(private val app: Application, private val selectedBrandIds: Set<String>) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T =
            SongSingerQuizViewModel(app, selectedBrandIds) as T
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SongSingerQuizScreen(
    selectedBrandIds: Set<String>,
    onBack: () -> Unit,
    viewModel: SongSingerQuizViewModel = viewModel(
        factory = SongSingerQuizViewModel.Factory(
            LocalContext.current.applicationContext as Application, selectedBrandIds
        )
    )
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    DisposableEffect(Unit) { onDispose { AudioPreviewManager.stop() } }
    val question = state.question
    val hintState = state.hintState
    val result = state.result

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("ソロ曲クイズ", fontWeight = FontWeight.Bold) },
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, "戻る") } }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier.fillMaxSize().padding(padding).background(DS.bg).verticalScroll(rememberScrollState()).padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            when {
                state.isLoading -> Box(Modifier.fillMaxWidth().padding(top = 60.dp), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
                result != null -> QuizResultView(
                    result = result, kind = GameKind.songSingerQuiz,
                    isNewBest = state.isNewBest, bestRate = state.bestRatePercent,
                    history = state.history, onReplay = { viewModel.restart() }
                )
                question != null && hintState != null -> {
                    QuizProgressHeader(
                        current = minOf(state.tally.asked.toInt() + if (state.selectedId != null) 0 else 1, QUIZ_SESSION_LENGTH),
                        total = QUIZ_SESSION_LENGTH, points = state.tally.points.toInt()
                    )
                    SongCard(question, hintState, answered = state.selectedId != null)
                    SongHintTiles(question, state.available, hintState, state.brandNames) { viewModel.openHint(it) }
                    IdolChoiceGrid(choices = question.choices, answer = question.answer, selectedId = state.selectedId) { idol, _ ->
                        viewModel.pick(idol)
                    }
                    if (state.selectedId != null) {
                        QuizNextButton(isLastQuestion = state.isLastQuestion, onNext = { viewModel.nextQuestion() }, onFinish = { viewModel.finish() })
                    }
                }
                else -> ImasEmptyState(icon = Icons.Filled.MusicNote, title = "出題できるソロ曲が不足しています")
            }
        }
    }
}

@Composable
private fun SongCard(q: SongQuestion, hintState: SongSingerQuizHintState, answered: Boolean) {
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(16.dp)).background(DS.surface).padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        if (!answered) QuizValueBadge(points = hintState.currentValue.toInt())
        if (hintState.showArtwork) {
            ArtworkImage(
                url = q.song.artworkUrl, size = 132.dp,
                previewUrl = if (hintState.canPreview) q.song.previewUrl else null,
                songTitle = q.song.title, songId = q.song.id
            )
        } else {
            Box(
                modifier = Modifier.size(132.dp).clip(RoundedCornerShape(16.dp)).background(DS.fill),
                contentAlignment = Alignment.Center
            ) { Icon(Icons.Filled.QuestionMark, null, tint = DS.ink3, modifier = Modifier.size(44.dp)) }
        }
        Text(q.song.title, fontSize = 20.sp, fontWeight = FontWeight.Bold, color = DS.ink, textAlign = TextAlign.Center)
        // 収録CD はヒントなので、解答前は開くまで出さない。
        if (answered) {
            q.song.cdTitle?.takeIf { it.isNotEmpty() }?.let { Text(it, fontSize = 12.sp, color = DS.ink3) }
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                ImasAvatar(label = q.answer.name, seed = q.answer.color, brand = q.answer.brandId, size = 28.dp)
                Text("正解: ${q.answer.name}", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
            }
        }
    }
}

private fun SongQuizHintKind.title(): String = when (this) {
    SongQuizHintKind.CD -> "収録CD"
    SongQuizHintKind.BRAND -> "ブランド"
    SongQuizHintKind.COLOR -> "イメージカラー"
    SongQuizHintKind.ARTWORK -> "ジャケット"
    SongQuizHintKind.PREVIEW -> "試聴"
}

private fun SongQuizHintKind.icon(): ImageVector = when (this) {
    SongQuizHintKind.CD -> Icons.Filled.Album
    SongQuizHintKind.BRAND -> Icons.Filled.Sell
    SongQuizHintKind.COLOR -> Icons.Filled.Palette
    SongQuizHintKind.ARTWORK -> Icons.Filled.Photo
    SongQuizHintKind.PREVIEW -> Icons.Filled.PlayCircle
}

/**
 * 出せるヒントをタイルで並べる (3 列、はみ出したら折り返す)。
 * 未開封 = 「名前 −コスト」で開く / ロック中 = 押せない / 開封済み = 中身を表示。
 * 開いたか・コスト・ロックはすべてコアの [SongSingerQuizHintState] が返す。
 */
@Composable
private fun SongHintTiles(
    q: SongQuestion,
    available: List<SongQuizHintKind>,
    hintState: SongSingerQuizHintState,
    brandNames: Map<String, String>,
    onOpen: (SongQuizHintKind) -> Unit
) {
    if (available.isEmpty()) return
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        available.chunked(3).forEach { row ->
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.fillMaxWidth()) {
                row.forEach { kind ->
                    Box(Modifier.weight(1f)) {
                        if (hintState.shown.contains(kind)) {
                            when (kind) {
                                SongQuizHintKind.CD -> QuizHintTile(kind.title(), kind.icon(), value = q.song.cdTitle ?: "—")
                                SongQuizHintKind.BRAND -> QuizHintTile(kind.title(), kind.icon(), value = brandNames[q.answer.brandId] ?: "—")
                                SongQuizHintKind.COLOR -> QuizHintTile(kind.title(), kind.icon(), value = q.answer.color ?: "—", swatchHex = q.answer.color)
                                SongQuizHintKind.ARTWORK -> QuizHintTile(kind.title(), kind.icon(), value = "表示中")
                                SongQuizHintKind.PREVIEW -> QuizHintTile(kind.title(), kind.icon(), value = "再生中")
                            }
                        } else {
                            val option = hintState.hints.firstOrNull { it.kind == kind }
                            if (option != null) {
                                QuizHintTile(
                                    kind.title(), kind.icon(), value = null, cost = option.cost.toInt(), locked = option.locked,
                                    onClick = { onOpen(kind) }
                                )
                            }
                        }
                    }
                }
                repeat(3 - row.size) { Box(Modifier.weight(1f)) }
            }
        }
    }
}
