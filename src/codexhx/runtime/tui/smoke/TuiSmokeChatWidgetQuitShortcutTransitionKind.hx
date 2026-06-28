package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetQuitShortcutTransitionKind(String) to String {
	final Arm = "arm";
	final Match = "match";
	final Replace = "replace";
	final ClearUnrelatedPress = "clear_unrelated_press";
	final ClearReasoningShortcut = "clear_reasoning_shortcut";
	final ClearCopyShortcut = "clear_copy_shortcut";
	final Expired = "expired";
	final RequestQuit = "request_quit";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetQuitShortcutTransitionKind {
		return switch value {
			case "arm": Arm;
			case "match": Match;
			case "replace": Replace;
			case "clear_unrelated_press": ClearUnrelatedPress;
			case "clear_reasoning_shortcut": ClearReasoningShortcut;
			case "clear_copy_shortcut": ClearCopyShortcut;
			case "expired": Expired;
			case "request_quit": RequestQuit;
			case _: Unknown;
		}
	}
}
