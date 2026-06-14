package codexhx.runtime.model.streamitem;

enum abstract ModelStreamOutputItemKind(String) to String {
	public var AssistantMessage = "assistant_message";
	public var Reasoning = "reasoning";
	public var FunctionCall = "function_call";
	public var CustomToolCall = "custom_tool_call";
	public var WebSearchCall = "web_search_call";
	public var ImageGenerationCall = "image_generation_call";
	public var ToolOutput = "tool_output";
	public var Unknown = "unknown";
}
