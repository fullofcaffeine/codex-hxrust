package codexhx.runtime.model.streamitem;

class ModelAppServerRequestResolutionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final surfaceRequestId:String;
	public final requestKind:ModelReplayedServerRequestKind;
	public final commandKind:ModelAppServerRequestResolutionCommandKind;
	public final payloadKind:ModelAppServerRequestResolutionPayloadKind;
	public final appServerRequestId:String;
	public final requestKey:String;
	public final commandKey:String;
	public final pendingRequestRecorded:Bool;
	public final commandMatchedPendingRequest:Bool;
	public final requestRemovedFromPending:Bool;
	public final serializedResponseIntentEmitted:Bool;
	public final execApprovalResolved:Bool;
	public final fileChangeApprovalResolved:Bool;
	public final permissionsResolved:Bool;
	public final userInputQueuePopped:Bool;
	public final userInputQueueLengthAfter:Int;
	public final resolvedUserInputItemId:String;
	public final mcpElicitationResolved:Bool;
	public final requestRemovedByNotification:Bool;
	public final duplicateOrMissingNoop:Bool;
	public final unsupportedRequestRejected:Bool;
	public final liveAppServerFanoutSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		surfaceRequestId:String,
		requestKind:ModelReplayedServerRequestKind,
		commandKind:ModelAppServerRequestResolutionCommandKind,
		payloadKind:ModelAppServerRequestResolutionPayloadKind,
		appServerRequestId:String,
		requestKey:String,
		commandKey:String,
		pendingRequestRecorded:Bool,
		commandMatchedPendingRequest:Bool,
		requestRemovedFromPending:Bool,
		serializedResponseIntentEmitted:Bool,
		execApprovalResolved:Bool,
		fileChangeApprovalResolved:Bool,
		permissionsResolved:Bool,
		userInputQueuePopped:Bool,
		userInputQueueLengthAfter:Int,
		resolvedUserInputItemId:String,
		mcpElicitationResolved:Bool,
		requestRemovedByNotification:Bool,
		duplicateOrMissingNoop:Bool,
		unsupportedRequestRejected:Bool,
		liveAppServerFanoutSuppressed:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.surfaceRequestId = surfaceRequestId == null ? "" : surfaceRequestId;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.commandKind = commandKind == null ? ModelAppServerRequestResolutionCommandKind.UserInputAnswer : commandKind;
		this.payloadKind = payloadKind == null ? ModelAppServerRequestResolutionPayloadKind.None : payloadKind;
		this.appServerRequestId = appServerRequestId == null ? "" : appServerRequestId;
		this.requestKey = requestKey == null ? "" : requestKey;
		this.commandKey = commandKey == null ? "" : commandKey;
		this.pendingRequestRecorded = pendingRequestRecorded;
		this.commandMatchedPendingRequest = commandMatchedPendingRequest;
		this.requestRemovedFromPending = requestRemovedFromPending;
		this.serializedResponseIntentEmitted = serializedResponseIntentEmitted;
		this.execApprovalResolved = execApprovalResolved;
		this.fileChangeApprovalResolved = fileChangeApprovalResolved;
		this.permissionsResolved = permissionsResolved;
		this.userInputQueuePopped = userInputQueuePopped;
		this.userInputQueueLengthAfter = userInputQueueLengthAfter < 0 ? 0 : userInputQueueLengthAfter;
		this.resolvedUserInputItemId = resolvedUserInputItemId == null ? "" : resolvedUserInputItemId;
		this.mcpElicitationResolved = mcpElicitationResolved;
		this.requestRemovedByNotification = requestRemovedByNotification;
		this.duplicateOrMissingNoop = duplicateOrMissingNoop;
		this.unsupportedRequestRejected = unsupportedRequestRejected;
		this.liveAppServerFanoutSuppressed = liveAppServerFanoutSuppressed;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";surfaceRequest=" + noneIfEmpty(surfaceRequestId)
			+ ";requestKind=" + requestKind
			+ ";commandKind=" + commandKind
			+ ";payloadKind=" + payloadKind
			+ ";appServerRequestId=" + noneIfEmpty(appServerRequestId)
			+ ";requestKey=" + noneIfEmpty(requestKey)
			+ ";commandKey=" + noneIfEmpty(commandKey)
			+ ";pendingRequestRecorded=" + boolText(pendingRequestRecorded)
			+ ";commandMatchedPendingRequest=" + boolText(commandMatchedPendingRequest)
			+ ";requestRemovedFromPending=" + boolText(requestRemovedFromPending)
			+ ";serializedResponseIntentEmitted=" + boolText(serializedResponseIntentEmitted)
			+ ";execApprovalResolved=" + boolText(execApprovalResolved)
			+ ";fileChangeApprovalResolved=" + boolText(fileChangeApprovalResolved)
			+ ";permissionsResolved=" + boolText(permissionsResolved)
			+ ";userInputQueuePopped=" + boolText(userInputQueuePopped)
			+ ";userInputQueueLengthAfter=" + userInputQueueLengthAfter
			+ ";resolvedUserInputItemId=" + noneIfEmpty(resolvedUserInputItemId)
			+ ";mcpElicitationResolved=" + boolText(mcpElicitationResolved)
			+ ";requestRemovedByNotification=" + boolText(requestRemovedByNotification)
			+ ";duplicateOrMissingNoop=" + boolText(duplicateOrMissingNoop)
			+ ";unsupportedRequestRejected=" + boolText(unsupportedRequestRejected)
			+ ";liveAppServerFanoutSuppressed=" + boolText(liveAppServerFanoutSuppressed)
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
