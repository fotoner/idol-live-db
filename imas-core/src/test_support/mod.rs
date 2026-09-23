//! 実データを読むテストの入口。DB のパスを直書きせず、ここを通す。
//!
//! どの DB を読むかは [`test_db`] が決める (既定は `db/master.sql` から復元したもの。
//! `IMAS_CORE_TEST_DB` で差し替えられる)。

pub(crate) mod test_db;

use crate::domain::snapshot::Snapshot;
use crate::inbound::snapshot_store::SnapshotStore;
use crate::outbound::sqlite_loader::load_snapshot;
use rusqlite::{Connection, OpenFlags};
use std::sync::{Arc, OnceLock};

/// 実データ DB のパス。
pub(crate) fn bundle_path() -> &'static str {
    test_db::path()
}

/// 実データのスナップショット。全テストで 1 つを共有する (不変なので安全で、ロードも 1 回で済む)。
pub(crate) fn bundle_snapshot() -> &'static Snapshot {
    static SNAP: OnceLock<Snapshot> = OnceLock::new();
    SNAP.get_or_init(|| load_snapshot(bundle_path()).expect("実データ DB からスナップショットを組める"))
}

/// 実データ DB への読み取り専用の接続 (SQL と突き合わせるテスト用)。
pub(crate) fn bundle_conn() -> Connection {
    Connection::open_with_flags(
        bundle_path(),
        OpenFlags::SQLITE_OPEN_READ_ONLY | OpenFlags::SQLITE_OPEN_NO_MUTEX,
    )
    .expect("実データ DB を開ける")
}

/// 実データを読み込んだ SnapshotStore (inbound の委譲を確かめるテスト用)。呼ぶたびに新しく作る。
pub(crate) fn bundle_store() -> Arc<SnapshotStore> {
    let store = SnapshotStore::new();
    store.load(bundle_path().to_string()).expect("実データ DB を SnapshotStore に読み込める");
    store
}
