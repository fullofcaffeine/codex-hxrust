package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;

/**
	Facade-level outcome for delivering late assistant stream evidence.
**/
class TuiPromptSubmittedTurnStreamDeliveryResult {
	final statusValue:TuiPromptSubmittedTurnStreamDeliveryStatus;
	final threadIdValue:ThreadId;
	final turnIdValue:TurnId;
	final deltaValue:String;
	final eventsQueuedValue:Int;

	public function new(status:TuiPromptSubmittedTurnStreamDeliveryStatus, threadId:ThreadId, turnId:TurnId, delta:String, eventsQueued:Int) {
		this.statusValue = status;
		this.threadIdValue = threadId;
		this.turnIdValue = turnId;
		this.deltaValue = delta == null ? "" : delta;
		this.eventsQueuedValue = eventsQueued < 0 ? 0 : eventsQueued;
	}

	public static function accepted(threadId:ThreadId, turnId:TurnId, delta:String, eventsQueued:Int):TuiPromptSubmittedTurnStreamDeliveryResult {
		return new TuiPromptSubmittedTurnStreamDeliveryResult(TuiPromptSubmittedTurnStreamDeliveryStatus.Accepted, threadId, turnId, delta, eventsQueued);
	}

	public static function rejected(status:TuiPromptSubmittedTurnStreamDeliveryStatus, threadId:ThreadId, turnId:TurnId,
			delta:String):TuiPromptSubmittedTurnStreamDeliveryResult {
		return new TuiPromptSubmittedTurnStreamDeliveryResult(status, threadId, turnId, delta, 0);
	}

	public function acceptedDelivery():Bool {
		return statusValue == TuiPromptSubmittedTurnStreamDeliveryStatus.Accepted;
	}

	public function status():TuiPromptSubmittedTurnStreamDeliveryStatus {
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

	public function deltaText():String {
		return deltaValue;
	}

	public function eventsQueued():Int {
		return eventsQueuedValue;
	}
}
