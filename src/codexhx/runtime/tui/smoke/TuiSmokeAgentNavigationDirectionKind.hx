package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAgentNavigationDirectionKind(String) to String {
	final Previous = "previous";
	final Next = "next";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAgentNavigationDirectionKind {
		return switch value {
			case "previous": Previous;
			case "next": Next;
			case _: Unknown;
		}
	}
}
