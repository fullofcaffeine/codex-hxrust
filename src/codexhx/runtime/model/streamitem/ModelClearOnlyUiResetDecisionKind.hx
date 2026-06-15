package codexhx.runtime.model.streamitem;

enum abstract ModelClearOnlyUiResetDecisionKind(String) to String {
	final ClearOnlyUiResetApplied = "clear_only_ui_reset_applied";
	final ClearOnlyUiResetSkipped = "clear_only_ui_reset_skipped";
	final ClearOnlyUiResetUnavailable = "clear_only_ui_reset_unavailable";
}
