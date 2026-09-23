package com.fugaif.imaslivedb

import android.app.Application
import android.util.Log
import com.fugaif.imaslivedb.di.AppModule
import com.fugaif.imaslivedb.player.AudioPreviewManager
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

class ImasLiveDBApplication : Application() {

    /** Eagerly initialised DI container; accessible from ViewModels via AppModule.from(context). */
    lateinit var appModule: AppModule
        private set

    /**
     * プロセス寿命の起動時タスク用。個々の失敗が他を巻き込まないよう SupervisorJob。
     * 捕まえ損ねた例外でプロセスごと落とさないよう、ハンドラで受けて記録だけする。
     */
    private val appScope = CoroutineScope(
        SupervisorJob() + Dispatchers.IO +
            CoroutineExceptionHandler { _, e -> Log.e(TAG, "起動時の処理が失敗", e) }
    )

    override fun onCreate() {
        super.onCreate()
        // Initialise DI container (warms up database singleton and repositories)
        appModule = AppModule.from(this)
        // 共有コアのスナップショットを起動時に load し、CloudKit sync 完了ごとに reload する。
        // 失敗・未ロード時は各リポジトリが Room/SQL 経路へフォールバックするので起動は阻害しない。
        appModule.snapshotStoreProvider.start()
        // サインイン済みなら isAdmin / BAN 状態をサーバから最新化する (iOS ImasLiveDBApp と同じ
        // タイミング)。BAN は /auth/login では返らないため、これが無いと BAN 済みユーザーに
        // 編集導線が出続ける。IO へ逃がすのは EncryptedSharedPreferences の復号もここで走るから。
        appScope.launch { appModule.authService.refreshMe() }
        // Initialise audio preview player
        AudioPreviewManager.init(this)
    }

    override fun onTerminate() {
        super.onTerminate()
        AudioPreviewManager.release()
    }

    private companion object {
        const val TAG = "ImasLiveDBApplication"
    }
}
