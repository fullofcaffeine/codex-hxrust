package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeApprovalRequestKind(String) to String {
	final Exec = "exec";
	final FileChange = "file_change";
	final Permissions = "permissions";
	final McpElicitation = "mcp_elicitation";
	final LegacyExec = "legacy_exec";
	final LegacyPatch = "legacy_patch";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeApprovalRequestKind {
		return switch value {
			case "exec": Exec;
			case "file_change": FileChange;
			case "permissions": Permissions;
			case "mcp_elicitation": McpElicitation;
			case "legacy_exec": LegacyExec;
			case "legacy_patch": LegacyPatch;
			case _: Unknown;
		}
	}
}
