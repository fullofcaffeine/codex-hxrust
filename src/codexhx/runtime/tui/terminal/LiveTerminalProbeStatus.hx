package codexhx.runtime.tui.terminal;

/**
	Typed status codes returned by the native live-terminal probe.
**/
enum abstract LiveTerminalProbeStatus(Int) from Int to Int {
	final Completed = 0;
	final SkippedNoTty = 1;
	final SetupFailed = 2;
	final DrawFailed = 3;
	final RestoreFailed = 4;
	final Inactive = 5;

	public function okForCi():Bool {
		return this == Completed || this == SkippedNoTty;
	}

	public function restored():Bool {
		return this == Completed || this == SkippedNoTty;
	}

	public function text():String {
		return switch (this) {
			case Completed: "completed";
			case SkippedNoTty: "skipped_no_tty";
			case SetupFailed: "setup_failed";
			case DrawFailed: "draw_failed";
			case RestoreFailed: "restore_failed";
			case Inactive: "inactive";
			case _: "unknown_status";
		}
	}
}
