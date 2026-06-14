package codexhx.runtime.model.streamitem;

enum abstract ModelAppServerRequestResolutionPayloadKind(String) to String {
	final None = "none";
	final CommandExecutionApprovalResponse = "command_execution_approval_response";
	final FileChangeApprovalResponse = "file_change_approval_response";
	final PermissionsApprovalResponse = "permissions_approval_response";
	final ToolRequestUserInputResponse = "tool_request_user_input_response";
	final McpElicitationResponse = "mcp_elicitation_response";
}
