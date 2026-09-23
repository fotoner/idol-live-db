package com.fugaif.imaslivedb.ui.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.Groups
import androidx.compose.material.icons.filled.LibraryMusic
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.vector.ImageVector
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve

private data class BottomNavItem(
    val tab: TopLevelTab,
    val label: DisplayText,
    val icon: ImageVector
)

private val navItems = listOf(
    BottomNavItem(TopLevelTab.Schedule, L10n.Nav.tabSchedule, Icons.Filled.CalendarMonth),
    BottomNavItem(TopLevelTab.Events, L10n.Nav.tabEvents, Icons.Filled.Mic),
    BottomNavItem(TopLevelTab.Songs, L10n.Nav.tabSongs, Icons.Filled.LibraryMusic),
    BottomNavItem(TopLevelTab.Idols, L10n.Nav.tabIdols, Icons.Filled.Groups),
    BottomNavItem(TopLevelTab.Produce, L10n.Nav.tabProduce, Icons.Filled.Star)
)

@Composable
fun BottomNavBar(
    currentTab: TopLevelTab,
    onTabSelected: (TopLevelTab) -> Unit
) {
    NavigationBar {
        navItems.forEach { item ->
            NavigationBarItem(
                selected = currentTab == item.tab,
                onClick = { onTabSelected(item.tab) },
                icon = { Icon(imageVector = item.icon, contentDescription = item.label.resolve()) },
                label = { Text(text = item.label.resolve()) }
            )
        }
    }
}
