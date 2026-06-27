package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadTranscriptActionKind(String) to String {
	final Project = "project";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadTranscriptActionKind {
		return switch value {
			case "project": Project;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
