package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeReplayedServerRequestSurfaceKind(String) to String {
	final CommandApproval = "command_approval";
	final FileChangeApproval = "file_change_approval";
	final PermissionsApproval = "permissions_approval";
	final McpElicitation = "mcp_elicitation";
	final ToolUserInput = "tool_user_input";
	final UnsupportedSuppressed = "unsupported_suppressed";
	final Unknown = "unknown";
}
