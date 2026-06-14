package codexhx.runtime.model.streamitem;

class ModelAppServerQueuedRequestDeliveryRequest {
	public final requestId:String;
	public final enqueueOutcome:ModelAppServerRequestEnqueueOutcome;
	public final requestKind:ModelReplayedServerRequestKind;
	public final requestStillPending:Bool;
	public final activeThreadEvent:Bool;
	public final replayDelivery:Bool;
	public final pendingPrimaryDrained:Bool;
	public final previousDeliveryCount:Int;
	public final deliveryOrderIndex:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		enqueueOutcome:ModelAppServerRequestEnqueueOutcome,
		requestKind:ModelReplayedServerRequestKind,
		requestStillPending:Bool,
		activeThreadEvent:Bool,
		replayDelivery:Bool,
		pendingPrimaryDrained:Bool,
		previousDeliveryCount:Int,
		deliveryOrderIndex:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.enqueueOutcome = enqueueOutcome;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.requestStillPending = requestStillPending;
		this.activeThreadEvent = activeThreadEvent;
		this.replayDelivery = replayDelivery;
		this.pendingPrimaryDrained = pendingPrimaryDrained;
		this.previousDeliveryCount = previousDeliveryCount < 0 ? 0 : previousDeliveryCount;
		this.deliveryOrderIndex = deliveryOrderIndex < 0 ? 0 : deliveryOrderIndex;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
