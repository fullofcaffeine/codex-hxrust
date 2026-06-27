package codexhx.runtime.tui.smoke;

enum abstract TuiSmokePopupConstsActionKind(String) to String {
	final MaxRows = "max_rows";
	final StandardHint = "standard_hint";
	final KeymapHint = "keymap_hint";
	final AcceptCancel = "accept_cancel";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokePopupConstsActionKind {
		return switch value {
			case "max_rows": MaxRows;
			case "standard_hint": StandardHint;
			case "keymap_hint": KeymapHint;
			case "accept_cancel": AcceptCancel;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
