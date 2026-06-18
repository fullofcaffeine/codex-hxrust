package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeEventStreamBrokerState(String) to String {
	final Paused = "paused";
	final Start = "start";
	final Running = "running";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeEventStreamBrokerState {
		return switch value {
			case "paused": Paused;
			case "start": Start;
			case "running": Running;
			case _: Unknown;
		}
	}
}
