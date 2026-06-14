package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingStreamAttemptResultKind(String) to String {
	var FixtureStreamOpened = "fixture_stream_opened";
	var RetryScheduled = "retry_scheduled";
	var UnauthorizedRetryPrepared = "unauthorized_retry_prepared";
	var TerminalError = "terminal_error";
}
