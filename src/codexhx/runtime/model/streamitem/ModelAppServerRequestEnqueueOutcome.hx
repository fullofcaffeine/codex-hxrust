package codexhx.runtime.model.streamitem;

class ModelAppServerRequestEnqueueOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final responseDispatchRequestId:String;
	public final requestKind:ModelReplayedServerRequestKind;
	public final routeKind:ModelAppServerRequestEnqueueRouteKind;
	public final threadId:String;
	public final primaryThreadId:String;
	public final requestRecordedPending:Bool;
	public final primaryPendingEventQueued:Bool;
	public final primaryThreadRequestQueued:Bool;
	public final backgroundThreadRequestQueued:Bool;
	public final threadlessRequestIgnored:Bool;
	public final unsupportedAlreadyRejectedSkipped:Bool;
	public final enqueueFailureRecorded:Bool;
	public final pendingInteractiveReplayRecordingIntended:Bool;
	public final chatWidgetDeliveryIntended:Bool;
	public final sideParentStatusRefreshIntended:Bool;
	public final refreshPendingApprovalsIntended:Bool;
	public final requestOrderingPreserved:Bool;
	public final pendingPrimaryEventCountAfter:Int;
	public final threadQueueEventCountAfter:Int;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, responseDispatchRequestId:String, requestKind:ModelReplayedServerRequestKind,
			routeKind:ModelAppServerRequestEnqueueRouteKind, threadId:String, primaryThreadId:String, requestRecordedPending:Bool,
			primaryPendingEventQueued:Bool, primaryThreadRequestQueued:Bool, backgroundThreadRequestQueued:Bool, threadlessRequestIgnored:Bool,
			unsupportedAlreadyRejectedSkipped:Bool, enqueueFailureRecorded:Bool, pendingInteractiveReplayRecordingIntended:Bool,
			chatWidgetDeliveryIntended:Bool, sideParentStatusRefreshIntended:Bool, refreshPendingApprovalsIntended:Bool, requestOrderingPreserved:Bool,
			pendingPrimaryEventCountAfter:Int, threadQueueEventCountAfter:Int, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.responseDispatchRequestId = responseDispatchRequestId == null ? "" : responseDispatchRequestId;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.routeKind = routeKind == null ? ModelAppServerRequestEnqueueRouteKind.ThreadlessIgnored : routeKind;
		this.threadId = threadId == null ? "" : threadId;
		this.primaryThreadId = primaryThreadId == null ? "" : primaryThreadId;
		this.requestRecordedPending = requestRecordedPending;
		this.primaryPendingEventQueued = primaryPendingEventQueued;
		this.primaryThreadRequestQueued = primaryThreadRequestQueued;
		this.backgroundThreadRequestQueued = backgroundThreadRequestQueued;
		this.threadlessRequestIgnored = threadlessRequestIgnored;
		this.unsupportedAlreadyRejectedSkipped = unsupportedAlreadyRejectedSkipped;
		this.enqueueFailureRecorded = enqueueFailureRecorded;
		this.pendingInteractiveReplayRecordingIntended = pendingInteractiveReplayRecordingIntended;
		this.chatWidgetDeliveryIntended = chatWidgetDeliveryIntended;
		this.sideParentStatusRefreshIntended = sideParentStatusRefreshIntended;
		this.refreshPendingApprovalsIntended = refreshPendingApprovalsIntended;
		this.requestOrderingPreserved = requestOrderingPreserved;
		this.pendingPrimaryEventCountAfter = pendingPrimaryEventCountAfter < 0 ? 0 : pendingPrimaryEventCountAfter;
		this.threadQueueEventCountAfter = threadQueueEventCountAfter < 0 ? 0 : threadQueueEventCountAfter;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";responseDispatchRequest=" + noneIfEmpty(responseDispatchRequestId)
			+ ";requestKind=" + requestKind + ";routeKind=" + routeKind + ";threadId=" + noneIfEmpty(threadId) + ";primaryThreadId="
			+ noneIfEmpty(primaryThreadId) + ";requestRecordedPending=" + boolText(requestRecordedPending) + ";primaryPendingEventQueued="
			+ boolText(primaryPendingEventQueued) + ";primaryThreadRequestQueued=" + boolText(primaryThreadRequestQueued) + ";backgroundThreadRequestQueued="
			+ boolText(backgroundThreadRequestQueued) + ";threadlessRequestIgnored=" + boolText(threadlessRequestIgnored)
			+ ";unsupportedAlreadyRejectedSkipped=" + boolText(unsupportedAlreadyRejectedSkipped) + ";enqueueFailureRecorded="
			+ boolText(enqueueFailureRecorded) + ";pendingInteractiveReplayRecordingIntended=" + boolText(pendingInteractiveReplayRecordingIntended)
			+ ";chatWidgetDeliveryIntended=" + boolText(chatWidgetDeliveryIntended) + ";sideParentStatusRefreshIntended="
			+ boolText(sideParentStatusRefreshIntended) + ";refreshPendingApprovalsIntended=" + boolText(refreshPendingApprovalsIntended)
			+ ";requestOrderingPreserved=" + boolText(requestOrderingPreserved) + ";pendingPrimaryEventCountAfter=" + pendingPrimaryEventCountAfter
			+ ";threadQueueEventCountAfter=" + threadQueueEventCountAfter + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error="
			+ errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
