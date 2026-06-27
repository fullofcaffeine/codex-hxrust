package codexhx.runtime.tui.smoke;

enum abstract TuiSmokePasteBurstActionKind(String) to String {
	final AsciiHoldFlush = "ascii_hold_flush";
	final AsciiFastBufferFlush = "ascii_fast_buffer_flush";
	final FlushBeforeModified = "flush_before_modified";
	final RetroDecision = "retro_decision";
	final SuppressionWindow = "suppression_window";
	final DirectInsertWindow = "direct_insert_window";
	final ActiveAppendClear = "active_append_clear";
	final NoHoldPath = "no_hold_path";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokePasteBurstActionKind {
		return switch value {
			case "ascii_hold_flush": AsciiHoldFlush;
			case "ascii_fast_buffer_flush": AsciiFastBufferFlush;
			case "flush_before_modified": FlushBeforeModified;
			case "retro_decision": RetroDecision;
			case "suppression_window": SuppressionWindow;
			case "direct_insert_window": DirectInsertWindow;
			case "active_append_clear": ActiveAppendClear;
			case "no_hold_path": NoHoldPath;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
