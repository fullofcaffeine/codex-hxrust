package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTerminalHyperlinkActionKind(String) to String {
	final Destination = "destination";
	final Discover = "discover";
	final Decorate = "decorate";
	final Strip = "strip";
	final PrefixRemap = "prefix_remap";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTerminalHyperlinkActionKind {
		return switch value {
			case "destination": Destination;
			case "discover": Discover;
			case "decorate": Decorate;
			case "strip": Strip;
			case "prefix_remap": PrefixRemap;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
