package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapListConflictActionKind(String) to String {
	final ListMoveUp = "list_move_up";
	final ListMoveDown = "list_move_down";
	final ListMoveLeft = "list_move_left";
	final ListMoveRight = "list_move_right";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapListConflictActionKind {
		return switch value {
			case "list_move_up": ListMoveUp;
			case "list_move_down": ListMoveDown;
			case "list_move_left": ListMoveLeft;
			case "list_move_right": ListMoveRight;
			case _: Unknown;
		}
	}
}
