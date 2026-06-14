package codexhx.runtime.model.streamitem;

enum abstract ModelPendingInputHookRecordingDecisionKind(String) to String {
	final ContinueToPrompt = "continue_to_prompt";
	final BreakBeforePrompt = "break_before_prompt";
	final Skipped = "skipped";
}
