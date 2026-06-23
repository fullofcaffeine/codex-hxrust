package codexhx.runtime.tui.resume.host;

enum abstract PendingRequestClassKind(String) to String {
	final ExecApproval = "exec_approval";
	final FileChangeApproval = "file_change_approval";
	final PermissionsApproval = "permissions_approval";
	final UserInput = "user_input";
	final McpElicitation = "mcp_elicitation";
	final DynamicToolCall = "dynamic_tool_call";
	final AttestationGenerate = "attestation_generate";
	final ChatgptAuthTokensRefresh = "chatgpt_auth_tokens_refresh";
	final Unknown = "unknown";
}
