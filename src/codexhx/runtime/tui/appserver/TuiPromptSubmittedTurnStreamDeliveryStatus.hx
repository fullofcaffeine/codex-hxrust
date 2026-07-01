package codexhx.runtime.tui.appserver;

/**
	Typed result codes for late assistant stream delivery on a submitted turn.
**/
enum abstract TuiPromptSubmittedTurnStreamDeliveryStatus(String) to String {
	final Accepted = "accepted";
	final EmptyDelta = "empty_delta";
	final NoSubmittedTurn = "no_submitted_turn";
	final WrongThread = "wrong_thread";
	final WrongTurn = "wrong_turn";
	final DuplicateCompletedTurn = "duplicate_completed_turn";
	final StaleInterruptedTurn = "stale_interrupted_turn_delivery";

	public function text():String {
		return this;
	}
}
