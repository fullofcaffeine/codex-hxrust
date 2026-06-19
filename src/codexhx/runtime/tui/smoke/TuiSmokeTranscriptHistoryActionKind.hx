package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTranscriptHistoryActionKind(String) to String {
	final Cell = "cell";
	final User = "user";
	final Assistant = "assistant";
	final Reasoning = "reasoning";
	final Notice = "notice";
	final Tool = "tool";
	final Command = "command";
	final TranscriptMode = "transcript_mode";
	final CopyHistory = "copy_history";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTranscriptHistoryActionKind {
		return switch value {
			case "cell": Cell;
			case "user": User;
			case "assistant": Assistant;
			case "reasoning": Reasoning;
			case "notice": Notice;
			case "tool": Tool;
			case "command": Command;
			case "transcript_mode": TranscriptMode;
			case "copy_history": CopyHistory;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
