package com.fugaif.imaslivedb.ui.navigation

import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.layout.Column
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.BarChart
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.Campaign
import androidx.compose.material.icons.filled.Groups
import androidx.compose.material.icons.filled.LibraryMusic
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.People
import androidx.compose.material.icons.filled.Poll
import androidx.compose.material.icons.filled.SportsEsports
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Timeline
import androidx.compose.material.icons.filled.Whatshot
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationDrawerItem
import androidx.compose.material3.PermanentDrawerSheet
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.unit.dp
import uniffi.imas_core.AppDestination
import uniffi.imas_core.NavItem
import uniffi.imas_core.NavSection

/**
 * 行き先のアイコン。並び・見出し・文言はコア (`appNavigationSections`) が持ち、
 * Material のアイコンだけ OS 側で引く (iOS は SF Symbols の別物になるため)。
 */
val AppDestination.icon: ImageVector
    get() = when (this) {
        AppDestination.SCHEDULE -> Icons.Filled.CalendarMonth
        AppDestination.EVENTS -> Icons.Filled.Mic
        AppDestination.SONGS -> Icons.Filled.LibraryMusic
        AppDestination.IDOLS -> Icons.Filled.Groups
        AppDestination.PRODUCE -> Icons.Filled.Star
        AppDestination.STATS -> Icons.Filled.BarChart
        AppDestination.TIMELINE -> Icons.Filled.Timeline
        AppDestination.POLLS -> Icons.Filled.Poll
        AppDestination.CALL_GUIDE -> Icons.Filled.Campaign
        AppDestination.COMMUNITY_ACTIVITY -> Icons.Filled.People
        AppDestination.TAG_ACTIVITY -> Icons.Filled.Whatshot
        AppDestination.GAMES -> Icons.Filled.SportsEsports
    }

/** 狭い画面の下のタブバー。載せるのはコアが `inTabBar` とした行き先だけ。 */
@Composable
fun BottomNavBar(
    items: List<NavItem>,
    current: AppDestination,
    onSelect: (AppDestination) -> Unit
) {
    NavigationBar {
        items.forEach { item ->
            NavigationBarItem(
                selected = current == item.destination,
                onClick = { onSelect(item.destination) },
                icon = { Icon(imageVector = item.destination.icon, contentDescription = item.label) },
                label = { Text(text = item.label) }
            )
        }
    }
}

/**
 * 広い画面 (タブレット) の左のサイドバー。iOS の `TabView(.sidebarAdaptable)` と同じ並び。
 * サイドバーだけの行き先の中身は、狭い画面でプロデュースの入口から開く画面と同じ。
 */
@Composable
fun AppSidebar(
    sections: List<NavSection>,
    current: AppDestination,
    onSelect: (AppDestination) -> Unit
) {
    PermanentDrawerSheet(modifier = Modifier.width(240.dp)) {
        Column(
            modifier = Modifier
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 12.dp, vertical = 16.dp)
        ) {
            sections.forEach { section ->
                section.title?.let { title ->
                    Spacer(Modifier.height(12.dp))
                    Text(
                        text = title,
                        style = MaterialTheme.typography.labelMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(start = 16.dp, bottom = 4.dp)
                    )
                }
                section.items.forEach { item ->
                    NavigationDrawerItem(
                        label = { Text(item.label) },
                        icon = { Icon(item.destination.icon, contentDescription = null) },
                        selected = current == item.destination,
                        onClick = { onSelect(item.destination) }
                    )
                }
            }
        }
    }
}
