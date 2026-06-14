package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadUiSyncRequest {
	public final requestId:String;
	public final statusChangeOutcome:ModelThreadSideParentStatusChangeOutcome;
	public final activeThreadDisplayed:Bool;
	public final sideThreadKnown:Bool;
	public final parentIsMain:Bool;
	public final parentThreadLabel:String;
	public final storedParentStatusBefore:ModelThreadSideParentStatusKind;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		statusChangeOutcome:ModelThreadSideParentStatusChangeOutcome,
		activeThreadDisplayed:Bool,
		sideThreadKnown:Bool,
		parentIsMain:Bool,
		parentThreadLabel:String,
		storedParentStatusBefore:ModelThreadSideParentStatusKind,
		eventOrderIndex:Int,
		previousEventCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.statusChangeOutcome = statusChangeOutcome;
		this.activeThreadDisplayed = activeThreadDisplayed;
		this.sideThreadKnown = sideThreadKnown;
		this.parentIsMain = parentIsMain;
		this.parentThreadLabel = parentThreadLabel == null ? "" : parentThreadLabel;
		this.storedParentStatusBefore = storedParentStatusBefore == null ? ModelThreadSideParentStatusKind.None : storedParentStatusBefore;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
