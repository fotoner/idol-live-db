package com.fugaif.imaslivedb.ui.edit

import android.app.Application
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.AddCircle
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.data.edit.EditApi
import com.fugaif.imaslivedb.data.model.Idol
import com.fugaif.imaslivedb.data.model.SetlistItem
import com.fugaif.imaslivedb.data.model.SetlistPerformer
import com.fugaif.imaslivedb.data.model.SetlistRow
import com.fugaif.imaslivedb.data.model.Show
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.theme.DS
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import uniffi.imas_core.PickedSongRecord
import uniffi.imas_core.SetlistItemDiffRow
import uniffi.imas_core.setlistItemIndexesNeedingSync
import uniffi.imas_core.setlistPerformerIndexesNeedingSync
import java.util.UUID

/**
 * 編集中の 1 行 (iOS `EditableSetlistRow` の移植)。
 * [songTitle] は曲名 (データ)。曲をまだ選んでいない行は空で、表示で「(曲を選択)」を出す。
 */
data class EditableSetlistRow(
    val rowId: String = UUID.randomUUID().toString(),
    val existingItemId: String? = null,
    val songId: String = "",
    val songTitle: String = "",
    val section: String? = null,
    val castIds: Set<String> = emptySet()
)

sealed class SetlistSaveOutcome {
    object Applied : SetlistSaveOutcome()
    data class Requested(val issueUrl: String?) : SetlistSaveOutcome()
    data class Failed(val message: DisplayText) : SetlistSaveOutcome()
}

data class SetlistEditUiState(
    val rows: List<EditableSetlistRow> = emptyList(),
    val initialItemIds: List<String> = emptyList(),
    /**
     * 編集前のセトリ行 (item id → 行そのもの)。用途は 2 つあり、どちらも**全列**が要る:
     *  - 「値が変わった行だけ送る」差分判定のベースライン (判定そのものは共有コアが行う)
     *  - このフォームが編集しない列 (notes / unitName) の引き継ぎ元。射影に落として
     *    捨てると [save] の楽観更新がその列を null で上書きする (iOS SetlistEditView と同じ理由)。
     */
    val originalItems: Map<String, SetlistRow> = emptyMap(),
    val initialPerformerKeys: Set<Pair<String, String>> = emptySet(),
    val idolById: Map<String, Idol> = emptyMap(),
    val isLoading: Boolean = true,
    val isSaving: Boolean = false,
    /** 解決済みの String ではなく文言の値で持ち、画面で resolve() する。 */
    val errorMessage: DisplayText? = null,
    val saveOutcome: SetlistSaveOutcome? = null
)

/** セトリ編集の状態管理。iOS `SetlistEditView` の移植 (契約: POST /edits を 1 リクエスト = 1 batch)。 */
class SetlistEditViewModel(app: Application, private val show: Show) : AndroidViewModel(app) {
    private val eventRepo = AppModule.from(app).eventRepository
    private val masterEditRepo = AppModule.from(app).masterEditRepository
    private val idolRepo = AppModule.from(app).idolRepository
    private val editApi = AppModule.from(app).editApi

    private val _uiState = MutableStateFlow(SetlistEditUiState())
    val uiState: StateFlow<SetlistEditUiState> = _uiState.asStateFlow()

    init {
        viewModelScope.launch { load() }
    }

    private suspend fun load() {
        try {
            val setlist: List<SetlistRow> = eventRepo.fetchSetlist(show.id)
            val allPerformers = eventRepo.fetchAllPerformers(show.id)
            val performersByItem = allPerformers.groupBy { it.setlistItemId }
            val idols = idolRepo.fetchIdols()
            val idolById = idols.associateBy { it.id }

            val rows = setlist.map { item ->
                EditableSetlistRow(
                    existingItemId = item.id,
                    songId = item.songId,
                    songTitle = item.songTitle,
                    section = item.section,
                    castIds = (performersByItem[item.id] ?: emptyList()).mapNotNull { it.idolId }.toSet()
                )
            }
            val performerKeys = allPerformers.mapNotNull { p -> p.idolId?.let { p.setlistItemId to it } }.toSet()

            _uiState.value = SetlistEditUiState(
                rows = rows,
                initialItemIds = setlist.map { it.id },
                originalItems = setlist.associateBy { it.id },
                initialPerformerKeys = performerKeys,
                idolById = idolById,
                isLoading = false
            )
        } catch (e: Exception) {
            _uiState.value = _uiState.value.copy(
                isLoading = false,
                errorMessage = L10n.Edit.setlistErrorLoadFailed(detail = e.message.toString())
            )
        }
    }

    fun addRow(song: PickedSongRecord) {
        val state = _uiState.value
        _uiState.value = state.copy(rows = state.rows + EditableSetlistRow(songId = song.id, songTitle = song.title))
    }

    fun setSong(rowId: String, song: PickedSongRecord) {
        updateRow(rowId) { it.copy(songId = song.id, songTitle = song.title) }
    }

    fun setSection(rowId: String, section: String?) {
        updateRow(rowId) { it.copy(section = section) }
    }

    fun setCasts(rowId: String, castIds: Set<String>) {
        updateRow(rowId) { it.copy(castIds = castIds) }
    }

    fun removeRow(rowId: String) {
        val state = _uiState.value
        _uiState.value = state.copy(rows = state.rows.filterNot { it.rowId == rowId })
    }

    fun moveUp(rowId: String) = move(rowId, -1)
    fun moveDown(rowId: String) = move(rowId, 1)

    private fun move(rowId: String, delta: Int) {
        val state = _uiState.value
        val idx = state.rows.indexOfFirst { it.rowId == rowId }
        val target = idx + delta
        if (idx < 0 || target < 0 || target >= state.rows.size) return
        val newRows = state.rows.toMutableList()
        val tmp = newRows[idx]
        newRows[idx] = newRows[target]
        newRows[target] = tmp
        _uiState.value = state.copy(rows = newRows)
    }

    private fun updateRow(rowId: String, transform: (EditableSetlistRow) -> EditableSetlistRow) {
        val state = _uiState.value
        _uiState.value = state.copy(rows = state.rows.map { if (it.rowId == rowId) transform(it) else it })
    }

    fun clearError() {
        _uiState.value = _uiState.value.copy(errorMessage = null)
    }

    fun consumeSaveOutcome() {
        _uiState.value = _uiState.value.copy(saveOutcome = null)
    }

    fun save() {
        val state = _uiState.value
        if (state.rows.any { it.songId.isEmpty() }) {
            _uiState.value = state.copy(errorMessage = L10n.Edit.setlistErrorSongMissing)
            return
        }
        _uiState.value = state.copy(isSaving = true)
        viewModelScope.launch {
            try {
                val existingIds = state.initialItemIds.toSet()

                // 新しい SetlistItem を構築。既存行は元 ID 維持 (位置非依存)、新規行は sli_<uuid>。
                // フォームに無い列 (notes / unitName) は元レコードから引き継ぐ。null で構築すると
                // 下の replaceSetlist (upsertItems = REPLACE) がその列を消してしまい、しかも
                // 差分送信のせいでサーバの modifiedAt が動かないため増分同期でも戻ってこない。
                data class Built(val item: SetlistItem, val castIds: Set<String>)
                val built = state.rows.mapIndexed { idx, row ->
                    val original = row.existingItemId?.let { state.originalItems[it] }
                    Built(
                        item = SetlistItem(
                            id = row.existingItemId ?: "sli_${UUID.randomUUID()}",
                            showId = show.id,
                            songId = row.songId,
                            position = idx + 1,
                            section = row.section,
                            notes = original?.notes,
                            unitName = original?.unitName
                        ),
                        castIds = row.castIds
                    )
                }

                val newItemIds = built.map { it.item.id }.toSet()
                val deletedItemIds = state.initialItemIds.filter { it !in newItemIds }

                // 出演者は index で引き直すのでリストのまま保持する (集合化は削除差分の計算だけ)。
                val newPerformers = built.flatMap { b -> b.castIds.map { b.item.id to it } }
                val deletedPerformerKeys = state.initialPerformerKeys - newPerformers.toSet()

                // 変わっていない行は送らない。差分規則は共有コア (domain::setlist_diff)。
                // 以前は 1 曲直すだけでも全曲・全出演者を送っていたため実測最大 606 ops に達し、
                // 一般ユーザーの修正リクエストが op 上限で弾かれていた。
                val changedItems = setlistItemIndexesNeedingSync(
                    items = built.map { it.item.toDiffRow() },
                    original = state.originalItems.values.map { it.toDiffRow() }
                ).map { built[it.toInt()].item }

                // 出演者は create と delete しか意味を持たない。SetlistPerformer は
                // (setlistItemId, idolId) しか持たず recordName がその 2 つから決まるので、
                // 既存出演者を update しても書く値が recordName と同じで変化しようがない。
                val addedPerformers = setlistPerformerIndexesNeedingSync(
                    recordNames = newPerformers.map { (itemId, idolId) -> performerRecordName(itemId, idolId) },
                    initialRecordNames = state.initialPerformerKeys.map { (itemId, idolId) ->
                        performerRecordName(itemId, idolId)
                    }
                ).map { newPerformers[it.toInt()] }

                val ops = mutableListOf<EditApi.EditOperation>()
                for (item in changedItems) {
                    val fields = mutableMapOf<String, Any?>(
                        "showId" to item.showId,
                        "songId" to item.songId,
                        "position" to item.position
                    )
                    if (item.section != null) {
                        fields["section"] = item.section
                    } else if (state.originalItems[item.id]?.section != null) {
                        // 「本編」に戻した = section のクリア。null を明示送信してサーバのマージで削除させる。
                        fields["section"] = null
                    }
                    ops.add(
                        EditApi.EditOperation(
                            op = if (existingIds.contains(item.id)) EditApi.EditOp.UPDATE else EditApi.EditOp.CREATE,
                            recordType = "SetlistItem",
                            recordName = item.id,
                            fields = fields
                        )
                    )
                }
                for ((itemId, idolId) in addedPerformers) {
                    ops.add(
                        EditApi.EditOperation(
                            op = EditApi.EditOp.CREATE,
                            recordType = "SetlistPerformer",
                            recordName = performerRecordName(itemId, idolId),
                            fields = mapOf("setlistItemId" to itemId, "idolId" to idolId)
                        )
                    )
                }
                for (id in deletedItemIds) {
                    ops.add(EditApi.EditOperation(op = EditApi.EditOp.DELETE, recordType = "SetlistItem", recordName = id))
                }
                for ((itemId, idolId) in deletedPerformerKeys) {
                    ops.add(
                        EditApi.EditOperation(
                            op = EditApi.EditOp.DELETE,
                            recordType = "SetlistPerformer",
                            recordName = performerRecordName(itemId, idolId)
                        )
                    )
                }

                // 差分が空 = 何も変えずに保存した。送るものが無いので通信もローカル置換もせず、
                // 「修正リクエストを送信しました」を出さずに閉じる (iOS SetlistEditView と同じ)。
                if (ops.isEmpty()) {
                    _uiState.value = _uiState.value.copy(isSaving = false, saveOutcome = SetlistSaveOutcome.Applied)
                    return@launch
                }

                // i18n-ignore(storage): 編集履歴に残るサマリ (サーバに送るデータ)。画面の言語で変えない
                val outcome = editApi.submitMaster(ops, summary = "セトリ編集")
                when (outcome) {
                    is EditApi.MasterEditOutcome.Applied -> {
                        // ローカル置換は差分ではなく編集後の全量で行う (サーバ確定値との一致が目的)。
                        val performers = newPerformers.map { (itemId, idolId) -> SetlistPerformer(itemId, idolId) }
                        masterEditRepo.replaceSetlist(
                            deletedItemIds = deletedItemIds,
                            deletedPerformers = deletedPerformerKeys.toList(),
                            items = built.map { it.item },
                            performers = performers
                        )
                        _uiState.value = _uiState.value.copy(isSaving = false, saveOutcome = SetlistSaveOutcome.Applied)
                    }
                    is EditApi.MasterEditOutcome.Requested -> {
                        _uiState.value = _uiState.value.copy(
                            isSaving = false,
                            saveOutcome = SetlistSaveOutcome.Requested(outcome.response.issueUrl)
                        )
                    }
                }
            } catch (e: EditApi.ApiException) {
                _uiState.value = _uiState.value.copy(isSaving = false, errorMessage = e.userMessage)
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isSaving = false,
                    errorMessage = L10n.Edit.formErrorSaveFailed(detail = e.message.toString())
                )
            }
        }
    }

    private fun performerRecordName(itemId: String, idolId: String) = "setlist_performers-$itemId-$idolId"
}

/** 差分判定に渡す射影。サーバに送る field だけを持つ (曲名やジャケ URL は編集対象外)。 */
private fun SetlistItem.toDiffRow() = SetlistItemDiffRow(
    id = id, songId = songId, position = position.toLong(), section = section
)

/** 編集前の行を同じ射影に落とす。比較の対象を送信 field だけに揃えるため。 */
private fun SetlistRow.toDiffRow() = SetlistItemDiffRow(
    id = id, songId = songId, position = position.toLong(), section = section
)

/**
 * セトリ編集画面。iOS `SetlistEditView` の移植。
 * ナビゲーションは Compose の Dialog (フルスクリーン) で表示する想定 (呼び出し元 [RecentEditsScreen] 参照)。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SetlistEditScreen(
    show: Show,
    eventName: String,
    onDismiss: () -> Unit,
    onSaved: () -> Unit
) {
    val context = LocalContext.current
    val app = context.applicationContext as Application
    val viewModel = viewModel<SetlistEditViewModel>(factory = SetlistEditViewModelFactory(app, show))
    val state by viewModel.uiState.collectAsState()

    var songPickerForRow by remember { mutableStateOf<String?>(null) }
    var castPickerForRow by remember { mutableStateOf<String?>(null) }
    var showClearConfirm by remember { mutableStateOf(false) }

    var requestedOutcome by remember { mutableStateOf<SetlistSaveOutcome.Requested?>(null) }

    LaunchedEffect(state.saveOutcome) {
        when (val outcome = state.saveOutcome) {
            is SetlistSaveOutcome.Applied -> {
                viewModel.consumeSaveOutcome()
                onSaved()
            }
            is SetlistSaveOutcome.Requested -> {
                viewModel.consumeSaveOutcome()
                requestedOutcome = outcome
            }
            else -> {}
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(L10n.Edit.setlistTitle.resolve(), fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, L10n.Edit.actionCancel.resolve())
                    }
                },
                actions = {
                    TextButton(
                        onClick = {
                            if (state.rows.isEmpty() && state.initialItemIds.isNotEmpty()) {
                                showClearConfirm = true
                            } else {
                                viewModel.save()
                            }
                        },
                        enabled = !state.isSaving
                    ) { Text(L10n.Edit.actionSave.resolve(), fontWeight = FontWeight.SemiBold) }
                }
            )
        }
    ) { padding ->
        Box(Modifier.fillMaxSize().padding(padding)) {
            if (state.isLoading) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
            } else {
                Column(Modifier.fillMaxSize()) {
                    Text(
                        L10n.Edit.setlistHeaderEventShow(event = eventName, show = show.name).resolve(),
                        fontSize = 13.sp, color = DS.ink2,
                        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp)
                    )
                    LazyColumn(modifier = Modifier.fillMaxSize().weight(1f)) {
                        items(state.rows, key = { it.rowId }) { row ->
                            SetlistEditRowView(
                                row = row,
                                idolById = state.idolById,
                                isFirst = state.rows.firstOrNull()?.rowId == row.rowId,
                                isLast = state.rows.lastOrNull()?.rowId == row.rowId,
                                onPickSong = { songPickerForRow = row.rowId },
                                onPickCasts = { castPickerForRow = row.rowId },
                                onSectionChange = { viewModel.setSection(row.rowId, it) },
                                onMoveUp = { viewModel.moveUp(row.rowId) },
                                onMoveDown = { viewModel.moveDown(row.rowId) },
                                onRemove = { viewModel.removeRow(row.rowId) }
                            )
                        }
                        item {
                            Row(
                                modifier = Modifier.fillMaxWidth()
                                    .clickable { songPickerForRow = NEW_ROW_MARKER }
                                    .padding(16.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                Icon(Icons.Filled.AddCircle, contentDescription = null, tint = DS.pick)
                                Text(
                                    L10n.Edit.setlistActionAddSong.resolve(),
                                    fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.pick
                                )
                            }
                        }
                    }
                }
            }

            if (state.isSaving) {
                Box(Modifier.fillMaxSize().background(DS.bg.copy(alpha = 0.5f)), contentAlignment = Alignment.Center) {
                    Column(
                        modifier = Modifier.clip(RoundedCornerShape(12.dp)).background(DS.surface).padding(24.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        CircularProgressIndicator()
                        Text(L10n.Edit.formSaving.resolve(), fontSize = 13.sp, color = DS.ink2, modifier = Modifier.padding(top = 8.dp))
                    }
                }
            }
        }
    }

    if (state.errorMessage != null) {
        AlertDialog(
            onDismissRequest = { viewModel.clearError() },
            confirmButton = { TextButton(onClick = { viewModel.clearError() }) { Text(L10n.Common.actionOk.resolve()) } },
            title = { Text(L10n.Edit.formErrorTitle.resolve()) },
            text = { Text(state.errorMessage?.resolve() ?: "") }
        )
    }

    if (requestedOutcome != null) {
        val issueUrl = requestedOutcome?.issueUrl
        val uriHandler = LocalUriHandler.current
        AlertDialog(
            onDismissRequest = { requestedOutcome = null; onSaved() },
            title = { Text(L10n.Edit.requestSentTitle.resolve()) },
            text = {
                Column {
                    Text(L10n.Edit.requestSentMessage.resolve())
                    if (issueUrl != null) {
                        Text(
                            L10n.Edit.requestSentProgress.resolve(),
                            color = DS.pick,
                            fontWeight = FontWeight.SemiBold,
                            modifier = Modifier.padding(top = 8.dp).clickable { uriHandler.openUri(issueUrl) }
                        )
                    }
                }
            },
            confirmButton = {
                TextButton(onClick = { requestedOutcome = null; onSaved() }) { Text(L10n.Common.actionOk.resolve()) }
            }
        )
    }

    if (showClearConfirm) {
        AlertDialog(
            onDismissRequest = { showClearConfirm = false },
            title = { Text(L10n.Edit.setlistClearTitle.resolve()) },
            text = { Text(L10n.Edit.setlistClearMessageAndroid(count = state.initialItemIds.size).resolve()) },
            confirmButton = {
                TextButton(onClick = { showClearConfirm = false; viewModel.save() }) {
                    Text(L10n.Edit.setlistClearConfirm.resolve())
                }
            },
            dismissButton = {
                TextButton(onClick = { showClearConfirm = false }) { Text(L10n.Edit.actionCancel.resolve()) }
            }
        )
    }

    if (songPickerForRow != null) {
        SongPickerSheet(
            onDismiss = { songPickerForRow = null },
            onSelect = { song ->
                val target = songPickerForRow
                if (target == NEW_ROW_MARKER) {
                    viewModel.addRow(song)
                } else if (target != null) {
                    viewModel.setSong(target, song)
                }
                songPickerForRow = null
            }
        )
    }

    if (castPickerForRow != null) {
        val row = state.rows.firstOrNull { it.rowId == castPickerForRow }
        if (row != null) {
            IdolMultiSelectSheet(
                selected = row.castIds,
                onDismiss = { castPickerForRow = null },
                onConfirm = { newSelection ->
                    viewModel.setCasts(row.rowId, newSelection)
                    castPickerForRow = null
                }
            )
        }
    }
}

private const val NEW_ROW_MARKER = "__new_row__"

private class SetlistEditViewModelFactory(
    private val app: Application,
    private val show: Show
) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return SetlistEditViewModel(app, show) as T
    }
}

// i18n-ignore(storage): マスタ (CloudKit) の section 列に入る語彙。訳さない・変えない (表示は sectionLabel)
private val sections = listOf("本編", "アンコール", "MC", "ダブルアンコール")

// i18n-ignore(storage): 本編 = section 列を持たない (保存しない) 区分
private const val MAIN_SECTION = "本編"

/** 区分の保存値 → 表示名。知らない値 (自由入力) はそのまま出す。 */
private fun sectionLabel(section: String): DisplayText = when (section) {
    sections[0] -> L10n.Edit.setlistSectionMain
    sections[1] -> L10n.Edit.setlistSectionEncore
    sections[2] -> L10n.Edit.setlistSectionMc
    sections[3] -> L10n.Edit.setlistSectionDoubleEncore
    else -> DisplayText.Verbatim(section)
}

@Composable
private fun SetlistEditRowView(
    row: EditableSetlistRow,
    idolById: Map<String, Idol>,
    isFirst: Boolean,
    isLast: Boolean,
    onPickSong: () -> Unit,
    onPickCasts: () -> Unit,
    onSectionChange: (String?) -> Unit,
    onMoveUp: () -> Unit,
    onMoveDown: () -> Unit,
    onRemove: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 6.dp)
            .clip(RoundedCornerShape(12.dp))
            .background(DS.surface)
            .padding(12.dp)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Row(
                modifier = Modifier.weight(1f).clickable(onClick = onPickSong),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Icon(Icons.Filled.MusicNote, contentDescription = null, tint = DS.ink2)
                Text(
                    if (row.songId.isEmpty() && row.songTitle.isEmpty()) {
                        L10n.Edit.setlistRowSongPlaceholder.resolve()
                    } else {
                        row.songTitle
                    },
                    fontSize = 15.sp,
                    color = if (row.songId.isEmpty()) DS.ink2 else DS.ink,
                    maxLines = 2, overflow = TextOverflow.Ellipsis,
                    modifier = Modifier.weight(1f)
                )
            }
            IconButton(onClick = onMoveUp, enabled = !isFirst) {
                Icon(Icons.Filled.KeyboardArrowUp, contentDescription = L10n.Edit.setlistRowMoveUpA11y.resolve())
            }
            IconButton(onClick = onMoveDown, enabled = !isLast) {
                Icon(Icons.Filled.KeyboardArrowDown, contentDescription = L10n.Edit.setlistRowMoveDownA11y.resolve())
            }
            IconButton(onClick = onRemove) {
                Icon(Icons.Filled.Close, contentDescription = L10n.Edit.setlistRowRemoveA11y.resolve(), tint = DS.danger)
            }
        }

        Row(
            modifier = Modifier.fillMaxWidth().padding(top = 8.dp),
            horizontalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            sections.forEach { section ->
                val selected = (row.section ?: MAIN_SECTION) == section
                FilterChip(
                    selected = selected,
                    onClick = { onSectionChange(if (section == MAIN_SECTION) null else section) },
                    label = { Text(sectionLabel(section).resolve(), fontSize = 12.sp) }
                )
            }
        }

        Row(
            modifier = Modifier.fillMaxWidth().clickable(onClick = onPickCasts).padding(top = 8.dp),
            verticalAlignment = Alignment.Top,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Icon(Icons.Filled.Person, contentDescription = null, tint = DS.ink2)
            if (row.castIds.isEmpty()) {
                Text(L10n.Edit.setlistRowNoCast.resolve(), fontSize = 13.sp, color = DS.ink2)
            } else {
                Text(
                    row.castIds.mapNotNull { idolById[it]?.name }.sorted().joinToString(" / "),
                    fontSize = 13.sp, color = DS.ink
                )
            }
        }
    }
}
