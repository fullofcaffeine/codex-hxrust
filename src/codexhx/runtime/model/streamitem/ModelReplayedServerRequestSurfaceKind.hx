package codexhx.runtime.model.streamitem;

enum abstract ModelReplayedServerRequestSurfaceKind(String) to String {
	final ExecApprovalPrompt = "exec_approval_prompt";
	final FileChangeApprovalPrompt = "file_change_approval_prompt";
	final McpElicitationPrompt = "mcp_elicitation_prompt";
	final PermissionsPrompt = "permissions_prompt";
	final UserInputPrompt = "user_input_prompt";
	final UnsupportedStubError = "unsupported_stub_error";
	final UnsupportedReplaySuppressed = "unsupported_replay_suppressed";
	final RequestFiltered = "request_filtered";
}
