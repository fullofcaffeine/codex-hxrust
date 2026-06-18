package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSlashPopupCompletionKind(String) to String {
	final Text = "text";
	final InlineArgs = "inline_args";
	final ImmediateDispatch = "immediate_dispatch";
	final Queue = "queue";
	final None = "none";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSlashPopupCompletionKind {
		return switch value {
			case "text": Text;
			case "inline_args": InlineArgs;
			case "immediate_dispatch": ImmediateDispatch;
			case "queue": Queue;
			case "none": None;
			case _: Unknown;
		}
	}
}
