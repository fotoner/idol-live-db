package com.fugaif.imaslivedb.ui.polls

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddCircle
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.community.CommunityApi
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.components.ImasFilterChip
import com.fugaif.imaslivedb.ui.components.ImasRemovableChip
import com.fugaif.imaslivedb.ui.components.ImasSegmented
import com.fugaif.imaslivedb.ui.theme.DS
import com.fugaif.imaslivedb.ui.theme.brandColor
import uniffi.imas_core.InputField
import uniffi.imas_core.inputClamp
import uniffi.imas_core.inputIsAcceptable
import uniffi.imas_core.inputLength
import uniffi.imas_core.inputLimitMax
import uniffi.imas_core.voteLimitPerTarget

/** 投票対象。index はセグメントの並びと 1:1 (曲 / アイドル / ユニット)。 */
private val TARGET_TYPES = listOf("song", "idol", "unit")
// 表示名はカタログの文言 (iOS PollTargetType.candidateNoun と同じキー)。表示するところで resolve() する
private val TARGET_LABELS = listOf(L10n.Polls.targetSong, L10n.Polls.targetIdol, L10n.Polls.targetUnit)
private val DAY_OPTIONS = listOf(7, 14, 30)
private val SCOPES = listOf(
    CommunityApi.PollCandidateScope.ALL,
    CommunityApi.PollCandidateScope.BRAND,
    CommunityApi.PollCandidateScope.MANUAL
)

/** 候補指定スコープの上限 (サーバの scope_entity_ids と同じ値)。超える分はピッカー側で切る。 */
private const val MAX_MANUAL_CANDIDATES = 500

/**
 * お題作成シート。iOS PollCreateSheet の移植。
 * タイトル / 説明 / 対象種別 / 募集期間 / 候補スコープ を指定して新しいお題を投稿する。
 * 候補指定スコープのピッカーは、お題詳細の「候補を追加」と同じものを使い回す。
 */
@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
fun PollCreateSheet(
    onDismiss: () -> Unit,
    onCreated: (CommunityApi.PollSummary) -> Unit,
    viewModel: PollCreateViewModel = viewModel()
) {
    val state by viewModel.uiState.collectAsState()
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)

    var title by remember { mutableStateOf("") }
    var description by remember { mutableStateOf("") }
    var targetIndex by remember { mutableIntStateOf(0) }
    var dayIndex by remember { mutableIntStateOf(1) }   // 既定は 14 日間 (iOS と同じ)
    var scopeIndex by remember { mutableIntStateOf(0) }
    var selectedBrandIds by remember { mutableStateOf(emptySet<String>()) }
    var showCandidatePicker by remember { mutableStateOf(false) }

    val targetType = TARGET_TYPES[targetIndex]
    val targetNoun = TARGET_LABELS[targetIndex]
    val scope = SCOPES[scopeIndex]
    val trimmedTitle = title.trim()

    // iOS canSubmit と同じ条件。ブランド限定は 1 つ以上、候補指定は 2 件以上ないとサーバが弾く。
    val canSubmit = inputIsAcceptable(InputField.POLL_TITLE, title) && !state.isSubmitting && when (scope) {
        CommunityApi.PollCandidateScope.ALL -> true
        CommunityApi.PollCandidateScope.BRAND -> selectedBrandIds.isNotEmpty()
        CommunityApi.PollCandidateScope.MANUAL -> state.candidates.size >= 2
    }

    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = sheetState) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
                .padding(bottom = 32.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text(L10n.Polls.createTitle.resolve(), fontSize = 20.sp, color = DS.ink)
            Text(
                L10n.Polls.createIntro(limit = voteLimitPerTarget().toInt()).resolve(),
                fontSize = 13.sp, color = DS.ink2
            )

            Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                OutlinedTextField(
                    value = title,
                    // 上限と数え方 (サーバと同じ UTF-16 の単位) はコア。超えた入力は切って、送信してから弾かれるのを防ぐ。
                    onValueChange = { title = inputClamp(InputField.POLL_TITLE, it) },
                    label = { Text(L10n.Polls.createTitleFieldHeader.resolve()) },
                    placeholder = { Text(L10n.Polls.createTitleFieldPlaceholder.resolve()) },
                    minLines = 1,
                    maxLines = 3,
                    modifier = Modifier.fillMaxWidth()
                )
                Text(
                    L10n.Polls.createCharCounter(
                        length = inputLength(InputField.POLL_TITLE, title).toInt(),
                        max = inputLimitMax(InputField.POLL_TITLE).toInt()
                    ).resolve(),
                    fontSize = 12.sp, color = DS.ink2
                )
            }

            Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                OutlinedTextField(
                    value = description,
                    onValueChange = { description = inputClamp(InputField.POLL_DESCRIPTION, it) },
                    label = { Text(L10n.Polls.createDescriptionFieldHeaderAndroid.resolve()) },
                    placeholder = { Text(L10n.Polls.createDescriptionFieldPlaceholderAndroid.resolve()) },
                    minLines = 2,
                    maxLines = 5,
                    modifier = Modifier.fillMaxWidth()
                )
                Text(
                    L10n.Polls.createCharCounter(
                        length = inputLength(InputField.POLL_DESCRIPTION, description).toInt(),
                        max = inputLimitMax(InputField.POLL_DESCRIPTION).toInt()
                    ).resolve(),
                    fontSize = 12.sp, color = DS.ink2
                )
            }

            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                Text(L10n.Polls.createTargetHeader.resolve(), fontSize = 13.sp, color = DS.ink2)
                ImasSegmented(
                    labels = TARGET_LABELS.map { it.resolve() },
                    selection = targetIndex,
                    onSelect = {
                        targetIndex = it
                        // 種類をまたいだ候補は作れないので、切り替えたら選択済み候補は捨てる。
                        viewModel.clearCandidates()
                    },
                    modifier = Modifier.fillMaxWidth()
                )
            }

            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                Text(L10n.Polls.createScopeHeader.resolve(), fontSize = 13.sp, color = DS.ink2)
                ImasSegmented(
                    labels = listOf(
                        L10n.Polls.createScopeAll.resolve(),
                        L10n.Polls.createScopeBrand.resolve(),
                        L10n.Polls.createScopeManual.resolve()
                    ),
                    selection = scopeIndex,
                    onSelect = { scopeIndex = it },
                    modifier = Modifier.fillMaxWidth()
                )
                when (scope) {
                    CommunityApi.PollCandidateScope.ALL ->
                        Text(L10n.Polls.createScopeAllHint(target = targetNoun).resolve(), fontSize = 12.sp, color = DS.ink3)

                    CommunityApi.PollCandidateScope.BRAND -> {
                        Text(
                            L10n.Polls.createScopeBrandHintAndroid(target = targetNoun).resolve(),
                            fontSize = 12.sp, color = DS.ink3
                        )
                        FlowRow(
                            horizontalArrangement = Arrangement.spacedBy(8.dp),
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            state.brands.forEach { brand ->
                                ImasFilterChip(
                                    label = brand.shortName,
                                    selected = selectedBrandIds.contains(brand.id),
                                    tintColor = brandColor(brand.id),
                                    onClick = {
                                        selectedBrandIds = if (selectedBrandIds.contains(brand.id)) {
                                            selectedBrandIds - brand.id
                                        } else {
                                            selectedBrandIds + brand.id
                                        }
                                    }
                                )
                            }
                        }
                        if (selectedBrandIds.isEmpty()) {
                            Text(L10n.Polls.createScopeBrandRequired.resolve(), fontSize = 12.sp, color = DS.danger)
                        }
                    }

                    CommunityApi.PollCandidateScope.MANUAL -> {
                        Row(modifier = Modifier.fillMaxWidth()) {
                            Text(L10n.Polls.createScopeManualMin.resolve(), fontSize = 12.sp, color = DS.ink3, modifier = Modifier.weight(1f))
                            Text(
                                L10n.Polls.createScopeManualSelected(count = state.candidates.size).resolve(),
                                fontSize = 12.sp, fontWeight = FontWeight.SemiBold,
                                color = if (state.candidates.size >= 2) DS.ink2 else DS.danger
                            )
                        }
                        if (state.candidates.isNotEmpty()) {
                            FlowRow(
                                horizontalArrangement = Arrangement.spacedBy(8.dp),
                                verticalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                state.candidates.forEach { candidate ->
                                    ImasRemovableChip(
                                        text = candidate.displayName,
                                        onRemove = { viewModel.removeCandidate(candidate.entityId) }
                                    )
                                }
                            }
                        }
                        Button(
                            onClick = { showCandidatePicker = true },
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Icon(Icons.Filled.AddCircle, contentDescription = null, modifier = Modifier.size(18.dp))
                            Text(L10n.Polls.createScopeAddCandidate.resolve(), fontSize = 14.sp, fontWeight = FontWeight.SemiBold,
                                modifier = Modifier.padding(start = 6.dp))
                        }
                    }
                }
            }

            Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                Text(L10n.Polls.createDurationHeader.resolve(), fontSize = 13.sp, color = DS.ink2)
                ImasSegmented(
                    labels = DAY_OPTIONS.map { L10n.Polls.createDurationDays(days = it).resolve() },
                    selection = dayIndex,
                    onSelect = { dayIndex = it },
                    modifier = Modifier.fillMaxWidth()
                )
            }

            state.errorMessage?.let { message ->
                Text(message.resolve(), color = DS.danger, fontSize = 13.sp)
            }

            Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.fillMaxWidth()) {
                TextButton(onClick = onDismiss, modifier = Modifier.weight(1f)) { Text(L10n.Polls.actionCancel.resolve()) }
                Button(
                    onClick = {
                        viewModel.submit(
                            title = trimmedTitle,
                            description = description.trim().ifEmpty { null },
                            targetType = targetType,
                            days = DAY_OPTIONS[dayIndex],
                            scope = scope,
                            brandIds = selectedBrandIds,
                            onCreated = { poll -> onCreated(poll); onDismiss() }
                        )
                    },
                    enabled = canSubmit,
                    modifier = Modifier.weight(1f)
                ) {
                    if (state.isSubmitting) {
                        CircularProgressIndicator(modifier = Modifier.size(18.dp), color = DS.ink)
                    } else {
                        Text(L10n.Polls.createSubmit.resolve())
                    }
                }
            }
        }
    }

    if (showCandidatePicker) {
        val alreadySelected = state.candidates.map { it.entityId }.toSet()
        // ピッカーは「追加分」だけを返すので、既存の並びの末尾に足して選択順を保つ。
        val appendCandidates: (List<String>) -> Unit = { newIds ->
            viewModel.setCandidates(targetType, state.candidates.map { it.entityId } + newIds)
            showCandidatePicker = false
        }
        val remaining = (MAX_MANUAL_CANDIDATES - alreadySelected.size).coerceAtLeast(0)
        when (targetType) {
            "idol" -> IdolPollCandidatePicker(
                alreadySelected = alreadySelected,
                remaining = remaining,
                onDismiss = { showCandidatePicker = false },
                onConfirm = appendCandidates
            )
            "unit" -> UnitPollCandidatePicker(
                alreadySelected = alreadySelected,
                remaining = remaining,
                onDismiss = { showCandidatePicker = false },
                onConfirm = appendCandidates
            )
            else -> SongPollCandidatePicker(
                alreadySelected = alreadySelected,
                remaining = remaining,
                // ブランド限定は「候補指定」と排他なので、ここでは曲の絞り込みを掛けない。
                restrictedBrandIds = null,
                onDismiss = { showCandidatePicker = false },
                onConfirm = appendCandidates
            )
        }
    }
}
