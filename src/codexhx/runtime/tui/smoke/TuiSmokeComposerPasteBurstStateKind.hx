package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerPasteBurstStateKind(String) to String {
	final Inactive = "inactive";
	final PendingFirstChar = "pending_first_char";
	final Buffering = "buffering";
	final FlushDue = "flush_due";
	final Flushed = "flushed";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerPasteBurstStateKind {
		return switch value {
			case "inactive": Inactive;
			case "pending_first_char": PendingFirstChar;
			case "buffering": Buffering;
			case "flush_due": FlushDue;
			case "flushed": Flushed;
			case _: Unknown;
		}
	}
}
