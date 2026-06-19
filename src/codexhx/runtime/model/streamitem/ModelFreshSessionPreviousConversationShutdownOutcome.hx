package codexhx.runtime.model.streamitem;

typedef ModelFreshSessionPreviousConversationShutdownOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelFreshSessionPreviousConversationShutdownDecisionKind;
	final previousConversationPresent:Bool;
	final shutdownCurrentThreadAttempted:Bool;
	final pendingRollbackCleared:Bool;
	final threadUnsubscribeAttempted:Bool;
	final threadUnsubscribeSucceeded:Bool;
	final listenerAbortAttempted:Bool;
	final listenerTaskRemoved:Bool;
	final opShutdownSubmitted:Bool;
	final opQueueLengthBefore:Int;
	final opQueueLengthAfter:Int;
	final duplicateShutdownSuppressed:Bool;
	final newSessionMayStartAfterShutdown:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelFreshSessionPreviousConversationShutdownOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelFreshSessionPreviousConversationShutdownDecisionKind;
	public final previousConversationPresent:Bool;
	public final shutdownCurrentThreadAttempted:Bool;
	public final pendingRollbackCleared:Bool;
	public final threadUnsubscribeAttempted:Bool;
	public final threadUnsubscribeSucceeded:Bool;
	public final listenerAbortAttempted:Bool;
	public final listenerTaskRemoved:Bool;
	public final opShutdownSubmitted:Bool;
	public final opQueueLengthBefore:Int;
	public final opQueueLengthAfter:Int;
	public final duplicateShutdownSuppressed:Bool;
	public final newSessionMayStartAfterShutdown:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelFreshSessionPreviousConversationShutdownOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelFreshSessionPreviousConversationShutdownDecisionKind.NoPreviousConversationNoop : fields.decisionKind;
		this.previousConversationPresent = fields.previousConversationPresent;
		this.shutdownCurrentThreadAttempted = fields.shutdownCurrentThreadAttempted;
		this.pendingRollbackCleared = fields.pendingRollbackCleared;
		this.threadUnsubscribeAttempted = fields.threadUnsubscribeAttempted;
		this.threadUnsubscribeSucceeded = fields.threadUnsubscribeSucceeded;
		this.listenerAbortAttempted = fields.listenerAbortAttempted;
		this.listenerTaskRemoved = fields.listenerTaskRemoved;
		this.opShutdownSubmitted = fields.opShutdownSubmitted;
		this.opQueueLengthBefore = fields.opQueueLengthBefore;
		this.opQueueLengthAfter = fields.opQueueLengthAfter;
		this.duplicateShutdownSuppressed = fields.duplicateShutdownSuppressed;
		this.newSessionMayStartAfterShutdown = fields.newSessionMayStartAfterShutdown;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";previousConversationPresent="
			+ boolText(previousConversationPresent) + ";shutdownCurrentThreadAttempted=" + boolText(shutdownCurrentThreadAttempted)
			+ ";pendingRollbackCleared=" + boolText(pendingRollbackCleared) + ";threadUnsubscribeAttempted=" + boolText(threadUnsubscribeAttempted)
			+ ";threadUnsubscribeSucceeded=" + boolText(threadUnsubscribeSucceeded) + ";listenerAbortAttempted=" + boolText(listenerAbortAttempted)
			+ ";listenerTaskRemoved=" + boolText(listenerTaskRemoved) + ";opShutdownSubmitted=" + boolText(opShutdownSubmitted) + ";opQueueLengthBefore="
			+ opQueueLengthBefore + ";opQueueLengthAfter=" + opQueueLengthAfter + ";duplicateShutdownSuppressed=" + boolText(duplicateShutdownSuppressed)
			+ ";newSessionMayStartAfterShutdown=" + boolText(newSessionMayStartAfterShutdown) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
