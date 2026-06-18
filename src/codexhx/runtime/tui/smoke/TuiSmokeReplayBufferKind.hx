package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeReplayBufferKind(String) to String {
	final None = "none";
	final InitialHistory = "initial_history";
	final ThreadSwitch = "thread_switch";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeReplayBufferKind {
		return switch value {
			case "none": None;
			case "initial_history": InitialHistory;
			case "thread_switch": ThreadSwitch;
			case _: Unknown;
		}
	}
}
