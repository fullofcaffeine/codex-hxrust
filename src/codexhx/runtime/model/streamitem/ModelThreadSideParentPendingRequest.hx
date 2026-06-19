package codexhx.runtime.model.streamitem;

class ModelThreadSideParentPendingRequest {
	public final requestId:String;
	public final activeTurnOutcome:ModelThreadActiveTurnOutcome;
	public final eventKind:ModelThreadSideParentPendingEventKind;
	public final requestKind:ModelReplayedServerRequestKind;
	public final pendingUserInputCountBefore:Int;
	public final pendingApprovalCountBefore:Int;
	public final requestAddsUserInput:Bool;
	public final requestAddsApproval:Bool;
	public final requestRemovesUserInput:Bool;
	public final requestRemovesApproval:Bool;
	public final requestStatusFallbackAllowed:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(requestId:String, activeTurnOutcome:ModelThreadActiveTurnOutcome, eventKind:ModelThreadSideParentPendingEventKind,
			requestKind:ModelReplayedServerRequestKind, pendingUserInputCountBefore:Int, pendingApprovalCountBefore:Int, requestAddsUserInput:Bool,
			requestAddsApproval:Bool, requestRemovesUserInput:Bool, requestRemovesApproval:Bool, requestStatusFallbackAllowed:Bool, eventOrderIndex:Int,
			previousEventCount:Int, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.activeTurnOutcome = activeTurnOutcome;
		this.eventKind = eventKind == null ? ModelThreadSideParentPendingEventKind.StatusRefresh : eventKind;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.pendingUserInputCountBefore = pendingUserInputCountBefore < 0 ? 0 : pendingUserInputCountBefore;
		this.pendingApprovalCountBefore = pendingApprovalCountBefore < 0 ? 0 : pendingApprovalCountBefore;
		this.requestAddsUserInput = requestAddsUserInput;
		this.requestAddsApproval = requestAddsApproval;
		this.requestRemovesUserInput = requestRemovesUserInput;
		this.requestRemovesApproval = requestRemovesApproval;
		this.requestStatusFallbackAllowed = requestStatusFallbackAllowed;
		this.eventOrderIndex = eventOrderIndex < 0 ? 0 : eventOrderIndex;
		this.previousEventCount = previousEventCount < 0 ? 0 : previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
