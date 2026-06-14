package codexhx.runtime.model.streamitem;

class ModelThreadSessionRebaseRequest {
	public final requestId:String;
	public final evictionOutcome:ModelThreadBufferedRequestEvictionOutcome;
	public final rebaseEventKind:ModelThreadSessionRebaseEventKind;
	public final bufferEventCountBefore:Int;
	public final eventOrderIndexBefore:Int;
	public final expectedOrderIndexAfter:Int;
	public final pendingReplayRecordedBefore:Bool;
	public final serverResolutionRecordedBefore:Bool;
	public final snapshotFilterChecked:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		evictionOutcome:ModelThreadBufferedRequestEvictionOutcome,
		rebaseEventKind:ModelThreadSessionRebaseEventKind,
		bufferEventCountBefore:Int,
		eventOrderIndexBefore:Int,
		expectedOrderIndexAfter:Int,
		pendingReplayRecordedBefore:Bool,
		serverResolutionRecordedBefore:Bool,
		snapshotFilterChecked:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.evictionOutcome = evictionOutcome;
		this.rebaseEventKind = rebaseEventKind == null ? ModelThreadSessionRebaseEventKind.Request : rebaseEventKind;
		this.bufferEventCountBefore = bufferEventCountBefore < 0 ? 0 : bufferEventCountBefore;
		this.eventOrderIndexBefore = eventOrderIndexBefore < 0 ? 0 : eventOrderIndexBefore;
		this.expectedOrderIndexAfter = expectedOrderIndexAfter < 0 ? 0 : expectedOrderIndexAfter;
		this.pendingReplayRecordedBefore = pendingReplayRecordedBefore;
		this.serverResolutionRecordedBefore = serverResolutionRecordedBefore;
		this.snapshotFilterChecked = snapshotFilterChecked;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
