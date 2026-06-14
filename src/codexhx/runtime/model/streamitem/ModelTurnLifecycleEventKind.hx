package codexhx.runtime.model.streamitem;

enum abstract ModelTurnLifecycleEventKind(String) to String {
	final TurnComplete = "turn_complete";
	final TurnAborted = "turn_aborted";
	final CompletionSuppressedForCancellation = "completion_suppressed_for_cancellation";
}
