package com.fugaif.imaslivedb.data.backup

import android.util.Log
import com.fugaif.imaslivedb.data.net.WorkerHttpClient
import com.fugaif.imaslivedb.i18n.DisplayText
import com.fugaif.imaslivedb.i18n.UserFacing
import com.fugaif.imaslivedb.i18n.generated.L10n
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject

/**
 * 引き継ぎコード API (`/transfer`) の呼び出しで発生したエラー。
 *
 * 例外は理由 ([reason]) だけを持ち、利用者に見せる文言への対応は [userMessage] の 1 か所に置く
 * (画面は `e.message` ではなく [userMessage] を UiState に入れ、出口で resolve する)。
 */
class BackupTransferException(val reason: Reason, val httpCode: Int? = null) :
    Exception(if (httpCode != null) "${reason.name} (HTTP $httpCode)" else reason.name), UserFacing {

    enum class Reason { LOGIN_REQUIRED, INVALID_OR_EXPIRED, RATE_LIMITED, BAD_DATA, BAD_RESPONSE, TRANSPORT, HTTP }

    override val userMessage: DisplayText
        get() = when (reason) {
            Reason.LOGIN_REQUIRED -> L10n.Settings.backupErrorLoginRequired
            Reason.INVALID_OR_EXPIRED -> L10n.Settings.backupErrorInvalidCode
            Reason.RATE_LIMITED -> L10n.Settings.backupErrorRateLimited
            Reason.BAD_DATA -> L10n.Settings.backupErrorBadData
            Reason.BAD_RESPONSE -> L10n.Settings.backupErrorBadResponse
            Reason.TRANSPORT -> L10n.Settings.backupErrorTransport
            Reason.HTTP -> L10n.Settings.backupErrorHttp(status = httpCode ?: 0)
        }
}

data class TransferCodeResult(val code: String, val expiresAt: String)

/** 引き継ぎコード方式のバックアップ転送 (サーバー経由)。iOS BackupTransferService の移植。 */
class BackupTransferApi(private val http: WorkerHttpClient) {

    /** POST /transfer — payload (envelope JSON文字列) をサーバーに保管し、ワンタイムコードを発行する。 */
    suspend fun createTransferCode(payloadJson: String): TransferCodeResult = withContext(Dispatchers.IO) {
        try {
            val response = http.request("POST", "/transfer", JSONObject().put("payload", payloadJson))
            if (!response.isSuccess) {
                Log.w(TAG, "POST /transfer -> HTTP ${response.code} body=${response.body}")
                throw statusException(response.code)
            }
            val json = JSONObject(response.body ?: throw BackupTransferException(BackupTransferException.Reason.BAD_RESPONSE))
            TransferCodeResult(json.getString("code"), json.getString("expiresAt"))
        } catch (e: BackupTransferException) {
            throw e
        } catch (e: Exception) {
            Log.w(TAG, "POST /transfer failed: ${e.message}")
            throw BackupTransferException(BackupTransferException.Reason.TRANSPORT)
        }
    }

    /** GET /transfer/:code — コードでペイロード文字列を取得する (ワンタイム消費、成功すればサーバー側では即座に削除される)。 */
    suspend fun fetchTransferCode(code: String): String = withContext(Dispatchers.IO) {
        try {
            val response = http.request("GET", "/transfer/${enc(code.trim().uppercase())}")
            if (!response.isSuccess) {
                Log.w(TAG, "GET /transfer/:code -> HTTP ${response.code} body=${response.body}")
                throw statusException(response.code)
            }
            val json = JSONObject(response.body ?: throw BackupTransferException(BackupTransferException.Reason.BAD_RESPONSE))
            json.getString("payload")
        } catch (e: BackupTransferException) {
            throw e
        } catch (e: Exception) {
            Log.w(TAG, "GET /transfer/:code failed: ${e.message}")
            throw BackupTransferException(BackupTransferException.Reason.TRANSPORT)
        }
    }

    private fun statusException(httpCode: Int): BackupTransferException = when (httpCode) {
        401 -> BackupTransferException(BackupTransferException.Reason.LOGIN_REQUIRED)
        404 -> BackupTransferException(BackupTransferException.Reason.INVALID_OR_EXPIRED)
        429 -> BackupTransferException(BackupTransferException.Reason.RATE_LIMITED)
        400 -> BackupTransferException(BackupTransferException.Reason.BAD_DATA)
        else -> BackupTransferException(BackupTransferException.Reason.HTTP, httpCode)
    }

    private fun enc(s: String): String = java.net.URLEncoder.encode(s, "UTF-8").replace("+", "%20")

    companion object {
        private const val TAG = "BackupTransferApi"
    }
}
