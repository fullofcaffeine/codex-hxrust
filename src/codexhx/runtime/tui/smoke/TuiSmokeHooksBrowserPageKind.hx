package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHooksBrowserPageKind(String) to String {
	final Events = "events";
	final Handlers = "handlers";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHooksBrowserPageKind {
		return switch value {
			case "events": Events;
			case "handlers": Handlers;
			case _: Unknown;
		}
	}
}
