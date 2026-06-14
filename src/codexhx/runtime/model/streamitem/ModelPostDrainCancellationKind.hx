package codexhx.runtime.model.streamitem;

enum abstract ModelPostDrainCancellationKind(String) to String {
	final None = "none";
	final AfterDrainBeforeTurnDiff = "after_drain_before_turn_diff";
}
