package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;

/**
	Facade-level outcome for delivering delayed submitted-turn completion evidence.
**/
class TuiPromptSubmittedTurnCompletionResult {
	final statusValue:TuiPromptSubmittedTurnCompletionStatus;
	final threadIdValue:ThreadId;
	final turnIdValue:TurnId;
	final eventsQueuedValue:Int;

	public function new(status:TuiPromptSubmittedTurnCompletionStatus, threadId:ThreadId, turnId:TurnId, eventsQueued:Int) {
		this.statusValue = status;
		this.threadIdValue = threadId;
		this.turnIdValue = turnId;
		this.eventsQueuedValue = eventsQueued < 0 ? 0 : eventsQueued;
	}

	public static function accepted(threadId:ThreadId, turnId:TurnId, eventsQueued:Int):TuiPromptSubmittedTurnCompletionResult {
		return new TuiPromptSubmittedTurnCompletionResult(TuiPromptSubmittedTurnCompletionStatus.Accepted, threadId, turnId, eventsQueued);
	}

	public static function rejected(status:TuiPromptSubmittedTurnCompletionStatus, threadId:ThreadId, turnId:TurnId):TuiPromptSubmittedTurnCompletionResult {
		return new TuiPromptSubmittedTurnCompletionResult(status, threadId, turnId, 0);
	}

	public function acceptedCompletion():Bool {
		return statusValue == TuiPromptSubmittedTurnCompletionStatus.Accepted;
	}

	public function status():TuiPromptSubmittedTurnCompletionStatus {
		return statusValue;
	}

	public function statusText():String {
		return statusValue.text();
	}

	public function threadIdText():String {
		return threadIdValue.toString();
	}

	public function turnIdText():String {
		return turnIdValue.toString();
	}

	public function eventsQueued():Int {
		return eventsQueuedValue;
	}
}
