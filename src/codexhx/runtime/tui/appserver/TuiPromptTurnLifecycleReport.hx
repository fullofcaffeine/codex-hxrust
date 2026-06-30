package codexhx.runtime.tui.appserver;

import codexhx.protocol.TurnId;

/**
	Typed lifecycle report for the selected prompt turn in stream notifications.
**/
class TuiPromptTurnLifecycleReport {
	public final status:TuiPromptTurnLifecycleStatus;
	public final expectedTurnIdText:String;
	public final startedTurnIdText:String;
	public final completedTurnIdText:String;
	public final checkedNotificationCount:Int;
	public final startedCount:Int;
	public final completedCount:Int;

	public function new(status:TuiPromptTurnLifecycleStatus, expectedTurnIdText:String, startedTurnIdText:String, completedTurnIdText:String,
			checkedNotificationCount:Int, startedCount:Int, completedCount:Int) {
		this.status = status;
		this.expectedTurnIdText = normalize(expectedTurnIdText);
		this.startedTurnIdText = normalize(startedTurnIdText);
		this.completedTurnIdText = normalize(completedTurnIdText);
		this.checkedNotificationCount = checkedNotificationCount < 0 ? 0 : checkedNotificationCount;
		this.startedCount = startedCount < 0 ? 0 : startedCount;
		this.completedCount = completedCount < 0 ? 0 : completedCount;
	}

	public static function fromNotifications(expectedTurnId:TurnId, notifications:Array<TuiPromptJsonRpcStreamNotification>):TuiPromptTurnLifecycleReport {
		final expectedTurn = expectedTurnId == null ? "" : expectedTurnId.toString();
		var checked = 0;
		var started = 0;
		var completed = 0;
		var startedTurn = "";
		var completedTurn = "";
		if (notifications != null) {
			for (notification in notifications) {
				checked = checked + 1;
				switch notification {
					case TuiPromptJsonRpcStreamNotification.Turn(turn):
						if (turn.turn.turnId.toString() == expectedTurn) {
							if (turn.method == TuiPromptJsonRpcNotificationMethod.TurnStarted) {
								started = started + 1;
								startedTurn = turn.turn.turnId.toString();
							}
							if (turn.method == TuiPromptJsonRpcNotificationMethod.TurnCompleted) {
								completed = completed + 1;
								completedTurn = turn.turn.turnId.toString();
							}
						}
					case _:
				}
			}
		}
		return new TuiPromptTurnLifecycleReport(statusFor(started, completed), expectedTurn, startedTurn, completedTurn, checked, started, completed);
	}

	public function isComplete():Bool {
		return status == TuiPromptTurnLifecycleStatus.Complete;
	}

	public function isSubmitted():Bool {
		return status == TuiPromptTurnLifecycleStatus.MissingCompleted && startedCount > 0 && completedCount == 0;
	}

	public function statusText():String {
		return status.text();
	}

	public function code():String {
		return status.text();
	}

	static function statusFor(started:Int, completed:Int):TuiPromptTurnLifecycleStatus {
		if (started > 0 && completed > 0)
			return TuiPromptTurnLifecycleStatus.Complete;
		if (started > 0)
			return TuiPromptTurnLifecycleStatus.MissingCompleted;
		if (completed > 0)
			return TuiPromptTurnLifecycleStatus.MissingStarted;
		return TuiPromptTurnLifecycleStatus.MissingStartedAndCompleted;
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}
}
