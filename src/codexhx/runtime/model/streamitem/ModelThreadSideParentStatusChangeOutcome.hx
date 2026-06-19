package codexhx.runtime.model.streamitem;

class ModelThreadSideParentStatusChangeOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final pendingRequestId:String;
	public final eventKind:ModelThreadSideParentStatusChangeEventKind;
	public final turnStatus:ModelThreadSideParentTurnStatusKind;
	public final decisionKind:ModelThreadSideParentStatusChangeDecisionKind;
	public final sideParentStatusBefore:ModelThreadSideParentStatusKind;
	public final pendingStatusAfter:ModelThreadSideParentStatusKind;
	public final sideParentStatusAfter:ModelThreadSideParentStatusKind;
	public final pendingStatusTookPrecedence:Bool;
	public final notificationStatusChangeApplied:Bool;
	public final actionableStatusCleared:Bool;
	public final terminalStatusSet:Bool;
	public final terminalStatusPreserved:Bool;
	public final ignoredInProgressTurn:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, pendingRequestId:String, eventKind:ModelThreadSideParentStatusChangeEventKind,
			turnStatus:ModelThreadSideParentTurnStatusKind, decisionKind:ModelThreadSideParentStatusChangeDecisionKind,
			sideParentStatusBefore:ModelThreadSideParentStatusKind, pendingStatusAfter:ModelThreadSideParentStatusKind,
			sideParentStatusAfter:ModelThreadSideParentStatusKind, pendingStatusTookPrecedence:Bool, notificationStatusChangeApplied:Bool,
			actionableStatusCleared:Bool, terminalStatusSet:Bool, terminalStatusPreserved:Bool, ignoredInProgressTurn:Bool, eventOrderingPreserved:Bool,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.pendingRequestId = pendingRequestId == null ? "" : pendingRequestId;
		this.eventKind = eventKind == null ? ModelThreadSideParentStatusChangeEventKind.OtherNotification : eventKind;
		this.turnStatus = turnStatus == null ? ModelThreadSideParentTurnStatusKind.None : turnStatus;
		this.decisionKind = decisionKind == null ? ModelThreadSideParentStatusChangeDecisionKind.PreservedNoChange : decisionKind;
		this.sideParentStatusBefore = sideParentStatusBefore == null ? ModelThreadSideParentStatusKind.None : sideParentStatusBefore;
		this.pendingStatusAfter = pendingStatusAfter == null ? ModelThreadSideParentStatusKind.None : pendingStatusAfter;
		this.sideParentStatusAfter = sideParentStatusAfter == null ? ModelThreadSideParentStatusKind.None : sideParentStatusAfter;
		this.pendingStatusTookPrecedence = pendingStatusTookPrecedence;
		this.notificationStatusChangeApplied = notificationStatusChangeApplied;
		this.actionableStatusCleared = actionableStatusCleared;
		this.terminalStatusSet = terminalStatusSet;
		this.terminalStatusPreserved = terminalStatusPreserved;
		this.ignoredInProgressTurn = ignoredInProgressTurn;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";pendingRequest=" + noneIfEmpty(pendingRequestId) + ";eventKind="
			+ eventKind + ";turnStatus=" + turnStatus + ";decisionKind=" + decisionKind + ";sideParentStatusBefore=" + sideParentStatusBefore
			+ ";pendingStatusAfter=" + pendingStatusAfter + ";sideParentStatusAfter=" + sideParentStatusAfter + ";pendingStatusTookPrecedence="
			+ boolText(pendingStatusTookPrecedence) + ";notificationStatusChangeApplied=" + boolText(notificationStatusChangeApplied)
			+ ";actionableStatusCleared=" + boolText(actionableStatusCleared) + ";terminalStatusSet=" + boolText(terminalStatusSet)
			+ ";terminalStatusPreserved=" + boolText(terminalStatusPreserved) + ";ignoredInProgressTurn=" + boolText(ignoredInProgressTurn)
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
