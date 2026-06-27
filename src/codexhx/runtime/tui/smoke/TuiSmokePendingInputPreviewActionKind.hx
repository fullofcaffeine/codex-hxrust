package codexhx.runtime.tui.smoke;

enum abstract TuiSmokePendingInputPreviewActionKind(String) to String {
	final Render = "render";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokePendingInputPreviewActionKind {
		return switch value {
			case "render": Render;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
