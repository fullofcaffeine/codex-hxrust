package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeListSelectionActionKind(String) to String {
	final Layout = "layout";
	final Filter = "filter";
	final MoveDown = "move_down";
	final MoveUp = "move_up";
	final Accept = "accept";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeListSelectionActionKind {
		return switch value {
			case "layout": Layout;
			case "filter": Filter;
			case "move_down": MoveDown;
			case "move_up": MoveUp;
			case "accept": Accept;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
