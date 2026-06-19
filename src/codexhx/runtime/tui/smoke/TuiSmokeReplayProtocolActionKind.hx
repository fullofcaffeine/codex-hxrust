package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeReplayProtocolActionKind(String) to String {
	final ReplayTurn = "replay_turn";
	final ReplayItem = "replay_item";
	final ServerNotification = "server_notification";
	final TurnCompleted = "turn_completed";
	final ErrorNotification = "error_notification";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeReplayProtocolActionKind {
		return switch value {
			case "replay_turn": ReplayTurn;
			case "replay_item": ReplayItem;
			case "server_notification": ServerNotification;
			case "turn_completed": TurnCompleted;
			case "error_notification": ErrorNotification;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
