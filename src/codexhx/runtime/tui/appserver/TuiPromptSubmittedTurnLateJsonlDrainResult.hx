package codexhx.runtime.tui.appserver;

/**
	Typed aggregate for a bounded persistent-session drain of late submitted-turn
	JSONL batches.
**/
class TuiPromptSubmittedTurnLateJsonlDrainResult {
	final statusValue:TuiPromptSubmittedTurnLateJsonlDrainStatus;
	final codeValue:String;
	final attemptedBatchCountValue:Int;
	final acceptedBatchCountValue:Int;
	final lineCountValue:Int;
	final notificationCountValue:Int;
	final appliedNotificationCountValue:Int;
	final eventsQueuedValue:Int;
	final assistantDeltaCountValue:Int;
	final completionCountValue:Int;
	final stopPumpStatusValue:String;
	final stopPumpCodeValue:String;
	final stopLineStatusValue:String;
	final stopLineCodeValue:String;
	final stopBatchStatusValue:String;
	final stopBatchCodeValue:String;
	final threadIdValue:String;
	final turnIdValue:String;
	final deltaValue:String;

	// Scalar constructor keeps this generated Rust review surface away from
	// anonymous-record lowering while haxe.rust still routes those through hxrt.
	public function new(status:TuiPromptSubmittedTurnLateJsonlDrainStatus, code:String, attemptedBatchCount:Int, acceptedBatchCount:Int, lineCount:Int,
			notificationCount:Int, appliedNotificationCount:Int, eventsQueued:Int, assistantDeltaCount:Int, completionCount:Int, stopPumpStatus:String,
			stopPumpCode:String, stopLineStatus:String, stopLineCode:String, stopBatchStatus:String, stopBatchCode:String, threadId:String, turnId:String,
			delta:String) {
		this.statusValue = status;
		this.codeValue = normalize(code, status.text());
		this.attemptedBatchCountValue = nonNegative(attemptedBatchCount);
		this.acceptedBatchCountValue = nonNegative(acceptedBatchCount);
		this.lineCountValue = nonNegative(lineCount);
		this.notificationCountValue = nonNegative(notificationCount);
		this.appliedNotificationCountValue = nonNegative(appliedNotificationCount);
		this.eventsQueuedValue = nonNegative(eventsQueued);
		this.assistantDeltaCountValue = nonNegative(assistantDeltaCount);
		this.completionCountValue = nonNegative(completionCount);
		this.stopPumpStatusValue = normalize(stopPumpStatus, "");
		this.stopPumpCodeValue = normalize(stopPumpCode, "");
		this.stopLineStatusValue = normalize(stopLineStatus, "");
		this.stopLineCodeValue = normalize(stopLineCode, "");
		this.stopBatchStatusValue = normalize(stopBatchStatus, "");
		this.stopBatchCodeValue = normalize(stopBatchCode, "");
		this.threadIdValue = normalize(threadId, "");
		this.turnIdValue = normalize(turnId, "");
		this.deltaValue = normalize(delta, "");
	}

	public static function invalid(code:String):TuiPromptSubmittedTurnLateJsonlDrainResult {
		return new TuiPromptSubmittedTurnLateJsonlDrainResult(TuiPromptSubmittedTurnLateJsonlDrainStatus.InvalidLimit, code, 0, 0, 0, 0, 0, 0, 0, 0, "", "",
			"", "", "", "", "", "", "");
	}

	public function completedDrain():Bool {
		return statusValue == TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed;
	}

	public function status():TuiPromptSubmittedTurnLateJsonlDrainStatus {
		return statusValue;
	}

	public function statusText():String {
		return statusValue.text();
	}

	public function code():String {
		return codeValue;
	}

	public function attemptedBatchCount():Int {
		return attemptedBatchCountValue;
	}

	public function acceptedBatchCount():Int {
		return acceptedBatchCountValue;
	}

	public function lineCount():Int {
		return lineCountValue;
	}

	public function notificationCount():Int {
		return notificationCountValue;
	}

	public function appliedNotificationCount():Int {
		return appliedNotificationCountValue;
	}

	public function eventsQueued():Int {
		return eventsQueuedValue;
	}

	public function assistantDeltaCount():Int {
		return assistantDeltaCountValue;
	}

	public function completionCount():Int {
		return completionCountValue;
	}

	public function stopPumpStatusText():String {
		return stopPumpStatusValue;
	}

	public function stopPumpCode():String {
		return stopPumpCodeValue;
	}

	public function stopLineStatusText():String {
		return stopLineStatusValue;
	}

	public function stopLineCode():String {
		return stopLineCodeValue;
	}

	public function stopBatchStatusText():String {
		return stopBatchStatusValue;
	}

	public function stopBatchCode():String {
		return stopBatchCodeValue;
	}

	public function threadIdText():String {
		return threadIdValue;
	}

	public function turnIdText():String {
		return turnIdValue;
	}

	public function deltaText():String {
		return deltaValue;
	}

	static function normalize(value:String, fallback:String):String {
		return value == null || value.length == 0 ? fallback : value;
	}

	static function nonNegative(value:Int):Int {
		return value < 0 ? 0 : value;
	}
}
