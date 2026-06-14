package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideParentStatusChangeEventKind(String) to String {
	var TurnStarted = "turn_started";
	var TurnCompleted = "turn_completed";
	var ThreadClosed = "thread_closed";
	var ItemStarted = "item_started";
	var ServerRequestResolved = "server_request_resolved";
	var OtherNotification = "other_notification";
}
