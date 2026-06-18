package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeKeyboardRestoreKind(String) to String {
	final PopStack = "pop_stack";
	final ResetAfterExit = "reset_after_exit";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeKeyboardRestoreKind {
		return switch value {
			case "pop_stack": PopStack;
			case "reset_after_exit": ResetAfterExit;
			case "none": None;
			case _: Unknown;
		}
	}
}
