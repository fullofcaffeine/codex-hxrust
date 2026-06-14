package codexhx.runtime.model.streamitem;

enum abstract ModelPatchToolOutputItemKind(String) to String {
	public var FunctionCallOutput = "function_call_output";
	public var CustomToolCallOutput = "custom_tool_call_output";
}
