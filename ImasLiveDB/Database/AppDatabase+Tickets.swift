//  公演のチケット価格の読み書き。マスタ表なので基本は読むだけで、
//  書き込みは同期 (CloudKit) 経由。
//
//  どの券を選ぶか・価格帯をどう出すかの判断は共有コア (domain/ticket_prices.rs)。

import Foundation
import GRDB

extension AppDatabase {

    /// その公演の券種。並べ替えはコアに任せるのでここでは取るだけ。
    func showTickets(showId: String) throws -> [ShowTicketRecord] {
        try dbQueue.read { db in
            try ShowTicketRecord
                .filter(ShowTicketRecord.Columns.showId == showId)
                .fetchAll(db)
        }
    }

    func showTicketsAsync(showId: String) async throws -> [ShowTicketRecord] {
        try await dbQueue.read { db in
            try ShowTicketRecord
                .filter(ShowTicketRecord.Columns.showId == showId)
                .fetchAll(db)
        }
    }

    /// 複数公演ぶんをまとめて (公演 id → 券種)。一覧で公演ごとに引くと N 回走る。
    func showTicketsAsync(showIds: [String]) async throws -> [String: [ShowTicketRecord]] {
        guard !showIds.isEmpty else { return [:] }
        let rows = try await dbQueue.read { db in
            try ShowTicketRecord
                .filter(showIds.contains(ShowTicketRecord.Columns.showId))
                .fetchAll(db)
        }
        return Dictionary(grouping: rows, by: \.showId)
    }

    /// 券種が 1 件でもある公演の数 (「価格が分かっている公演」の件数表示用)。
    func showTicketCoverage() throws -> Int {
        try dbQueue.read { db in
            try Int.fetchOne(db, sql: "SELECT COUNT(DISTINCT show_id) FROM show_tickets") ?? 0
        }
    }
}
