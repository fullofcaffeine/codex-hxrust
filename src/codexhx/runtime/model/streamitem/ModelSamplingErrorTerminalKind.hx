package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingErrorTerminalKind(String) to String {
	final TurnAborted = "turn_aborted";
	final InvalidImageRequest = "invalid_image_request";
	final GenericCodexError = "generic_codex_error";
}
