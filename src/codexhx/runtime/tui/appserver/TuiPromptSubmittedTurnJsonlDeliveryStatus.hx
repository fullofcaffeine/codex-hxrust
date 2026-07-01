package codexhx.runtime.tui.appserver;

/**
	Typed result codes for late submitted-turn JSONL notification handoff.
**/
enum abstract TuiPromptSubmittedTurnJsonlDeliveryStatus(String) to String {
	final Accepted = "accepted";
	final DecodeRejected = "decode_rejected";
	final MultipleNotifications = "multiple_notifications";
	final UnsupportedNotification = "unsupported_notification";
	final StreamDeliveryRejected = "stream_delivery_rejected";

	public function text():String {
		return this;
	}
}
