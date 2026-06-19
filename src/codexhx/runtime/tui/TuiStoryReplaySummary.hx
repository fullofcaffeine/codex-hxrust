package codexhx.runtime.tui;

class TuiStoryReplaySummary {
	public var records:Int;
	public var sessionStarts:Int;
	public var sessionEnds:Int;
	public var appEvents:Int;
	public var keyEvents:Int;
	public var codexEvents:Int;
	public var insertHistoryEvents:Int;
	public var operations:Int;
	public var insertedLines:Int;
	public var taskStarted:Int;
	public var taskCompleted:Int;
	public var agentMessageDeltaCount:Int;
	public var reasoningDeltaCount:Int;
	public var shutdownComplete:Int;
	public var typedText:String;
	public var assistantPreview:String;
	public var reasoningPreview:String;
	public var variants:Array<String>;
	public var codexTypes:Array<String>;

	public function new() {
		records = 0;
		sessionStarts = 0;
		sessionEnds = 0;
		appEvents = 0;
		keyEvents = 0;
		codexEvents = 0;
		insertHistoryEvents = 0;
		operations = 0;
		insertedLines = 0;
		taskStarted = 0;
		taskCompleted = 0;
		agentMessageDeltaCount = 0;
		reasoningDeltaCount = 0;
		shutdownComplete = 0;
		typedText = "";
		assistantPreview = "";
		reasoningPreview = "";
		variants = [];
		codexTypes = [];
	}

	public function add(record:TuiStoryRecord):Void {
		records = records + 1;
		switch record.kind {
			case TuiStoryKind.SessionStart:
				sessionStarts = sessionStarts + 1;
			case TuiStoryKind.SessionEnd:
				sessionEnds = sessionEnds + 1;
			case TuiStoryKind.AppEvent:
				appEvents = appEvents + 1;
				addUnique(variants, record.appVariant);
			case TuiStoryKind.KeyEvent:
				keyEvents = keyEvents + 1;
				if (record.keyEvent != null)
					typedText = typedText + record.keyEvent.typedCharacter();
			case TuiStoryKind.CodexEvent:
				codexEvents = codexEvents + 1;
				addUnique(codexTypes, record.codexEventType);
				switch record.codexEventType {
					case CodexStoryMessageType.TaskStarted:
						taskStarted = taskStarted + 1;
					case CodexStoryMessageType.TaskComplete:
						taskCompleted = taskCompleted + 1;
					case CodexStoryMessageType.AgentMessageDelta:
						agentMessageDeltaCount = agentMessageDeltaCount + 1;
						assistantPreview = assistantPreview + record.textDelta;
					case CodexStoryMessageType.AgentReasoningRawContentDelta:
						reasoningDeltaCount = reasoningDeltaCount + 1;
						reasoningPreview = reasoningPreview + record.textDelta;
					case CodexStoryMessageType.ShutdownComplete:
						shutdownComplete = shutdownComplete + 1;
					case _:
				}
			case TuiStoryKind.InsertHistory:
				insertHistoryEvents = insertHistoryEvents + 1;
				insertedLines = insertedLines + record.historyLines;
			case TuiStoryKind.Operation:
				operations = operations + 1;
			case _:
		}
	}

	public function fingerprint():String {
		return "records=" + Std.string(records) + "|sessions=" + Std.string(sessionStarts) + "/" + Std.string(sessionEnds) + "|app=" + Std.string(appEvents)
			+ ":" + variants.join(",") + "|keys=" + Std.string(keyEvents) + ":" + escapeText(typedText) + "|codex=" + Std.string(codexEvents) + ":"
			+ codexTypes.join(",") + "|history=" + Std.string(insertHistoryEvents) + "/" + Std.string(insertedLines) + "|tasks=" + Std.string(taskStarted)
			+ "/" + Std.string(taskCompleted) + "|deltas=" + Std.string(agentMessageDeltaCount) + "/" + Std.string(reasoningDeltaCount) + "|assistant="
			+ escapeText(assistantPreview) + "|reasoning=" + escapeText(reasoningPreview) + "|ops=" + Std.string(operations) + "|shutdown="
			+ Std.string(shutdownComplete);
	}

	static function addUnique(values:Array<String>, value:String):Void {
		if (value == "")
			return;
		for (existing in values) {
			if (existing == value)
				return;
		}
		values.push(value);
	}

	static function escapeText(value:String):String {
		return StringTools.replace(value, "\n", "\\n");
	}
}
