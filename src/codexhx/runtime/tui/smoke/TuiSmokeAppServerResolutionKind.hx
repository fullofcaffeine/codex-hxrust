package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppServerResolutionKind(String) to String {
	final CommandApproval = "command_approval";
	final FileChangeApproval = "file_change_approval";
	final PermissionsApproval = "permissions_approval";
	final ToolUserInput = "tool_user_input";
	final ServerRequestResolved = "server_request_resolved";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerResolutionKind {
		return switch value {
			case "command_approval": CommandApproval;
			case "file_change_approval": FileChangeApproval;
			case "permissions_approval": PermissionsApproval;
			case "tool_user_input": ToolUserInput;
			case "server_request_resolved": ServerRequestResolved;
			case _: Unknown;
		}
	}
}
