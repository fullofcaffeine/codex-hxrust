package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeCustomPromptStepKind(String) to String {
	final Char = "char";
	final Tab = "tab";
	final Enter = "enter";
	final Esc = "esc";
	final Paste = "paste";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeCustomPromptStepKind {
		return switch value {
			case "char": Char;
			case "tab": Tab;
			case "enter": Enter;
			case "esc": Esc;
			case "paste": Paste;
			case _: Unknown;
		}
	}
}
