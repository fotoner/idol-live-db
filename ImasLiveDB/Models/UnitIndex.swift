import Foundation

/// セトリ表示でパフォーマー集合から「ユニット成立しているか?」を逆引きするためのインデックス。
/// AppDatabase.fetchUnitIndex() で一度構築し、setlist 画面内で使い回す。
struct UnitIndex: Sendable {
    let units: [Unit]
    /// unit_id → メンバー idol_id の集合
    let memberIds: [String: Set<String>]
    /// idol_id → その idol が所属する unit_id の集合
    let byIdol: [String: Set<String>]
    /// 楽曲が紐付いている unit_id (songs.unit_id 参照)。
    /// セトリ表示での unit 逆引きはこれに含まれるものだけに絞り、
    /// 名前だけ一致する合同メンバー集合での誤検出を避ける。
    let unitsWithSongs: Set<String>


    init(
        units: [Unit],
        memberIds: [String: Set<String>],
        byIdol: [String: Set<String>],
        unitsWithSongs: Set<String> = []
    ) {
        self.units = units
        self.memberIds = memberIds
        self.byIdol = byIdol
        self.unitsWithSongs = unitsWithSongs
    }
}
