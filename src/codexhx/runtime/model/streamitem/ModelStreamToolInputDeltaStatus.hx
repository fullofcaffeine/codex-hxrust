package codexhx.runtime.model.streamitem;

enum abstract ModelStreamToolInputDeltaStatus(String) to String {
	public var Accepted = "accepted";
	public var IgnoredNoActiveToolCall = "ignored_no_active_tool_call";
	public var IgnoredCallMismatch = "ignored_call_mismatch";
}
