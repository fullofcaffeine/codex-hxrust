package codexhx.runtime.model.streamitem;

typedef ModelThreadRollbackResponseActiveQueueFlushOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelThreadRollbackResponseActiveQueueFlushDecisionKind;
	final numTurns:Int;
	final activeThreadMatched:Bool;
	final threadStoreRollbackApplied:Bool;
	final receiverAttachedBefore:Bool;
	final receiverAttachedAfter:Bool;
	final receiverClearedAfterDisconnect:Bool;
	final queuedActiveEventCountBefore:Int;
	final drainedActiveEventCount:Int;
	final queuedActiveEventCountAfter:Int;
	final staleNotificationDiscarded:Bool;
	final applyThreadRollbackEventQueued:Bool;
	final pendingBacktrackFinished:Bool;
	final eventOrderingPreserved:Bool;
	final liveOnlyEffectsSuppressed:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelThreadRollbackResponseActiveQueueFlushOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelThreadRollbackResponseActiveQueueFlushDecisionKind;
	public final numTurns:Int;
	public final activeThreadMatched:Bool;
	public final threadStoreRollbackApplied:Bool;
	public final receiverAttachedBefore:Bool;
	public final receiverAttachedAfter:Bool;
	public final receiverClearedAfterDisconnect:Bool;
	public final queuedActiveEventCountBefore:Int;
	public final drainedActiveEventCount:Int;
	public final queuedActiveEventCountAfter:Int;
	public final staleNotificationDiscarded:Bool;
	public final applyThreadRollbackEventQueued:Bool;
	public final pendingBacktrackFinished:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelThreadRollbackResponseActiveQueueFlushOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelThreadRollbackResponseActiveQueueFlushDecisionKind.ActiveQueueUnchanged : fields.decisionKind;
		this.numTurns = fields.numTurns;
		this.activeThreadMatched = fields.activeThreadMatched;
		this.threadStoreRollbackApplied = fields.threadStoreRollbackApplied;
		this.receiverAttachedBefore = fields.receiverAttachedBefore;
		this.receiverAttachedAfter = fields.receiverAttachedAfter;
		this.receiverClearedAfterDisconnect = fields.receiverClearedAfterDisconnect;
		this.queuedActiveEventCountBefore = fields.queuedActiveEventCountBefore;
		this.drainedActiveEventCount = fields.drainedActiveEventCount;
		this.queuedActiveEventCountAfter = fields.queuedActiveEventCountAfter;
		this.staleNotificationDiscarded = fields.staleNotificationDiscarded;
		this.applyThreadRollbackEventQueued = fields.applyThreadRollbackEventQueued;
		this.pendingBacktrackFinished = fields.pendingBacktrackFinished;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveOnlyEffectsSuppressed = fields.liveOnlyEffectsSuppressed;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";numTurns=" + numTurns
			+ ";activeThreadMatched=" + boolText(activeThreadMatched) + ";threadStoreRollbackApplied=" + boolText(threadStoreRollbackApplied)
			+ ";receiverAttachedBefore=" + boolText(receiverAttachedBefore) + ";receiverAttachedAfter=" + boolText(receiverAttachedAfter)
			+ ";receiverClearedAfterDisconnect=" + boolText(receiverClearedAfterDisconnect) + ";queuedActiveEventCountBefore=" + queuedActiveEventCountBefore
			+ ";drainedActiveEventCount=" + drainedActiveEventCount + ";queuedActiveEventCountAfter=" + queuedActiveEventCountAfter
			+ ";staleNotificationDiscarded=" + boolText(staleNotificationDiscarded) + ";applyThreadRollbackEventQueued="
			+ boolText(applyThreadRollbackEventQueued) + ";pendingBacktrackFinished=" + boolText(pendingBacktrackFinished) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveOnlyEffectsSuppressed=" + boolText(liveOnlyEffectsSuppressed) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
