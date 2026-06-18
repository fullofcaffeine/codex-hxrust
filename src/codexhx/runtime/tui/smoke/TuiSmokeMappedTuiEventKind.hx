package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMappedTuiEventKind(String) to String {
	final None = "none";
	final Draw = "draw";
	final Resize = "resize";
	final Paste = "paste";
	final Key = "key";
	final Pending = "pending";
	final End = "end";
	final Skipped = "skipped";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMappedTuiEventKind {
		return switch value {
			case "none": None;
			case "draw": Draw;
			case "resize": Resize;
			case "paste": Paste;
			case "key": Key;
			case "pending": Pending;
			case "end": End;
			case "skipped": Skipped;
			case _: Unknown;
		}
	}
}
