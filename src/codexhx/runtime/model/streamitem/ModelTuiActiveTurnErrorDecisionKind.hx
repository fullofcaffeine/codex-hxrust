package codexhx.runtime.model.streamitem;

enum abstract ModelTuiActiveTurnErrorDecisionKind(String) from String to String {
	final StructuredNotSteerable = "structured_not_steerable";
	final SteerMissingActiveTurn = "steer_missing_active_turn";
	final SteerExpectedTurnMismatch = "steer_expected_turn_mismatch";
	final InterruptExpectedTurnMismatch = "interrupt_expected_turn_mismatch";
	final ArchivedSessionGuidance = "archived_session_guidance";
	final NoMatch = "no_match";
}
