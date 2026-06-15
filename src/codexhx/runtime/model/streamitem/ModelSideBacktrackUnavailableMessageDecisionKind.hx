package codexhx.runtime.model.streamitem;

enum abstract ModelSideBacktrackUnavailableMessageDecisionKind(String) to String {
	final SideBacktrackUnavailableMessageInserted = "side_backtrack_unavailable_message_inserted";
	final SideBacktrackUnavailableMessageUnavailable = "side_backtrack_unavailable_message_unavailable";
}
