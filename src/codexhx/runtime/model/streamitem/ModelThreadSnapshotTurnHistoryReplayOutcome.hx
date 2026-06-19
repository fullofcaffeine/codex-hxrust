package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotTurnHistoryReplayOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final replayKind:ModelTurnReplayKind;
	final decisionKind:ModelThreadSnapshotTurnHistoryDecisionKind;
	final turnCount:Int;
	final replayedItemCount:Int;
	final userMessageCount:Int;
	final agentMessageCount:Int;
	final terminalTurnCompletedNotificationCount:Int;
	final transcriptUserMessages:Array<String>;
	final transcriptAgentMessages:Array<String>;
	final userMessagesInExpectedOrder:Bool;
	final agentMessagesInExpectedOrder:Bool;
	final turnOrderPreserved:Bool;
	final itemOrderPreserved:Bool;
	final sessionAppliedBeforeTurns:Bool;
	final queueAutosendSuppressed:Bool;
	final liveOnlyEffectsSuppressed:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelThreadSnapshotTurnHistoryReplayOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final replayKind:ModelTurnReplayKind;
	public final decisionKind:ModelThreadSnapshotTurnHistoryDecisionKind;
	public final turnCount:Int;
	public final replayedItemCount:Int;
	public final userMessageCount:Int;
	public final agentMessageCount:Int;
	public final terminalTurnCompletedNotificationCount:Int;
	public final transcriptUserMessages:Array<String>;
	public final transcriptAgentMessages:Array<String>;
	public final userMessagesInExpectedOrder:Bool;
	public final agentMessagesInExpectedOrder:Bool;
	public final turnOrderPreserved:Bool;
	public final itemOrderPreserved:Bool;
	public final sessionAppliedBeforeTurns:Bool;
	public final queueAutosendSuppressed:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelThreadSnapshotTurnHistoryReplayOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.replayKind = fields.replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : fields.replayKind;
		this.decisionKind = fields.decisionKind == null ? ModelThreadSnapshotTurnHistoryDecisionKind.TurnHistoryReplayBlocked : fields.decisionKind;
		this.turnCount = fields.turnCount;
		this.replayedItemCount = fields.replayedItemCount;
		this.userMessageCount = fields.userMessageCount;
		this.agentMessageCount = fields.agentMessageCount;
		this.terminalTurnCompletedNotificationCount = fields.terminalTurnCompletedNotificationCount;
		this.transcriptUserMessages = fields.transcriptUserMessages == null ? [] : fields.transcriptUserMessages;
		this.transcriptAgentMessages = fields.transcriptAgentMessages == null ? [] : fields.transcriptAgentMessages;
		this.userMessagesInExpectedOrder = fields.userMessagesInExpectedOrder;
		this.agentMessagesInExpectedOrder = fields.agentMessagesInExpectedOrder;
		this.turnOrderPreserved = fields.turnOrderPreserved;
		this.itemOrderPreserved = fields.itemOrderPreserved;
		this.sessionAppliedBeforeTurns = fields.sessionAppliedBeforeTurns;
		this.queueAutosendSuppressed = fields.queueAutosendSuppressed;
		this.liveOnlyEffectsSuppressed = fields.liveOnlyEffectsSuppressed;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";replayKind=" + replayKind + ";decisionKind=" + decisionKind
			+ ";turnCount=" + turnCount + ";replayedItemCount=" + replayedItemCount + ";userMessageCount=" + userMessageCount + ";agentMessageCount="
			+ agentMessageCount + ";terminalTurnCompletedNotificationCount=" + terminalTurnCompletedNotificationCount + ";userMessagesInExpectedOrder="
			+ boolText(userMessagesInExpectedOrder) + ";agentMessagesInExpectedOrder=" + boolText(agentMessagesInExpectedOrder) + ";turnOrderPreserved="
			+ boolText(turnOrderPreserved) + ";itemOrderPreserved=" + boolText(itemOrderPreserved) + ";sessionAppliedBeforeTurns="
			+ boolText(sessionAppliedBeforeTurns) + ";queueAutosendSuppressed=" + boolText(queueAutosendSuppressed) + ";liveOnlyEffectsSuppressed="
			+ boolText(liveOnlyEffectsSuppressed) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
