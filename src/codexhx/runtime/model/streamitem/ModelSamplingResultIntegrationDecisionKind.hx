package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingResultIntegrationDecisionKind(String) to String {
	final ContinueSampling = "continue_sampling";
	final AutoCompact = "auto_compact";
	final StopTurn = "stop_turn";
	final BypassCancellation = "bypass_cancellation";
	final BypassError = "bypass_error";
}
