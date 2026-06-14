package codexhx.runtime.model.streamitem;

class ModelThreadBufferedRequestEvictionRequest {
	public final requestId:String;
	public final deliveryOutcome:ModelAppServerQueuedRequestDeliveryOutcome;
	public final requestKind:ModelReplayedServerRequestKind;
	public final incomingEventKind:ModelThreadBufferedEventKind;
	public final evictedEventKind:ModelThreadBufferedEventKind;
	public final bufferCapacity:Int;
	public final bufferEventCountBefore:Int;
	public final incomingOrderIndex:Int;
	public final evictedOrderIndex:Int;
	public final targetRequestEvicted:Bool;
	public final targetRequestWasPendingInteractive:Bool;
	public final pendingReplayRecordedBefore:Bool;
	public final snapshotFilterChecked:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		deliveryOutcome:ModelAppServerQueuedRequestDeliveryOutcome,
		requestKind:ModelReplayedServerRequestKind,
		incomingEventKind:ModelThreadBufferedEventKind,
		evictedEventKind:ModelThreadBufferedEventKind,
		bufferCapacity:Int,
		bufferEventCountBefore:Int,
		incomingOrderIndex:Int,
		evictedOrderIndex:Int,
		targetRequestEvicted:Bool,
		targetRequestWasPendingInteractive:Bool,
		pendingReplayRecordedBefore:Bool,
		snapshotFilterChecked:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.deliveryOutcome = deliveryOutcome;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.incomingEventKind = incomingEventKind == null ? ModelThreadBufferedEventKind.Request : incomingEventKind;
		this.evictedEventKind = evictedEventKind == null ? ModelThreadBufferedEventKind.Notification : evictedEventKind;
		this.bufferCapacity = bufferCapacity < 0 ? 0 : bufferCapacity;
		this.bufferEventCountBefore = bufferEventCountBefore < 0 ? 0 : bufferEventCountBefore;
		this.incomingOrderIndex = incomingOrderIndex < 0 ? 0 : incomingOrderIndex;
		this.evictedOrderIndex = evictedOrderIndex < 0 ? 0 : evictedOrderIndex;
		this.targetRequestEvicted = targetRequestEvicted;
		this.targetRequestWasPendingInteractive = targetRequestWasPendingInteractive;
		this.pendingReplayRecordedBefore = pendingReplayRecordedBefore;
		this.snapshotFilterChecked = snapshotFilterChecked;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
