package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingStreamEventClassKind(String) to String {
	final AttemptRetry = "attempt_retry";
	final AttemptTerminal = "attempt_terminal";
	final CompletedEndTurn = "completed_end_turn";
	final CompletedFollowUp = "completed_follow_up";
	final ClosedBeforeCompleted = "closed_before_completed";
}
