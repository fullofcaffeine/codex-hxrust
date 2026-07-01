package codexhx.runtime.tui.appserver;

/**
	Typed result codes for ordered late submitted-turn JSONL batch handoff.
**/
enum abstract TuiPromptSubmittedTurnJsonlBatchStatus(String) to String {
	final Accepted = "accepted";
	final DecodeRejected = "decode_rejected";
	final UnsupportedNotification = "unsupported_notification";
	final StreamDeliveryRejected = "stream_delivery_rejected";
	final CompletionDeliveryRejected = "completion_delivery_rejected";

	public function text():String {
		return this;
	}
}
