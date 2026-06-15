package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapMainSurfaceAssignmentActionKind(String) to String {
	final ToggleFastMode = "toggle_fast_mode";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapMainSurfaceAssignmentActionKind {
		return switch value {
			case "toggle_fast_mode": ToggleFastMode;
			case _: Unknown;
		}
	}
}
