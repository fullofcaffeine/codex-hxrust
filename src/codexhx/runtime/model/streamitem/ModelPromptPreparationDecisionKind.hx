package codexhx.runtime.model.streamitem;

enum abstract ModelPromptPreparationDecisionKind(String) to String {
	final ContinueToDispatch = "continue_to_dispatch";
	final BreakBeforePrompt = "break_before_prompt";
	final Skipped = "skipped";
}
