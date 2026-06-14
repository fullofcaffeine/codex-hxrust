package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingStreamErrorKind(String) to String {
	var None = "none";
	var StreamDisconnected = "stream_disconnected";
	var Unauthorized = "unauthorized";
	var ContextWindowExceeded = "context_window_exceeded";
	var UsageLimitReached = "usage_limit_reached";
	var NonRetryableApiError = "non_retryable_api_error";
}
