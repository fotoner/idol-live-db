// 生成物: i18n/catalog/system.json → python3 tools/i18n/i18n.py generate。手で直さない。
package com.fugaif.imaslivedb.i18n.generated

import com.fugaif.imaslivedb.R
import com.fugaif.imaslivedb.i18n.DisplayText

/** i18n/catalog/system.json の文言。L10n.System から引く (iOS の L10n.System と同じ名前)。 */
object L10nSystem {
    /** アイドルライブDB — ホーム画面のアプリ名 (iOS CFBundleDisplayName / Android の application・activity の label)。ko 表記はオーナー確定待ち。ja は project.yml の INFOPLIST_KEY_CFBundleDisplayName と同じにする */
    val appDisplayName: DisplayText get() = DisplayText.Res(R.string.system_app_display_name)
}
