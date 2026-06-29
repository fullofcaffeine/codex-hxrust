package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeToolLifecycleActionKind(String) to String {
	final PatchApplyBegin = "patch_apply_begin";
	final FileChangeCompleted = "file_change_completed";
	final AppServerFileChangeStarted = "app_server_file_change_started";
	final AppServerCommandShellWrapper = "app_server_command_shell_wrapper";
	final ViewImage = "view_image";
	final ImageGeneration = "image_generation";
	final McpToolStarted = "mcp_tool_started";
	final McpToolCompleted = "mcp_tool_completed";
	final WebSearch = "web_search";
	final CollabEvent = "collab_event";
	final CollabAgentTool = "collab_agent_tool";
	final SubAgentActivity = "sub_agent_activity";
	final QueuedItemDispatch = "queued_item_dispatch";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeToolLifecycleActionKind {
		return switch value {
			case "patch_apply_begin": PatchApplyBegin;
			case "file_change_completed": FileChangeCompleted;
			case "app_server_file_change_started": AppServerFileChangeStarted;
			case "app_server_command_shell_wrapper": AppServerCommandShellWrapper;
			case "view_image": ViewImage;
			case "image_generation": ImageGeneration;
			case "mcp_tool_started": McpToolStarted;
			case "mcp_tool_completed": McpToolCompleted;
			case "web_search": WebSearch;
			case "collab_event": CollabEvent;
			case "collab_agent_tool": CollabAgentTool;
			case "sub_agent_activity": SubAgentActivity;
			case "queued_item_dispatch": QueuedItemDispatch;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
