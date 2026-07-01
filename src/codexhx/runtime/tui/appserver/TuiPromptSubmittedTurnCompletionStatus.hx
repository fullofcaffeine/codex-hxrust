package codexhx.runtime.tui.appserver;

/**
	Typed result codes for delayed completion of a submitted prompt turn.
**/
enum abstract TuiPromptSubmittedTurnCompletionStatus(String) to String {
	final Accepted = "accepted";
	final NoSubmittedTurn = "no_submitted_turn";
	final WrongThread = "wrong_thread";
	final WrongTurn = "wrong_turn";
	final DuplicateCompletion = "duplicate_completion";
	final StaleInterruptedTurn = "stale_interrupted_turn_completion";

	public function text():String {
		return this;
	}
}
