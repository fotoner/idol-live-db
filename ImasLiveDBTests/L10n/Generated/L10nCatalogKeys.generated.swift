// 生成物: i18n/catalog/*.json → python3 tools/i18n/i18n.py generate。手で直さない。
import Foundation
@testable import ImasLiveDB

/// カタログの 1 キー × 見本引数 1 組と、生成器が計算した言語ごとの期待値。
/// L10nCatalogTests が実行時の解決結果と比べる (書式・エスケープ・桁区切り・表の置き場所)。
struct L10nCatalogSample {
    /// 完全キー (<名前空間>.<相対キー>)
    let key: String
    /// String Catalog の表の名前
    let table: String
    /// 表が入るバンドル ("app" / "widget")
    let bundles: [String]
    /// 値を持つ言語 (基準言語と、訳のある言語)
    let languagesWithValue: [String]
    /// 見本の引数 (失敗メッセージ用)
    let args: String
    /// 見本の引数で作った文言
    let make: () -> LocalizedStringResource
    /// 言語 → 期待値 (訳の無い言語は基準言語へのフォールバック)
    let expected: [String: String]

    var sample: LocalizedStringResource { make() }
}

/// Info.plist の表 (InfoPlist.xcstrings) の 1 キー。key は Info.plist のキー名。
struct L10nInfoPlistSample {
    let catalogKey: String
    /// "app" / "widget"
    let target: String
    let key: String
    /// 言語 → 値 (値のある言語だけ)
    let values: [String: String]
}

enum L10nCatalogKeys {
    /// このカタログの言語 (基準言語が先頭)
    static let languages: [String] = ["ja", "ko"]

    /// 全キー × 見本
    static var all: [L10nCatalogSample] {
        var all: [L10nCatalogSample] = []
        all += samplesCommon()
        all += samplesI18n()
        all += samplesNav()
        all += samplesSearch()
        all += samplesUnits()
        return all
    }

    /// Info.plist の表のキー
    static var infoPlist: [L10nInfoPlistSample] {
        var all: [L10nInfoPlistSample] = []
        all.append(L10nInfoPlistSample(catalogKey: "system.app.apple_music_usage", target: "app", key: "NSAppleMusicUsageDescription", values: ["ja": "楽曲のジャケット写真の表示とプレビュー再生に使用します", "ko": "곡의 재킷 사진 표시와 미리 듣기에 사용해요"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.app.calendars_full_usage", target: "app", key: "NSCalendarsFullAccessUsageDescription", values: ["ja": "お手持ちのカレンダーの予定をアプリ内のスケジュールに重ねて表示するために使用します", "ko": "가지고 있는 캘린더의 일정을 앱의 스케줄에 겹쳐 보여 주는 데 사용해요"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.app.calendars_write_only_usage", target: "app", key: "NSCalendarsWriteOnlyAccessUsageDescription", values: ["ja": "ライブの予定をカレンダーに追加するために使用します", "ko": "라이브 일정을 캘린더에 추가하는 데 사용해요"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.app.camera_usage", target: "app", key: "NSCameraUsageDescription", values: ["ja": "セットリストの写真を撮影してOCRで曲名を認識します", "ko": "세트리스트 사진을 찍어 OCR로 곡명을 인식해요"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.app.display_name", target: "app", key: "CFBundleDisplayName", values: ["ja": "アイドルライブDB"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.app.microphone_usage", target: "app", key: "NSMicrophoneUsageDescription", values: ["ja": "イントロドンで曲名を音声で答えるために使用します", "ko": "인트로돈에서 곡명을 음성으로 답하는 데 사용해요"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.app.photo_library_usage", target: "app", key: "NSPhotoLibraryUsageDescription", values: ["ja": "セットリストの写真を選択してOCRで曲名を認識します", "ko": "세트리스트 사진을 골라 OCR로 곡명을 인식해요"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.app.speech_recognition_usage", target: "app", key: "NSSpeechRecognitionUsageDescription", values: ["ja": "発声した曲名をテキスト化してクイズに回答するために使用します", "ko": "말한 곡명을 텍스트로 바꿔 퀴즈에 답하는 데 사용해요"]))
        all.append(L10nInfoPlistSample(catalogKey: "system.widget_extension.display_name", target: "widget", key: "CFBundleDisplayName", values: ["ja": "担当ウィジェット"]))
        return all
    }

    private static func samplesCommon() -> [L10nCatalogSample] {
        var s: [L10nCatalogSample] = []
        s.append(L10nCatalogSample(key: "common.action.login", table: "Common", bundles: ["app", "widget"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Common.actionLogin }, expected: ["ja": "ログイン", "ko": "로그인"]))
        s.append(L10nCatalogSample(key: "common.action.retry", table: "Common", bundles: ["app", "widget"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Common.actionRetry }, expected: ["ja": "再試行", "ko": "다시 시도"]))
        s.append(L10nCatalogSample(key: "common.action.see_all", table: "Common", bundles: ["app", "widget"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Common.actionSeeAll }, expected: ["ja": "すべて見る", "ko": "모두 보기"]))
        return s
    }

    private static func samplesI18n() -> [L10nCatalogSample] {
        var s: [L10nCatalogSample] = []
        s.append(L10nCatalogSample(key: "i18n.language_tag", table: "I18n", bundles: ["app", "widget"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.I18n.languageTag }, expected: ["ja": "ja", "ko": "ko"]))
        return s
    }

    private static func samplesNav() -> [L10nCatalogSample] {
        var s: [L10nCatalogSample] = []
        s.append(L10nCatalogSample(key: "nav.settings_button.a11y", table: "Nav", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Nav.settingsButtonA11y }, expected: ["ja": "設定・マイ", "ko": "설정·마이페이지"]))
        return s
    }

    private static func samplesSearch() -> [L10nCatalogSample] {
        var s: [L10nCatalogSample] = []
        s.append(L10nCatalogSample(key: "search.cross_tab.chip", table: "Search", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "tab=かな カナ1, count=2026", make: { L10n.Search.crossTabChip(tab: "かな カナ1", count: 2026) }, expected: ["ja": "かな カナ1に 2026", "ko": "かな カナ1에 2026"]))
        s.append(L10nCatalogSample(key: "search.cross_tab.header", table: "Search", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Search.crossTabHeader }, expected: ["ja": "別のタブ", "ko": "다른 탭"]))
        return s
    }

    private static func samplesUnits() -> [L10nCatalogSample] {
        var s: [L10nCatalogSample] = []
        s.append(L10nCatalogSample(key: "units.detail.community.login_prompt", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailCommunityLoginPrompt }, expected: ["ja": "タグ付け・投票にはログインが必要です", "ko": "태그를 달거나 투표하려면 로그인해야 해요"]))
        s.append(L10nCatalogSample(key: "units.detail.copy.name", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailCopyName }, expected: ["ja": "ユニット名をコピー", "ko": "유닛 이름 복사"]))
        s.append(L10nCatalogSample(key: "units.detail.copy.name_alt", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailCopyNameAlt }, expected: ["ja": "別名をコピー", "ko": "다른 이름 복사"]))
        s.append(L10nCatalogSample(key: "units.detail.load_error.message", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailLoadErrorMessage }, expected: ["ja": "読み込みに失敗しました。通信状況を確認してもう一度お試しください。", "ko": "불러오지 못했어요. 통신 상태를 확인하고 다시 시도해 주세요."]))
        s.append(L10nCatalogSample(key: "units.detail.load_error.title", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailLoadErrorTitle }, expected: ["ja": "読み込みに失敗しました", "ko": "불러오지 못했어요"]))
        s.append(L10nCatalogSample(key: "units.detail.members.empty.message", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailMembersEmptyMessage }, expected: ["ja": "メンバー情報はまだ登録されていません。", "ko": "멤버 정보가 아직 등록되지 않았어요."]))
        s.append(L10nCatalogSample(key: "units.detail.members.empty.title", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailMembersEmptyTitle }, expected: ["ja": "メンバーがいません", "ko": "멤버가 없어요"]))
        s.append(L10nCatalogSample(key: "units.detail.members.header", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailMembersHeader }, expected: ["ja": "メンバー", "ko": "멤버"]))
        s.append(L10nCatalogSample(key: "units.detail.personal_tags.action.remove", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailPersonalTagsActionRemove }, expected: ["ja": "マイタグを削除", "ko": "마이 태그 삭제"]))
        s.append(L10nCatalogSample(key: "units.detail.personal_tags.add.a11y", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailPersonalTagsAddA11y }, expected: ["ja": "マイタグを追加", "ko": "마이 태그 추가"]))
        s.append(L10nCatalogSample(key: "units.detail.personal_tags.caption", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailPersonalTagsCaption }, expected: ["ja": "自分だけに表示されます (コミュニティには公開されません)", "ko": "나에게만 보여요 (커뮤니티에는 공개되지 않아요)"]))
        s.append(L10nCatalogSample(key: "units.detail.personal_tags.header", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailPersonalTagsHeader }, expected: ["ja": "マイタグ", "ko": "마이 태그"]))
        s.append(L10nCatalogSample(key: "units.detail.personal_tags.placeholder", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailPersonalTagsPlaceholder }, expected: ["ja": "マイタグを追加 (例: 聞いた)", "ko": "마이 태그 추가 (예: 들었음)"]))
        s.append(L10nCatalogSample(key: "units.detail.similar.caption", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailSimilarCaption }, expected: ["ja": "つけられたタグが似ているユニット", "ko": "달린 태그가 비슷한 유닛"]))
        s.append(L10nCatalogSample(key: "units.detail.similar.header", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailSimilarHeader }, expected: ["ja": "タグが似ているユニット", "ko": "태그가 비슷한 유닛"]))
        s.append(L10nCatalogSample(key: "units.detail.similar.shared_tags", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "count=1", make: { L10n.Units.detailSimilarSharedTags(count: 1) }, expected: ["ja": "タグ1個一致", "ko": "태그 1개 일치"]))
        s.append(L10nCatalogSample(key: "units.detail.similar.shared_tags", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "count=3", make: { L10n.Units.detailSimilarSharedTags(count: 3) }, expected: ["ja": "タグ3個一致", "ko": "태그 3개 일치"]))
        s.append(L10nCatalogSample(key: "units.detail.similar.shared_tags", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "count=1234", make: { L10n.Units.detailSimilarSharedTags(count: 1234) }, expected: ["ja": "タグ1,234個一致", "ko": "태그 1,234개 일치"]))
        s.append(L10nCatalogSample(key: "units.detail.songs.collected", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailSongsCollected }, expected: ["ja": "回収済", "ko": "회수 완료"]))
        s.append(L10nCatalogSample(key: "units.detail.songs.empty.message", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailSongsEmptyMessage }, expected: ["ja": "このユニットの楽曲情報はまだ登録されていません。", "ko": "이 유닛의 곡 정보가 아직 등록되지 않았어요."]))
        s.append(L10nCatalogSample(key: "units.detail.songs.empty.title", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailSongsEmptyTitle }, expected: ["ja": "楽曲がありません", "ko": "곡이 없어요"]))
        s.append(L10nCatalogSample(key: "units.detail.songs.header", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailSongsHeader }, expected: ["ja": "楽曲", "ko": "곡"]))
        s.append(L10nCatalogSample(key: "units.detail.tab.community", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTabCommunity }, expected: ["ja": "コミュニティ", "ko": "커뮤니티"]))
        s.append(L10nCatalogSample(key: "units.detail.tab.members", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTabMembers }, expected: ["ja": "メンバー", "ko": "멤버"]))
        s.append(L10nCatalogSample(key: "units.detail.tab.songs", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTabSongs }, expected: ["ja": "楽曲", "ko": "곡"]))
        s.append(L10nCatalogSample(key: "units.detail.tags.action.add", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTagsActionAdd }, expected: ["ja": "タグを追加", "ko": "태그 추가"]))
        s.append(L10nCatalogSample(key: "units.detail.tags.action.remove", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTagsActionRemove }, expected: ["ja": "タグを外す", "ko": "태그 해제"]))
        s.append(L10nCatalogSample(key: "units.detail.tags.action.show_detail", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTagsActionShowDetail }, expected: ["ja": "タグ詳細を見る", "ko": "태그 상세 보기"]))
        s.append(L10nCatalogSample(key: "units.detail.tags.add_button", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTagsAddButton }, expected: ["ja": "タグ", "ko": "태그"]))
        s.append(L10nCatalogSample(key: "units.detail.tags.empty.message", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTagsEmptyMessage }, expected: ["ja": "このユニットを一言で表すタグを付けてみませんか？", "ko": "이 유닛을 한마디로 표현하는 태그를 달아 볼까요?"]))
        s.append(L10nCatalogSample(key: "units.detail.tags.empty.title", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTagsEmptyTitle }, expected: ["ja": "タグはまだありません", "ko": "아직 태그가 없어요"]))
        s.append(L10nCatalogSample(key: "units.detail.tags.header", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.detailTagsHeader }, expected: ["ja": "タグ", "ko": "태그"]))
        s.append(L10nCatalogSample(key: "units.list.empty.message", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listEmptyMessage }, expected: ["ja": "登録されているユニットがまだありません。", "ko": "등록된 유닛이 아직 없어요."]))
        s.append(L10nCatalogSample(key: "units.list.empty.title", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listEmptyTitle }, expected: ["ja": "ユニットがありません", "ko": "유닛이 없어요"]))
        s.append(L10nCatalogSample(key: "units.list.filter_empty.action.clear", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listFilterEmptyActionClear }, expected: ["ja": "絞り込みを解除", "ko": "필터 해제"]))
        s.append(L10nCatalogSample(key: "units.list.filter_empty.message", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "query=かな カナ1", make: { L10n.Units.listFilterEmptyMessage(query: "かな カナ1") }, expected: ["ja": "「かな カナ1」に一致するユニットがありません", "ko": "“かな カナ1”에 해당하는 유닛이 없어요"]))
        s.append(L10nCatalogSample(key: "units.list.filter_empty.title", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listFilterEmptyTitle }, expected: ["ja": "絞り込み結果がありません", "ko": "필터 결과가 없어요"]))
        s.append(L10nCatalogSample(key: "units.list.search_field.prompt", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listSearchFieldPrompt }, expected: ["ja": "ユニット名", "ko": "유닛 이름"]))
        s.append(L10nCatalogSample(key: "units.list.title", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listTitle }, expected: ["ja": "ユニット", "ko": "유닛"]))
        s.append(L10nCatalogSample(key: "units.list.view_mode.grid.a11y", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listViewModeGridA11y }, expected: ["ja": "グリッド表示", "ko": "그리드로 보기"]))
        s.append(L10nCatalogSample(key: "units.list.view_mode.list.a11y", table: "Units", bundles: ["app"], languagesWithValue: ["ja", "ko"], args: "", make: { L10n.Units.listViewModeListA11y }, expected: ["ja": "リスト表示", "ko": "목록으로 보기"]))
        return s
    }
}
