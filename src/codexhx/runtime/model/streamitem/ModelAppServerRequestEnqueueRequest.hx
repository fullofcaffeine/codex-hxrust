package codexhx.runtime.model.streamitem;

class ModelAppServerRequestEnqueueRequest {
	public final requestId:String;
	public final responseDispatchOutcome:ModelAppServerResponseDispatchOutcome;
	public final requestKind:ModelReplayedServerRequestKind;
	public final threadId:String;
	public final primaryThreadId:String;
	public final primaryThreadKnown:Bool;
	public final activeThreadId:String;
	public final threadIdAvailable:Bool;
	public final pendingRequestRecorded:Bool;
	public final queueActive:Bool;
	public final enqueueSucceeds:Bool;
	public final pendingPrimaryEventCountBefore:Int;
	public final threadQueueEventCountBefore:Int;
	public final previousRequestCount:Int;
	public final requestOrderIndex:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		responseDispatchOutcome:ModelAppServerResponseDispatchOutcome,
		requestKind:ModelReplayedServerRequestKind,
		threadId:String,
		primaryThreadId:String,
		primaryThreadKnown:Bool,
		activeThreadId:String,
		threadIdAvailable:Bool,
		pendingRequestRecorded:Bool,
		queueActive:Bool,
		enqueueSucceeds:Bool,
		pendingPrimaryEventCountBefore:Int,
		threadQueueEventCountBefore:Int,
		previousRequestCount:Int,
		requestOrderIndex:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.responseDispatchOutcome = responseDispatchOutcome;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.threadId = threadId == null ? "" : threadId;
		this.primaryThreadId = primaryThreadId == null ? "" : primaryThreadId;
		this.primaryThreadKnown = primaryThreadKnown;
		this.activeThreadId = activeThreadId == null ? "" : activeThreadId;
		this.threadIdAvailable = threadIdAvailable;
		this.pendingRequestRecorded = pendingRequestRecorded;
		this.queueActive = queueActive;
		this.enqueueSucceeds = enqueueSucceeds;
		this.pendingPrimaryEventCountBefore = pendingPrimaryEventCountBefore < 0 ? 0 : pendingPrimaryEventCountBefore;
		this.threadQueueEventCountBefore = threadQueueEventCountBefore < 0 ? 0 : threadQueueEventCountBefore;
		this.previousRequestCount = previousRequestCount < 0 ? 0 : previousRequestCount;
		this.requestOrderIndex = requestOrderIndex < 0 ? 0 : requestOrderIndex;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
