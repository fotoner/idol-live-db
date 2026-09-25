package com.fugaif.imaslivedb.ui.games

import android.app.Application
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.ContentCut
import androidx.compose.material.icons.filled.EmojiEvents
import androidx.compose.material.icons.filled.Palette
import androidx.compose.material.icons.filled.QuestionMark
import androidx.compose.material.icons.filled.Verified
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.games.GameKind
import com.fugaif.imaslivedb.data.model.Brand
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.ui.components.ImasAvatar
import com.fugaif.imaslivedb.ui.components.ImasSegmented
import com.fugaif.imaslivedb.ui.theme.DS
import com.fugaif.imaslivedb.ui.theme.hexToColor
import kotlin.random.Random
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import uniffi.imas_core.ColorMatchAssignment
import uniffi.imas_core.ColorMatchBrandRef
import uniffi.imas_core.ColorMatchDifficulty
import uniffi.imas_core.ColorMatchIdol
import uniffi.imas_core.ColorMatchIdolSource
import uniffi.imas_core.ColorMatchJudgement
import uniffi.imas_core.ColorMatchPools
import uniffi.imas_core.ColorMatchRound
import uniffi.imas_core.ColorQuizHintKind
import uniffi.imas_core.ColorQuizHintState
import uniffi.imas_core.ColorQuizQuestion
import uniffi.imas_core.QuizSessionResult
import uniffi.imas_core.QuizTally
import uniffi.imas_core.colorMatchAccuracyPercent
import uniffi.imas_core.colorMatchBuildPools
import uniffi.imas_core.colorMatchEffectivePool
import uniffi.imas_core.colorMatchJudgeRound
import uniffi.imas_core.colorMatchStartGame
import uniffi.imas_core.colorQuizAnswer
import uniffi.imas_core.colorQuizHintState
import uniffi.imas_core.colorQuizSessionResult
import uniffi.imas_core.colorQuizStartGame
import uniffi.imas_core.gameProgressBestRatePercent

// =============================================================================
// メンバーカラー合わせ。iOS ColorMatchGameView の移植。
// 遊び方は 2 つ: 4択 (名前 → イメージカラーを 4 色から選ぶ・ヒント式採点) と 並べる。
// 並べるはドラッグ&ドロップの代わりに「色チップをタップで選択 → メンバー行をタップで割当」方式のみ提供
// (iOS 側もタップ割当を併存させているため、機能的な等価性は保たれる)。
//
// 母集団の決定 (外部ゲスト・対象外ブランド・色の重複の除外)、難易度ごとの出題、
// 色の一致判定・正答率は imas-core の `domain::color_match` が持つ。
// ここに残すのは Compose の描画とシードの調達、id → Idol の解決だけ。
// =============================================================================

private val PLAY_MODE_LABELS = listOf("4択", "並べる")
private val LEVEL_LABELS = listOf("やさしい", "ふつう", "むずい")
private val QUESTION_COUNT_OPTIONS = listOf(5, 10)

/**
 * 「はじめる」を許す最小の母集団人数。コア `domain::color_match::MIN_POOL_SIZE` と同値だが、
 * 定数 1 個のために FFI 面を増やさないのでここに写している (増減はコアに追従させる)。
 */
private const val MIN_POOL_SIZE = 2

/** 4択は 4 色並べるので 4 人要る。 */
private const val MIN_CHOICE_POOL_SIZE = 4

/** UI の難易度セグメント (0/1/2) → コアの難易度。並び順で対応する。 */
private fun difficultyOf(segment: Int): ColorMatchDifficulty =
    ColorMatchDifficulty.entries.getOrElse(segment) { ColorMatchDifficulty.NORMAL }

data class ColorMatchUiState(
    val isLoading: Boolean = true,
    /** 出題ブランドとして選べるブランド (コアの selectable_brand_ids 順)。 */
    val brands: List<Brand> = emptyList(),
    /** 出題可能ブランド (4 人以上) の短縮名。ブランド跨ぎの行に添える。 */
    val brandShortNames: Map<String, String> = emptyMap(),
    /** 出題メンバー (id と色だけ) から名前などを引くための索引。 */
    val idolsById: Map<String, Idol> = emptyMap(),
    val selectedBrandIds: Set<String> = emptySet(),
    /** 現在の出題母集団の人数 (「はじめる」の可否判定に使う)。 */
    val poolSize: Int = 0,
    /** 遊び方: 0=4択 / 1=並べる。 */
    val playMode: Int = 0,
    val difficulty: Int = 1,
    val questionCount: Int = 5,
    val inGame: Boolean = false,
    val sessionDone: Boolean = false,
    val roundIndex: Int = 0,
    val totalCorrect: Int = 0,
    val totalAnswered: Int = 0,
    /** 1 ゲーム分の出題。開始操作 1 回でまとめて生成する。 */
    val rounds: List<ColorMatchRound> = emptyList(),
    val assignments: Map<String, String> = emptyMap(),
    val selectedHex: String? = null,
    /** 答え合わせ結果 (未判定は null)。行の正誤も正解色の表示文字列もここに入っている。 */
    val judgement: ColorMatchJudgement? = null,
    // --- 4択 ---
    /** 1 ゲーム分の 4 択 (「はじめる」1 回でコアがまとめて生成)。 */
    val choiceQuestions: List<ColorQuizQuestion> = emptyList(),
    /** この問題で開いたヒント。 */
    val choiceOpened: List<ColorQuizHintKind> = emptyList(),
    /** いまの獲得点・色の系統・2択で消した色・まだ開けるヒント (コアが算出)。 */
    val choiceHint: ColorQuizHintState? = null,
    val choiceTally: QuizTally = QuizTally(asked = 0u, correct = 0u, points = 0u),
    /** 直前の問題の判定 (解答後に出す)。null = 未解答。 */
    val choiceVerdict: ColorChoiceVerdict? = null,
    /** 4択のセッション結果 (点・グレードはコア)。 */
    val sessionResult: QuizSessionResult? = null,
    val isNewBest: Boolean = false,
    val bestRatePercent: Int = 0
) {
    val isChoiceMode: Boolean get() = playMode == 0
    val choiceQuestion: ColorQuizQuestion? get() = choiceQuestions.getOrNull(roundIndex)
    val round: ColorMatchRound? get() = rounds.getOrNull(roundIndex)
    val members: List<ColorMatchIdol> get() = round?.members ?: emptyList()
    val palette: List<String> get() = round?.palette ?: emptyList()
    val judged: Boolean get() = judgement != null
    val requiredPool: Int get() = if (isChoiceMode) MIN_CHOICE_POOL_SIZE else MIN_POOL_SIZE
    val canStart: Boolean get() = poolSize >= requiredPool
    val isCrossBrand: Boolean get() = selectedBrandIds.size != 1
}

/** 4択 1 問ぶんの判定 (解答後に出すカード用)。 */
data class ColorChoiceVerdict(
    val isCorrect: Boolean,
    val pickedHex: String,
    val earnedPoints: Int,
    val familyLabel: String?
)

class ColorMatchViewModel(app: Application) : AndroidViewModel(app) {
    private val idolRepository = AppModule.from(app).idolRepository
    private val stats = AppModule.from(app).statsRepository
    private val progressStore = AppModule.from(app).gameProgressStore

    private val _uiState = MutableStateFlow(ColorMatchUiState())
    val uiState: StateFlow<ColorMatchUiState> = _uiState.asStateFlow()

    /** 画面ロード時に 1 回だけ組む母集団一式 (ブランド切替のたびに引き直す元)。 */
    private var pools: ColorMatchPools? = null
    private var pool: List<ColorMatchIdol> = emptyList()

    init { load() }

    private fun load() {
        viewModelScope.launch {
            val all = idolRepository.fetchIdols()
            val allBrands = stats.fetchBrands()
            val built = colorMatchBuildPools(
                idols = all.map {
                    ColorMatchIdolSource(
                        id = it.id, brandId = it.brandId, color = it.color,
                        isExternal = it.isExternal, sortOrder = it.sortOrder
                    )
                },
                brands = allBrands.map { ColorMatchBrandRef(id = it.id, sortOrder = it.sortOrder) }
            )
            pools = built
            val brandById = allBrands.associateBy { it.id }
            _uiState.value = _uiState.value.copy(
                isLoading = false,
                brands = built.selectableBrandIds.mapNotNull { brandById[it] },
                // 短縮名を引けるのは「出題可能ブランド」だけ (原本と同じ範囲)。
                brandShortNames = built.brandPools.mapNotNull { p ->
                    brandById[p.brandId]?.let { p.brandId to it.shortName }
                }.toMap(),
                idolsById = all.associateBy { it.id }
            )
            refreshPool()
        }
    }

    /** 出題母集団を引き直す。ブランド選択が変わったときだけ呼ぶ (描画ごとに呼ばない)。 */
    private fun refreshPool() {
        val built = pools ?: return
        pool = colorMatchEffectivePool(built, _uiState.value.selectedBrandIds.toList())
        _uiState.value = _uiState.value.copy(poolSize = pool.size)
    }

    fun toggleBrand(id: String) {
        val current = _uiState.value.selectedBrandIds
        _uiState.value = _uiState.value.copy(
            selectedBrandIds = if (current.contains(id)) current - id else current + id
        )
        refreshPool()
    }

    fun clearBrands() {
        _uiState.value = _uiState.value.copy(selectedBrandIds = emptySet())
        refreshPool()
    }

    fun setPlayMode(m: Int) { _uiState.value = _uiState.value.copy(playMode = m) }
    fun setDifficulty(d: Int) { _uiState.value = _uiState.value.copy(difficulty = d) }
    fun setQuestionCount(n: Int) { _uiState.value = _uiState.value.copy(questionCount = n) }

    fun startSession() {
        val s = _uiState.value
        if (pool.size < s.requiredPool) return
        // 全問まとめて生成する (問題ごとに FFI を呼ばない)。シードの調達だけがここの責務。
        val seed = Random.Default.nextLong().toULong()
        val reset = s.copy(
            roundIndex = 0, totalCorrect = 0, totalAnswered = 0,
            sessionDone = false, inGame = true,
            assignments = emptyMap(), selectedHex = null, judgement = null,
            choiceOpened = emptyList(), choiceVerdict = null,
            choiceTally = QuizTally(asked = 0u, correct = 0u, points = 0u),
            sessionResult = null, isNewBest = false
        )
        _uiState.value = if (s.isChoiceMode) {
            val questions = colorQuizStartGame(
                pool = pool,
                difficulty = difficultyOf(s.difficulty),
                questionCount = s.questionCount.toUInt(),
                seed = seed
            )
            withChoiceHint(reset.copy(choiceQuestions = questions, rounds = emptyList()))
        } else {
            val rounds = colorMatchStartGame(
                pool = pool,
                difficulty = difficultyOf(s.difficulty),
                questionCount = s.questionCount.toUInt(),
                seed = seed
            )
            reset.copy(rounds = rounds, choiceQuestions = emptyList(), choiceHint = null)
        }
    }

    /** 4択のヒント状態を引き直す (出題が変わった / ヒントを開いた / 解答した とき)。 */
    private fun withChoiceHint(state: ColorMatchUiState): ColorMatchUiState {
        val q = state.choiceQuestion ?: return state.copy(choiceHint = null)
        return state.copy(
            choiceHint = colorQuizHintState(
                question = q, opened = state.choiceOpened, answered = state.choiceVerdict != null
            )
        )
    }

    fun openChoiceHint(kind: ColorQuizHintKind) {
        val s = _uiState.value
        if (s.choiceVerdict != null || s.choiceOpened.contains(kind)) return
        _uiState.value = withChoiceHint(s.copy(choiceOpened = s.choiceOpened + kind))
    }

    fun pickChoice(hex: String) {
        val s = _uiState.value
        val q = s.choiceQuestion ?: return
        if (s.choiceVerdict != null) return
        // 正誤・獲得点 (開いたヒントで決まる)・積み上げはコアがまとめて返す。
        val outcome = colorQuizAnswer(
            question = q, opened = s.choiceOpened, pickedHex = hex,
            before = s.choiceTally, questionCount = s.questionCount.toUInt()
        )
        val family = colorQuizHintState(question = q, opened = s.choiceOpened, answered = true).familyLabel
        _uiState.value = withChoiceHint(
            s.copy(
                choiceTally = outcome.tally,
                choiceVerdict = ColorChoiceVerdict(
                    isCorrect = outcome.isCorrect,
                    pickedHex = hex,
                    earnedPoints = outcome.earnedPoints.toInt(),
                    familyLabel = family
                )
            )
        )
    }

    fun resetToSetup() {
        _uiState.value = _uiState.value.copy(inGame = false, sessionDone = false, sessionResult = null)
    }

    fun selectHex(hex: String) {
        val s = _uiState.value
        if (s.judged) return
        _uiState.value = s.copy(selectedHex = if (s.selectedHex == hex) null else hex)
    }

    fun onMemberTap(idolId: String) {
        val s = _uiState.value
        if (s.judged) return
        if (s.assignments.containsKey(idolId)) {
            _uiState.value = s.copy(assignments = s.assignments - idolId)
        } else {
            val hex = s.selectedHex ?: return
            val cleared = s.assignments.filterValues { it != hex }
            _uiState.value = s.copy(assignments = cleared + (idolId to hex), selectedHex = null)
        }
    }

    fun judge() {
        val s = _uiState.value
        val judgement = colorMatchJudgeRound(
            members = s.members,
            assignments = s.assignments.map { (idolId, hex) -> ColorMatchAssignment(idolId = idolId, hex = hex) }
        )
        _uiState.value = s.copy(
            judgement = judgement,
            totalCorrect = s.totalCorrect + judgement.score.toInt(),
            totalAnswered = s.totalAnswered + judgement.outOf.toInt()
        )
    }

    fun advance() {
        val s = _uiState.value
        if (s.roundIndex + 1 < s.questionCount) {
            _uiState.value = withChoiceHint(
                s.copy(
                    roundIndex = s.roundIndex + 1,
                    assignments = emptyMap(), selectedHex = null, judgement = null,
                    choiceOpened = emptyList(), choiceVerdict = null
                )
            )
        } else {
            finishSession()
        }
    }

    private fun finishSession() {
        val s = _uiState.value
        if (s.isChoiceMode) {
            // 4択はヒント込みの点 / 満点を記録する (満点はコアが出題数から出す)。
            val result = colorQuizSessionResult(tally = s.choiceTally, questionCount = s.questionCount.toUInt())
            val update = progressStore.recordResult(
                GameKind.colorMatch, score = s.choiceTally.points.toInt(), outOf = result.outOf.toInt()
            )
            _uiState.value = s.copy(
                sessionDone = true,
                sessionResult = result,
                choiceVerdict = null,
                isNewBest = update.isNewBest,
                bestRatePercent = gameProgressBestRatePercent(update.record) ?: result.ratePercent.toInt()
            )
        } else {
            _uiState.value = s.copy(sessionDone = true)
            progressStore.recordResult(GameKind.colorMatch, score = s.totalCorrect, outOf = s.totalAnswered)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ColorMatchGameScreen(onBack: () -> Unit, viewModel: ColorMatchViewModel = viewModel()) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("メンバーカラー合わせ", fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, "戻る") }
                }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier.fillMaxSize().padding(padding).background(DS.bg).verticalScroll(rememberScrollState()).padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            when {
                state.isLoading -> Box(Modifier.fillMaxWidth().padding(top = 60.dp), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
                state.sessionDone -> {
                    val result = state.sessionResult
                    if (state.isChoiceMode && result != null) {
                        ColorChoiceResult(state, result, onReplay = { viewModel.startSession() }, onChangeSetup = { viewModel.resetToSetup() })
                    } else {
                        ColorMatchResult(state, onReplay = { viewModel.startSession() }, onChangeSetup = { viewModel.resetToSetup() })
                    }
                }
                !state.inGame -> ColorMatchSetup(state, viewModel)
                state.isChoiceMode -> ColorChoicePlay(state, viewModel)
                else -> ColorMatchPlay(state, viewModel)
            }
        }
    }
}

@Composable
private fun ColorMatchSetup(state: ColorMatchUiState, viewModel: ColorMatchViewModel) {
    Text(
        "出題ブランドを選んで、似た色のメンバーの色を当てよう。",
        fontSize = 13.sp, color = DS.ink2
    )
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("遊び方", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2)
        ImasSegmented(labels = PLAY_MODE_LABELS, selection = state.playMode, onSelect = { viewModel.setPlayMode(it) })
        Text(
            if (state.isChoiceMode) "名前を見て、その子のイメージカラーを 4 色から選ぶ"
            else "何人かの名前に、色をタップで割り当てる",
            fontSize = 12.sp, color = DS.ink3
        )
    }
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("難易度", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2)
        ImasSegmented(labels = LEVEL_LABELS, selection = state.difficulty, onSelect = { viewModel.setDifficulty(it) })
    }
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("問題数", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2)
        val idx = QUESTION_COUNT_OPTIONS.indexOf(state.questionCount).coerceAtLeast(0)
        ImasSegmented(
            labels = QUESTION_COUNT_OPTIONS.map { "${it}問" }, selection = idx,
            onSelect = { viewModel.setQuestionCount(QUESTION_COUNT_OPTIONS[it]) }
        )
    }
    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text("出題ブランド", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2)
        Text("未選択なら全ブランドから出題", fontSize = 12.sp, color = DS.ink3)
        GameBrandFilterGrid(
            brands = state.brands, selectedBrandIds = state.selectedBrandIds,
            onToggle = { viewModel.toggleBrand(it) }, onClearAll = { viewModel.clearBrands() }
        )
    }
    Box(Modifier.alpha(if (state.canStart) 1f else 0.5f)) {
        QuizPrimaryButton(title = "はじめる（全${state.questionCount}問）") { if (state.canStart) viewModel.startSession() }
    }
}

@Composable
private fun ColorMatchPlay(state: ColorMatchUiState, viewModel: ColorMatchViewModel) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                Text(
                    if (state.judged) "答え合わせ" else "色をタップして選択、メンバーをタップで割当",
                    fontSize = 17.sp, fontWeight = FontWeight.Bold, color = DS.ink
                )
                Text(
                    "第${state.roundIndex + 1}問 / 全${state.questionCount}問 ・ ${LEVEL_LABELS[state.difficulty]}",
                    fontSize = 12.sp, color = DS.ink3
                )
            }
            Text(
                "やめる", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2,
                modifier = Modifier.clickable { viewModel.resetToSetup() }
            )
        }
    }

    ColorMatchPaletteRow(state, viewModel)
    ColorMatchMemberList(state, viewModel)

    val judgement = state.judgement
    if (judgement != null) {
        Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(12.dp), modifier = Modifier.fillMaxWidth()) {
            Text("${judgement.score} / ${judgement.outOf} 正解", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = DS.ink)
            QuizPrimaryButton(
                title = if (state.roundIndex + 1 < state.questionCount) "次へ（第${state.roundIndex + 2}問）" else "結果を見る"
            ) { viewModel.advance() }
        }
    } else {
        val ready = state.assignments.size == state.members.size
        val accent = com.fugaif.imaslivedb.ui.theme.ImasTheme.derive(null, null, dark = true)
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(14.dp))
                .background(if (ready) accent.accent else DS.fill)
                .clickable(enabled = ready) { viewModel.judge() }
                .padding(vertical = 15.dp),
            contentAlignment = Alignment.Center
        ) {
            Text("判定する", fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = if (ready) accent.onAccent else DS.ink3)
        }
    }
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun ColorMatchPaletteRow(state: ColorMatchUiState, viewModel: ColorMatchViewModel) {
    FlowRow(horizontalArrangement = Arrangement.spacedBy(12.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
        state.palette.forEach { hex ->
            val used = state.assignments.values.contains(hex)
            val isSelected = state.selectedHex == hex
            Box(
                modifier = Modifier
                    .size(46.dp)
                    .clip(CircleShape)
                    .background(hexToColor(hex))
                    .border(if (isSelected) 3.dp else 1.dp, if (isSelected) DS.ink else Color.White.copy(alpha = 0.5f), CircleShape)
                    .clickable { viewModel.selectHex(hex) },
                contentAlignment = Alignment.Center
            ) {
                if (used) Icon(Icons.Filled.Check, null, tint = Color.White, modifier = Modifier.size(16.dp))
            }
        }
    }
}

@Composable
private fun ColorMatchMemberList(state: ColorMatchUiState, viewModel: ColorMatchViewModel) {
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(14.dp)).background(DS.surface),
        verticalArrangement = Arrangement.spacedBy(0.dp)
    ) {
        state.members.forEachIndexed { idx, member ->
            if (idx > 0) Box(Modifier.fillMaxWidth().height(1.dp).background(DS.sep).padding(start = 16.dp))
            ColorMatchMemberRow(member, idx, state, viewModel)
        }
    }
}

@Composable
private fun ColorMatchMemberRow(member: ColorMatchIdol, position: Int, state: ColorMatchUiState, viewModel: ColorMatchViewModel) {
    val idol = state.idolsById[member.id]
    val assigned = state.assignments[member.id]
    // 行の正誤も正解色の表示文字列も判定結果に同梱されている (行ごとに FFI を呼ばない)。
    val correct = state.judgement?.correct?.getOrNull(position) == true
    val correctHexLabel = state.judgement?.correctHexLabels?.getOrNull(position)
    val ring = when {
        state.judged -> if (correct) DS.success else DS.danger
        else -> Color.White.copy(alpha = 0.4f)
    }
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { viewModel.onMemberTap(member.id) }
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        val name = idol?.name ?: member.id
        ImasAvatar(label = name, seed = null, size = 44.dp)
        Column(Modifier.weight(1f)) {
            Text(name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
            if (state.isCrossBrand) {
                idol?.brandId?.let { state.brandShortNames[it] }?.let {
                    Text(it, fontSize = 12.sp, color = DS.ink3)
                }
            }
            if (correctHexLabel != null) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(5.dp)) {
                    Text(if (correct) "メンバーカラー" else "正解", fontSize = 12.sp, color = DS.ink3)
                    Box(Modifier.size(12.dp).clip(CircleShape).background(hexToColor(member.color ?: "")).border(0.5.dp, DS.sep, CircleShape))
                    Text(correctHexLabel, fontSize = 11.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2)
                }
            }
        }
        Box(
            modifier = Modifier.size(40.dp).clip(CircleShape).background(assigned?.let { hexToColor(it) } ?: DS.fill)
                .border(2.5.dp, ring, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            if (assigned == null && !state.judged) Icon(Icons.Filled.QuestionMark, null, tint = DS.ink3, modifier = Modifier.size(14.dp))
        }
        if (state.judged) {
            Icon(
                if (correct) Icons.Filled.Verified else Icons.Filled.Close,
                null, tint = if (correct) DS.success else DS.danger, modifier = Modifier.size(20.dp)
            )
        }
    }
}

@Composable
private fun ColorMatchResult(state: ColorMatchUiState, onReplay: () -> Unit, onChangeSetup: () -> Unit) {
    val rate = colorMatchAccuracyPercent(state.totalCorrect.toUInt(), state.totalAnswered.toUInt()).toInt()
    Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(16.dp), modifier = Modifier.fillMaxWidth().padding(top = 30.dp)) {
        Icon(
            if (rate >= 80) Icons.Filled.EmojiEvents else Icons.Filled.Verified,
            null, tint = if (rate >= 80) DS.favorite else com.fugaif.imaslivedb.ui.theme.ImasTheme.derive(null, null, dark = true).accent,
            modifier = Modifier.size(52.dp)
        )
        Text("正答率 $rate%", fontSize = 34.sp, fontWeight = FontWeight.Bold, color = DS.ink)
        Text("${state.totalCorrect} / ${state.totalAnswered} 正解（全${state.questionCount}問）", fontSize = 15.sp, color = DS.ink2)
        Column(verticalArrangement = Arrangement.spacedBy(10.dp), modifier = Modifier.fillMaxWidth().padding(top = 8.dp)) {
            QuizPrimaryButton(title = "もう一度", onClick = onReplay)
            Box(
                modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(14.dp)).background(DS.fill)
                    .clickable(onClick = onChangeSetup).padding(vertical = 15.dp),
                contentAlignment = Alignment.Center
            ) { Text("設定を変える", fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = DS.ink) }
        }
    }
}

// MARK: - 4択 (iOS ColorMatchGameView の「4択」の移植)

private val CHOICE_LETTERS = listOf("A", "B", "C", "D")

@Composable
private fun ColorChoicePlay(state: ColorMatchUiState, viewModel: ColorMatchViewModel) {
    val q = state.choiceQuestion ?: return
    val hint = state.choiceHint ?: return
    val verdict = state.choiceVerdict
    val answered = verdict != null

    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                "${LEVEL_LABELS[state.difficulty]} ・ 4択",
                fontSize = 12.sp, color = DS.ink3, modifier = Modifier.weight(1f)
            )
            Text(
                "やめる", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink2,
                modifier = Modifier.clickable { viewModel.resetToSetup() }
            )
        }
        QuizProgressHeader(
            current = minOf(state.choiceTally.asked.toInt() + if (answered) 0 else 1, state.questionCount),
            total = state.questionCount,
            points = state.choiceTally.points.toInt()
        )
    }

    ColorChoiceCard(state, q, hint, answered)
    if (!answered) ColorChoiceHintTiles(state, hint, viewModel)
    if (verdict != null) ColorChoiceVerdictCard(q, verdict, state)
    ColorChoiceSwatches(q, hint, verdict) { viewModel.pickChoice(it) }
    if (answered) {
        QuizNextButton(
            isLastQuestion = state.roundIndex + 1 >= state.questionCount,
            onNext = { viewModel.advance() }, onFinish = { viewModel.advance() }
        )
    }
}

/** 出題カード: アイドルの名前 (複数ブランドならブランド名も) と、いまの獲得点。 */
@Composable
private fun ColorChoiceCard(state: ColorMatchUiState, q: ColorQuizQuestion, hint: ColorQuizHintState, answered: Boolean) {
    val idol = state.idolsById[q.answer.id]
    val name = idol?.name ?: q.answer.id
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(16.dp)).background(DS.surface).padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        if (!answered) QuizValueBadge(points = hint.currentValue.toInt())
        Text("この子のイメージカラーはどれ？", fontSize = 13.sp, color = DS.ink2)
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            ImasAvatar(label = idol?.shortName ?: name, seed = null, size = 48.dp)
            Column {
                if (state.isCrossBrand) {
                    idol?.brandId?.let { state.brandShortNames[it] }?.let {
                        Text(it, fontSize = 12.sp, fontWeight = FontWeight.Bold, color = DS.ink3)
                    }
                }
                Text(name, fontSize = 22.sp, fontWeight = FontWeight.Bold, color = DS.ink)
            }
        }
    }
}

/** 「色の系統 −3」「2択にする −5」。開いたものは中身 (系統名 / 2色に) を出す。 */
@Composable
private fun ColorChoiceHintTiles(state: ColorMatchUiState, hint: ColorQuizHintState, viewModel: ColorMatchViewModel) {
    // タイルの並びは固定 (色の系統 → 2択)。開けるかどうか・コストはコアの hints が決める。
    val kinds = listOf(ColorQuizHintKind.FAMILY, ColorQuizHintKind.FIFTY_FIFTY)
    Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.fillMaxWidth()) {
        kinds.forEach { kind ->
            val title = when (kind) {
                ColorQuizHintKind.FAMILY -> "色の系統"
                ColorQuizHintKind.FIFTY_FIFTY -> "2択にする"
            }
            val icon = when (kind) {
                ColorQuizHintKind.FAMILY -> Icons.Filled.Palette
                ColorQuizHintKind.FIFTY_FIFTY -> Icons.Filled.ContentCut
            }
            Box(Modifier.weight(1f)) {
                val option = hint.hints.firstOrNull { it.kind == kind }
                when {
                    state.choiceOpened.contains(kind) -> QuizHintTile(
                        title, icon,
                        value = when (kind) {
                            ColorQuizHintKind.FAMILY -> hint.familyLabel ?: "—"
                            ColorQuizHintKind.FIFTY_FIFTY -> "2色に"
                        }
                    )
                    option != null -> QuizHintTile(
                        title, icon, value = null, cost = option.cost.toInt(),
                        onClick = { viewModel.openChoiceHint(kind) }
                    )
                }
            }
        }
    }
}

/** 色の選択肢 (2×2)。2択ヒントで消した色は押せなくして薄くする。解答後は正解=緑・誤答=赤。 */
@Composable
private fun ColorChoiceSwatches(
    q: ColorQuizQuestion,
    hint: ColorQuizHintState,
    verdict: ColorChoiceVerdict?,
    onPick: (String) -> Unit
) {
    val out = hint.eliminated.map { it.toInt() }.toSet()
    val answerHex = q.answer.color
    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        q.choices.withIndex().chunked(2).forEach { row ->
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp), modifier = Modifier.fillMaxWidth()) {
                row.forEach { (i, hex) ->
                    val isOut = out.contains(i)
                    val isAnswer = answerHex != null && hex.equals(answerHex, ignoreCase = true)
                    val isPicked = verdict?.pickedHex == hex
                    val ring = when {
                        verdict != null && isAnswer -> DS.success
                        verdict != null && isPicked -> DS.danger
                        else -> DS.sep
                    }
                    Column(
                        modifier = Modifier
                            .weight(1f)
                            .alpha(if (isOut) 0.18f else 1f)
                            .clip(RoundedCornerShape(18.dp))
                            .background(DS.surface)
                            .border(if (verdict != null && (isAnswer || isPicked)) 2.dp else 1.dp, ring, RoundedCornerShape(18.dp))
                            .clickable(enabled = verdict == null && !isOut) { onPick(hex) }
                            .padding(8.dp),
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        Box(
                            Modifier.fillMaxWidth().height(76.dp).clip(RoundedCornerShape(12.dp))
                                .background(hexToColor(hex)).border(1.dp, DS.sep, RoundedCornerShape(12.dp)),
                            contentAlignment = Alignment.Center
                        ) {
                            if (verdict != null && (isAnswer || isPicked)) {
                                Icon(
                                    if (isAnswer) Icons.Filled.CheckCircle else Icons.Filled.Cancel, null,
                                    tint = Color.White, modifier = Modifier.size(24.dp)
                                )
                            }
                        }
                        Row(Modifier.fillMaxWidth().padding(horizontal = 4.dp)) {
                            Text(CHOICE_LETTERS.getOrElse(i) { "" }, fontSize = 11.sp, color = DS.ink3, fontFamily = FontFamily.Monospace)
                            Box(Modifier.weight(1f))
                            Text(hex.uppercase(), fontSize = 11.sp, color = DS.ink, fontFamily = FontFamily.Monospace)
                        }
                    }
                }
                if (row.size < 2) Box(Modifier.weight(1f))
            }
        }
    }
}

/** 解答直後の判定: 正解 / 不正解と正しい色 (HEX・系統)、獲得点。 */
@Composable
private fun ColorChoiceVerdictCard(q: ColorQuizQuestion, verdict: ColorChoiceVerdict, state: ColorMatchUiState) {
    val tone = if (verdict.isCorrect) DS.success else DS.danger
    val name = state.idolsById[q.answer.id]?.name ?: q.answer.id
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(16.dp)).background(tone.copy(alpha = 0.12f))
            .border(1.5.dp, tone, RoundedCornerShape(16.dp)).padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Icon(if (verdict.isCorrect) Icons.Filled.CheckCircle else Icons.Filled.Cancel, null, tint = tone, modifier = Modifier.size(22.dp))
            Text(if (verdict.isCorrect) "正解！" else "不正解", fontSize = 20.sp, fontWeight = FontWeight.Bold, color = tone)
            Box(Modifier.weight(1f))
            Text(
                "+${verdict.earnedPoints}pt", fontSize = 15.sp, fontWeight = FontWeight.Bold,
                color = if (verdict.earnedPoints > 0) DS.success else DS.ink3
            )
        }
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Box(Modifier.size(22.dp).clip(CircleShape).background(hexToColor(q.answer.color ?: "")).border(0.5.dp, DS.sep, CircleShape))
            Column {
                Text("${name}のイメージカラー", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
                Text(
                    listOfNotNull(q.answer.color?.uppercase(), verdict.familyLabel).joinToString(" · "),
                    fontSize = 12.sp, color = DS.ink2
                )
            }
        }
        if (!verdict.isCorrect) {
            Text("あなたの選択: ${verdict.pickedHex.uppercase()}", fontSize = 12.sp, color = DS.ink3)
        }
    }
}

/** 4択の結果。点・グレードはコアの [QuizSessionResult]、記録の保存後の自己ベストは ViewModel が渡す。 */
@Composable
private fun ColorChoiceResult(state: ColorMatchUiState, result: QuizSessionResult, onReplay: () -> Unit, onChangeSetup: () -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(10.dp), modifier = Modifier.fillMaxWidth()) {
        QuizResultView(
            result = result, kind = GameKind.colorMatch,
            isNewBest = state.isNewBest, bestRate = state.bestRatePercent,
            history = emptyList(), onReplay = onReplay
        )
        Box(
            modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(14.dp)).background(DS.fill)
                .clickable(onClick = onChangeSetup).padding(vertical = 15.dp),
            contentAlignment = Alignment.Center
        ) { Text("設定を変える", fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = DS.ink) }
    }
}
