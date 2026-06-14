package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideParentPendingEventKind(String) to String {
	var RequestQueued = "request_queued";
	var ServerRequestResolved = "server_request_resolved";
	var RequestEvicted = "request_evicted";
	var ThreadClosed = "thread_closed";
	var StatusRefresh = "status_refresh";
}
