package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapEditorConflictActionKind(String) to String {
	final EditorMoveLeft = "editor_move_left";
	final EditorMoveRight = "editor_move_right";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapEditorConflictActionKind {
		return switch value {
			case "editor_move_left": EditorMoveLeft;
			case "editor_move_right": EditorMoveRight;
			case _: Unknown;
		}
	}
}
