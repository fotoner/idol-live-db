package com.fugaif.imaslivedb.data.auth

import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment

/**
 * 認証情報の保存先 (EncryptedSharedPreferences) が開けない端末でも、AuthService が落ちない。
 *
 * キーストアが壊れた端末では暗号化 prefs の作成が例外になる。以前はそれがコンストラクタから
 * 飛び、起動時の refreshMe や設定画面が触れた瞬間にアプリが落ち、起動のたびに落ち続けた。
 * Robolectric には AndroidKeyStore が無いので、ここでは実際に作成が失敗する。
 */
@RunWith(RobolectricTestRunner::class)
class AuthServiceStartupTest {

    @Test
    fun startsSignedOutWhenSecurePrefsCannotBeOpened() = runBlocking {
        val auth = AuthService(RuntimeEnvironment.getApplication())

        assertEquals(AuthState(), auth.state.value)
        assertNull(auth.sessionToken)
        // どれもサーバや保存先に触れる前に黙って終わる (例外を投げない)。
        auth.refreshMe()
        auth.markBannedFromServer()
        auth.signOut()
        assertTrue(!auth.state.value.isSignedIn)
    }
}
