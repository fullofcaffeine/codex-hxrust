package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppServerRequestKind(String) to String {
	final CommandApproval = "command_approval";
	final FileChangeApproval = "file_change_approval";
	final PermissionsApproval = "permissions_approval";
	final ToolUserInput = "tool_user_input";
	final McpElicitation = "mcp_elicitation";
	final DynamicToolCall = "dynamic_tool_call";
	final AuthTokensRefresh = "auth_tokens_refresh";
	final AttestationGenerate = "attestation_generate";
	final LegacyPatchApproval = "legacy_patch_approval";
	final LegacyCommandApproval = "legacy_command_approval";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerRequestKind {
		return switch value {
			case "command_approval": CommandApproval;
			case "file_change_approval": FileChangeApproval;
			case "permissions_approval": PermissionsApproval;
			case "tool_user_input": ToolUserInput;
			case "mcp_elicitation": McpElicitation;
			case "dynamic_tool_call": DynamicToolCall;
			case "auth_tokens_refresh": AuthTokensRefresh;
			case "attestation_generate": AttestationGenerate;
			case "legacy_patch_approval": LegacyPatchApproval;
			case "legacy_command_approval": LegacyCommandApproval;
			case _: Unknown;
		}
	}
}
