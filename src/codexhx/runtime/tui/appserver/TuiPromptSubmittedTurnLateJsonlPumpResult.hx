package codexhx.runtime.tui.appserver;

/**
	Result for reading a late JSONL batch from the persistent session and applying
	it through the submitted-turn batch handoff.
**/
class TuiPromptSubmittedTurnLateJsonlPumpResult {
	final statusValue:TuiPromptSubmittedTurnLateJsonlPumpStatus;
	final codeValue:String;
	final lineStatusValue:String;
	final lineCodeValue:String;
	final lineCountValue:Int;
	final batchStatusValue:String;
	final batchCodeValue:String;
	final streamStatusValue:String;
	final completionStatusValue:String;
	final threadIdValue:String;
	final turnIdValue:String;
	final deltaValue:String;
	final notificationCountValue:Int;
	final appliedNotificationCountValue:Int;
	final eventsQueuedValue:Int;
	final assistantDeltaCountValue:Int;
	final completionCountValue:Int;

	// Scalar constructor keeps generated Rust direct; anonymous records currently
	// lower through hxrt::anon and make this runtime result harder to inspect.
	public function new(status:TuiPromptSubmittedTurnLateJsonlPumpStatus, code:String, lineStatus:String, lineCode:String, lineCount:Int, batchStatus:String,
			batchCode:String, streamStatus:String, completionStatus:String, threadId:String, turnId:String, delta:String, notificationCount:Int,
			appliedNotificationCount:Int, eventsQueued:Int, assistantDeltaCount:Int, completionCount:Int) {
		this.statusValue = status;
		this.codeValue = normalize(code, status.text());
		this.lineStatusValue = lineStatus;
		this.lineCodeValue = lineCode;
		this.lineCountValue = nonNegative(lineCount);
		this.batchStatusValue = batchStatus;
		this.batchCodeValue = batchCode;
		this.streamStatusValue = streamStatus;
		this.completionStatusValue = completionStatus;
		this.threadIdValue = threadId;
		this.turnIdValue = turnId;
		this.deltaValue = delta;
		this.notificationCountValue = nonNegative(notificationCount);
		this.appliedNotificationCountValue = nonNegative(appliedNotificationCount);
		this.eventsQueuedValue = nonNegative(eventsQueued);
		this.assistantDeltaCountValue = nonNegative(assistantDeltaCount);
		this.completionCountValue = nonNegative(completionCount);
	}

	public static function lineRejected(lines:TuiAppServerJsonRpcLateJsonlBatch):TuiPromptSubmittedTurnLateJsonlPumpResult {
		final lineStatus = lines == null ? TuiAppServerJsonRpcTransportStatus.Rejected.text() : lines.statusText();
		final lineCode = lines == null ? "missing_late_jsonl_batch" : lines.code();
		final lineCount = lines == null ? 0 : lines.lineCount();
		return new TuiPromptSubmittedTurnLateJsonlPumpResult(TuiPromptSubmittedTurnLateJsonlPumpStatus.LineReadRejected, lineCode, lineStatus, lineCode,
			lineCount, "", "", "", "", "", "", "", 0, 0, 0, 0, 0);
	}

	public static function fromBatch(lines:TuiAppServerJsonRpcLateJsonlBatch,
			batch:TuiPromptSubmittedTurnJsonlBatchResult):TuiPromptSubmittedTurnLateJsonlPumpResult {
		final lineStatus = lines == null ? "" : lines.statusText();
		final lineCode = lines == null ? "" : lines.code();
		final lineCount = lines == null ? 0 : lines.lineCount();
		if (batch == null)
			return new TuiPromptSubmittedTurnLateJsonlPumpResult(TuiPromptSubmittedTurnLateJsonlPumpStatus.BatchRejected, "missing_batch_result", lineStatus,
				lineCode, lineCount, "", "", "", "", "", "", "", 0, 0, 0, 0, 0);
		final status = batch.acceptedBatch() ? TuiPromptSubmittedTurnLateJsonlPumpStatus.Accepted : TuiPromptSubmittedTurnLateJsonlPumpStatus.BatchRejected;
		return new TuiPromptSubmittedTurnLateJsonlPumpResult(status, batch.code(), lineStatus, lineCode, lineCount, batch.statusText(), batch.code(),
			batch.streamStatusText(), batch.completionStatusText(), batch.threadIdText(), batch.turnIdText(), batch.deltaText(), batch.notificationCount(),
			batch.appliedNotificationCount(), batch.eventsQueued(), batch.assistantDeltaCount(), batch.completionCount());
	}

	public function acceptedPump():Bool {
		return statusValue == TuiPromptSubmittedTurnLateJsonlPumpStatus.Accepted;
	}

	public function status():TuiPromptSubmittedTurnLateJsonlPumpStatus {
		return statusValue;
	}

	public function statusText():String {
		return statusValue.text();
	}

	public function code():String {
		return codeValue;
	}

	public function lineStatusText():String {
		return lineStatusValue;
	}

	public function lineCode():String {
		return lineCodeValue;
	}

	public function lineCount():Int {
		return lineCountValue;
	}

	public function batchStatusText():String {
		return batchStatusValue;
	}

	public function batchCode():String {
		return batchCodeValue;
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
