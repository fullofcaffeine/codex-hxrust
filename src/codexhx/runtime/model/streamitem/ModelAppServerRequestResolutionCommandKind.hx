package codexhx.runtime.model.streamitem;

enum abstract ModelAppServerRequestResolutionCommandKind(String) to String {
	final ExecApprovalResponse = "exec_approval_response";
	final FileChangeApprovalResponse = "file_change_approval_response";
	final PermissionsResponse = "permissions_response";
	final UserInputAnswer = "user_input_answer";
	final McpElicitationResponse = "mcp_elicitation_response";
	final ServerRequestResolvedNotification = "server_request_resolved_notification";
}
