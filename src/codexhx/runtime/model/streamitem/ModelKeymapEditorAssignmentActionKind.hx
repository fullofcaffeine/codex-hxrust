package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapEditorAssignmentActionKind(String) to String {
	final KillWholeLine = "kill_whole_line";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapEditorAssignmentActionKind {
		return switch value {
			case "kill_whole_line": KillWholeLine;
			case _: Unknown;
		}
	}
}
