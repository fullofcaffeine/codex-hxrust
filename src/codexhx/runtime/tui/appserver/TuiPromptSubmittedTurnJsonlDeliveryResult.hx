package codexhx.runtime.tui.appserver;

/**
	Facade-level result for decoding a late JSONL stream notification and
	handoff into the submitted-turn stream delivery path.
**/
class TuiPromptSubmittedTurnJsonlDeliveryResult {
	final statusValue:TuiPromptSubmittedTurnJsonlDeliveryStatus;
	final codeValue:String;
	final streamStatusValue:String;
	final threadIdValue:String;
	final turnIdValue:String;
	final deltaValue:String;
	final eventsQueuedValue:Int;
	final lineCountValue:Int;
	final notificationCountValue:Int;

	public function new(status:TuiPromptSubmittedTurnJsonlDeliveryStatus, code:String, streamStatus:String, threadId:String, turnId:String, delta:String,
			eventsQueued:Int, lineCount:Int, notificationCount:Int) {
		this.statusValue = status;
		this.codeValue = normalize(code, status.text());
		this.streamStatusValue = streamStatus == null ? "" : streamStatus;
		this.threadIdValue = threadId == null ? "" : threadId;
		this.turnIdValue = turnId == null ? "" : turnId;
		this.deltaValue = delta == null ? "" : delta;
		this.eventsQueuedValue = eventsQueued < 0 ? 0 : eventsQueued;
		this.lineCountValue = lineCount < 0 ? 0 : lineCount;
		this.notificationCountValue = notificationCount < 0 ? 0 : notificationCount;
	}

	public static function accepted(delivery:TuiPromptSubmittedTurnStreamDeliveryResult, lineCount:Int,
			notificationCount:Int):TuiPromptSubmittedTurnJsonlDeliveryResult {
		return fromDelivery(TuiPromptSubmittedTurnJsonlDeliveryStatus.Accepted, "accepted", delivery, lineCount, notificationCount);
	}

	public static function rejected(status:TuiPromptSubmittedTurnJsonlDeliveryStatus, code:String, lineCount:Int,
			notificationCount:Int):TuiPromptSubmittedTurnJsonlDeliveryResult {
		return new TuiPromptSubmittedTurnJsonlDeliveryResult(status, code, "", "", "", "", 0, lineCount, notificationCount);
	}

	public static function rejectedWithDelivery(status:TuiPromptSubmittedTurnJsonlDeliveryStatus, code:String,
			delivery:TuiPromptSubmittedTurnStreamDeliveryResult, lineCount:Int, notificationCount:Int):TuiPromptSubmittedTurnJsonlDeliveryResult {
		return fromDelivery(status, code, delivery, lineCount, notificationCount);
	}

	public function acceptedDelivery():Bool {
		return statusValue == TuiPromptSubmittedTurnJsonlDeliveryStatus.Accepted;
	}

	public function status():TuiPromptSubmittedTurnJsonlDeliveryStatus {
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

	public function threadIdText():String {
		return threadIdValue;
	}

	public function turnIdText():String {
		return turnIdValue;
	}

	public function deltaText():String {
		return deltaValue;
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

	static function fromDelivery(status:TuiPromptSubmittedTurnJsonlDeliveryStatus, code:String, delivery:TuiPromptSubmittedTurnStreamDeliveryResult,
			lineCount:Int, notificationCount:Int):TuiPromptSubmittedTurnJsonlDeliveryResult {
		return new TuiPromptSubmittedTurnJsonlDeliveryResult(status, code, delivery.statusText(), delivery.threadIdText(), delivery.turnIdText(),
			delivery.deltaText(), delivery.eventsQueued(), lineCount, notificationCount);
	}
}
