package com.fugaif.imaslivedb.ui.games

import android.app.Application
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.FormatListNumbered
import androidx.compose.material.icons.filled.Groups
import androidx.compose.material.icons.filled.UnfoldMore
import androidx.compose.material.icons.filled.Filter2
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.games.GameKind
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.ui.components.ImasEmptyState
import com.fugaif.imaslivedb.ui.theme.DS
import com.fugaif.imaslivedb.ui.theme.hexToColor
import kotlin.random.Random
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import uniffi.imas_core.QuizSessionResult
import uniffi.imas_core.QuizTally
import uniffi.imas_core.SetlistQuizHintKind
import uniffi.imas_core.SetlistQuizHintState
import uniffi.imas_core.SetlistQuizLine
import uniffi.imas_core.SetlistQuizQuestion
import uniffi.imas_core.gameProgressBestRatePercent
import uniffi.imas_core.setlistQuizAnswer
import uniffi.imas_core.setlistQuizHintState
import uniffi.imas_core.setlistQuizSessionResult
import uniffi.imas_core.setlistSectionLabel

// =============================================================================
// セトリ当てクイズ。iOS SetlistQuizView の移植。
// 公演のセトリの 1 曲を伏せ、そこに入る曲を 4 択で当てる。最初は伏せた曲の前後 2 曲ずつだけ見せ、
// ヒント (前後をもっと見る / 歌唱メンバー / 2択) を開くほど獲得点が下がる。
//
// 公演の選び方・伏せる曲・誤答の選び方・見せる範囲・採点は imas-core の
// `domain/setlist_quiz.rs` にあり、iOS と同じ実装を共有する。この画面は描画とシード調達だけ。
// =============================================================================

/** 解答直後の判定表示 (正誤・獲得点・正解/選んだ曲)。 */
data class SetlistQuizVerdict(
    val isCorrect: Boolean,
    val earnedPoints: Int,
    val baseValue: Int,
    val answerTitle: String,
    val pickedTitle: String?
)

data class SetlistQuizUiState(
    val isLoading: Boolean = true,
    val questions: List<SetlistQuizQuestion> = emptyList(),
    val index: Int = 0,
    /** この問題で開いたヒント (開いた順)。点数はコアがここから算出する。 */
    val opened: List<SetlistQuizHintKind> = emptyList(),
    /** 見せる範囲・次のヒント・いまの獲得点。コアが返す。 */
    val hintState: SetlistQuizHintState? = null,
    val pickedSongId: String? = null,
    val verdict: SetlistQuizVerdict? = null,
    val tally: QuizTally = QuizTally(asked = 0u, correct = 0u, points = 0u),
    val isLastQuestion: Boolean = false,
    val result: QuizSessionResult? = null,
    val isNewBest: Boolean = false,
    val bestRatePercent: Int = 0
) {
    val question: SetlistQuizQuestion? get() = questions.getOrNull(index)
    val answered: Boolean get() = pickedSongId != null
}

class SetlistQuizViewModel(app: Application, private val selectedBrandIds: Set<String>) : AndroidViewModel(app) {
    private val snapshots = AppModule.from(app).snapshotStoreProvider
    private val progressStore = AppModule.from(app).gameProgressStore

    private val _uiState = MutableStateFlow(SetlistQuizUiState())
    val uiState: StateFlow<SetlistQuizUiState> = _uiState.asStateFlow()

    init {
        startSession()
    }

    /** 1 ゲーム分の出題をコアに一括生成させる。候補不足・読み込み失敗なら空。 */
    private suspend fun makeSession(): List<SetlistQuizQuestion> {
        // シードの調達だけがラッパの責務 (抽選そのものはコアの SplitMix64)。
        val seed = Random.Default.nextLong().toULong()
        val brandIds = selectedBrandIds.toList()
        return runCatching {
            snapshots.query { store -> store.setlistQuizSession(brandIds, seed) }
        }.getOrDefault(emptyList())
    }

    private fun withHintState(state: SetlistQuizUiState): SetlistQuizUiState {
        val q = state.question ?: return state.copy(hintState = null)
        return state.copy(hintState = setlistQuizHintState(q, state.opened, state.answered))
    }

    fun openHint(kind: SetlistQuizHintKind) {
        val s = _uiState.value
        if (s.question == null || s.answered || s.opened.contains(kind)) return
        if (s.hintState?.hints?.none { it.kind == kind } != false) return
        _uiState.value = withHintState(s.copy(opened = s.opened + kind))
    }

    fun pick(songId: String) {
        val s = _uiState.value
        val q = s.question ?: return
        if (s.answered) return
        val outcome = setlistQuizAnswer(q, s.opened, songId, s.tally)
        val picked = q.choices.firstOrNull { it.songId == songId }?.title
        _uiState.value = withHintState(
            s.copy(
                pickedSongId = songId,
                tally = outcome.tally,
                isLastQuestion = outcome.isLastQuestion,
                verdict = SetlistQuizVerdict(
                    isCorrect = outcome.isCorrect,
                    earnedPoints = outcome.earnedPoints.toInt(),
                    baseValue = s.hintState?.baseValue?.toInt() ?: 0,
                    answerTitle = q.answer.title,
                    pickedTitle = if (outcome.isCorrect) null else picked
                )
            )
        )
    }

    fun nextQuestion() {
        val s = _uiState.value
        _uiState.value = withHintState(
            s.copy(index = s.index + 1, opened = emptyList(), pickedSongId = null, verdict = null)
        )
    }

    fun finish() {
        val s = _uiState.value
        val result = setlistQuizSessionResult(s.tally)
        // 保存 → 保存後の記録から自己ベスト率を読む、の順で組む (更新判定は保存側の担当)。
        val update = progressStore.recordResult(
            GameKind.setlistQuiz, score = result.points.toInt(), outOf = result.outOf.toInt()
        )
        _uiState.value = s.copy(
            result = result,
            verdict = null,
            isNewBest = update.isNewBest,
            bestRatePercent = gameProgressBestRatePercent(update.record) ?: result.ratePercent.toInt()
        )
    }

    fun restart() = startSession()

    private fun startSession() {
        viewModelScope.launch {
            _uiState.value = withHintState(SetlistQuizUiState(isLoading = false, questions = makeSession()))
        }
    }

    class Factory(private val app: Application, private val selectedBrandIds: Set<String>) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T =
            SetlistQuizViewModel(app, selectedBrandIds) as T
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SetlistQuizScreen(
    selectedBrandIds: Set<String>,
    onBack: () -> Unit,
    viewModel: SetlistQuizViewModel = viewModel(
        factory = SetlistQuizViewModel.Factory(
            LocalContext.current.applicationContext as Application, selectedBrandIds
        )
    )
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val question = state.question
    val hintState = state.hintState
    val result = state.result
    val verdict = state.verdict

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("セトリ当て", fontWeight = FontWeight.Bold) },
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
                    result = result, kind = GameKind.setlistQuiz,
                    isNewBest = state.isNewBest, bestRate = state.bestRatePercent,
                    // 振り返り一覧はアイドル前提の行なので、セトリ当てでは出さない。
                    history = emptyList(), onReplay = { viewModel.restart() }
                )
                question != null && hintState != null -> {
                    QuizProgressHeader(
                        current = minOf(state.tally.asked.toInt() + if (state.answered) 0 else 1, QUIZ_SESSION_LENGTH),
                        total = QUIZ_SESSION_LENGTH, points = state.tally.points.toInt()
                    )
                    SetlistCard(question, hintState, answered = state.answered)
                    if (verdict != null) {
                        SetlistVerdictCard(verdict)
                        QuizNextButton(
                            isLastQuestion = state.isLastQuestion,
                            onNext = { viewModel.nextQuestion() }, onFinish = { viewModel.finish() }
                        )
                    } else {
                        SetlistHintTiles(question, state.opened, hintState) { viewModel.openHint(it) }
                        SetlistChoiceList(question, hintState) { viewModel.pick(it) }
                    }
                }
                else -> ImasEmptyState(icon = Icons.Filled.FormatListNumbered, title = "出題できる公演がありません")
            }
        }
    }
}

// MARK: - 出題カード

@Composable
private fun SetlistCard(q: SetlistQuizQuestion, hint: SetlistQuizHintState, answered: Boolean) {
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(16.dp)).background(DS.surface).padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        if (!answered) QuizValueBadge(points = hint.currentValue.toInt())
        Text("空欄に入る曲は？", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = DS.ink3)
        Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
            Text(
                q.eventName, fontSize = 20.sp, fontWeight = FontWeight.Black, color = DS.ink,
                maxLines = 2, overflow = TextOverflow.Ellipsis
            )
            val meta = listOfNotNull(q.showName, q.date.replace("-", "."), q.venue)
                .filter { it.isNotEmpty() }.joinToString(" · ")
            Text(meta, fontSize = 12.sp, fontWeight = FontWeight.Bold, color = DS.ink3, maxLines = 2, overflow = TextOverflow.Ellipsis)
        }
        SetlistLines(q, hint)
        if (hint.showPerformers && q.performers.isNotEmpty()) SetlistPerformers(q)
    }
}

/** 見せる範囲のセトリ。隠れている分は「⋮ 前に N 曲」と畳む。 */
@Composable
private fun SetlistLines(q: SetlistQuizQuestion, hint: SetlistQuizHintState) {
    val from = hint.visibleFrom.toInt()
    val to = hint.visibleTo.toInt()
    val visible = if (from in q.lines.indices && to in q.lines.indices && from <= to) q.lines.subList(from, to + 1) else emptyList()
    Column {
        if (hint.hiddenBefore > 0u) HiddenRow("前に ${hint.hiddenBefore} 曲")
        visible.forEachIndexed { offset, line ->
            val i = offset + from
            val label = setlistSectionLabel(line.section)
            val previous = if (i > 0) setlistSectionLabel(q.lines[i - 1].section) else null
            if (label != null && (i == 0 || previous != label)) {
                Text(
                    label, fontSize = 11.sp, fontFamily = FontFamily.Monospace, letterSpacing = 1.2.sp,
                    color = DS.ink3, modifier = Modifier.padding(top = 8.dp, bottom = 2.dp)
                )
            }
            LineRow(line, reveal = hint.revealAnswer)
        }
        if (hint.hiddenAfter > 0u) HiddenRow("後に ${hint.hiddenAfter} 曲")
    }
}

@Composable
private fun HiddenRow(text: String) {
    Row(
        modifier = Modifier.heightIn(min = 30.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text("⋮", fontSize = 16.sp, fontWeight = FontWeight.Black, color = DS.ink3, modifier = Modifier.width(38.dp))
        Text(text, fontSize = 12.sp, fontWeight = FontWeight.Bold, color = DS.ink3)
    }
}

@Composable
private fun LineRow(line: SetlistQuizLine, reveal: Boolean) {
    val stamp = DS.danger
    Row(
        modifier = Modifier.fillMaxWidth().heightIn(min = 34.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text(
            "M%02d".format(line.number.toInt()), fontSize = 12.sp, fontFamily = FontFamily.Monospace,
            color = if (line.isBlank) stamp else DS.ink3, modifier = Modifier.width(38.dp)
        )
        if (line.isBlank) {
            Box(
                modifier = Modifier
                    .weight(1f)
                    .padding(vertical = 2.dp)
                    .drawBehind {
                        val stroke = 2.dp.toPx()
                        drawRoundRect(
                            color = stamp,
                            topLeft = androidx.compose.ui.geometry.Offset(stroke / 2, stroke / 2),
                            size = androidx.compose.ui.geometry.Size(size.width - stroke, size.height - stroke),
                            cornerRadius = CornerRadius(10.dp.toPx()),
                            style = Stroke(
                                width = stroke,
                                pathEffect = if (reveal) null else PathEffect.dashPathEffect(floatArrayOf(5.dp.toPx(), 4.dp.toPx()))
                            )
                        )
                    }
                    .padding(horizontal = 12.dp, vertical = 6.dp)
            ) {
                Text(
                    if (reveal) line.songTitle else "？？？",
                    fontSize = 16.sp, fontWeight = FontWeight.Black,
                    color = if (reveal) DS.ink else stamp,
                    maxLines = 1, overflow = TextOverflow.Ellipsis
                )
            }
        } else {
            Text(
                line.songTitle, fontSize = 15.sp, fontWeight = FontWeight.Bold, color = DS.ink,
                maxLines = 1, overflow = TextOverflow.Ellipsis, modifier = Modifier.weight(1f)
            )
        }
    }
}

@Composable
private fun SetlistPerformers(q: SetlistQuizQuestion) {
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(14.dp)).background(DS.fill).padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Text("歌唱メンバー", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = DS.ink3)
        Text(q.performers.joinToString("、") { it.name }, fontSize = 14.sp, fontWeight = FontWeight.Bold, color = DS.ink)
        Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
            q.performers.take(16).forEach { p ->
                val color = p.color?.takeIf { it.isNotEmpty() }?.let { hexToColor(it) } ?: DS.ink3
                Box(Modifier.width(8.dp).heightIn(min = 20.dp).clip(RoundedCornerShape(4.dp)).background(color))
            }
        }
    }
}

// MARK: - ヒント

private fun SetlistQuizHintKind.title(): String = when (this) {
    SetlistQuizHintKind.WIDER -> "前後をもっと見る"
    SetlistQuizHintKind.PERFORMERS -> "歌唱メンバー"
    SetlistQuizHintKind.FIFTY_FIFTY -> "2択にする"
}

private fun SetlistQuizHintKind.icon(): ImageVector = when (this) {
    SetlistQuizHintKind.WIDER -> Icons.Filled.UnfoldMore
    SetlistQuizHintKind.PERFORMERS -> Icons.Filled.Groups
    SetlistQuizHintKind.FIFTY_FIFTY -> Icons.Filled.Filter2
}

private fun SetlistQuizHintKind.openedValue(q: SetlistQuizQuestion): String = when (this) {
    SetlistQuizHintKind.WIDER -> "全${q.lines.size}曲"
    SetlistQuizHintKind.PERFORMERS -> "${q.performers.size}人"
    SetlistQuizHintKind.FIFTY_FIFTY -> "2曲に"
}

/** ヒントのタイル (開いたものも同じ位置に残す)。出せるか・コストはコアの [SetlistQuizHintState] が返す。 */
@Composable
private fun SetlistHintTiles(
    q: SetlistQuizQuestion,
    opened: List<SetlistQuizHintKind>,
    hint: SetlistQuizHintState,
    onOpen: (SetlistQuizHintKind) -> Unit
) {
    val offered = hint.hints.map { it.kind }.toSet()
    val kinds = listOf(SetlistQuizHintKind.WIDER, SetlistQuizHintKind.PERFORMERS, SetlistQuizHintKind.FIFTY_FIFTY)
        .filter { it in opened || it in offered }
    if (kinds.isEmpty()) return
    Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.fillMaxWidth()) {
        kinds.forEach { kind ->
            Box(Modifier.weight(1f)) {
                val option = hint.hints.firstOrNull { it.kind == kind }
                if (option != null) {
                    QuizHintTile(kind.title(), kind.icon(), value = null, cost = option.cost.toInt(), onClick = { onOpen(kind) })
                } else {
                    QuizHintTile(kind.title(), kind.icon(), value = kind.openedValue(q))
                }
            }
        }
        repeat(3 - kinds.size) { Box(Modifier.weight(1f)) }
    }
}

// MARK: - 選択肢・判定

/** 4 択 (1 列)。2 択ヒントで消した選択肢は押せず薄く出す。 */
@Composable
private fun SetlistChoiceList(q: SetlistQuizQuestion, hint: SetlistQuizHintState, onPick: (String) -> Unit) {
    val eliminated = hint.eliminated.map { it.toInt() }.toSet()
    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        q.choices.forEachIndexed { i, choice ->
            val disabled = i in eliminated
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .alpha(if (disabled) 0.35f else 1f)
                    .clip(RoundedCornerShape(14.dp))
                    .background(DS.surface)
                    .clickable(enabled = !disabled) { onPick(choice.songId) }
                    .padding(horizontal = 16.dp, vertical = 14.dp)
            ) {
                Text(
                    choice.title, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink,
                    maxLines = 2, overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}

@Composable
private fun SetlistVerdictCard(v: SetlistQuizVerdict) {
    val tone: Color = if (v.isCorrect) DS.success else DS.danger
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(tone.copy(alpha = 0.12f))
            .border(1.5.dp, tone, RoundedCornerShape(16.dp))
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Icon(if (v.isCorrect) Icons.Filled.CheckCircle else Icons.Filled.Cancel, null, tint = tone, modifier = Modifier.size(22.dp))
            Text(if (v.isCorrect) "正解" else "不正解", fontSize = 20.sp, fontWeight = FontWeight.Black, color = tone)
            Box(Modifier.weight(1f))
            Text(
                "+${v.earnedPoints}pt", fontSize = 16.sp, fontWeight = FontWeight.Bold,
                color = if (v.earnedPoints > 0) DS.success else DS.ink3
            )
        }
        Text("正解: ${v.answerTitle}", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
        v.pickedTitle?.let {
            Text("あなたの解答: $it", fontSize = 13.sp, color = DS.ink3)
        }
    }
}
