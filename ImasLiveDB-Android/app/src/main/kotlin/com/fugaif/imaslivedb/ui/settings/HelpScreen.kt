package com.fugaif.imaslivedb.ui.settings

import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Bookmark
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.CloudSync
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.ExpandLess
import androidx.compose.material.icons.filled.ExpandMore
import androidx.compose.material.icons.filled.Groups
import androidx.compose.material.icons.filled.Headphones
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.Palette
import androidx.compose.material.icons.filled.PhotoLibrary
import androidx.compose.material.icons.filled.QueueMusic
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Sell
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.theme.DS
import com.fugaif.imaslivedb.ui.theme.ImasTheme

/**
 * ヘルプ (使い方カタログ)。iOS `Views/Help/HelpView.swift` の移植。
 *
 * 文面は i18n/catalog/help.json (kind: content) にあり、iOS の `HelpCatalog.sections` と同じ項目は
 * **同じキー**を引く。両 OS で説明が食い違うと「アプリによって出来ることが違う」と読めてしまうため、
 * 文言を片方だけ直さないこと (直すときはカタログの 1 か所で両方が変わる)。
 *
 * **ただし、実際に出来ることが違う項目はこちらの実装に合わせて書き換える。**
 * 機械変換した初版は「Apple Music に契約していればフル再生 OK」「Sign in with Apple」
 * 「マイページ → 画像インポート」のように、Android に無い機能や違う場所を案内していた。
 * 揃えるべきは文言ではなく「読んだ人が実際にたどり着けること」。そういう項目はカタログで
 * `*_android` のキー (または Android だけの項目) にしてある。
 *
 * アイコンだけは SF Symbol → Material Icons の対応を人が決めている。
 * 色 (tint) は iOS と同じ hex を渡し、`ImasTheme.derive` で両 OS 同じトークンに導出する。
 */
data class HelpSection(
    /** 一覧の key (カタログの help.category.<id>)。LazyColumn の key は Bundle に入る型にする。 */
    val id: String,
    val icon: ImageVector,
    /** カテゴリ識別用の装飾テーマ seed (hex)。iOS と同じ値。 */
    val tint: String,
    val title: DisplayText,
    val summary: DisplayText,
    val body: List<HelpItem>
)

data class HelpItem(val label: DisplayText, val detail: DisplayText)

object HelpCatalog {
    val sections: List<HelpSection> = listOf(
    HelpSection(
        id = "events",
        icon = Icons.Filled.Mic,
        tint = "#FF2D55",
        title = L10n.Help.categoryEventsTitle,
        summary = L10n.Help.categoryEventsSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryEventsYearListLabel, L10n.Help.categoryEventsYearListDetail),
            HelpItem(L10n.Help.categoryEventsBrandFilterLabel, L10n.Help.categoryEventsBrandFilterDetail),
            HelpItem(L10n.Help.categoryEventsKindFilterLabel, L10n.Help.categoryEventsKindFilterDetail),
            HelpItem(L10n.Help.categoryEventsEventDetailLabel, L10n.Help.categoryEventsEventDetailDetail),
            HelpItem(L10n.Help.categoryEventsAttendedLabel, L10n.Help.categoryEventsAttendedDetail),
        )
    ),
    HelpSection(
        id = "songs",
        icon = Icons.Filled.QueueMusic,
        tint = "#5856D6",
        title = L10n.Help.categorySongsTitle,
        summary = L10n.Help.categorySongsSummary,
        body = listOf(
            HelpItem(L10n.Help.categorySongsViewModesLabel, L10n.Help.categorySongsViewModesDetail),
            HelpItem(L10n.Help.categorySongsPreviewLabel, L10n.Help.categorySongsPreviewDetail),
            HelpItem(L10n.Help.categorySongsHistoryLabel, L10n.Help.categorySongsHistoryDetail),
            HelpItem(L10n.Help.categorySongsOriginalMembersLabel, L10n.Help.categorySongsOriginalMembersDetail),
            HelpItem(L10n.Help.categorySongsCollectFilterLabel, L10n.Help.categorySongsCollectFilterDetail),
        )
    ),
    HelpSection(
        id = "idols",
        icon = Icons.Filled.Groups,
        tint = "#FF9500",
        title = L10n.Help.categoryIdolsTitle,
        summary = L10n.Help.categoryIdolsSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryIdolsLayoutLabel, L10n.Help.categoryIdolsLayoutDetail),
            HelpItem(L10n.Help.categoryIdolsCvNamesLabel, L10n.Help.categoryIdolsCvNamesDetail),
            HelpItem(L10n.Help.categoryIdolsAttributesLabel, L10n.Help.categoryIdolsAttributesDetail),
            HelpItem(L10n.Help.categoryIdolsIdolDetailLabel, L10n.Help.categoryIdolsIdolDetailDetail),
            HelpItem(L10n.Help.categoryIdolsAliasesLabel, L10n.Help.categoryIdolsAliasesDetail),
        )
    ),
    HelpSection(
        id = "marks",
        icon = Icons.Filled.Bookmark,
        tint = "#FF3B30",
        title = L10n.Help.categoryMarksTitle,
        summary = L10n.Help.categoryMarksSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryMarksOshiLabel, L10n.Help.categoryMarksOshiDetail),
            HelpItem(L10n.Help.categoryMarksCollectedLabel, L10n.Help.categoryMarksCollectedDetail),
            HelpItem(L10n.Help.categoryMarksAttendedLabel, L10n.Help.categoryMarksAttendedDetail),
            HelpItem(L10n.Help.categoryMarksLocalLabel, L10n.Help.categoryMarksLocalDetailAndroid),
        )
    ),
    HelpSection(
        id = "edit",
        icon = Icons.Filled.Edit,
        tint = "#007AFF",
        title = L10n.Help.categoryEditTitle,
        summary = L10n.Help.categoryEditSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryEditDirectLabel, L10n.Help.categoryEditDirectDetail),
            HelpItem(L10n.Help.categoryEditLoginLabelAndroid, L10n.Help.categoryEditLoginDetailAndroid),
            HelpItem(L10n.Help.categoryEditHistoryLabel, L10n.Help.categoryEditHistoryDetail),
            HelpItem(L10n.Help.categoryEditLikesLabel, L10n.Help.categoryEditLikesDetail),
            HelpItem(L10n.Help.categoryEditRevertLabel, L10n.Help.categoryEditRevertDetail),
            HelpItem(L10n.Help.categoryEditContributionLabel, L10n.Help.categoryEditContributionDetail),
        )
    ),
    HelpSection(
        id = "tags",
        icon = Icons.Filled.Sell,
        tint = "#30B0C7",
        title = L10n.Help.categoryTagsTitle,
        summary = L10n.Help.categoryTagsSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryTagsAttachLabel, L10n.Help.categoryTagsAttachDetail),
            HelpItem(L10n.Help.categoryTagsBrowseLabel, L10n.Help.categoryTagsBrowseDetail),
            HelpItem(L10n.Help.categoryTagsDescriptionLabel, L10n.Help.categoryTagsDescriptionDetail),
        )
    ),
    HelpSection(
        id = "penlight",
        icon = Icons.Filled.Palette,
        tint = "#AF52DE",
        title = L10n.Help.categoryPenlightTitle,
        summary = L10n.Help.categoryPenlightSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryPenlightVoteLabel, L10n.Help.categoryPenlightVoteDetail),
            HelpItem(L10n.Help.categoryPenlightResultsLabel, L10n.Help.categoryPenlightResultsDetail),
            HelpItem(L10n.Help.categoryPenlightOneVoteLabel, L10n.Help.categoryPenlightOneVoteDetail),
        )
    ),
    HelpSection(
        id = "intro",
        icon = Icons.Filled.Headphones,
        tint = "#FF2D55",
        title = L10n.Help.categoryIntroTitle,
        summary = L10n.Help.categoryIntroSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryIntroStreamableLabel, L10n.Help.categoryIntroStreamableDetail),
            HelpItem(L10n.Help.categoryIntroDifficultyLabel, L10n.Help.categoryIntroDifficultyDetail),
            HelpItem(L10n.Help.categoryIntroChoicesLabel, L10n.Help.categoryIntroChoicesDetail),
            HelpItem(L10n.Help.categoryIntroBestLabel, L10n.Help.categoryIntroBestDetail),
        )
    ),
    HelpSection(
        id = "search",
        icon = Icons.Filled.Search,
        tint = "#8E8E93",
        title = L10n.Help.categorySearchTitle,
        summary = L10n.Help.categorySearchSummary,
        body = listOf(
            HelpItem(L10n.Help.categorySearchInTabLabel, L10n.Help.categorySearchInTabDetail),
            HelpItem(L10n.Help.categorySearchGlobalLabel, L10n.Help.categorySearchGlobalDetailAndroid),
            HelpItem(L10n.Help.categorySearchFallbackLabel, L10n.Help.categorySearchFallbackDetail),
            HelpItem(L10n.Help.categorySearchAliasesLabel, L10n.Help.categorySearchAliasesDetail),
        )
    ),
    HelpSection(
        id = "calendar",
        icon = Icons.Filled.CalendarMonth,
        tint = "#34C759",
        title = L10n.Help.categoryCalendarTitle,
        summary = L10n.Help.categoryCalendarSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryCalendarOpenLabelAndroid, L10n.Help.categoryCalendarOpenDetail),
            HelpItem(L10n.Help.categoryCalendarColorsLabel, L10n.Help.categoryCalendarColorsDetail),
        )
    ),
    HelpSection(
        id = "image_import",
        icon = Icons.Filled.PhotoLibrary,
        tint = "#00C7BE",
        title = L10n.Help.categoryImageImportTitle,
        summary = L10n.Help.categoryImageImportSummary,
        body = listOf(
            HelpItem(L10n.Help.categoryImageImportOpenLabelAndroid, L10n.Help.categoryImageImportOpenDetail),
            HelpItem(L10n.Help.categoryImageImportTemplateLabel, L10n.Help.categoryImageImportTemplateDetail),
            HelpItem(L10n.Help.categoryImageImportAliasesLabel, L10n.Help.categoryImageImportAliasesDetail),
            HelpItem(L10n.Help.categoryImageImportResetLabel, L10n.Help.categoryImageImportResetDetail),
        )
    ),
    HelpSection(
        id = "sync",
        icon = Icons.Filled.CloudSync,
        tint = "#32ADE6",
        title = L10n.Help.categorySyncTitle,
        summary = L10n.Help.categorySyncSummary,
        body = listOf(
            HelpItem(L10n.Help.categorySyncCloudkitLabel, L10n.Help.categorySyncCloudkitDetail),
            HelpItem(L10n.Help.categorySyncLoginLabelAndroid, L10n.Help.categorySyncLoginDetail),
            HelpItem(L10n.Help.categorySyncDeleteAccountLabel, L10n.Help.categorySyncDeleteAccountDetail),
        )
    ),
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HelpScreen(onBack: () -> Unit) {
    Scaffold(
        containerColor = DS.bg,
        topBar = {
            TopAppBar(
                title = { Text(L10n.Help.topTitleAndroid.resolve(), fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = L10n.Common.actionBack.resolve())
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = DS.bg, titleContentColor = DS.ink, navigationIconContentColor = DS.ink
                )
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier.fillMaxSize().padding(padding),
            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            item {
                Column(modifier = Modifier.padding(horizontal = 4.dp, vertical = 8.dp)) {
                    Text(L10n.Help.topHeading.resolve(), fontSize = 20.sp, fontWeight = FontWeight.Bold, color = DS.ink)
                    Text(
                        L10n.Help.topIntro.resolve(),
                        fontSize = 13.sp, color = DS.ink2, modifier = Modifier.padding(top = 4.dp)
                    )
                }
            }
            items(HelpCatalog.sections, key = { it.id }) { section -> HelpSectionCard(section) }
        }
    }
}

/** 見出しをタップで開閉する 1 カテゴリ。iOS は遷移だが、Android は戻る操作が増えるので開閉にした。 */
@Composable
private fun HelpSectionCard(section: HelpSection) {
    var expanded by remember { mutableStateOf(false) }
    val theme = ImasTheme.derive(section.tint)
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(14.dp))
            .background(DS.surface)
            .clickable { expanded = !expanded }
            .animateContentSize()
            .padding(14.dp)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(12.dp)) {
            Icon(
                section.icon, contentDescription = null, tint = theme.accent,
                modifier = Modifier.size(36.dp).clip(CircleShape).background(theme.bar.copy(alpha = 0.18f)).padding(7.dp)
            )
            Column(modifier = Modifier.weight(1f)) {
                Text(section.title.resolve(), fontSize = 15.sp, fontWeight = FontWeight.Bold, color = DS.ink)
                Text(section.summary.resolve(), fontSize = 12.sp, color = DS.ink2)
            }
            Icon(
                if (expanded) Icons.Filled.ExpandLess else Icons.Filled.ExpandMore,
                contentDescription = null, tint = DS.ink3
            )
        }
        if (expanded) {
            Column(modifier = Modifier.padding(top = 12.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                section.body.forEach { item ->
                    Column {
                        Text(item.label.resolve(), fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
                        Text(item.detail.resolve(), fontSize = 12.sp, color = DS.ink2, modifier = Modifier.padding(top = 2.dp))
                    }
                }
            }
        }
    }
}
