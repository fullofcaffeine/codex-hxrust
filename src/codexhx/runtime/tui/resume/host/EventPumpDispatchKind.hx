package codexhx.runtime.tui.resume.host;

enum abstract EventPumpDispatchKind(String) to String {
	final Dispatched = "dispatched";
	final StaleIgnored = "stale_ignored";
	final Pending = "pending";
	final Closed = "closed";
	final Backpressured = "backpressured";
	final Failed = "failed";
	final Cancelled = "cancelled";
	final Unknown = "unknown";
}
