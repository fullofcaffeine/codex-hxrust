package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeFileMentionPopupActionKind(String) to String {
	final Sync = "sync";
	final ActivateFile = "activate_file";
	final FileSearchStart = "file_search_start";
	final FileSearchResult = "file_search_result";
	final MoveSelection = "move_selection";
	final InsertFile = "insert_file";
	final DismissFile = "dismiss_file";
	final ActivateMention = "activate_mention";
	final SwitchMentionMode = "switch_mention_mode";
	final InsertMention = "insert_mention";
	final DismissMention = "dismiss_mention";
	final ClearQuery = "clear_query";
	final Hide = "hide";
	final SuppressSlash = "suppress_slash";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeFileMentionPopupActionKind {
		return switch value {
			case "sync": Sync;
			case "activate_file": ActivateFile;
			case "file_search_start": FileSearchStart;
			case "file_search_result": FileSearchResult;
			case "move_selection": MoveSelection;
			case "insert_file": InsertFile;
			case "dismiss_file": DismissFile;
			case "activate_mention": ActivateMention;
			case "switch_mention_mode": SwitchMentionMode;
			case "insert_mention": InsertMention;
			case "dismiss_mention": DismissMention;
			case "clear_query": ClearQuery;
			case "hide": Hide;
			case "suppress_slash": SuppressSlash;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
