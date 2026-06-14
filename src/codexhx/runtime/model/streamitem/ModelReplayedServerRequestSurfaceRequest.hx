package codexhx.runtime.model.streamitem;

class ModelReplayedServerRequestSurfaceRequest {
	public final requestId:String;
	public final dispatchOutcome:ModelThreadSnapshotReplayDispatchOutcome;
	public final requestKind:ModelReplayedServerRequestKind;
	public final replayKind:ModelTurnReplayKind;
	public final snapshotRequestAllowed:Bool;
	public final liveRequest:Bool;
	public final elicitationUrlRequest:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		dispatchOutcome:ModelThreadSnapshotReplayDispatchOutcome,
		requestKind:ModelReplayedServerRequestKind,
		replayKind:ModelTurnReplayKind,
		snapshotRequestAllowed:Bool,
		liveRequest:Bool,
		elicitationUrlRequest:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.dispatchOutcome = dispatchOutcome;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.replayKind = replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : replayKind;
		this.snapshotRequestAllowed = snapshotRequestAllowed;
		this.liveRequest = liveRequest;
		this.elicitationUrlRequest = elicitationUrlRequest;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
