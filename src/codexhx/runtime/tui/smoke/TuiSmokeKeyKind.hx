package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeKeyKind(String) to String {
	final None = "none";
	final CtrlC = "ctrl-c";
	final Escape = "escape";
	final CharQ = "q";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeKeyKind {
		return switch value {
			case "none": None;
			case "ctrl-c": CtrlC;
			case "escape": Escape;
			case "q": CharQ;
			case _: Unknown;
		}
	}
}
