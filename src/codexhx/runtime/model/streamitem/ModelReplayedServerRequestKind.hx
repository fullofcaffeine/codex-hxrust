package codexhx.runtime.model.streamitem;

enum abstract ModelReplayedServerRequestKind(String) to String {
	final ExecApproval = "exec_approval";
	final FileChangeApproval = "file_change_approval";
	final McpElicitation = "mcp_elicitation";
	final PermissionsApproval = "permissions_approval";
	final UserInput = "user_input";
	final DynamicToolCall = "dynamic_tool_call";
	final AttestationGenerate = "attestation_generate";
	final ChatgptAuthTokensRefresh = "chatgpt_auth_tokens_refresh";
	final LegacyApplyPatchApproval = "legacy_apply_patch_approval";
	final LegacyExecCommandApproval = "legacy_exec_command_approval";
}
