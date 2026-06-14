package codexhx.runtime.model.streamitem;

enum abstract ModelPostSamplingPendingInputSourceKind(String) to String {
	final ActiveTurn = "active_turn";
	final Mailbox = "mailbox";
}
