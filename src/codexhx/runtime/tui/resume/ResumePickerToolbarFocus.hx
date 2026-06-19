package codexhx.runtime.tui.resume;

enum abstract ResumePickerToolbarFocus(String) to String {
	final Filter = "filter";
	final Sort = "sort";
	final Unknown = "unknown";

	public static function fromString(value:String):ResumePickerToolbarFocus {
		return switch value {
			case "filter": Filter;
			case "sort": Sort;
			case _: Unknown;
		}
	}
}
