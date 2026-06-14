package codexhx.runtime.model.streamitem;

enum abstract ModelTerminalStopHookDecisionKind(String) to String {
	final Skipped = "skipped";
	final BreakTurn = "break_turn";
	final ContinueWithHookPrompt = "continue_with_hook_prompt";
	final LegacyAfterAgentAbort = "legacy_after_agent_abort";
}
