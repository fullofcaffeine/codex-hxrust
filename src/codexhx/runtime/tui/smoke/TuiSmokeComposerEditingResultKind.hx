package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerEditingResultKind(String) to String {
	final None = "none";
	final Submitted = "submitted";
	final Queued = "queued";
	final Command = "command";
	final CommandWithArgs = "command_with_args";
	final Ignored = "ignored";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerEditingResultKind {
		return switch value {
			case "none": None;
			case "submitted": Submitted;
			case "queued": Queued;
			case "command": Command;
			case "command_with_args": CommandWithArgs;
			case "ignored": Ignored;
			case _: Unknown;
		}
	}
}
