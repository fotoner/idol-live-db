package com.fugaif.imaslivedb.ui.edit

import com.fugaif.imaslivedb.i18n.generated.L10n
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test

/** 語彙に無い種別のイベントを直しても、黙って別の種別に書き換えない (iOS EventEditKindTests と同じ)。 */
class EventEditKindTest {

    @Test
    fun unknownKindKeepsAnUnchangedOption() {
        val options = eventKindEditOptions("future_kind")
        // 選び直さない限り、元の生の値がそのまま状態に残り送り返される。
        // ラベルは「変更しない (future_kind)」の文言 (解決せずに値で比べる)。
        assertEquals("future_kind" to L10n.Edit.eventKindUnchanged(raw = "future_kind"), options.last())
        assertFalse("受け皿の「その他」は選択肢に出さない", options.any { it.first == "other" })
    }

    @Test
    fun knownKindHasNoExtraOption() {
        val options = eventKindEditOptions("festival")
        assertFalse(options.any { it.second == L10n.Edit.eventKindUnchanged(raw = it.first) })
        assertEquals(options, eventKindEditOptions(null))
    }

    @Test
    fun otherItselfIsKeptAsIs() {
        assertEquals("other" to L10n.Edit.eventKindUnchanged(raw = "other"), eventKindEditOptions("other").last())
    }
}
