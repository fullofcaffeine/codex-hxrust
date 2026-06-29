package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;

/**
	Typed scope report for prompt stream notifications against the active
	thread/turn expected by the submitted prompt.
**/
class TuiPromptJsonRpcStreamScopeReport {
	public final status:TuiPromptJsonRpcStreamScopeStatus;
	public final expectedThreadIdText:String;
	public final expectedTurnIdText:String;
	public final actualThreadIdText:String;
	public final actualTurnIdText:String;
	public final checkedNotificationCount:Int;
	public final firstMismatchIndex:Int;

	public function new(status:TuiPromptJsonRpcStreamScopeStatus, expectedThreadIdText:String, expectedTurnIdText:String, actualThreadIdText:String,
			actualTurnIdText:String, checkedNotificationCount:Int, firstMismatchIndex:Int) {
		this.status = status;
		this.expectedThreadIdText = normalize(expectedThreadIdText);
		this.expectedTurnIdText = normalize(expectedTurnIdText);
		this.actualThreadIdText = normalize(actualThreadIdText);
		this.actualTurnIdText = normalize(actualTurnIdText);
		this.checkedNotificationCount = checkedNotificationCount < 0 ? 0 : checkedNotificationCount;
		this.firstMismatchIndex = firstMismatchIndex;
	}

	public static function fromNotifications(expectedThreadId:ThreadId, expectedTurnId:TurnId,
			notifications:Array<TuiPromptJsonRpcStreamNotification>):TuiPromptJsonRpcStreamScopeReport {
		final expectedThread = expectedThreadId == null ? "" : expectedThreadId.toString();
		final expectedTurn = expectedTurnId == null ? "" : expectedTurnId.toString();
		if (notifications == null || notifications.length == 0)
			return new TuiPromptJsonRpcStreamScopeReport(TuiPromptJsonRpcStreamScopeStatus.Empty, expectedThread, expectedTurn, "", "", 0, -1);
		var index = 0;
		for (notification in notifications) {
			final actualThread = threadIdText(notification);
			if (actualThread != expectedThread)
				return new TuiPromptJsonRpcStreamScopeReport(TuiPromptJsonRpcStreamScopeStatus.ThreadMismatch, expectedThread, expectedTurn, actualThread,
					turnIdText(notification), index + 1, index);
			final actualTurn = turnIdText(notification);
			if (actualTurn.length > 0 && actualTurn != expectedTurn)
				return new TuiPromptJsonRpcStreamScopeReport(TuiPromptJsonRpcStreamScopeStatus.TurnMismatch, expectedThread, expectedTurn, actualThread,
					actualTurn, index + 1, index);
			index = index + 1;
		}
		return new TuiPromptJsonRpcStreamScopeReport(TuiPromptJsonRpcStreamScopeStatus.Complete, expectedThread, expectedTurn, expectedThread, expectedTurn,
			notifications.length, -1);
	}

	public function isAccepted():Bool {
		final value = status.text();
		return value == TuiPromptJsonRpcStreamScopeStatus.Complete.text() || value == TuiPromptJsonRpcStreamScopeStatus.Empty.text();
	}

	public function statusText():String {
		return status.text();
	}

	public function code():String {
		return status.text();
	}

	static function threadIdText(notification:TuiPromptJsonRpcStreamNotification):String {
		return switch notification {
			case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(status):
				status.threadId.toString();
			case TuiPromptJsonRpcStreamNotification.Turn(turn):
				turn.threadId.toString();
			case TuiPromptJsonRpcStreamNotification.UserMessageCompleted(completed):
				completed.threadId.toString();
			case TuiPromptJsonRpcStreamNotification.AgentMessageStarted(started):
				started.threadId.toString();
			case TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta):
				delta.threadId.toString();
			case TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(completed):
				completed.threadId.toString();
			case TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(completed):
				completed.threadId.toString();
		}
	}

	static function turnIdText(notification:TuiPromptJsonRpcStreamNotification):String {
		return switch notification {
			case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(_):
				"";
			case TuiPromptJsonRpcStreamNotification.Turn(turn):
				turn.turn.turnId.toString();
			case TuiPromptJsonRpcStreamNotification.UserMessageCompleted(completed):
				completed.turnId.toString();
			case TuiPromptJsonRpcStreamNotification.AgentMessageStarted(started):
				started.turnId.toString();
			case TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta):
				delta.turnId.toString();
			case TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(completed):
				completed.turnId.toString();
			case TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(completed):
				completed.turnId.toString();
		}
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}
}
