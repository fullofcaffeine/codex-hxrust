package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTerminalTitleActionKind(String) to String {
	final Set = "set";
	final NoVisibleContent = "no_visible_content";
	final SkipDuplicate = "skip_duplicate";
	final ClearManaged = "clear_managed";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTerminalTitleActionKind {
		return switch value {
			case "set": Set;
			case "no_visible_content": NoVisibleContent;
			case "skip_duplicate": SkipDuplicate;
			case "clear_managed": ClearManaged;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
