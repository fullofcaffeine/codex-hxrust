package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeRawOutputRenderActionKind(String) to String {
	final ModeSet = "mode_set";
	final Notice = "notice";
	final StatusLine = "status_line";
	final RenderCell = "render_cell";
	final ActiveStream = "active_stream";
	final CommandOutput = "command_output";
	final ToolOutput = "tool_output";
	final CopyTranscript = "copy_transcript";
	final ResizeSync = "resize_sync";
	final SlashCommand = "slash_command";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeRawOutputRenderActionKind {
		return switch value {
			case "mode_set": ModeSet;
			case "notice": Notice;
			case "status_line": StatusLine;
			case "render_cell": RenderCell;
			case "active_stream": ActiveStream;
			case "command_output": CommandOutput;
			case "tool_output": ToolOutput;
			case "copy_transcript": CopyTranscript;
			case "resize_sync": ResizeSync;
			case "slash_command": SlashCommand;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
