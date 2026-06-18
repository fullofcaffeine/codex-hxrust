package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeEventStreamActionKind(String) to String {
	final CreateStream = "create_stream";
	final Pause = "pause";
	final Resume = "resume";
	final Poll = "poll";
	final SourceEvent = "source_event";
	final DrawEvent = "draw_event";
	final LaggedDraw = "lagged_draw";
	final FlushStaleInput = "flush_stale_input";
	final RestoreTerminal = "restore_terminal";
	final PauseStderr = "pause_stderr";
	final ResumeStderr = "resume_stderr";
	final SetModes = "set_modes";
	final LeaveAltScreen = "leave_alt_screen";
	final EnterAltScreen = "enter_alt_screen";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeEventStreamActionKind {
		return switch value {
			case "create_stream": CreateStream;
			case "pause": Pause;
			case "resume": Resume;
			case "poll": Poll;
			case "source_event": SourceEvent;
			case "draw_event": DrawEvent;
			case "lagged_draw": LaggedDraw;
			case "flush_stale_input": FlushStaleInput;
			case "restore_terminal": RestoreTerminal;
			case "pause_stderr": PauseStderr;
			case "resume_stderr": ResumeStderr;
			case "set_modes": SetModes;
			case "leave_alt_screen": LeaveAltScreen;
			case "enter_alt_screen": EnterAltScreen;
			case _: Unknown;
		}
	}
}
