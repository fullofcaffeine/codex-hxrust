package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingStreamHandoffKind(String) to String {
	final ScheduleRetry = "schedule_retry";
	final PrepareUnauthorizedRetry = "prepare_unauthorized_retry";
	final TerminalError = "terminal_error";
	final CompleteTurn = "complete_turn";
	final ContinueTurn = "continue_turn";
}
