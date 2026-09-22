//! 公演の呼び名の FFI 面。ロジックは domain::show_naming。

#[uniffi::export]
pub fn show_display_title(event_name: String, show_name: String, date: String) -> String {
    crate::domain::show_naming::show_identity(&event_name, &show_name, &date).title()
}

#[cfg(test)]
mod tests {
    use super::*;

    /// FFI 関数が domain へ委譲していること。
    #[test]
    fn delegates_to_domain() {
        let expected = crate::domain::show_naming::show_identity(
            "THE IDOLM@STER LIVE", "THE IDOLM@STER LIVE DAY1", "2026-09-19")
            .title();
        assert_eq!(
            show_display_title("THE IDOLM@STER LIVE".into(),
                               "THE IDOLM@STER LIVE DAY1".into(),
                               "2026-09-19".into()),
            expected
        );
    }
}
