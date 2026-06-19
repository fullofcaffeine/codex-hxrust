package codexhx.runtime.model.streamitem;

class ModelThreadSideParentPendingOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final activeTurnRequestId:String;
	public final eventKind:ModelThreadSideParentPendingEventKind;
	public final decisionKind:ModelThreadSideParentPendingDecisionKind;
	public final requestKind:ModelReplayedServerRequestKind;
	public final sideParentStatusAfter:ModelThreadSideParentStatusKind;
	public final pendingUserInputCountAfter:Int;
	public final pendingApprovalCountAfter:Int;
	public final pendingThreadApprovalsAfter:Bool;
	public final userInputPriorityApplied:Bool;
	public final requestStatusFallbackApplied:Bool;
	public final resolvedRequestRemoved:Bool;
	public final evictedRequestRemoved:Bool;
	public final threadClosedCleared:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, activeTurnRequestId:String, eventKind:ModelThreadSideParentPendingEventKind,
			decisionKind:ModelThreadSideParentPendingDecisionKind, requestKind:ModelReplayedServerRequestKind,
			sideParentStatusAfter:ModelThreadSideParentStatusKind, pendingUserInputCountAfter:Int, pendingApprovalCountAfter:Int,
			pendingThreadApprovalsAfter:Bool, userInputPriorityApplied:Bool, requestStatusFallbackApplied:Bool, resolvedRequestRemoved:Bool,
			evictedRequestRemoved:Bool, threadClosedCleared:Bool, eventOrderingPreserved:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.activeTurnRequestId = activeTurnRequestId == null ? "" : activeTurnRequestId;
		this.eventKind = eventKind == null ? ModelThreadSideParentPendingEventKind.StatusRefresh : eventKind;
		this.decisionKind = decisionKind == null ? ModelThreadSideParentPendingDecisionKind.PreservedNoPending : decisionKind;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.sideParentStatusAfter = sideParentStatusAfter == null ? ModelThreadSideParentStatusKind.None : sideParentStatusAfter;
		this.pendingUserInputCountAfter = pendingUserInputCountAfter < 0 ? 0 : pendingUserInputCountAfter;
		this.pendingApprovalCountAfter = pendingApprovalCountAfter < 0 ? 0 : pendingApprovalCountAfter;
		this.pendingThreadApprovalsAfter = pendingThreadApprovalsAfter;
		this.userInputPriorityApplied = userInputPriorityApplied;
		this.requestStatusFallbackApplied = requestStatusFallbackApplied;
		this.resolvedRequestRemoved = resolvedRequestRemoved;
		this.evictedRequestRemoved = evictedRequestRemoved;
		this.threadClosedCleared = threadClosedCleared;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";activeTurnRequest=" + noneIfEmpty(activeTurnRequestId) + ";eventKind="
			+ eventKind + ";decisionKind=" + decisionKind + ";requestKind=" + requestKind + ";sideParentStatusAfter=" + sideParentStatusAfter
			+ ";pendingUserInputCountAfter=" + pendingUserInputCountAfter + ";pendingApprovalCountAfter=" + pendingApprovalCountAfter
			+ ";pendingThreadApprovalsAfter=" + boolText(pendingThreadApprovalsAfter) + ";userInputPriorityApplied=" + boolText(userInputPriorityApplied)
			+ ";requestStatusFallbackApplied=" + boolText(requestStatusFallbackApplied) + ";resolvedRequestRemoved=" + boolText(resolvedRequestRemoved)
			+ ";evictedRequestRemoved=" + boolText(evictedRequestRemoved) + ";threadClosedCleared=" + boolText(threadClosedCleared)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error="
			+ errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
