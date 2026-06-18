package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerPopupSyncActionKind(String) to String {
	final Sync = "sync";
	final HistorySearchSuppress = "history_search_suppress";
	final PopupsDisabled = "popups_disabled";
	final HistoryNavigationSuppress = "history_navigation_suppress";
	final CommandPopup = "command_popup";
	final FileSearchPopup = "file_search_popup";
	final MentionPopup = "mention_popup";
	final MentionsV2Popup = "mentions_v2_popup";
	final ClearFileSearch = "clear_file_search";
	final DismissedToken = "dismissed_token";
	final ClearInactivePopup = "clear_inactive_popup";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerPopupSyncActionKind {
		return switch value {
			case "sync": Sync;
			case "history_search_suppress": HistorySearchSuppress;
			case "popups_disabled": PopupsDisabled;
			case "history_navigation_suppress": HistoryNavigationSuppress;
			case "command_popup": CommandPopup;
			case "file_search_popup": FileSearchPopup;
			case "mention_popup": MentionPopup;
			case "mentions_v2_popup": MentionsV2Popup;
			case "clear_file_search": ClearFileSearch;
			case "dismissed_token": DismissedToken;
			case "clear_inactive_popup": ClearInactivePopup;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
