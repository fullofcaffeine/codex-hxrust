package codexhx.runtime.tui.resume;

enum abstract ResumePickerActionKind(String) to String {
	final Resume = "resume";
	final Fork = "fork";
	final Unknown = "unknown";

	public static function fromString(value:String):ResumePickerActionKind {
		return switch value {
			case "resume": Resume;
			case "fork": Fork;
			case _: Unknown;
		}
	}
}
