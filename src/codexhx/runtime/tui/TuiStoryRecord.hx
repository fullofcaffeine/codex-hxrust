package codexhx.runtime.tui;

class TuiStoryRecord {
	public final lineNumber:Int;
	public final direction:TuiStoryDirection;
	public final kind:TuiStoryKind;
	public final normalizedTime:String;
	public final appVariant:String;
	public final keyEvent:TuiStoryKeyEvent;
	public final codexEventType:CodexStoryMessageType;
	public final textDelta:String;
	public final historyLines:Int;
	public final operationType:String;
	public final sourceId:String;

	public function new(lineNumber:Int, direction:TuiStoryDirection, kind:TuiStoryKind, normalizedTime:String, appVariant:String, keyEvent:TuiStoryKeyEvent,
			codexEventType:CodexStoryMessageType, textDelta:String, historyLines:Int, operationType:String, sourceId:String) {
		this.lineNumber = lineNumber;
		this.direction = direction;
		this.kind = kind;
		this.normalizedTime = normalizedTime;
		this.appVariant = appVariant;
		this.keyEvent = keyEvent;
		this.codexEventType = codexEventType;
		this.textDelta = textDelta;
		this.historyLines = historyLines;
		this.operationType = operationType;
		this.sourceId = sourceId;
	}

	public function summary():String {
		return Std.string(lineNumber) + ":" + direction + ":" + kind + ":" + normalizedTime + ":" + appVariant + ":" + keySummary() + ":" + codexEventType
			+ ":" + textDelta + ":" + Std.string(historyLines) + ":" + operationType + ":" + sourceId;
	}

	function keySummary():String {
		if (keyEvent == null)
			return "";
		return keyEvent.summary();
	}
}
