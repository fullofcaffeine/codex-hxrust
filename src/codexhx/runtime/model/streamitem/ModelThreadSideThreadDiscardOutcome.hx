package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadDiscardOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final uiSyncRequestId:String;
	public final decisionKind:ModelThreadSideThreadDiscardDecisionKind;
	public final maybeReturnEligible:Bool;
	public final returnFromSideAttempted:Bool;
	public final returnFromSideSucceeded:Bool;
	public final discardTargetSelected:Bool;
	public final interruptKind:ModelThreadSideThreadInterruptKind;
	public final interruptAttempted:Bool;
	public final unsubscribeAttempted:Bool;
	public final localStateRemoved:Bool;
	public final activeThreadCleared:Bool;
	public final pendingApprovalsRefreshed:Bool;
	public final activeAgentLabelSynced:Bool;
	public final cleanupFailureKeptVisible:Bool;
	public final surfacePendingInactiveRequests:Bool;
	public final serverRpcAttempted:Bool;
	public final closedSideThreadLocalOnly:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		uiSyncRequestId:String,
		decisionKind:ModelThreadSideThreadDiscardDecisionKind,
		maybeReturnEligible:Bool,
		returnFromSideAttempted:Bool,
		returnFromSideSucceeded:Bool,
		discardTargetSelected:Bool,
		interruptKind:ModelThreadSideThreadInterruptKind,
		interruptAttempted:Bool,
		unsubscribeAttempted:Bool,
		localStateRemoved:Bool,
		activeThreadCleared:Bool,
		pendingApprovalsRefreshed:Bool,
		activeAgentLabelSynced:Bool,
		cleanupFailureKeptVisible:Bool,
		surfacePendingInactiveRequests:Bool,
		serverRpcAttempted:Bool,
		closedSideThreadLocalOnly:Bool,
		eventOrderingPreserved:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.uiSyncRequestId = uiSyncRequestId == null ? "" : uiSyncRequestId;
		this.decisionKind = decisionKind == null ? ModelThreadSideThreadDiscardDecisionKind.ReturnBlocked : decisionKind;
		this.maybeReturnEligible = maybeReturnEligible;
		this.returnFromSideAttempted = returnFromSideAttempted;
		this.returnFromSideSucceeded = returnFromSideSucceeded;
		this.discardTargetSelected = discardTargetSelected;
		this.interruptKind = interruptKind == null ? ModelThreadSideThreadInterruptKind.None : interruptKind;
		this.interruptAttempted = interruptAttempted;
		this.unsubscribeAttempted = unsubscribeAttempted;
		this.localStateRemoved = localStateRemoved;
		this.activeThreadCleared = activeThreadCleared;
		this.pendingApprovalsRefreshed = pendingApprovalsRefreshed;
		this.activeAgentLabelSynced = activeAgentLabelSynced;
		this.cleanupFailureKeptVisible = cleanupFailureKeptVisible;
		this.surfacePendingInactiveRequests = surfacePendingInactiveRequests;
		this.serverRpcAttempted = serverRpcAttempted;
		this.closedSideThreadLocalOnly = closedSideThreadLocalOnly;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";uiSyncRequest=" + noneIfEmpty(uiSyncRequestId)
			+ ";decisionKind=" + decisionKind
			+ ";maybeReturnEligible=" + boolText(maybeReturnEligible)
			+ ";returnFromSideAttempted=" + boolText(returnFromSideAttempted)
			+ ";returnFromSideSucceeded=" + boolText(returnFromSideSucceeded)
			+ ";discardTargetSelected=" + boolText(discardTargetSelected)
			+ ";interruptKind=" + interruptKind
			+ ";interruptAttempted=" + boolText(interruptAttempted)
			+ ";unsubscribeAttempted=" + boolText(unsubscribeAttempted)
			+ ";localStateRemoved=" + boolText(localStateRemoved)
			+ ";activeThreadCleared=" + boolText(activeThreadCleared)
			+ ";pendingApprovalsRefreshed=" + boolText(pendingApprovalsRefreshed)
			+ ";activeAgentLabelSynced=" + boolText(activeAgentLabelSynced)
			+ ";cleanupFailureKeptVisible=" + boolText(cleanupFailureKeptVisible)
			+ ";surfacePendingInactiveRequests=" + boolText(surfacePendingInactiveRequests)
			+ ";serverRpcAttempted=" + boolText(serverRpcAttempted)
			+ ";closedSideThreadLocalOnly=" + boolText(closedSideThreadLocalOnly)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
