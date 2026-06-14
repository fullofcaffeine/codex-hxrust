package codexhx.runtime.model.streamitem;

class ModelThreadBufferedRequestEvictionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final deliveryRequestId:String;
	public final requestKind:ModelReplayedServerRequestKind;
	public final evictionKind:ModelThreadBufferedRequestEvictionKind;
	public final incomingEventKind:ModelThreadBufferedEventKind;
	public final evictedEventKind:ModelThreadBufferedEventKind;
	public final overCapacity:Bool;
	public final evictedRequestObserved:Bool;
	public final pendingPromptRemoved:Bool;
	public final pendingReplayRecordedAfter:Bool;
	public final snapshotRequestReplayed:Bool;
	public final replaySkippedAfterEviction:Bool;
	public final bufferCountAfter:Int;
	public final capacityPreserved:Bool;
	public final orderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		deliveryRequestId:String,
		requestKind:ModelReplayedServerRequestKind,
		evictionKind:ModelThreadBufferedRequestEvictionKind,
		incomingEventKind:ModelThreadBufferedEventKind,
		evictedEventKind:ModelThreadBufferedEventKind,
		overCapacity:Bool,
		evictedRequestObserved:Bool,
		pendingPromptRemoved:Bool,
		pendingReplayRecordedAfter:Bool,
		snapshotRequestReplayed:Bool,
		replaySkippedAfterEviction:Bool,
		bufferCountAfter:Int,
		capacityPreserved:Bool,
		orderingPreserved:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.deliveryRequestId = deliveryRequestId == null ? "" : deliveryRequestId;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.evictionKind = evictionKind == null ? ModelThreadBufferedRequestEvictionKind.BufferedRequestRetained : evictionKind;
		this.incomingEventKind = incomingEventKind == null ? ModelThreadBufferedEventKind.Request : incomingEventKind;
		this.evictedEventKind = evictedEventKind == null ? ModelThreadBufferedEventKind.Notification : evictedEventKind;
		this.overCapacity = overCapacity;
		this.evictedRequestObserved = evictedRequestObserved;
		this.pendingPromptRemoved = pendingPromptRemoved;
		this.pendingReplayRecordedAfter = pendingReplayRecordedAfter;
		this.snapshotRequestReplayed = snapshotRequestReplayed;
		this.replaySkippedAfterEviction = replaySkippedAfterEviction;
		this.bufferCountAfter = bufferCountAfter < 0 ? 0 : bufferCountAfter;
		this.capacityPreserved = capacityPreserved;
		this.orderingPreserved = orderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";deliveryRequest=" + noneIfEmpty(deliveryRequestId)
			+ ";requestKind=" + requestKind
			+ ";evictionKind=" + evictionKind
			+ ";incomingEventKind=" + incomingEventKind
			+ ";evictedEventKind=" + evictedEventKind
			+ ";overCapacity=" + boolText(overCapacity)
			+ ";evictedRequestObserved=" + boolText(evictedRequestObserved)
			+ ";pendingPromptRemoved=" + boolText(pendingPromptRemoved)
			+ ";pendingReplayRecordedAfter=" + boolText(pendingReplayRecordedAfter)
			+ ";snapshotRequestReplayed=" + boolText(snapshotRequestReplayed)
			+ ";replaySkippedAfterEviction=" + boolText(replaySkippedAfterEviction)
			+ ";bufferCountAfter=" + bufferCountAfter
			+ ";capacityPreserved=" + boolText(capacityPreserved)
			+ ";orderingPreserved=" + boolText(orderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
