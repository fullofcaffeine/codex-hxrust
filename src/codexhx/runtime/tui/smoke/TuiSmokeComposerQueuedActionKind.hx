package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerQueuedActionKind(String) to String {
	final Plain = "plain";
	final ParseSlash = "parse_slash";
	final RunShell = "run_shell";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerQueuedActionKind {
		return switch value {
			case "plain": Plain;
			case "parse_slash": ParseSlash;
			case "run_shell": RunShell;
			case _: Unknown;
		}
	}
}
