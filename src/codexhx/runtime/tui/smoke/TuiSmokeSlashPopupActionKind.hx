package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSlashPopupActionKind(String) to String {
	final Sync = "sync";
	final Activate = "activate";
	final Render = "render";
	final Filter = "filter";
	final MoveSelection = "move_selection";
	final Complete = "complete";
	final Dispatch = "dispatch";
	final InlineDispatch = "inline_dispatch";
	final StageHistory = "stage_history";
	final Queue = "queue";
	final Elementize = "elementize";
	final RejectUnavailable = "reject_unavailable";
	final Dismiss = "dismiss";
	final Hide = "hide";
	final SuppressInterrupt = "suppress_interrupt";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSlashPopupActionKind {
		return switch value {
			case "sync": Sync;
			case "activate": Activate;
			case "render": Render;
			case "filter": Filter;
			case "move_selection": MoveSelection;
			case "complete": Complete;
			case "dispatch": Dispatch;
			case "inline_dispatch": InlineDispatch;
			case "stage_history": StageHistory;
			case "queue": Queue;
			case "elementize": Elementize;
			case "reject_unavailable": RejectUnavailable;
			case "dismiss": Dismiss;
			case "hide": Hide;
			case "suppress_interrupt": SuppressInterrupt;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
