package com.fugaif.imaslivedb.ui.edit

import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.LocalContext
import com.fugaif.imaslivedb.data.edit.EditApi
import com.fugaif.imaslivedb.data.edit.putClearable
import com.fugaif.imaslivedb.data.model.Show
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import kotlinx.coroutines.launch

/** 出演形態。iOS `ShowEditView.performerTypes` と同じ 4 択 (空 = 未指定。それ以外は保存する値をそのまま出す)。 */
private val PERFORMER_TYPES: List<Pair<String, DisplayText>>
    get() = listOf(
        "" to L10n.Edit.formOptionUnspecified,
        "character" to DisplayText.Verbatim("character"),
        "cast" to DisplayText.Verbatim("cast"),
        "mixed" to DisplayText.Verbatim("mixed")
    )

/**
 * 公演 (Show) の新規作成 / 編集。iOS `ShowEditView` の移植。
 *
 * 新規作成は必ず親イベントの詳細画面から開く ([eventId] が必須のため)。
 * recordName はサーバ採番に任せる。
 *
 * @param original null なら新規作成。
 * @param eventId 親イベント ID。編集時は original.eventId と同じ値を渡すこと。
 * @param suggestedSortOrder 新規作成時の並び順初期値 (既存公演数を渡す想定)。
 */
@Composable
fun ShowEditScreen(
    original: Show? = null,
    eventId: String,
    suggestedSortOrder: Int = 0,
    onDismiss: () -> Unit,
    onSaved: (String) -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    val isCreate = original == null
    val key = original?.id ?: "new"

    var name by rememberSaveable(key) { mutableStateOf(original?.name ?: "") }
    var date by rememberSaveable(key) { mutableStateOf(original?.date ?: "") }
    var venue by rememberSaveable(key) { mutableStateOf(original?.venue ?: "") }
    var venueCity by rememberSaveable(key) { mutableStateOf(original?.venueCity ?: "") }
    var startTime by rememberSaveable(key) { mutableStateOf(original?.startTime ?: "") }
    var sortOrder by rememberSaveable(key) { mutableIntStateOf(original?.sortOrder ?: suggestedSortOrder) }
    var performerType by rememberSaveable(key) { mutableStateOf(original?.performerType ?: "") }

    var isSaving by remember { mutableStateOf(false) }
    var errorMessage by remember { mutableStateOf<DisplayText?>(null) }
    var requestedIssueUrl by remember { mutableStateOf<String?>(null) }
    var requestSent by remember { mutableStateOf(false) }

    fun save() {
        val trimmedName = name.trim()
        val trimmedDate = date.trim()
        // iOS ShowEditView.save() と同条件: 公演名と日付が必須、日付は YYYY-MM-DD。
        if (trimmedName.isEmpty() || trimmedDate.isEmpty()) {
            errorMessage = L10n.Edit.showErrorRequired; return
        }
        if (!isValidShowDate(trimmedDate)) {
            errorMessage = L10n.Edit.showErrorDateFormat; return
        }

        val fields = mutableMapOf<String, Any?>(
            "eventId" to eventId,
            "name" to trimmedName,
            "date" to trimmedDate,
            "sortOrder" to sortOrder
        )
        fields.putClearable("venue", venue, original?.venue)
        fields.putClearable("venueCity", venueCity, original?.venueCity)
        fields.putClearable("startTime", startTime, original?.startTime)
        fields.putClearable("performerType", performerType, original?.performerType)

        val op = EditApi.EditOperation(
            op = if (isCreate) EditApi.EditOp.CREATE else EditApi.EditOp.UPDATE,
            recordType = "Show",
            recordName = original?.id,
            fields = fields
        )

        isSaving = true
        scope.launch {
            val result = submitMasterEdit(
                context = context,
                ops = listOf(op),
                // i18n-ignore(storage): 編集履歴に残るサマリ (サーバに送るデータ)。画面の言語で変えない
                summary = if (isCreate) "公演追加" else "公演編集",
                fallbackRecordName = original?.id
            ) { resolvedId ->
                // venueId / hall / streamPlatform はフォームに無い列。copy で引き継がないと
                // Room の REPLACE で消え、会場の同一性 (venue_id) まで失われる。
                val saved = (original ?: emptyShow(resolvedId, eventId)).copy(
                    id = resolvedId,
                    eventId = eventId,
                    name = trimmedName,
                    date = trimmedDate,
                    venue = venue.nonEmptyTrimmed(),
                    venueCity = venueCity.nonEmptyTrimmed(),
                    startTime = startTime.nonEmptyTrimmed(),
                    sortOrder = sortOrder,
                    performerType = performerType.nonEmptyTrimmed()
                )
                AppModule.from(context).masterEditRepository.applyShow(saved)
            }
            isSaving = false
            when (result) {
                is MasterEditSubmitResult.Applied -> onSaved(result.recordName)
                is MasterEditSubmitResult.Requested -> {
                    requestedIssueUrl = result.issueUrl
                    requestSent = true
                }
                is MasterEditSubmitResult.Failed -> errorMessage = result.message
            }
        }
    }

    MasterEditScaffold(
        title = (if (isCreate) L10n.Edit.showTitleCreateAndroid else L10n.Edit.showTitleEdit).resolve(),
        canSave = name.trim().isNotEmpty() && date.trim().isNotEmpty(),
        isSaving = isSaving,
        onCancel = onDismiss,
        onSave = ::save
    ) {
        EditSection(L10n.Edit.formSectionBasic.resolve()) {
            if (original != null) EditReadonlyRow("ID", original.id)
            EditTextField(L10n.Edit.showFieldName.resolve(), name, { name = it })
            EditTextField(L10n.Edit.showFieldDate.resolve(), date, { date = it })
            EditTextField(L10n.Edit.showFieldVenue.resolve(), venue, { venue = it })
            EditTextField(L10n.Edit.showFieldVenueCity.resolve(), venueCity, { venueCity = it })
            EditTextField(L10n.Edit.showFieldStartTime.resolve(), startTime, { startTime = it })
            EditStepperRow(L10n.Edit.formSortOrderAndroid(value = sortOrder), sortOrder, 0..999) { sortOrder = it }
            EditDropdownField(L10n.Edit.showFieldPerformerType.resolve(), PERFORMER_TYPES, performerType) { performerType = it }
        }
    }

    errorMessage?.let { EditErrorDialog(it) { errorMessage = null } }

    if (requestSent) {
        EditRequestSentDialog(requestedIssueUrl) { requestSent = false; onDismiss() }
    }
}

/** 新規作成時の土台。フォームで埋める列以外は既定値にする。 */
private fun emptyShow(id: String, eventId: String) = Show(
    id = id,
    eventId = eventId,
    name = "",
    date = "",
    venue = null,
    venueCity = null,
    startTime = null,
    sortOrder = 0,
    performerType = null
)
