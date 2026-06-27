package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSkillPopupActionKind(String) to String {
	final Snapshot = "snapshot";
	final SetMentions = "set_mentions";
	final SetQuery = "set_query";
	final MoveUp = "move_up";
	final MoveDown = "move_down";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSkillPopupActionKind {
		return switch value {
			case "snapshot": Snapshot;
			case "set_mentions": SetMentions;
			case "set_query": SetQuery;
			case "move_up": MoveUp;
			case "move_down": MoveDown;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
