package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAppLinkSuggestionKind(String) to String {
	final Install = "install";
	final Enable = "enable";
	final Auth = "auth";
	final ExternalAction = "external_action";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppLinkSuggestionKind {
		return switch value {
			case "install": Install;
			case "enable": Enable;
			case "auth": Auth;
			case "external_action": ExternalAction;
			case "none": None;
			case _: Unknown;
		}
	}
}
