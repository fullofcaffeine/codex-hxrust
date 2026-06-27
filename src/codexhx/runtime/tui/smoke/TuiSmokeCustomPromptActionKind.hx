package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeCustomPromptActionKind(String) to String {
	final Init = "init";
	final Sequence = "sequence";
	final Paste = "paste";
	final Height = "height";
	final Cursor = "cursor";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeCustomPromptActionKind {
		return switch value {
			case "init": Init;
			case "sequence": Sequence;
			case "paste": Paste;
			case "height": Height;
			case "cursor": Cursor;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
