package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeClipboardPasteActionKind(String) to String {
	final Probe = "probe";
	final ImageAccept = "image_accept";
	final WslPath = "wsl_path";
	final Refusal = "refusal";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeClipboardPasteActionKind {
		return switch value {
			case "probe": Probe;
			case "image_accept": ImageAccept;
			case "wsl_path": WslPath;
			case "refusal": Refusal;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
