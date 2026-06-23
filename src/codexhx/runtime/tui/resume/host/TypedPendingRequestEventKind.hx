package codexhx.runtime.tui.resume.host;

enum abstract TypedPendingRequestEventKind(String) to String {
	final Registered = "registered";
	final DuplicateRejected = "duplicate_rejected";
	final UnsupportedRefused = "unsupported_refused";
	final ResolvedByKey = "resolved_by_key";
	final UserInputFifoPopped = "user_input_fifo_popped";
	final McpMatched = "mcp_matched";
	final NotificationRemoved = "notification_removed";
	final StaleReplaySkipped = "stale_replay_skipped";
	final MissingPendingRefused = "missing_pending_refused";
	final Unknown = "unknown";
}
