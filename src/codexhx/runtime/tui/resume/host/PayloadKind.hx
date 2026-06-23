package codexhx.runtime.tui.resume.host;

enum abstract PayloadKind(String) to String {
	final CommandExecutionApprovalResponse = "command_execution_approval_response";
	final FileChangeApprovalResponse = "file_change_approval_response";
	final PermissionsApprovalResponse = "permissions_approval_response";
	final ToolRequestUserInputResponse = "tool_request_user_input_response";
	final McpElicitationResponse = "mcp_elicitation_response";
	final JsonRpcError = "json_rpc_error";
	final MissingPendingNoop = "missing_pending_noop";
	final Unknown = "unknown";
}
