package com.fugaif.imaslivedb.ui.ledger

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fugaif.imaslivedb.data.model.Expense
import com.fugaif.imaslivedb.data.repository.LedgerShowOption
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.components.ImasFilterChip
import com.fugaif.imaslivedb.ui.theme.DS
import java.time.Instant
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import uniffi.imas_core.ExpenseCategory
import uniffi.imas_core.ExpenseInputError
import uniffi.imas_core.expenseCategories
import uniffi.imas_core.expenseCategoryKey
import uniffi.imas_core.textSearchMatchRange
import uniffi.imas_core.validateExpense

private val DATE_FORMAT: DateTimeFormatter = DateTimeFormatter.ISO_LOCAL_DATE

/**
 * 支出 1 件の入力。追加も編集も同じシート。iOS `ExpenseEditorView` の移植。
 *
 * 入力の検査 (日付の形・金額の範囲) は**共有コア** (`validateExpense`) 一本。
 * ここは弾かれた理由を文言 (カタログ) に直して出すだけで、条件は Kotlin に書かない。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExpenseEditorSheet(
    expense: Expense?,
    showOptions: List<LedgerShowOption>,
    onSave: (Expense) -> Unit,
    onDismiss: () -> Unit
) {
    var dateText by rememberSaveable { mutableStateOf(expense?.date ?: DATE_FORMAT.format(Instant.now().atZone(ZoneOffset.UTC))) }
    var category by remember { mutableStateOf(expense?.categoryValue ?: ExpenseCategory.TICKET) }
    var amountText by rememberSaveable { mutableStateOf(expense?.amount?.toString() ?: "") }
    var note by rememberSaveable { mutableStateOf(expense?.note ?: "") }
    var showId by rememberSaveable { mutableStateOf(expense?.showId) }
    var eventId by rememberSaveable { mutableStateOf(expense?.eventId) }
    var showDatePicker by remember { mutableStateOf(false) }
    var showShowPicker by remember { mutableStateOf(false) }

    val amount = amountText.filter { it.isDigit() }.toLongOrNull() ?: 0L
    val validation = validateExpense(dateText, amount)

    ModalBottomSheet(onDismissRequest = onDismiss, containerColor = DS.bg) {
        Column(Modifier.padding(horizontal = 16.dp).padding(bottom = 24.dp)) {
            Text(
                (if (expense == null) L10n.Ledger.editorTitleAdd else L10n.Ledger.editorTitleEdit).resolve(),
                fontSize = 17.sp, fontWeight = FontWeight.Bold, color = DS.ink
            )
            Spacer(Modifier.height(16.dp))

            Text(L10n.Ledger.editorAmountHeader.resolve(), fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            OutlinedTextField(
                value = amountText,
                onValueChange = { amountText = it.filter(Char::isDigit) },
                placeholder = { Text("0") },
                leadingIcon = { Text("¥", color = DS.ink2) },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                singleLine = true,
                modifier = Modifier.fillMaxWidth()
            )
            if (validation == ExpenseInputError.NOT_POSITIVE || validation == ExpenseInputError.TOO_LARGE) {
                Text(message(validation).resolve(), fontSize = 12.sp, color = DS.danger,
                     modifier = Modifier.padding(top = 4.dp))
            }
            Spacer(Modifier.height(16.dp))

            Text(L10n.Ledger.editorCategoryHeader.resolve(), fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            CategoryGrid(selected = category, onSelect = { category = it })
            Spacer(Modifier.height(16.dp))

            Text(L10n.Ledger.editorDateHeader.resolve(), fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            Row(
                Modifier.fillMaxWidth().clip(RoundedCornerShape(10.dp)).background(DS.fill)
                    .clickable { showDatePicker = true }.padding(horizontal = 14.dp, vertical = 12.dp)
            ) {
                Text(dateText, fontSize = 15.sp, color = DS.ink)
            }
            Spacer(Modifier.height(16.dp))

            Text(L10n.Ledger.editorShowHeader.resolve(), fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            Row(
                Modifier.fillMaxWidth().clip(RoundedCornerShape(10.dp)).background(DS.fill)
                    .clickable { showShowPicker = true }.padding(horizontal = 14.dp, vertical = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                val label = showOptions.firstOrNull { it.id == showId }?.label ?: L10n.Ledger.editorShowNone.resolve()
                Text(label, fontSize = 15.sp, color = if (showId == null) DS.ink2 else DS.ink)
            }
            Text(
                L10n.Ledger.editorShowFooter.resolve(),
                fontSize = 11.sp, color = DS.ink3, modifier = Modifier.padding(top = 6.dp)
            )
            Spacer(Modifier.height(16.dp))

            Text(L10n.Ledger.editorNoteHeader.resolve(), fontSize = 12.sp, color = DS.ink2)
            Spacer(Modifier.height(6.dp))
            OutlinedTextField(
                value = note, onValueChange = { note = it },
                placeholder = { Text(L10n.Ledger.editorNotePlaceholder.resolve()) },
                singleLine = true, modifier = Modifier.fillMaxWidth()
            )
            Spacer(Modifier.height(20.dp))

            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
                TextButton(onClick = onDismiss) { Text(L10n.Ledger.editorActionCancel.resolve()) }
                Spacer(Modifier.width(8.dp))
                Button(
                    onClick = {
                        val saved = expense?.copy(
                            date = dateText, category = expenseCategoryKey(category), amount = amount,
                            showId = showId, eventId = eventId, note = note.ifEmpty { null }
                        ) ?: Expense.make(dateText, category, amount, showId, eventId, note)
                        onSave(saved)
                    },
                    enabled = validation == null
                ) { Text(L10n.Ledger.editorActionSave.resolve()) }
            }
        }
    }

    if (showDatePicker) {
        val initialMillis = runCatching {
            java.time.LocalDate.parse(dateText, DATE_FORMAT).atStartOfDay(ZoneOffset.UTC).toInstant().toEpochMilli()
        }.getOrNull()
        val pickerState = rememberDatePickerState(initialSelectedDateMillis = initialMillis)
        DatePickerDialog(
            onDismissRequest = { showDatePicker = false },
            confirmButton = {
                TextButton(onClick = {
                    pickerState.selectedDateMillis?.let { millis ->
                        dateText = Instant.ofEpochMilli(millis).atZone(ZoneOffset.UTC).format(DATE_FORMAT)
                    }
                    showDatePicker = false
                }) { Text(L10n.Ledger.editorDateConfirm.resolve()) }
            },
            dismissButton = {
                TextButton(onClick = { showDatePicker = false }) { Text(L10n.Ledger.editorActionCancel.resolve()) }
            }
        ) { DatePicker(state = pickerState) }
    }

    if (showShowPicker) {
        LedgerShowPickerSheet(
            options = showOptions,
            onPick = { option ->
                showId = option?.id
                eventId = option?.eventId
                // 日付を入れ直していなければ公演の日に合わせる (遠征費は当日が大半)。
                if (option != null && expense == null && amountText.isEmpty()) dateText = option.date
                showShowPicker = false
            },
            onDismiss = { showShowPicker = false }
        )
    }
}

@Composable
private fun CategoryGrid(selected: ExpenseCategory, onSelect: (ExpenseCategory) -> Unit) {
    // 並びはコアが決める。画面ごとに並べ替えない。
    val categories = remember { expenseCategories() }
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        categories.chunked(3).forEach { row ->
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                row.forEach { info ->
                    ImasFilterChip(info.label, info.category == selected, { onSelect(info.category) })
                }
            }
        }
    }
}

private fun message(error: ExpenseInputError?): DisplayText = when (error) {
    ExpenseInputError.BAD_DATE -> L10n.Ledger.editorErrorBadDate
    ExpenseInputError.NOT_POSITIVE -> L10n.Ledger.editorErrorNotPositive
    ExpenseInputError.TOO_LARGE -> L10n.Ledger.editorErrorTooLarge
    null -> DisplayText.Verbatim("")
}

/** 紐づける公演を選ぶ。参加を付けた公演だけが並ぶ。iOS `LedgerShowPicker` の移植。 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun LedgerShowPickerSheet(
    options: List<LedgerShowOption>,
    onPick: (LedgerShowOption?) -> Unit,
    onDismiss: () -> Unit
) {
    var query by rememberSaveable { mutableStateOf("") }
    // 照合の規則はコア一本 (画面で contains を書かない)。
    val shown = if (query.isEmpty()) options else options.filter {
        textSearchMatchRange(it.label, query) != null
    }

    ModalBottomSheet(onDismissRequest = onDismiss, containerColor = DS.bg) {
        Column(Modifier.padding(horizontal = 16.dp).padding(bottom = 24.dp)) {
            Text(L10n.Ledger.showPickerTitle.resolve(), fontSize = 17.sp, fontWeight = FontWeight.Bold, color = DS.ink)
            Spacer(Modifier.height(12.dp))
            OutlinedTextField(
                value = query, onValueChange = { query = it },
                placeholder = { Text(L10n.Ledger.showPickerSearchPrompt.resolve()) },
                singleLine = true, modifier = Modifier.fillMaxWidth()
            )
            Spacer(Modifier.height(8.dp))
            LazyColumn(Modifier.height(360.dp)) {
                item {
                    Text(
                        L10n.Ledger.showPickerNone.resolve(), fontSize = 15.sp, color = DS.ink,
                        modifier = Modifier.fillMaxWidth().clickable { onPick(null) }.padding(vertical = 12.dp)
                    )
                }
                if (options.isEmpty()) {
                    item {
                        Text(
                            L10n.Ledger.showPickerEmptyMessageAndroid.resolve(),
                            fontSize = 13.sp, color = DS.ink3, modifier = Modifier.padding(vertical = 12.dp)
                        )
                    }
                }
                items(shown, key = { it.id }) { option ->
                    Column(
                        Modifier.fillMaxWidth().clickable { onPick(option) }.padding(vertical = 10.dp)
                    ) {
                        Text(option.label, fontSize = 15.sp, color = DS.ink, maxLines = 2)
                        Text(option.date, fontSize = 12.sp, color = DS.ink3)
                    }
                }
            }
        }
    }
}
