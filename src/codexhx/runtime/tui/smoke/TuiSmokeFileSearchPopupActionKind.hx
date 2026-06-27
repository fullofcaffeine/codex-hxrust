package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeFileSearchPopupActionKind(String) to String {
	final Snapshot = "snapshot";
	final SetQuery = "set_query";
	final EmptyPrompt = "empty_prompt";
	final SetMatches = "set_matches";
	final MoveUp = "move_up";
	final MoveDown = "move_down";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeFileSearchPopupActionKind {
		return switch value {
			case "snapshot": Snapshot;
			case "set_query": SetQuery;
			case "empty_prompt": EmptyPrompt;
			case "set_matches": SetMatches;
			case "move_up": MoveUp;
			case "move_down": MoveDown;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
