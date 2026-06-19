package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadUiSyncOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final statusChangeRequestId:String;
	public final decisionKind:ModelThreadSideThreadUiSyncDecisionKind;
	public final storedParentStatusBefore:ModelThreadSideParentStatusKind;
	public final storedParentStatusAfter:ModelThreadSideParentStatusKind;
	public final statusChanged:Bool;
	public final syncTriggered:Bool;
	public final sideUiCleared:Bool;
	public final sideConversationActive:Bool;
	public final contextLabel:String;
	public final renameBlocked:Bool;
	public final interruptedTurnNoticeSuppressed:Bool;
	public final interruptedTurnNoticeDefaultRestored:Bool;
	public final statusLabelApplied:Bool;
	public final statusClearApplied:Bool;
	public final repeatedSameStatusNoop:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, statusChangeRequestId:String, decisionKind:ModelThreadSideThreadUiSyncDecisionKind,
			storedParentStatusBefore:ModelThreadSideParentStatusKind, storedParentStatusAfter:ModelThreadSideParentStatusKind, statusChanged:Bool,
			syncTriggered:Bool, sideUiCleared:Bool, sideConversationActive:Bool, contextLabel:String, renameBlocked:Bool,
			interruptedTurnNoticeSuppressed:Bool, interruptedTurnNoticeDefaultRestored:Bool, statusLabelApplied:Bool, statusClearApplied:Bool,
			repeatedSameStatusNoop:Bool, eventOrderingPreserved:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool,
			errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.statusChangeRequestId = statusChangeRequestId == null ? "" : statusChangeRequestId;
		this.decisionKind = decisionKind == null ? ModelThreadSideThreadUiSyncDecisionKind.ClearedNoActiveThread : decisionKind;
		this.storedParentStatusBefore = storedParentStatusBefore == null ? ModelThreadSideParentStatusKind.None : storedParentStatusBefore;
		this.storedParentStatusAfter = storedParentStatusAfter == null ? ModelThreadSideParentStatusKind.None : storedParentStatusAfter;
		this.statusChanged = statusChanged;
		this.syncTriggered = syncTriggered;
		this.sideUiCleared = sideUiCleared;
		this.sideConversationActive = sideConversationActive;
		this.contextLabel = contextLabel == null ? "" : contextLabel;
		this.renameBlocked = renameBlocked;
		this.interruptedTurnNoticeSuppressed = interruptedTurnNoticeSuppressed;
		this.interruptedTurnNoticeDefaultRestored = interruptedTurnNoticeDefaultRestored;
		this.statusLabelApplied = statusLabelApplied;
		this.statusClearApplied = statusClearApplied;
		this.repeatedSameStatusNoop = repeatedSameStatusNoop;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";statusChangeRequest=" + noneIfEmpty(statusChangeRequestId)
			+ ";decisionKind=" + decisionKind + ";storedParentStatusBefore=" + storedParentStatusBefore + ";storedParentStatusAfter="
			+ storedParentStatusAfter + ";statusChanged=" + boolText(statusChanged) + ";syncTriggered=" + boolText(syncTriggered) + ";sideUiCleared="
			+ boolText(sideUiCleared) + ";sideConversationActive=" + boolText(sideConversationActive) + ";contextLabel=" + noneIfEmpty(contextLabel)
			+ ";renameBlocked=" + boolText(renameBlocked) + ";interruptedTurnNoticeSuppressed=" + boolText(interruptedTurnNoticeSuppressed)
			+ ";interruptedTurnNoticeDefaultRestored=" + boolText(interruptedTurnNoticeDefaultRestored) + ";statusLabelApplied="
			+ boolText(statusLabelApplied) + ";statusClearApplied=" + boolText(statusClearApplied) + ";repeatedSameStatusNoop="
			+ boolText(repeatedSameStatusNoop) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
