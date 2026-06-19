package codexhx.runtime.model.streamitem;

class ModelAppServerQueuedRequestDeliveryOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final enqueueRequestId:String;
	public final requestKind:ModelReplayedServerRequestKind;
	public final deliveryKind:ModelAppServerQueuedRequestDeliveryKind;
	public final requestStillPending:Bool;
	public final activeThreadEvent:Bool;
	public final replayKindAttached:Bool;
	public final chatWidgetRequestHandled:Bool;
	public final pendingCheckApplied:Bool;
	public final nonPendingSkipped:Bool;
	public final pendingPrimaryStillDeferred:Bool;
	public final replayStatePreserved:Bool;
	public final deliveryOrderingPreserved:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, enqueueRequestId:String, requestKind:ModelReplayedServerRequestKind,
			deliveryKind:ModelAppServerQueuedRequestDeliveryKind, requestStillPending:Bool, activeThreadEvent:Bool, replayKindAttached:Bool,
			chatWidgetRequestHandled:Bool, pendingCheckApplied:Bool, nonPendingSkipped:Bool, pendingPrimaryStillDeferred:Bool, replayStatePreserved:Bool,
			deliveryOrderingPreserved:Bool, liveOnlyEffectsSuppressed:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.enqueueRequestId = enqueueRequestId == null ? "" : enqueueRequestId;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.deliveryKind = deliveryKind == null ? ModelAppServerQueuedRequestDeliveryKind.NotQueuedSkipped : deliveryKind;
		this.requestStillPending = requestStillPending;
		this.activeThreadEvent = activeThreadEvent;
		this.replayKindAttached = replayKindAttached;
		this.chatWidgetRequestHandled = chatWidgetRequestHandled;
		this.pendingCheckApplied = pendingCheckApplied;
		this.nonPendingSkipped = nonPendingSkipped;
		this.pendingPrimaryStillDeferred = pendingPrimaryStillDeferred;
		this.replayStatePreserved = replayStatePreserved;
		this.deliveryOrderingPreserved = deliveryOrderingPreserved;
		this.liveOnlyEffectsSuppressed = liveOnlyEffectsSuppressed;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";enqueueRequest=" + noneIfEmpty(enqueueRequestId) + ";requestKind="
			+ requestKind + ";deliveryKind=" + deliveryKind + ";requestStillPending=" + boolText(requestStillPending) + ";activeThreadEvent="
			+ boolText(activeThreadEvent) + ";replayKindAttached=" + boolText(replayKindAttached) + ";chatWidgetRequestHandled="
			+ boolText(chatWidgetRequestHandled) + ";pendingCheckApplied=" + boolText(pendingCheckApplied) + ";nonPendingSkipped="
			+ boolText(nonPendingSkipped) + ";pendingPrimaryStillDeferred=" + boolText(pendingPrimaryStillDeferred) + ";replayStatePreserved="
			+ boolText(replayStatePreserved) + ";deliveryOrderingPreserved=" + boolText(deliveryOrderingPreserved) + ";liveOnlyEffectsSuppressed="
			+ boolText(liveOnlyEffectsSuppressed) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
