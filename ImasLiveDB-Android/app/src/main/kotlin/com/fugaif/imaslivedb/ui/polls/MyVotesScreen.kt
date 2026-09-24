package com.fugaif.imaslivedb.ui.polls

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.HowToVote
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.components.ImasEmptyState
import com.fugaif.imaslivedb.ui.theme.DS

/**
 * 自分が投票したお題の履歴。プロデュースタブ「投票」タイル → ここに飛ぶ。iOS MyVotesView の移植。
 * サーバに my-votes API が無いため、端末ローカル (LocalPollVoteLog) 駆動の履歴になっている
 * (再インストールで消えうる)。詳細画面への遷移導線は未配線のため、選択肢はラベル表示のみ。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MyVotesScreen(
    onBack: () -> Unit,
    viewModel: MyVotesViewModel = viewModel()
) {
    val state by viewModel.uiState.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(L10n.Polls.myVotesTitle.resolve(), fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onBack) { Icon(Icons.AutoMirrored.Filled.ArrowBack, L10n.Common.actionBack.resolve()) }
                }
            )
        }
    ) { padding ->
        when {
            state.isLoading && state.entries.isEmpty() -> {
                Box(Modifier.fillMaxSize().padding(padding), contentAlignment = Alignment.Center) { CircularProgressIndicator() }
            }
            state.entries.isEmpty() -> {
                Box(Modifier.fillMaxSize().padding(padding), contentAlignment = Alignment.Center) {
                    ImasEmptyState(
                        Icons.Filled.HowToVote,
                        L10n.Polls.myVotesEmptyTitle.resolve(),
                        L10n.Polls.myVotesEmptyMessage.resolve()
                    )
                }
            }
            else -> {
                LazyColumn(
                    modifier = Modifier.fillMaxSize().padding(padding),
                    contentPadding = PaddingValues(16.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    items(state.entries, key = { it.poll.id }) { entry ->
                        MyVoteEntryCard(entry)
                    }
                }
            }
        }
    }
}

@Composable
private fun MyVoteEntryCard(entry: MyVoteEntry) {
    Column(
        modifier = Modifier.fillMaxWidth()
            .clip(RoundedCornerShape(14.dp)).background(DS.surface)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text(
                entry.poll.title, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink,
                maxLines = 1, overflow = TextOverflow.Ellipsis, modifier = Modifier.weight(1f)
            )
            Text(
                pollStatusText(entry.poll.isActive, entry.poll.endsAtMs).resolve(), fontSize = 12.sp,
                color = if (entry.poll.isActive) DS.success else DS.ink3
            )
        }
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            entry.choices.forEach { choice ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Filled.CheckCircle, contentDescription = null, tint = DS.success, modifier = Modifier.size(18.dp))
                    Text(
                        choice.label.resolve(), fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = DS.ink,
                        maxLines = 2, overflow = TextOverflow.Ellipsis, modifier = Modifier.padding(start = 8.dp)
                    )
                }
            }
        }
    }
}
