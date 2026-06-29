package codexhx.runtime.tui.appserver;

/**
	Request/response correlation state for prompt JSON-RPC frames.
**/
enum abstract TuiPromptJsonRpcCorrelationStatus(String) to String {
	final Complete = "complete";
	final RequestOnly = "request_only";
	final MissingRequest = "missing_request";
	final ResponseIdMismatch = "response_id_mismatch";

	public function text():String {
		return this;
	}
}
