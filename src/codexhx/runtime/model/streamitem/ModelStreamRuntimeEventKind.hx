package codexhx.runtime.model.streamitem;

enum abstract ModelStreamRuntimeEventKind(String) to String {
	public var ItemStarted = "item_started";
	public var ItemCompleted = "item_completed";
	public var AgentMessageContentDelta = "agent_message_content_delta";
	public var ReasoningContentDelta = "reasoning_content_delta";
	public var ReasoningRawContentDelta = "reasoning_raw_content_delta";
	public var ToolCallInputDelta = "tool_call_input_delta";
	public var ToolCallInputDeltaIgnored = "tool_call_input_delta_ignored";
	public var ToolArgumentDiffUpdated = "tool_argument_diff_updated";
	public var ToolCallQueued = "tool_call_queued";
	public var StreamCompleted = "stream_completed";
	public var RouteDenied = "route_denied";
	public var ReducerError = "reducer_error";
}
