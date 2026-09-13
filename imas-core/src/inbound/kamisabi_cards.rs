//! KAMISABI の収録と所持コンプ (FFI 面・impl 分割)。domain::kamisabi_cards への委譲だけ。
//!
//! 所持マーク (user_marks の `owned`) はスナップショットに無いので、
//! 解決済みの song_id 集合をプラットフォーム側が渡す (回収系と同じ流儀)。

use super::snapshot_store::{SnapshotError, SnapshotStore};
use crate::domain::kamisabi_cards::{self as cards, KamisabiCompletion};

#[uniffi::export]
impl SnapshotStore {
    /// KAMISABI 収録曲の song_id 列。`brand_id` を渡すとその商品だけ。
    pub fn kamisabi_song_ids(&self, brand_id: Option<String>) -> Result<Vec<String>, SnapshotError> {
        let snap = self.current()?;
        Ok(self.ids(&snap, cards::song_indexes(&snap, brand_id.as_deref())))
    }

    /// 収録曲のある商品 (ブランド id)。
    pub fn kamisabi_brand_ids(&self) -> Result<Vec<String>, SnapshotError> {
        let snap = self.current()?;
        Ok(cards::brand_ids(&snap))
    }

    /// 所持コンプ。**分母はその商品の収録曲数**で、3 商品の合算ではない。
    pub fn kamisabi_completion(
        &self,
        brand_id: Option<String>,
        owned_song_ids: Vec<String>,
    ) -> Result<KamisabiCompletion, SnapshotError> {
        let snap = self.current()?;
        Ok(cards::completion(&snap, brand_id.as_deref(), &owned_song_ids))
    }
}

/// 収録の札 (`KAMISABI 収録`)。どの OS も同じ語を出すためにコアから配る。
#[uniffi::export]
pub fn kamisabi_card_label() -> String {
    cards::CARD_LABEL.to_string()
}

/// 「7 / 50 曲所持」。言い回しもコアが決める。
#[uniffi::export]
pub fn kamisabi_completion_label(completion: KamisabiCompletion) -> String {
    cards::completion_label(&completion)
}
