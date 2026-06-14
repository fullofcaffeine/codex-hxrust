package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingInputItemKind(String) to String {
	var ToolResponseOutput = "tool_response_output";
	var PendingUserInput = "pending_user_input";
	var PendingResponseItem = "pending_response_item";
}
