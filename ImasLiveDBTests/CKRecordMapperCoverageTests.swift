import CloudKit
import XCTest
@testable import ImasLiveDB

/// `CKRecordMapper` がレコードのフィールドを読み落としていないことを検査する。
///
/// なぜ個別フィールドのテストではなく網羅チェックなのか:
/// GRDB の `upsert` は「モデルがエンコードした列」を全部書く
/// (`AppDatabase+Sync.swift` の `record.upsert(db)`)。したがって
/// **モデルにプロパティを足して mapper に足し忘れると、同期のたびにその列が
/// NULL で上書きされる** — 列を足さないより悪い。
///
/// これは実際に `series_group` で起きていた。`Song` 側にはプロパティも
/// CodingKeys もあり「宣言漏れを直した」というコメントまで付いていたのに、
/// `CKRecordMapper.song(from:)` だけが `record["seriesGroup"]` を読んでおらず、
/// 1,956 曲の series_group が同期のたび消えてシリーズ絞り込みが壊れていた。
/// (Android の `SyncMappers.kt` は正しく読んでいたので iOS だけの不整合。)
///
/// 個別テストでは「次に足したプロパティ」を守れないので、Mirror で全プロパティを
/// 走査して「値を入れたレコードから作ったモデルに、値の入っていないプロパティが
/// 残っていないか」を見る。21 あるマッパーを全部ここで守る。
///
/// Bool は false が正しい値のこともあるので網羅チェックでは見ない。各テストで
/// **既定値と逆の値**をレコードに入れ、直に `XCTAssert` する (既定値と同じ値だと、
/// 読み落としても既定値で同じ結果になり捕まらない)。
final class CKRecordMapperCoverageTests: XCTestCase {

    private func record(type: String, fields: [String: CKRecordValue]) -> CKRecord {
        let rec = CKRecord(recordType: type, recordID: CKRecord.ID(recordName: "test"))
        for (key, value) in fields { rec[key] = value }
        return rec
    }

    /// 値が入っていないプロパティ名を集める (nil・空文字・数値の 0)。Bool は対象外。
    private func unsetProperties(of subject: Any) -> [String] {
        Mirror(reflecting: subject).children.compactMap { child in
            guard let label = child.label, isUnset(child.value) else { return nil }
            return label
        }
    }

    private func isUnset(_ value: Any) -> Bool {
        let mirror = Mirror(reflecting: value)
        if mirror.displayStyle == .optional {
            guard let wrapped = mirror.children.first?.value else { return true }
            return isUnset(wrapped)
        }
        switch value {
        case let text as String: return text.isEmpty
        case let number as Int: return number == 0
        case let number as Int64: return number == 0
        case let number as Double: return number == 0
        default: return false
        }
    }

    /// 全フィールドを埋めたレコードから作ったモデルに、読み落としが無いことを確かめる。
    ///
    /// - Parameter notCarriedByRecord: CloudKit のレコードに載っていない端末専用の列。
    ///   同期では埋まらないことが分かっているものだけを、理由を添えて列挙する。
    private func assertReadsEveryField(
        _ model: Any?,
        mapper: String,
        notCarriedByRecord: Set<String> = [],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let model else {
            XCTFail("\(mapper) が nil を返した (必須キーの読み取りに失敗している)", file: file, line: line)
            return
        }
        let missing = Set(unsetProperties(of: model)).subtracting(notCarriedByRecord)
        XCTAssertTrue(
            missing.isEmpty,
            """
            \(mapper) が読み落としているプロパティ: \(missing.sorted())

            モデルにプロパティを足したら \(mapper) にも足すこと。
            片方だけだと CloudKit 同期のたびに該当列が NULL 上書きされる。
            (このテストにも該当フィールドを追加すること。)
            """,
            file: file,
            line: line
        )
    }

    // MARK: - Core Entities

    func testBrandMapperReadsEveryField() {
        let rec = record(type: "Brand", fields: [
            "id": "765as" as NSString,
            "name": "765PRO ALLSTARS" as NSString,
            "shortName": "765AS" as NSString,
            "color": "#F34F6D" as NSString,
            "sortOrder": 1 as NSNumber,
            "iconUrl": "https://example.com/765.png" as NSString,
        ])
        assertReadsEveryField(CKRecordMapper.brand(from: rec), mapper: "CKRecordMapper.brand(from:)")
    }

    /// Idol も同じ性質を持つので同様に守る。
    func testIdolMapperReadsEveryField() throws {
        let rec = record(type: "Idol", fields: [
            "id": "i1" as NSString,
            "brandId": "765as" as NSString,
            "name": "如月千早" as NSString,
            "nameKana": "キサラギチハヤ" as NSString,
            "nameRomaji": "Kisaragi Chihaya" as NSString,
            "familyName": "如月" as NSString,
            "givenName": "千早" as NSString,
            "nickname": "ちひゃー" as NSString,
            "color": "#0000FF" as NSString,
            "sortOrder": 5 as NSNumber,
            "birthday": "02-25" as NSString,
            "bloodType": "A" as NSString,
            "height": 162.0 as NSNumber,
            "weight": 41.0 as NSNumber,
            "birthPlace": "東京都" as NSString,
            "age": 16 as NSNumber,
            "bust": 72.0 as NSNumber,
            "waist": 55.0 as NSNumber,
            "hip": 78.0 as NSNumber,
            "constellation": "うお座" as NSString,
            "hobbies": "音楽鑑賞" as NSString,
            "talents": "歌" as NSString,
            "description": "歌に人生を捧げる少女" as NSString,
            "gender": "女性" as NSString,
            "handedness": "右" as NSString,
            "debutDate": "2005-01-01" as NSString,
            "attribute": "クール" as NSString,
            "isExternal": 1 as NSNumber,
            "aliases": "千早" as NSString,
            // `Idol` からは消した列だが、レコードには今も載っている
            // (声優履歴 `idol_voice_actors` から導出して、旧バージョンのアプリに配り続けている)。
            // マッパーが読まない余分なキーがあっても壊れないことの確認も兼ねる。
            "voiceActors": "今井麻美" as NSString,
        ])

        let idol = try XCTUnwrap(CKRecordMapper.idol(from: rec))
        // 落とすと同期のたびに外部ゲストが一覧・検索・統計に混ざる。
        XCTAssertTrue(idol.isExternal, "CKRecordMapper.idol(from:) が isExternal を読み落としている")
        assertReadsEveryField(idol, mapper: "CKRecordMapper.idol(from:)")
    }

    func testEventMapperReadsEveryField() throws {
        let rec = record(type: "Event", fields: [
            "id": "ev1" as NSString,
            "brandId": "ml" as NSString,
            "name": "13thLIVE" as NSString,
            "nameKana": "さーてぃーんすらいぶ" as NSString,
            "eventType": "anniversary" as NSString,
            "isStreaming": 1 as NSNumber,
            "isSolo": 0 as NSNumber,
            "kind": "festival" as NSString,
            "ticketOpenDate": "2026-06-13" as NSString,
            "ticketDeadline": "2026-06-20" as NSString,
            "ticketLotteryDate": "2026-06-27" as NSString,
            "ticketUrl": "https://example.com/ticket" as NSString,
            "jointBrandIds": "765as,cg" as NSString,
        ])

        let event = try XCTUnwrap(CKRecordMapper.event(from: rec))
        XCTAssertTrue(event.isStreaming, "CKRecordMapper.event(from:) が isStreaming を読み落としている")
        // 既定値は true なので false を入れて確かめる。
        XCTAssertFalse(event.isSolo, "CKRecordMapper.event(from:) が isSolo を読み落としている")
        assertReadsEveryField(
            event, mapper: "CKRecordMapper.event(from:)",
            // 開催形態は端末で持つ列で、Event レコードには載っていない (v23 の移行が作る)。
            notCarriedByRecord: ["hasStreaming", "hasLiveViewing"]
        )
    }

    func testShowMapperReadsEveryField() {
        let rec = record(type: "Show", fields: [
            "id": "sh1" as NSString,
            "eventId": "ev1" as NSString,
            "name": "DAY1" as NSString,
            "date": "2026-07-25" as NSString,
            "venue": "京王アリーナTOKYO" as NSString,
            "venueId": "venue_keio" as NSString,
            "hall": "メインアリーナ" as NSString,
            "streamPlatform": "ASOBI STAGE" as NSString,
            "venueCity": "東京" as NSString,
            "startTime": "17:00" as NSString,
            "sortOrder": 1 as NSNumber,
            "performerType": "character" as NSString,
        ])
        assertReadsEveryField(
            CKRecordMapper.show(from: rec), mapper: "CKRecordMapper.show(from:)",
            // Event と同じく、開催形態は Show レコードに載っていない端末の列。
            notCarriedByRecord: ["hasStreaming", "hasLiveViewing"]
        )
    }

    func testVenueMapperReadsEveryField() {
        let rec = record(type: "Venue", fields: [
            "id": "venue_keio" as NSString,
            "name": "京王アリーナTOKYO" as NSString,
            "nameKana": "けいおうありーなとうきょう" as NSString,
            "prefecture": "東京都" as NSString,
            "city": "調布市" as NSString,
            "aliases": "武蔵野の森総合スポーツプラザ" as NSString,
            "capacity": 10_000 as NSNumber,
            "sortOrder": 2 as NSNumber,
        ])
        assertReadsEveryField(CKRecordMapper.venue(from: rec), mapper: "CKRecordMapper.venue(from:)")
    }

    func testCreatorMapperReadsEveryField() {
        let rec = record(type: "Creator", fields: [
            "id": "cr1" as NSString,
            "name": "作曲者" as NSString,
            "nameKana": "さっきょくしゃ" as NSString,
            "aliases": "別名義" as NSString,
        ])
        assertReadsEveryField(CKRecordMapper.creator(from: rec), mapper: "CKRecordMapper.creator(from:)")
    }

    func testUnitVersionMapperReadsEveryField() {
        let rec = record(type: "UnitVersion", fields: [
            "id": "unit_x__axe8" as NSString,
            "unitId": "unit_x" as NSString,
            "code": "axe8" as NSString,
            "name": "Project“ReLight”AXE8" as NSString,
            "catchphrase": "キャッチコピー" as NSString,
            "logoUrl": "https://example.com/logo.png" as NSString,
            "validFrom": "2024-01-01" as NSString,
            "validTo": "2025-01-01" as NSString,
            "sortOrder": 3 as NSNumber,
        ])
        assertReadsEveryField(CKRecordMapper.unitVersion(from: rec), mapper: "CKRecordMapper.unitVersion(from:)")
    }

    func testCostumeMapperReadsEveryField() {
        let rec = record(type: "Costume", fields: [
            "id": "cos1" as NSString,
            "brandId": "765as" as NSString,
            "name": "10th 共通衣装" as NSString,
            "nameKana": "てんす きょうつういしょう" as NSString,
            "unitId": "unit_x" as NSString,
            "idolId": "i1" as NSString,
            "description": "白基調" as NSString,
            "sourceUrl": "https://example.com/costume" as NSString,
            "sortOrder": 4 as NSNumber,
        ])
        assertReadsEveryField(CKRecordMapper.costume(from: rec), mapper: "CKRecordMapper.costume(from:)")
    }

    func testCostumeWearMapperReadsEveryField() {
        let rec = record(type: "CostumeWear", fields: [
            "id": "cw1" as NSString,
            "costumeId": "cos1" as NSString,
            "showId": "sh1" as NSString,
            "setlistItemId": "si1" as NSString,
            "idolId": "i1" as NSString,
            "sortOrder": 5 as NSNumber,
        ])
        assertReadsEveryField(CKRecordMapper.costumeWear(from: rec), mapper: "CKRecordMapper.costumeWear(from:)")
    }

    func testShowTicketMapperReadsEveryField() throws {
        let rec = record(type: "ShowTicket", fields: [
            "id": "t1" as NSString,
            "showId": "sh1" as NSString,
            "kind": "stream" as NSString,
            "name": "配信 (アーカイブ付き)" as NSString,
            "price": 6_600 as NSNumber,
            "isEstimate": 1 as NSNumber,
            "note": "見逃し 1 週間" as NSString,
            "sortOrder": 2 as NSNumber,
        ])

        let ticket = try XCTUnwrap(CKRecordMapper.showTicket(from: rec))
        XCTAssertTrue(ticket.isEstimate, "CKRecordMapper.showTicket(from:) が isEstimate を読み落としている")
        assertReadsEveryField(ticket, mapper: "CKRecordMapper.showTicket(from:)")
    }

    func testVenueNameMapperReadsEveryField() {
        let rec = record(type: "VenueName", fields: [
            "id": "vn1" as NSString,
            "venueId": "venue_keio" as NSString,
            "name": "武蔵野の森総合スポーツプラザ" as NSString,
            "validFrom": "2017-11-01" as NSString,
            "validTo": "2024-12-31" as NSString,
        ])
        assertReadsEveryField(CKRecordMapper.venueName(from: rec), mapper: "CKRecordMapper.venueName(from:)")
    }

    func testVenueHallMapperReadsEveryField() {
        let rec = record(type: "VenueHall", fields: [
            "id": "vh1" as NSString,
            "venueId": "venue_keio" as NSString,
            "name": "メインアリーナ" as NSString,
            "capacity": 7_000 as NSNumber,
        ])
        assertReadsEveryField(CKRecordMapper.venueHall(from: rec), mapper: "CKRecordMapper.venueHall(from:)")
    }

    /// Song: CloudKit の Song レコードにある全フィールドを埋めて、
    /// 変換後の Song に読み落としが 1 つも無いことを確認する。
    func testSongMapperReadsEveryField() throws {
        let rec = record(type: "Song", fields: [
            "id": "s1" as NSString,
            "title": "蒼い鳥" as NSString,
            "titleKana": "アオイトリ" as NSString,
            "brandId": "765as" as NSString,
            "songType": "unit" as NSString,
            "releaseDate": "2005-01-01" as NSString,
            "durationSec": 240 as NSNumber,
            "composer": "作曲者" as NSString,
            "lyricist": "作詞者" as NSString,
            "arranger": "編曲者" as NSString,
            "cdSeries": "MASTER ARTIST" as NSString,
            "cdTitle": "アルバム名" as NSString,
            "artworkUrl": "https://example.com/a.jpg" as NSString,
            "previewUrl": "https://example.com/p.m4a" as NSString,
            "appleMusicId": "123456" as NSString,
            "appleMusicAlbumId": "654321" as NSString,
            "isrc": "JPXX01234567" as NSString,
            "lyricsUrl": "https://example.com/l" as NSString,
            "parentSongId": "s0" as NSString,
            "singerLabel": "如月千早" as NSString,
            "unitName": "ユニット名" as NSString,
            "unitId": "u1" as NSString,
            "seriesGroup": "LIVE THE@TER FORWARD" as NSString,
            "unitVersionId": "unit_アルストロメリア__axe8" as NSString,
            "jointBrandIds": "cg,ml" as NSString,
            "isCollab": 1 as NSNumber,
            "hasKamisabiCard": 1 as NSNumber,
        ])

        let song = try XCTUnwrap(CKRecordMapper.song(from: rec))
        // 落とすと同期のたびに合同曲の札が false へ戻る。
        XCTAssertTrue(song.isCollab, "CKRecordMapper.song(from:) が isCollab を読み落としている")
        // 同じ理由。落とすと同期のたびに KAMISABI 収録フラグが false へ戻る。
        XCTAssertTrue(song.hasKamisabiCard, "CKRecordMapper.song(from:) が hasKamisabiCard を読み落としている")
        assertReadsEveryField(song, mapper: "CKRecordMapper.song(from:)")
    }

    func testUnitMapperReadsEveryField() throws {
        let rec = record(type: "ImasUnit", fields: [
            "id": "u1" as NSString,
            "brandId": "765as" as NSString,
            "name": "竜宮小町" as NSString,
            "isPermanent": 0 as NSNumber,
            "nameAlt": "Ryugu Komachi" as NSString,
            "nameKana": "りゅうぐうこまち" as NSString,
        ])

        let unit = try XCTUnwrap(CKRecordMapper.unit(from: rec))
        // 既定値は true なので false を入れて確かめる。
        XCTAssertFalse(unit.isPermanent, "CKRecordMapper.unit(from:) が isPermanent を読み落としている")
        assertReadsEveryField(unit, mapper: "CKRecordMapper.unit(from:)")
    }

    // MARK: - Junction Tables

    func testIdolBrandMapperReadsEveryField() throws {
        let rec = record(type: "IdolBrand", fields: [
            "idolId": "i1" as NSString,
            "brandId": "765as" as NSString,
            "isPrimary": 1 as NSNumber,
        ])

        let idolBrand = try XCTUnwrap(CKRecordMapper.idolBrand(from: rec))
        XCTAssertTrue(idolBrand.isPrimary, "CKRecordMapper.idolBrand(from:) が isPrimary を読み落としている")
        assertReadsEveryField(idolBrand, mapper: "CKRecordMapper.idolBrand(from:)")
    }

    func testSongArtistMapperReadsEveryField() throws {
        let rec = record(type: "SongArtist", fields: [
            "songId": "s1" as NSString,
            "idolId": "i1" as NSString,
            "role": "performer" as NSString,
        ])

        let artist = try XCTUnwrap(CKRecordMapper.songArtist(from: rec))
        // 既定値 original と違う値で、読んでいることを確かめる。
        XCTAssertEqual(artist.role, "performer")
        assertReadsEveryField(artist, mapper: "CKRecordMapper.songArtist(from:)")
    }

    func testUnitMemberMapperReadsEveryField() {
        let rec = record(type: "UnitMember", fields: [
            "unitId": "u1" as NSString,
            "idolId": "i1" as NSString,
        ])
        assertReadsEveryField(CKRecordMapper.unitMember(from: rec), mapper: "CKRecordMapper.unitMember(from:)")
    }

    func testShowCastMapperReadsEveryField() throws {
        let rec = record(type: "ShowCast", fields: [
            "showId": "sh1" as NSString,
            "idolId": "i1" as NSString,
            "castRole": "lead" as NSString,
        ])

        let cast = try XCTUnwrap(CKRecordMapper.showCast(from: rec))
        // 既定値 member と違う値で、読んでいることを確かめる。
        XCTAssertEqual(cast.castRole, .lead)
        assertReadsEveryField(cast, mapper: "CKRecordMapper.showCast(from:)")
    }

    func testSetlistItemMapperReadsEveryField() {
        let rec = record(type: "SetlistItem", fields: [
            "id": "si1" as NSString,
            "showId": "sh1" as NSString,
            "songId": "s1" as NSString,
            "position": 7 as NSNumber,
            "section": "encore" as NSString,
            "notes": "メドレー" as NSString,
            "unitName": "ユニット名" as NSString,
        ])
        assertReadsEveryField(CKRecordMapper.setlistItem(from: rec), mapper: "CKRecordMapper.setlistItem(from:)")
    }

    func testSetlistPerformerMapperReadsEveryField() {
        let rec = record(type: "SetlistPerformer", fields: [
            "setlistItemId": "si1" as NSString,
            "idolId": "i1" as NSString,
        ])
        assertReadsEveryField(
            CKRecordMapper.setlistPerformer(from: rec), mapper: "CKRecordMapper.setlistPerformer(from:)")
    }

    // MARK: - Community Content

    func testSongVideoMapperReadsEveryField() {
        let rec = record(type: "SongVideo", fields: [
            "id": "v1" as NSString,
            "songId": "s1" as NSString,
            "youtubeUrl": "https://www.youtube.com/watch?v=abc" as NSString,
            "videoTitle": "参考動画" as NSString,
            "note": "2番から" as NSString,
            "createdAt": Date(timeIntervalSince1970: 1_700_000_000) as NSDate,
            "authorDisplayName": "投稿者" as NSString,
        ])
        assertReadsEveryField(CKRecordMapper.songVideo(from: rec), mapper: "CKRecordMapper.songVideo(from:)")
    }
}
