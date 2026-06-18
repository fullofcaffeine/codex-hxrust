package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerFooterModeKind(String) to String {
	final ComposerEmpty = "composer_empty";
	final ComposerHasDraft = "composer_has_draft";
	final HistorySearch = "history_search";
	final QuitShortcutReminder = "quit_shortcut_reminder";
	final ShortcutOverlay = "shortcut_overlay";
	final EscHint = "esc_hint";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerFooterModeKind {
		return switch value {
			case "composer_empty": ComposerEmpty;
			case "composer_has_draft": ComposerHasDraft;
			case "history_search": HistorySearch;
			case "quit_shortcut_reminder": QuitShortcutReminder;
			case "shortcut_overlay": ShortcutOverlay;
			case "esc_hint": EscHint;
			case _: Unknown;
		}
	}
}
