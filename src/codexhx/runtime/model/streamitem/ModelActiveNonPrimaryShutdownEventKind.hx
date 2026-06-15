package codexhx.runtime.model.streamitem;

enum abstract ModelActiveNonPrimaryShutdownEventKind(String) to String {
	var Other = "other";
	var ThreadClosed = "thread_closed";
}
