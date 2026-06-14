package codexhx.runtime.model.streamitem;

class ModelThreadSideParentStatusChangeRequest {
	public final requestId:String;
	public final pendingOutcome:ModelThreadSideParentPendingOutcome;
	public final eventKind:ModelThreadSideParentStatusChangeEventKind;
	public final turnStatus:ModelThreadSideParentTurnStatusKind;
	public final sideParentStatusBefore:ModelThreadSideParentStatusKind;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		pendingOutcome:ModelThreadSideParentPendingOutcome,
		eventKind:ModelThreadSideParentStatusChangeEventKind,
		turnStatus:ModelThreadSideParentTurnStatusKind,
		sideParentStatusBefore:ModelThreadSideParentStatusKind,
		eventOrderIndex:Int,
		previousEventCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.pendingOutcome = pendingOutcome;
		this.eventKind = eventKind == null ? ModelThreadSideParentStatusChangeEventKind.OtherNotification : eventKind;
		this.turnStatus = turnStatus == null ? ModelThreadSideParentTurnStatusKind.None : turnStatus;
		this.sideParentStatusBefore = sideParentStatusBefore == null ? ModelThreadSideParentStatusKind.None : sideParentStatusBefore;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
