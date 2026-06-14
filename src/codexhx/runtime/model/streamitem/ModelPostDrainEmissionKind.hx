package codexhx.runtime.model.streamitem;

enum abstract ModelPostDrainEmissionKind(String) to String {
	final NoEmission = "no_emission";
	final TokenCountOnly = "token_count_only";
	final TurnDiffOnly = "turn_diff_only";
	final TokenCountAndTurnDiff = "token_count_and_turn_diff";
	final CancelledAfterTokenCount = "cancelled_after_token_count";
	final FatalDrain = "fatal_drain";
}
