package codexhx.runtime.tui.resume;

enum abstract ResumePickerDensity(String) to String {
	final Comfortable = "comfortable";
	final Dense = "dense";
	final Unknown = "unknown";

	public static function fromString(value:String):ResumePickerDensity {
		return switch value {
			case "comfortable": Comfortable;
			case "dense": Dense;
			case _: Unknown;
		}
	}
}
