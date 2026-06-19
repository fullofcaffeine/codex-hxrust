package codexhx.runtime.model.streamitem;

class ModelAppServerResponseDispatchOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final resolutionRequestId:String;
	public final requestKind:ModelReplayedServerRequestKind;
	public final dispatchKind:ModelAppServerResponseDispatchKind;
	public final appServerRequestId:String;
	public final payloadKind:ModelAppServerRequestResolutionPayloadKind;
	public final appServerSessionAvailable:Bool;
	public final serializedPayloadAvailable:Bool;
	public final dispatchIntentRecorded:Bool;
	public final resolveServerRequestIntent:Bool;
	public final rejectServerRequestIntent:Bool;
	public final jsonRpcErrorPayloadBuilt:Bool;
	public final responseOrderingPreserved:Bool;
	public final pendingReplayStateRefreshRequested:Bool;
	public final missingSessionNoop:Bool;
	public final serializationRefused:Bool;
	public final dispatchFailureRecorded:Bool;
	public final liveTransportAttempted:Bool;
	public final liveTransportSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, resolutionRequestId:String, requestKind:ModelReplayedServerRequestKind,
			dispatchKind:ModelAppServerResponseDispatchKind, appServerRequestId:String, payloadKind:ModelAppServerRequestResolutionPayloadKind,
			appServerSessionAvailable:Bool, serializedPayloadAvailable:Bool, dispatchIntentRecorded:Bool, resolveServerRequestIntent:Bool,
			rejectServerRequestIntent:Bool, jsonRpcErrorPayloadBuilt:Bool, responseOrderingPreserved:Bool, pendingReplayStateRefreshRequested:Bool,
			missingSessionNoop:Bool, serializationRefused:Bool, dispatchFailureRecorded:Bool, liveTransportAttempted:Bool, liveTransportSuppressed:Bool,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.resolutionRequestId = resolutionRequestId == null ? "" : resolutionRequestId;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.dispatchKind = dispatchKind == null ? ModelAppServerResponseDispatchKind.ResolveResponse : dispatchKind;
		this.appServerRequestId = appServerRequestId == null ? "" : appServerRequestId;
		this.payloadKind = payloadKind == null ? ModelAppServerRequestResolutionPayloadKind.None : payloadKind;
		this.appServerSessionAvailable = appServerSessionAvailable;
		this.serializedPayloadAvailable = serializedPayloadAvailable;
		this.dispatchIntentRecorded = dispatchIntentRecorded;
		this.resolveServerRequestIntent = resolveServerRequestIntent;
		this.rejectServerRequestIntent = rejectServerRequestIntent;
		this.jsonRpcErrorPayloadBuilt = jsonRpcErrorPayloadBuilt;
		this.responseOrderingPreserved = responseOrderingPreserved;
		this.pendingReplayStateRefreshRequested = pendingReplayStateRefreshRequested;
		this.missingSessionNoop = missingSessionNoop;
		this.serializationRefused = serializationRefused;
		this.dispatchFailureRecorded = dispatchFailureRecorded;
		this.liveTransportAttempted = liveTransportAttempted;
		this.liveTransportSuppressed = liveTransportSuppressed;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";resolutionRequest=" + noneIfEmpty(resolutionRequestId) + ";requestKind="
			+ requestKind + ";dispatchKind=" + dispatchKind + ";appServerRequestId=" + noneIfEmpty(appServerRequestId) + ";payloadKind=" + payloadKind
			+ ";appServerSessionAvailable=" + boolText(appServerSessionAvailable) + ";serializedPayloadAvailable=" + boolText(serializedPayloadAvailable)
			+ ";dispatchIntentRecorded=" + boolText(dispatchIntentRecorded) + ";resolveServerRequestIntent=" + boolText(resolveServerRequestIntent)
			+ ";rejectServerRequestIntent=" + boolText(rejectServerRequestIntent) + ";jsonRpcErrorPayloadBuilt=" + boolText(jsonRpcErrorPayloadBuilt)
			+ ";responseOrderingPreserved=" + boolText(responseOrderingPreserved) + ";pendingReplayStateRefreshRequested="
			+ boolText(pendingReplayStateRefreshRequested) + ";missingSessionNoop=" + boolText(missingSessionNoop) + ";serializationRefused="
			+ boolText(serializationRefused) + ";dispatchFailureRecorded=" + boolText(dispatchFailureRecorded) + ";liveTransportAttempted="
			+ boolText(liveTransportAttempted) + ";liveTransportSuppressed=" + boolText(liveTransportSuppressed) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
