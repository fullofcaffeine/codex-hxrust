package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppLinkViewActionKind(String) to String {
	final Params = "params";
	final Labels = "labels";
	final Move = "move";
	final Activate = "activate";
	final Dismiss = "dismiss";
	final Height = "height";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppLinkViewActionKind {
		return switch value {
			case "params": Params;
			case "labels": Labels;
			case "move": Move;
			case "activate": Activate;
			case "dismiss": Dismiss;
			case "height": Height;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
