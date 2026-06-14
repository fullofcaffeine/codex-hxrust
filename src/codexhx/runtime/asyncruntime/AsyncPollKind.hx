package codexhx.runtime.asyncruntime;

enum abstract AsyncPollKind(String) to String {
	var Pending = "pending";
	var Ready = "ready";
	var Failed = "failed";
	var Cancelled = "cancelled";
	var Closed = "closed";
	var Backpressured = "backpressured";
}
