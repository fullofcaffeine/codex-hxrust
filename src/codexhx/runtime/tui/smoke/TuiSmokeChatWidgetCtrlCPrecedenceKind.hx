package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetCtrlCPrecedenceKind(String) to String {
	final RealtimeStop = "realtime_stop";
	final BottomPaneModal = "bottom_pane_modal";
	final BottomPaneHistorySearch = "bottom_pane_history_search";
	final BottomPaneComposerClear = "bottom_pane_composer_clear";
	final DisabledInterrupt = "disabled_interrupt";
	final DisabledQuit = "disabled_quit";
	final EnabledShortcutMatch = "enabled_shortcut_match";
	final EnabledArmAndInterrupt = "enabled_arm_and_interrupt";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetCtrlCPrecedenceKind {
		return switch value {
			case "realtime_stop": RealtimeStop;
			case "bottom_pane_modal": BottomPaneModal;
			case "bottom_pane_history_search": BottomPaneHistorySearch;
			case "bottom_pane_composer_clear": BottomPaneComposerClear;
			case "disabled_interrupt": DisabledInterrupt;
			case "disabled_quit": DisabledQuit;
			case "enabled_shortcut_match": EnabledShortcutMatch;
			case "enabled_arm_and_interrupt": EnabledArmAndInterrupt;
			case _: Unknown;
		}
	}
}
