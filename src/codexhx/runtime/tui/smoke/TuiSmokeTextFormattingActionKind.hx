package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTextFormattingActionKind(String) to String {
	final Capitalize = "capitalize";
	final JsonCompact = "json_compact";
	final TruncateText = "truncate_text";
	final ToolResult = "tool_result";
	final CenterPath = "center_path";
	final ProperJoin = "proper_join";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTextFormattingActionKind {
		return switch value {
			case "capitalize": Capitalize;
			case "json_compact": JsonCompact;
			case "truncate_text": TruncateText;
			case "tool_result": ToolResult;
			case "center_path": CenterPath;
			case "proper_join": ProperJoin;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
