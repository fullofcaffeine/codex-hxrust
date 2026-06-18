package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSlashPopupMatchKind(String) to String {
	final Empty = "empty";
	final Exact = "exact";
	final Prefix = "prefix";
	final Fuzzy = "fuzzy";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSlashPopupMatchKind {
		return switch value {
			case "empty": Empty;
			case "exact": Exact;
			case "prefix": Prefix;
			case "fuzzy": Fuzzy;
			case "none": None;
			case _: Unknown;
		}
	}
}
