package codexhx.runtime.model.streamitem;

enum abstract ModelTurnReplayTargetKind(String) to String {
	final ActiveExact = "active_exact";
	final HistoricalExact = "historical_exact";
	final ActiveFallback = "active_fallback";
	final MissingNoop = "missing_noop";
}
