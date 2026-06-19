package codexhx.runtime.tui.resume;

enum abstract ResumePickerFilterMode(String) to String {
	final Cwd = "cwd";
	final All = "all";
	final Unknown = "unknown";

	public static function fromString(value:String):ResumePickerFilterMode {
		return switch value {
			case "cwd": Cwd;
			case "all": All;
			case _: Unknown;
		}
	}
}
