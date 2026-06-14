package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingErrorTerminalDecisionKind(String) to String {
	final BreakWithoutErrorEvent = "break_without_error_event";
	final RetryAfterImageSanitization = "retry_after_image_sanitization";
	final EmitBadRequestAndBreak = "emit_bad_request_and_break";
	final EmitErrorAndBreak = "emit_error_and_break";
}
