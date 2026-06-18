package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMcpElicitationModeKind(String) to String {
	final FormContent = "form_content";
	final ApprovalAction = "approval_action";
	final ToolSuggestion = "tool_suggestion";
	final Unsupported = "unsupported";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMcpElicitationModeKind {
		return switch value {
			case "form_content": FormContent;
			case "approval_action": ApprovalAction;
			case "tool_suggestion": ToolSuggestion;
			case "unsupported": Unsupported;
			case _: Unknown;
		}
	}
}
