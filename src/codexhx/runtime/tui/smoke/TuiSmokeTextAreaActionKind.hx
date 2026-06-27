package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTextAreaActionKind(String) to String {
	final ReplaceClear = "replace_clear";
	final ReplaceElements = "replace_elements";
	final InsertReplace = "insert_replace";
	final CursorBoundary = "cursor_boundary";
	final KillPreserve = "kill_preserve";
	final PasteBurstMode = "paste_burst_mode";
	final WrapCursor = "wrap_cursor";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTextAreaActionKind {
		return switch value {
			case "replace_clear": ReplaceClear;
			case "replace_elements": ReplaceElements;
			case "insert_replace": InsertReplace;
			case "cursor_boundary": CursorBoundary;
			case "kill_preserve": KillPreserve;
			case "paste_burst_mode": PasteBurstMode;
			case "wrap_cursor": WrapCursor;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
