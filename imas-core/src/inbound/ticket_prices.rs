//! チケット価格の FFI 面。ロジックは domain::ticket_prices。
//!
//! 公演 1 つぶんの券種をまとめて渡して、選んだ結果や価格帯を受け取る。

use crate::domain::ticket_prices::{
    ShowTicket, TicketInputError, TicketKind, TicketPriceRange,
};

#[uniffi::export]
pub fn tickets_for_kind(tickets: Vec<ShowTicket>, kind: TicketKind) -> Vec<ShowTicket> {
    crate::domain::ticket_prices::tickets_for_kind(&tickets, kind)
}

#[uniffi::export]
pub fn default_ticket(tickets: Vec<ShowTicket>, kind: TicketKind) -> Option<ShowTicket> {
    crate::domain::ticket_prices::default_ticket(&tickets, kind)
}

#[uniffi::export]
pub fn ticket_price_range(tickets: Vec<ShowTicket>, kind: TicketKind) -> Option<TicketPriceRange> {
    crate::domain::ticket_prices::price_range(&tickets, kind)
}

#[uniffi::export]
pub fn ticket_price_ranges(tickets: Vec<ShowTicket>) -> Vec<TicketPriceRange> {
    crate::domain::ticket_prices::price_ranges(&tickets)
}

#[uniffi::export]
pub fn ticket_kind_from_attendance(text_value: String) -> TicketKind {
    crate::domain::ticket_prices::ticket_kind_from_attendance(&text_value)
}

#[uniffi::export]
pub fn ticket_kind_label(kind: TicketKind) -> String {
    crate::domain::ticket_prices::ticket_kind_label(kind)
}

#[uniffi::export]
pub fn validate_ticket(name: String, price: i64) -> Option<TicketInputError> {
    crate::domain::ticket_prices::validate_ticket(&name, price)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn ticket(id: &str, kind: TicketKind, name: &str, price: i64) -> ShowTicket {
        ShowTicket {
            id: id.into(),
            show_id: "show_1".into(),
            kind,
            name: name.into(),
            price,
            is_estimate: false,
            note: None,
            sort_order: 0,
        }
    }

    /// FFI 関数が domain へ委譲していること (値渡し = FFI と同じ所有権移動)。
    #[test]
    fn delegates_to_domain() {
        let tickets = vec![
            ticket("a", TicketKind::Live, "S席", 13_200),
            ticket("b", TicketKind::Stream, "配信", 5_500),
        ];
        assert_eq!(
            tickets_for_kind(tickets.clone(), TicketKind::Live),
            crate::domain::ticket_prices::tickets_for_kind(&tickets, TicketKind::Live)
        );
        assert_eq!(
            default_ticket(tickets.clone(), TicketKind::Live).map(|t| t.name),
            Some("S席".to_string())
        );
        assert_eq!(
            ticket_price_range(tickets.clone(), TicketKind::Stream).map(|r| r.label),
            Some("¥5,500".to_string())
        );
        assert_eq!(ticket_price_ranges(tickets).len(), 2);
        assert_eq!(ticket_kind_from_attendance("stream".into()), TicketKind::Stream);
        assert_eq!(ticket_kind_label(TicketKind::LiveViewing), "LV");
        assert_eq!(validate_ticket("".into(), 100), Some(TicketInputError::EmptyName));
    }
}
