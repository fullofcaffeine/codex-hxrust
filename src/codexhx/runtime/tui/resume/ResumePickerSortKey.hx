package codexhx.runtime.tui.resume;

enum abstract ResumePickerSortKey(String) to String {
	final UpdatedAt = "updated_at";
	final CreatedAt = "created_at";
	final Unknown = "unknown";

	public static function fromString(value:String):ResumePickerSortKey {
		return switch value {
			case "updated_at": UpdatedAt;
			case "created_at": CreatedAt;
			case _: Unknown;
		}
	}
}
