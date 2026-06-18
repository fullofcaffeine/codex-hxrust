package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSideConversationActionKind(String) to String {
	final SyncUi = "sync_ui";
	final StartBlock = "start_block";
	final ForkThread = "fork_thread";
	final InjectBoundary = "inject_boundary";
	final SwitchThread = "switch_thread";
	final ParentStatusChange = "parent_status_change";
	final MaybeReturn = "maybe_return";
	final RestoreUserMessage = "restore_user_message";
	final DiscardSide = "discard_side";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSideConversationActionKind {
		return switch value {
			case "sync_ui": SyncUi;
			case "start_block": StartBlock;
			case "fork_thread": ForkThread;
			case "inject_boundary": InjectBoundary;
			case "switch_thread": SwitchThread;
			case "parent_status_change": ParentStatusChange;
			case "maybe_return": MaybeReturn;
			case "restore_user_message": RestoreUserMessage;
			case "discard_side": DiscardSide;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
