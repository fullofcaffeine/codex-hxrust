package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMentionCandidateKind(String) to String {
	final File = "file";
	final Directory = "directory";
	final Skill = "skill";
	final Plugin = "plugin";
	final Tool = "tool";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMentionCandidateKind {
		return switch value {
			case "file": File;
			case "directory": Directory;
			case "skill": Skill;
			case "plugin": Plugin;
			case "tool": Tool;
			case _: Unknown;
		}
	}
}
