package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapListConflictActionKind(String) to String {
	final ListMoveUp = "list_move_up";
	final ListMoveDown = "list_move_down";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapListConflictActionKind {
		return switch value {
			case "list_move_up": ListMoveUp;
			case "list_move_down": ListMoveDown;
			case _: Unknown;
		}
	}
}
