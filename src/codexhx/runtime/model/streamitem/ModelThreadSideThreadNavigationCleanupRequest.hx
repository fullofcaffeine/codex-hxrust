package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadNavigationCleanupRequest {
	public final requestId:String;
	public final composerHandoffOutcome:ModelThreadSideThreadComposerHandoffOutcome;
	public final currentDisplayedThreadIsSide:Bool;
	public final targetIsCurrentSideThread:Bool;
	public final targetIsParentThread:Bool;
	public final selectedByParentSwitch:Bool;
	public final selectTargetSucceeded:Bool;
	public final discardClosedNotification:Bool;
	public final activeThreadWasSideBeforeSwitch:Bool;
	public final activeThreadIsDiscardTarget:Bool;
	public final activeTurnPresent:Bool;
	public final interruptSucceeded:Bool;
	public final unsubscribeSucceeded:Bool;
	public final threadEventChannelBefore:Bool;
	public final sideThreadLocalStateBefore:Bool;
	public final agentNavigationEntryBefore:Bool;
	public final pendingInactiveRequests:Bool;
	public final keepVisibleSelectSucceeded:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		composerHandoffOutcome:ModelThreadSideThreadComposerHandoffOutcome,
		currentDisplayedThreadIsSide:Bool,
		targetIsCurrentSideThread:Bool,
		targetIsParentThread:Bool,
		selectedByParentSwitch:Bool,
		selectTargetSucceeded:Bool,
		discardClosedNotification:Bool,
		activeThreadWasSideBeforeSwitch:Bool,
		activeThreadIsDiscardTarget:Bool,
		activeTurnPresent:Bool,
		interruptSucceeded:Bool,
		unsubscribeSucceeded:Bool,
		threadEventChannelBefore:Bool,
		sideThreadLocalStateBefore:Bool,
		agentNavigationEntryBefore:Bool,
		pendingInactiveRequests:Bool,
		keepVisibleSelectSucceeded:Bool,
		eventOrderIndex:Int,
		previousEventCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.composerHandoffOutcome = composerHandoffOutcome;
		this.currentDisplayedThreadIsSide = currentDisplayedThreadIsSide;
		this.targetIsCurrentSideThread = targetIsCurrentSideThread;
		this.targetIsParentThread = targetIsParentThread;
		this.selectedByParentSwitch = selectedByParentSwitch;
		this.selectTargetSucceeded = selectTargetSucceeded;
		this.discardClosedNotification = discardClosedNotification;
		this.activeThreadWasSideBeforeSwitch = activeThreadWasSideBeforeSwitch;
		this.activeThreadIsDiscardTarget = activeThreadIsDiscardTarget;
		this.activeTurnPresent = activeTurnPresent;
		this.interruptSucceeded = interruptSucceeded;
		this.unsubscribeSucceeded = unsubscribeSucceeded;
		this.threadEventChannelBefore = threadEventChannelBefore;
		this.sideThreadLocalStateBefore = sideThreadLocalStateBefore;
		this.agentNavigationEntryBefore = agentNavigationEntryBefore;
		this.pendingInactiveRequests = pendingInactiveRequests;
		this.keepVisibleSelectSucceeded = keepVisibleSelectSucceeded;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
