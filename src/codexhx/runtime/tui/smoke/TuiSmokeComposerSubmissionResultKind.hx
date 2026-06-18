package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerSubmissionResultKind(String) to String {
	final Submitted = "submitted";
	final Queued = "queued";
	final Command = "command";
	final ServiceTierCommand = "service_tier_command";
	final CommandWithArgs = "command_with_args";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerSubmissionResultKind {
		return switch value {
			case "submitted": Submitted;
			case "queued": Queued;
			case "command": Command;
			case "service_tier_command": ServiceTierCommand;
			case "command_with_args": CommandWithArgs;
			case "none": None;
			case _: Unknown;
		}
	}
}
