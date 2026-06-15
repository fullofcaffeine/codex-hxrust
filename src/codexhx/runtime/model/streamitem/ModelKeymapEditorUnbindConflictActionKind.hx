package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapEditorUnbindConflictActionKind(String) to String {
	final KillLineStart = "kill_line_start";
	final KillWholeLine = "kill_whole_line";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapEditorUnbindConflictActionKind {
		return switch value {
			case "kill_line_start": KillLineStart;
			case "kill_whole_line": KillWholeLine;
			case _: Unknown;
		}
	}
}
