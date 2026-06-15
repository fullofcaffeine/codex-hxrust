package codexhx.runtime.model.streamitem;

typedef ModelThreadRollbackResponseActiveQueueFlushRequestFields = {
	final requestId:String;
	final activeThreadId:String;
	final rollbackThreadId:String;
	final numTurns:Int;
	final threadChannelKnown:Bool;
	final receiverAttachedBefore:Bool;
	final receiverDisconnectedDuringDrain:Bool;
	final queuedActiveEventCountBefore:Int;
	final queuedStaleNotificationCountBefore:Int;
	final pendingBacktrackRollback:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelThreadRollbackResponseActiveQueueFlushRequest {
	public final requestId:String;
	public final activeThreadId:String;
	public final rollbackThreadId:String;
	public final numTurns:Int;
	public final threadChannelKnown:Bool;
	public final receiverAttachedBefore:Bool;
	public final receiverDisconnectedDuringDrain:Bool;
	public final queuedActiveEventCountBefore:Int;
	public final queuedStaleNotificationCountBefore:Int;
	public final pendingBacktrackRollback:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelThreadRollbackResponseActiveQueueFlushRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.activeThreadId = fields.activeThreadId == null ? "" : fields.activeThreadId;
		this.rollbackThreadId = fields.rollbackThreadId == null ? "" : fields.rollbackThreadId;
		this.numTurns = fields.numTurns;
		this.threadChannelKnown = fields.threadChannelKnown;
		this.receiverAttachedBefore = fields.receiverAttachedBefore;
		this.receiverDisconnectedDuringDrain = fields.receiverDisconnectedDuringDrain;
		this.queuedActiveEventCountBefore = fields.queuedActiveEventCountBefore;
		this.queuedStaleNotificationCountBefore = fields.queuedStaleNotificationCountBefore;
		this.pendingBacktrackRollback = fields.pendingBacktrackRollback;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
