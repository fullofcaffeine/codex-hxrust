package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotSessionRefreshRequestFields = {
	final requestId:String;
	final threadId:String;
	final snapshotSessionCwdBefore:String;
	final storeSessionCwdBefore:String;
	final refreshedSessionCwd:String;
	final snapshotTurnCountBefore:Int;
	final storeTurnCountBefore:Int;
	final resumedTurns:Array<ModelThreadSnapshotSessionRefreshTurn>;
	final bufferEventCountBefore:Int;
	final survivingBufferEventCount:Int;
	final secretProbe:String;
}

class ModelThreadSnapshotSessionRefreshRequest {
	public final requestId:String;
	public final threadId:String;
	public final snapshotSessionCwdBefore:String;
	public final storeSessionCwdBefore:String;
	public final refreshedSessionCwd:String;
	public final snapshotTurnCountBefore:Int;
	public final storeTurnCountBefore:Int;
	public final resumedTurns:Array<ModelThreadSnapshotSessionRefreshTurn>;
	public final bufferEventCountBefore:Int;
	public final survivingBufferEventCount:Int;
	public final secretProbe:String;

	public function new(fields:ModelThreadSnapshotSessionRefreshRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.snapshotSessionCwdBefore = fields.snapshotSessionCwdBefore == null ? "" : fields.snapshotSessionCwdBefore;
		this.storeSessionCwdBefore = fields.storeSessionCwdBefore == null ? "" : fields.storeSessionCwdBefore;
		this.refreshedSessionCwd = fields.refreshedSessionCwd == null ? "" : fields.refreshedSessionCwd;
		this.snapshotTurnCountBefore = fields.snapshotTurnCountBefore;
		this.storeTurnCountBefore = fields.storeTurnCountBefore;
		this.resumedTurns = fields.resumedTurns == null ? [] : fields.resumedTurns;
		this.bufferEventCountBefore = fields.bufferEventCountBefore < 0 ? 0 : fields.bufferEventCountBefore;
		this.survivingBufferEventCount = fields.survivingBufferEventCount < 0 ? 0 : fields.survivingBufferEventCount;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
