package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSlashCommandActionKind(String) to String {
	final Dispatch = "dispatch";
	final RawMode = "raw_mode";
	final StatusOutput = "status_output";
	final InlineArgs = "inline_args";
	final Availability = "availability";
	final AppEvent = "app_event";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSlashCommandActionKind {
		return switch value {
			case "dispatch": Dispatch;
			case "raw_mode": RawMode;
			case "status_output": StatusOutput;
			case "inline_args": InlineArgs;
			case "availability": Availability;
			case "app_event": AppEvent;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
