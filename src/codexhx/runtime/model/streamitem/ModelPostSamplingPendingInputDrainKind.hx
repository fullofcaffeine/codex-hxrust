package codexhx.runtime.model.streamitem;

enum abstract ModelPostSamplingPendingInputDrainKind(String) to String {
	final Drained = "drained";
	final SkippedNoPending = "skipped_no_pending";
	final SkippedTerminal = "skipped_terminal";
	final SkippedAutoCompact = "skipped_auto_compact";
	final Bypassed = "bypassed";
}
