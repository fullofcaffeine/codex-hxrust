package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerPopupKind(String) to String {
	final None = "none";
	final Command = "command";
	final File = "file";
	final Skill = "skill";
	final MentionV2 = "mention_v2";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerPopupKind {
		return switch value {
			case "none": None;
			case "command": Command;
			case "file": File;
			case "skill": Skill;
			case "mention_v2": MentionV2;
			case _: Unknown;
		}
	}
}
