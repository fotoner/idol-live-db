//! 名前からエンティティを引き当てる規則 (曖昧解決)。
//!
//! LLM は id を知らない。「未来」「トラプリ」「ミリオン 10th」のような人の言葉で
//! 尋ねてくるので、**まずここで候補に落としてから**各ツールが id で引く。
//!
//! 照合の実体は `text_search_index` / `fuzzy_search` / `credit_names` が持っている。
//! ここに新しい照合規則を書かない — 畳み方が二重になると、画面の検索とこの入口で
//! 「当たる語」が食い違う。

use crate::domain::snapshot::Snapshot;

/// 引き当てたエンティティの種別。
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EntityKind {
    Idol,
    Song,
    Event,
    Show,
    Unit,
    Brand,
    Creator,
    Venue,
}

impl EntityKind {
    /// JSON / CLI に出す綴り。
    pub fn as_str(self) -> &'static str {
        match self {
            Self::Idol => "idol",
            Self::Song => "song",
            Self::Event => "event",
            Self::Show => "show",
            Self::Unit => "unit",
            Self::Brand => "brand",
            Self::Creator => "creator",
            Self::Venue => "venue",
        }
    }
}

/// 候補 1 件。
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EntityHit {
    pub kind: EntityKind,
    pub id: String,
    /// 表示名 (人が読む形)。
    pub name: String,
    /// どれを選ぶか LLM が判断するための一言 (ブランド名・開催日・原唱者など)。
    pub hint: String,
}

/// 語から候補を引く。`kinds` が空なら全種別。
pub fn resolve(_snap: &Snapshot, _query: &str, _kinds: &[EntityKind], _limit: u32) -> Vec<EntityHit> {
    Vec::new() // TODO(coder-a)
}
