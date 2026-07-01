package codexhx.runtime.tui.appserver;

/**
	Facade-level result for applying an ordered late JSONL notification batch to
	a submitted turn.
**/
class TuiPromptSubmittedTurnJsonlBatchResult {
	final statusValue:TuiPromptSubmittedTurnJsonlBatchStatus;
	final codeValue:String;
	final streamStatusValue:String;
	final completionStatusValue:String;
	final threadIdValue:String;
	final turnIdValue:String;
	final deltaValue:String;
	final lineCountValue:Int;
	final notificationCountValue:Int;
	final appliedNotificationCountValue:Int;
	final eventsQueuedValue:Int;
	final assistantDeltaCountValue:Int;
	final completionCountValue:Int;

	// This result uses a scalar constructor instead of a Haxe anonymous field
	// record because haxe.rust currently lowers anonymous records through
	// hxrt::anon; this DTO is part of the generated Rust review surface.
	public function new(status:TuiPromptSubmittedTurnJsonlBatchStatus, code:String, streamStatus:String, completionStatus:String, threadId:String,
			turnId:String, delta:String, lineCount:Int, notificationCount:Int, appliedNotificationCount:Int, eventsQueued:Int, assistantDeltaCount:Int,
			completionCount:Int) {
		this.statusValue = status;
		this.codeValue = normalize(code, status.text());
		this.streamStatusValue = streamStatus;
		this.completionStatusValue = completionStatus;
		this.threadIdValue = threadId;
		this.turnIdValue = turnId;
		this.deltaValue = delta;
		this.lineCountValue = nonNegative(lineCount);
		this.notificationCountValue = nonNegative(notificationCount);
		this.appliedNotificationCountValue = nonNegative(appliedNotificationCount);
		this.eventsQueuedValue = nonNegative(eventsQueued);
		this.assistantDeltaCountValue = nonNegative(assistantDeltaCount);
		this.completionCountValue = nonNegative(completionCount);
	}

	public function acceptedBatch():Bool {
		return statusValue == TuiPromptSubmittedTurnJsonlBatchStatus.Accepted;
	}

	public function status():TuiPromptSubmittedTurnJsonlBatchStatus {
		return statusValue;
	}

	public function statusText():String {
		return statusValue.text();
	}

	public function code():String {
		return codeValue;
	}

	public function streamStatusText():String {
		return streamStatusValue;
	}

	public function completionStatusText():String {
		return completionStatusValue;
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

	static function normalize(value:String, fallback:String):String {
		return value == null || value.length == 0 ? fallback : value;
	}

	static function nonNegative(value:Int):Int {
		return value < 0 ? 0 : value;
	}
}
