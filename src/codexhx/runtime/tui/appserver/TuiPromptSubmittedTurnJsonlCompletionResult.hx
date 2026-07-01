package codexhx.runtime.tui.appserver;

/**
	Facade-level result for decoding a late JSONL turn-completion notification
	and handoff into the submitted-turn completion path.
**/
class TuiPromptSubmittedTurnJsonlCompletionResult {
	final statusValue:TuiPromptSubmittedTurnJsonlCompletionStatus;
	final codeValue:String;
	final completionStatusValue:String;
	final threadIdValue:String;
	final turnIdValue:String;
	final eventsQueuedValue:Int;
	final lineCountValue:Int;
	final notificationCountValue:Int;

	public function new(status:TuiPromptSubmittedTurnJsonlCompletionStatus, code:String, completionStatus:String, threadId:String, turnId:String,
			eventsQueued:Int, lineCount:Int, notificationCount:Int) {
		this.statusValue = status;
		this.codeValue = normalize(code, status.text());
		this.completionStatusValue = completionStatus == null ? "" : completionStatus;
		this.threadIdValue = threadId == null ? "" : threadId;
		this.turnIdValue = turnId == null ? "" : turnId;
		this.eventsQueuedValue = eventsQueued < 0 ? 0 : eventsQueued;
		this.lineCountValue = lineCount < 0 ? 0 : lineCount;
		this.notificationCountValue = notificationCount < 0 ? 0 : notificationCount;
	}

	public static function accepted(completion:TuiPromptSubmittedTurnCompletionResult, lineCount:Int,
			notificationCount:Int):TuiPromptSubmittedTurnJsonlCompletionResult {
		return fromCompletion(TuiPromptSubmittedTurnJsonlCompletionStatus.Accepted, "accepted", completion, lineCount, notificationCount);
	}

	public static function rejected(status:TuiPromptSubmittedTurnJsonlCompletionStatus, code:String, lineCount:Int,
			notificationCount:Int):TuiPromptSubmittedTurnJsonlCompletionResult {
		return new TuiPromptSubmittedTurnJsonlCompletionResult(status, code, "", "", "", 0, lineCount, notificationCount);
	}

	public static function rejectedWithCompletion(status:TuiPromptSubmittedTurnJsonlCompletionStatus, code:String,
			completion:TuiPromptSubmittedTurnCompletionResult, lineCount:Int, notificationCount:Int):TuiPromptSubmittedTurnJsonlCompletionResult {
		return fromCompletion(status, code, completion, lineCount, notificationCount);
	}

	public function acceptedCompletion():Bool {
		return statusValue == TuiPromptSubmittedTurnJsonlCompletionStatus.Accepted;
	}

	public function status():TuiPromptSubmittedTurnJsonlCompletionStatus {
		return statusValue;
	}

	public function statusText():String {
		return statusValue.text();
	}

	public function code():String {
		return codeValue;
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

	public function eventsQueued():Int {
		return eventsQueuedValue;
	}

	public function lineCount():Int {
		return lineCountValue;
	}

	public function notificationCount():Int {
		return notificationCountValue;
	}

	static function normalize(value:String, fallback:String):String {
		return value == null || value.length == 0 ? fallback : value;
	}

	static function fromCompletion(status:TuiPromptSubmittedTurnJsonlCompletionStatus, code:String, completion:TuiPromptSubmittedTurnCompletionResult,
			lineCount:Int, notificationCount:Int):TuiPromptSubmittedTurnJsonlCompletionResult {
		return new TuiPromptSubmittedTurnJsonlCompletionResult(status, code, completion.statusText(), completion.threadIdText(), completion.turnIdText(),
			completion.eventsQueued(), lineCount, notificationCount);
	}
}
