package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadDiscardRequest {
	public final requestId:String;
	public final uiSyncOutcome:ModelThreadSideThreadUiSyncOutcome;
	public final maybeReturnRequested:Bool;
	public final overlayActive:Bool;
	public final modalOrPopupActive:Bool;
	public final composerEmpty:Bool;
	public final activeSideParentKnown:Bool;
	public final selectionSucceeded:Bool;
	public final activeSideParentAfterSelectionKnown:Bool;
	public final currentThreadDisplayed:Bool;
	public final currentThreadIsSideThread:Bool;
	public final targetIsCurrentThread:Bool;
	public final sideThreadHasActiveTurn:Bool;
	public final interruptSucceeded:Bool;
	public final unsubscribeSucceeded:Bool;
	public final discardedThreadWasActive:Bool;
	public final closedSideThread:Bool;
	public final keepVisibleAfterCleanupFailure:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		uiSyncOutcome:ModelThreadSideThreadUiSyncOutcome,
		maybeReturnRequested:Bool,
		overlayActive:Bool,
		modalOrPopupActive:Bool,
		composerEmpty:Bool,
		activeSideParentKnown:Bool,
		selectionSucceeded:Bool,
		activeSideParentAfterSelectionKnown:Bool,
		currentThreadDisplayed:Bool,
		currentThreadIsSideThread:Bool,
		targetIsCurrentThread:Bool,
		sideThreadHasActiveTurn:Bool,
		interruptSucceeded:Bool,
		unsubscribeSucceeded:Bool,
		discardedThreadWasActive:Bool,
		closedSideThread:Bool,
		keepVisibleAfterCleanupFailure:Bool,
		eventOrderIndex:Int,
		previousEventCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.uiSyncOutcome = uiSyncOutcome;
		this.maybeReturnRequested = maybeReturnRequested;
		this.overlayActive = overlayActive;
		this.modalOrPopupActive = modalOrPopupActive;
		this.composerEmpty = composerEmpty;
		this.activeSideParentKnown = activeSideParentKnown;
		this.selectionSucceeded = selectionSucceeded;
		this.activeSideParentAfterSelectionKnown = activeSideParentAfterSelectionKnown;
		this.currentThreadDisplayed = currentThreadDisplayed;
		this.currentThreadIsSideThread = currentThreadIsSideThread;
		this.targetIsCurrentThread = targetIsCurrentThread;
		this.sideThreadHasActiveTurn = sideThreadHasActiveTurn;
		this.interruptSucceeded = interruptSucceeded;
		this.unsubscribeSucceeded = unsubscribeSucceeded;
		this.discardedThreadWasActive = discardedThreadWasActive;
		this.closedSideThread = closedSideThread;
		this.keepVisibleAfterCleanupFailure = keepVisibleAfterCleanupFailure;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
