package codexhx.runtime.tui.appserver;

/**
	Typed result codes for late submitted-turn JSONL completion handoff.
**/
enum abstract TuiPromptSubmittedTurnJsonlCompletionStatus(String) to String {
	final Accepted = "accepted";
	final DecodeRejected = "decode_rejected";
	final MultipleNotifications = "multiple_notifications";
	final UnsupportedNotification = "unsupported_notification";
	final CompletionDeliveryRejected = "completion_delivery_rejected";

	public function text():String {
		return this;
	}
}
