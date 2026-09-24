package com.fugaif.imaslivedb.ui.settings

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.OpenInNew
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.generated.L10n
import com.fugaif.imaslivedb.i18n.resolve
import com.fugaif.imaslivedb.ui.theme.DS

/**
 * プライバシーポリシー / 利用規約 / サポート。iOS `Views/About` 配下の各 swift ファイルの移植。
 * `NavRoutes`/`AppNavigation` は他画面監査と競合するため触らず、`SettingsScreen` から
 * フルスクリーン `Dialog` として開く (`RecentEditsScreen.SetlistEditScreen` と同じパターン)。
 *
 * 画面名・サポートの文言は i18n/catalog/about.json、プライバシーポリシーと利用規約の本文は
 * legal.json (iOS と ja が同じ節はキーも同じ。違う節は `*_android` のキー)。
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InfoScreenScaffold(title: DisplayText, onBack: () -> Unit, content: @Composable () -> Unit) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(title.resolve(), fontWeight = FontWeight.Bold) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, L10n.Common.actionBack.resolve())
                    }
                }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            content()
        }
    }
}

@Composable
private fun InfoSection(title: DisplayText, content: DisplayText) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(title.resolve(), fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
        Text(content.resolve(), fontSize = 15.sp, color = DS.ink2)
    }
}

@Composable
private fun LastUpdated(text: DisplayText) {
    Text(text.resolve(), fontSize = 12.sp, color = DS.ink3)
}

@Composable
fun PrivacyPolicyScreen(onBack: () -> Unit) {
    InfoScreenScaffold(title = L10n.About.privacyTitle, onBack = onBack) {
        InfoSection(L10n.Legal.privacyOverviewHeader, L10n.Legal.privacyOverviewBody)
        InfoSection(L10n.Legal.privacyCollectedHeader, L10n.Legal.privacyCollectedBodyAndroid)
        InfoSection(L10n.Legal.privacyThirdPartyHeader, L10n.Legal.privacyThirdPartyBodyAndroid)
        InfoSection(L10n.Legal.privacySharingHeader, L10n.Legal.privacySharingBodyAndroid)
        InfoSection(L10n.Legal.privacyRightsHeader, L10n.Legal.privacyRightsBodyAndroid)
        InfoSection(L10n.Legal.privacyContactHeader, L10n.Legal.privacyContactBody)
        LastUpdated(L10n.Legal.privacyLastUpdated)
    }
}

@Composable
fun TermsOfServiceScreen(onBack: () -> Unit) {
    InfoScreenScaffold(title = L10n.About.termsTitle, onBack = onBack) {
        InfoSection(L10n.Legal.termsDisclaimerHeader, L10n.Legal.termsDisclaimerBody)
        InfoSection(L10n.Legal.termsIpHeader, L10n.Legal.termsIpBody)
        InfoSection(L10n.Legal.termsMaterialsHeader, L10n.Legal.termsMaterialsBodyAndroid)
        InfoSection(L10n.Legal.termsUserContentHeader, L10n.Legal.termsUserContentBody)
        InfoSection(L10n.Legal.termsContentLicenseHeader, L10n.Legal.termsContentLicenseBodyAndroid)
        InfoSection(L10n.Legal.termsProhibitedHeader, L10n.Legal.termsProhibitedBodyAndroid)
        InfoSection(L10n.Legal.termsServiceChangesHeader, L10n.Legal.termsServiceChangesBody)
        InfoSection(L10n.Legal.termsContactHeader, L10n.Legal.termsContactBody)
        LastUpdated(L10n.Legal.termsLastUpdated)
    }
}

@Composable
fun SupportScreen(onBack: () -> Unit, onOpenGithubIssue: () -> Unit) {
    InfoScreenScaffold(title = L10n.About.supportTitle, onBack = onBack) {
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            Text(
                L10n.About.supportFeedbackHeader.resolve(),
                fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = DS.ink
            )
            Row(
                modifier = Modifier.clickable(onClick = onOpenGithubIssue),
                verticalAlignment = androidx.compose.ui.Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(6.dp)
            ) {
                Icon(Icons.AutoMirrored.Filled.OpenInNew, contentDescription = null, tint = Color(0xFF4A90D9))
                Text(L10n.About.supportFeedbackGithub.resolve(), fontSize = 15.sp, color = Color(0xFF4A90D9))
            }
        }
        Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
            Text(L10n.About.supportFaqHeader.resolve(), fontSize = 17.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
            FaqItem(L10n.About.supportFaqStaleDataQuestion, L10n.About.supportFaqStaleDataAnswer)
            FaqItem(L10n.About.supportFaqArtworkQuestion, L10n.About.supportFaqArtworkAnswerAndroid)
            FaqItem(L10n.About.supportFaqSyncQuestionAndroid, L10n.About.supportFaqSyncAnswerAndroid)
            FaqItem(L10n.About.supportFaqUnofficialQuestion, L10n.About.supportFaqUnofficialAnswer)
        }
    }
}

@Composable
private fun FaqItem(question: DisplayText, answer: DisplayText) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Text("Q. ${question.resolve()}", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
        Text("A. ${answer.resolve()}", fontSize = 15.sp, color = DS.ink2)
    }
}

/**
 * オープンソースライセンス一覧 (iOS `MyPageView` の OSS ライセンス節に対応)。
 *
 * 収録の基準は「アプリの配布物に実際に入るもの」= `app/build.gradle.kts` の
 * `implementation` 依存。ビルドやテストにしか使わない依存 (`debugImplementation` /
 * `testImplementation`) は配布されないので載せない。
 * 依存を足したらここも足すこと — 生成ツールを入れていないので同期は手動。
 */
@Composable
fun OssLicensesScreen(onBack: () -> Unit) {
    InfoScreenScaffold(title = L10n.About.ossTitle, onBack = onBack) {
        Text(
            L10n.About.ossIntro.resolve(),
            fontSize = 13.sp,
            color = DS.ink2
        )
        LicenseItem("AndroidX (Core / Lifecycle / Activity / Navigation / Security / Credentials)", "Google", APACHE_2)
        LicenseItem("Jetpack Compose (UI / Material 3 / Material Icons)", "Google", APACHE_2)
        LicenseItem("Room", "Google", APACHE_2)
        LicenseItem("Glance (App Widget)", "Google", APACHE_2)
        LicenseItem("Media3 / ExoPlayer", "Google", APACHE_2)
        LicenseItem("Google Identity Services (googleid)", "Google", APACHE_2)
        LicenseItem("Coil", "Coil Contributors", APACHE_2)
        LicenseItem("OkHttp", "Square, Inc.", APACHE_2)
        LicenseItem("Kotlin / kotlinx.coroutines", "JetBrains", APACHE_2)
        // JNA だけライセンスが違う。UniFFI が生成するバインディングが要求する実行時依存。
        LicenseItem("JNA (Java Native Access)", "JNA Contributors", L10n.About.ossJnaLicense)
        LicenseItem("imas-core", L10n.About.ossCoreOwner, L10n.About.ossCoreLicense)
    }
}

/** ライセンス名は訳さない (固有名詞)。 */
private val APACHE_2: DisplayText = DisplayText.Verbatim("Apache License 2.0")

/** 作者が固有名詞 (Google など。訳さない) の行。 */
@Composable
private fun LicenseItem(name: String, owner: String, license: DisplayText) =
    LicenseItem(name, DisplayText.Verbatim(owner), license)

@Composable
private fun LicenseItem(name: String, owner: DisplayText, license: DisplayText) {
    Column(verticalArrangement = Arrangement.spacedBy(2.dp)) {
        Text(name, fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = DS.ink)
        Text(L10n.About.ossItemMeta(owner = owner, license = license).resolve(), fontSize = 12.sp, color = DS.ink2)
    }
}
