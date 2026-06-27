package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeCommandPopupActionKind(String) to String {
	final Filter = "filter";
	final MoveDown = "move_down";
	final MoveUp = "move_up";
	final Accept = "accept";
	final Height = "height";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeCommandPopupActionKind {
		return switch value {
			case "filter": Filter;
			case "move_down": MoveDown;
			case "move_up": MoveUp;
			case "accept": Accept;
			case "height": Height;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
