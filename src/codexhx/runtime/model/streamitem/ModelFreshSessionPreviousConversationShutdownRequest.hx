package codexhx.runtime.model.streamitem;

typedef ModelFreshSessionPreviousConversationShutdownRequestFields = {
	final requestId:String;
	final previousThreadId:String;
	final newSessionRequested:Bool;
	final chatWidgetThreadKnown:Bool;
	final appServerSessionAvailable:Bool;
	final threadChannelTracked:Bool;
	final listenerTaskTracked:Bool;
	final pendingRollbackBefore:Bool;
	final unsubscribeSucceeded:Bool;
	final opQueueLengthBefore:Int;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelFreshSessionPreviousConversationShutdownRequest {
	public final requestId:String;
	public final previousThreadId:String;
	public final newSessionRequested:Bool;
	public final chatWidgetThreadKnown:Bool;
	public final appServerSessionAvailable:Bool;
	public final threadChannelTracked:Bool;
	public final listenerTaskTracked:Bool;
	public final pendingRollbackBefore:Bool;
	public final unsubscribeSucceeded:Bool;
	public final opQueueLengthBefore:Int;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelFreshSessionPreviousConversationShutdownRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.previousThreadId = fields.previousThreadId == null ? "" : fields.previousThreadId;
		this.newSessionRequested = fields.newSessionRequested;
		this.chatWidgetThreadKnown = fields.chatWidgetThreadKnown;
		this.appServerSessionAvailable = fields.appServerSessionAvailable;
		this.threadChannelTracked = fields.threadChannelTracked;
		this.listenerTaskTracked = fields.listenerTaskTracked;
		this.pendingRollbackBefore = fields.pendingRollbackBefore;
		this.unsubscribeSucceeded = fields.unsubscribeSucceeded;
		this.opQueueLengthBefore = fields.opQueueLengthBefore;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
