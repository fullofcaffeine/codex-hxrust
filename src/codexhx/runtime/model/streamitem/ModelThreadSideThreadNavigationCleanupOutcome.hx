package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadNavigationCleanupOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final composerHandoffRequestId:String;
	public final decisionKind:ModelThreadSideThreadNavigationCleanupDecisionKind;
	public final discardTargetSelected:Bool;
	public final parentSwitchAttempted:Bool;
	public final selectTargetSucceeded:Bool;
	public final interruptAttempted:Bool;
	public final startupInterruptAttempted:Bool;
	public final turnInterruptAttempted:Bool;
	public final unsubscribeAttempted:Bool;
	public final serverRpcAttempted:Bool;
	public final localStateRemoved:Bool;
	public final localStateRetained:Bool;
	public final threadEventChannelRemoved:Bool;
	public final sideThreadStateRemoved:Bool;
	public final agentNavigationEntryRemoved:Bool;
	public final activeThreadCleared:Bool;
	public final pendingApprovalsRefreshed:Bool;
	public final activeAgentLabelSynced:Bool;
	public final pendingInactiveRequestsSurfaced:Bool;
	public final cleanupFailureKeptVisible:Bool;
	public final closedSideThreadLocalOnly:Bool;
	public final errorMessageDisplayed:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		composerHandoffRequestId:String,
		decisionKind:ModelThreadSideThreadNavigationCleanupDecisionKind,
		discardTargetSelected:Bool,
		parentSwitchAttempted:Bool,
		selectTargetSucceeded:Bool,
		interruptAttempted:Bool,
		startupInterruptAttempted:Bool,
		turnInterruptAttempted:Bool,
		unsubscribeAttempted:Bool,
		serverRpcAttempted:Bool,
		localStateRemoved:Bool,
		localStateRetained:Bool,
		threadEventChannelRemoved:Bool,
		sideThreadStateRemoved:Bool,
		agentNavigationEntryRemoved:Bool,
		activeThreadCleared:Bool,
		pendingApprovalsRefreshed:Bool,
		activeAgentLabelSynced:Bool,
		pendingInactiveRequestsSurfaced:Bool,
		cleanupFailureKeptVisible:Bool,
		closedSideThreadLocalOnly:Bool,
		errorMessageDisplayed:Bool,
		eventOrderingPreserved:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.composerHandoffRequestId = composerHandoffRequestId == null ? "" : composerHandoffRequestId;
		this.decisionKind = decisionKind == null ? ModelThreadSideThreadNavigationCleanupDecisionKind.NoDiscardSameTarget : decisionKind;
		this.discardTargetSelected = discardTargetSelected;
		this.parentSwitchAttempted = parentSwitchAttempted;
		this.selectTargetSucceeded = selectTargetSucceeded;
		this.interruptAttempted = interruptAttempted;
		this.startupInterruptAttempted = startupInterruptAttempted;
		this.turnInterruptAttempted = turnInterruptAttempted;
		this.unsubscribeAttempted = unsubscribeAttempted;
		this.serverRpcAttempted = serverRpcAttempted;
		this.localStateRemoved = localStateRemoved;
		this.localStateRetained = localStateRetained;
		this.threadEventChannelRemoved = threadEventChannelRemoved;
		this.sideThreadStateRemoved = sideThreadStateRemoved;
		this.agentNavigationEntryRemoved = agentNavigationEntryRemoved;
		this.activeThreadCleared = activeThreadCleared;
		this.pendingApprovalsRefreshed = pendingApprovalsRefreshed;
		this.activeAgentLabelSynced = activeAgentLabelSynced;
		this.pendingInactiveRequestsSurfaced = pendingInactiveRequestsSurfaced;
		this.cleanupFailureKeptVisible = cleanupFailureKeptVisible;
		this.closedSideThreadLocalOnly = closedSideThreadLocalOnly;
		this.errorMessageDisplayed = errorMessageDisplayed;
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
			+ ";composerHandoffRequest=" + noneIfEmpty(composerHandoffRequestId)
			+ ";decisionKind=" + decisionKind
			+ ";discardTargetSelected=" + boolText(discardTargetSelected)
			+ ";parentSwitchAttempted=" + boolText(parentSwitchAttempted)
			+ ";selectTargetSucceeded=" + boolText(selectTargetSucceeded)
			+ ";interruptAttempted=" + boolText(interruptAttempted)
			+ ";startupInterruptAttempted=" + boolText(startupInterruptAttempted)
			+ ";turnInterruptAttempted=" + boolText(turnInterruptAttempted)
			+ ";unsubscribeAttempted=" + boolText(unsubscribeAttempted)
			+ ";serverRpcAttempted=" + boolText(serverRpcAttempted)
			+ ";localStateRemoved=" + boolText(localStateRemoved)
			+ ";localStateRetained=" + boolText(localStateRetained)
			+ ";threadEventChannelRemoved=" + boolText(threadEventChannelRemoved)
			+ ";sideThreadStateRemoved=" + boolText(sideThreadStateRemoved)
			+ ";agentNavigationEntryRemoved=" + boolText(agentNavigationEntryRemoved)
			+ ";activeThreadCleared=" + boolText(activeThreadCleared)
			+ ";pendingApprovalsRefreshed=" + boolText(pendingApprovalsRefreshed)
			+ ";activeAgentLabelSynced=" + boolText(activeAgentLabelSynced)
			+ ";pendingInactiveRequestsSurfaced=" + boolText(pendingInactiveRequestsSurfaced)
			+ ";cleanupFailureKeptVisible=" + boolText(cleanupFailureKeptVisible)
			+ ";closedSideThreadLocalOnly=" + boolText(closedSideThreadLocalOnly)
			+ ";errorMessageDisplayed=" + boolText(errorMessageDisplayed)
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
