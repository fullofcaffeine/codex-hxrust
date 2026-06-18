package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeFileMentionPopupKind(String) to String {
	final None = "none";
	final File = "file";
	final Skill = "skill";
	final MentionV2 = "mention_v2";
	final Command = "command";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeFileMentionPopupKind {
		return switch value {
			case "none": None;
			case "file": File;
			case "skill": Skill;
			case "mention_v2": MentionV2;
			case "command": Command;
			case _: Unknown;
		}
	}
}
