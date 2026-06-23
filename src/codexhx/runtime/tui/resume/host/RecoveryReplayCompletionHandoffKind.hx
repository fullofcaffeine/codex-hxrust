package codexhx.runtime.tui.resume.host;

enum abstract RecoveryReplayCompletionHandoffKind(String) to String {
	final CompletedRecoveredSelection = "completed_recovered_selection";
	final CompletionRejected = "completion_rejected";
	final Unknown = "unknown";
}
