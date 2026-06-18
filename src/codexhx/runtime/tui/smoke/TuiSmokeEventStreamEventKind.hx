package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeEventStreamEventKind(String) to String {
	final None = "none";
	final Key = "key";
	final Resize = "resize";
	final Paste = "paste";
	final FocusGained = "focus_gained";
	final FocusLost = "focus_lost";
	final Mouse = "mouse";
	final Error = "error";
	final Eof = "eof";
	final Pending = "pending";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeEventStreamEventKind {
		return switch value {
			case "none": None;
			case "key": Key;
			case "resize": Resize;
			case "paste": Paste;
			case "focus_gained": FocusGained;
			case "focus_lost": FocusLost;
			case "mouse": Mouse;
			case "error": Error;
			case "eof": Eof;
			case "pending": Pending;
			case _: Unknown;
		}
	}
}
