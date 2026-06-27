package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMultiSelectActionKind(String) to String {
	final Filter = "filter";
	final MoveDown = "move_down";
	final MoveUp = "move_up";
	final Toggle = "toggle";
	final ReorderUp = "reorder_up";
	final ReorderDown = "reorder_down";
	final Confirm = "confirm";
	final Cancel = "cancel";
	final Height = "height";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMultiSelectActionKind {
		return switch value {
			case "filter": Filter;
			case "move_down": MoveDown;
			case "move_up": MoveUp;
			case "toggle": Toggle;
			case "reorder_up": ReorderUp;
			case "reorder_down": ReorderDown;
			case "confirm": Confirm;
			case "cancel": Cancel;
			case "height": Height;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
