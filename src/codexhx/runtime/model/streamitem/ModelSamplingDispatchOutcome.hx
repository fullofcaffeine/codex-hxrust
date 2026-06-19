package codexhx.runtime.model.streamitem;

class ModelSamplingDispatchOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final transportKind:ModelSamplingDispatchTransportKind;
	public final windowId:String;
	public final turnMetadataHeaderPresent:Bool;
	public final nextSamplingRequestIndex:Int;
	public final promptItemCount:Int;
	public final assembledItemCount:Int;
	public final dispatchAttemptIndex:Int;
	public final maxRetries:Int;
	public final retryStateInitialized:Bool;
	public final modelClientSessionTurnScoped:Bool;
	public final modelClientSessionReused:Bool;
	public final stickyRoutingTokenPreserved:Bool;
	public final cancellationChildTokenCreated:Bool;
	public final promptOrderingPreserved:Bool;
	public final liveProviderRequestAttempted:Bool;
	public final providerStreamOpened:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, transportKind:ModelSamplingDispatchTransportKind, windowId:String,
			turnMetadataHeaderPresent:Bool, nextSamplingRequestIndex:Int, promptItemCount:Int, assembledItemCount:Int, dispatchAttemptIndex:Int,
			maxRetries:Int, retryStateInitialized:Bool, modelClientSessionTurnScoped:Bool, modelClientSessionReused:Bool, stickyRoutingTokenPreserved:Bool,
			cancellationChildTokenCreated:Bool, promptOrderingPreserved:Bool, liveProviderRequestAttempted:Bool, providerStreamOpened:Bool,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.transportKind = transportKind;
		this.windowId = windowId == null ? "" : windowId;
		this.turnMetadataHeaderPresent = turnMetadataHeaderPresent;
		this.nextSamplingRequestIndex = nextSamplingRequestIndex;
		this.promptItemCount = promptItemCount;
		this.assembledItemCount = assembledItemCount;
		this.dispatchAttemptIndex = dispatchAttemptIndex;
		this.maxRetries = maxRetries;
		this.retryStateInitialized = retryStateInitialized;
		this.modelClientSessionTurnScoped = modelClientSessionTurnScoped;
		this.modelClientSessionReused = modelClientSessionReused;
		this.stickyRoutingTokenPreserved = stickyRoutingTokenPreserved;
		this.cancellationChildTokenCreated = cancellationChildTokenCreated;
		this.promptOrderingPreserved = promptOrderingPreserved;
		this.liveProviderRequestAttempted = liveProviderRequestAttempted;
		this.providerStreamOpened = providerStreamOpened;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";transportKind=" + transportKind + ";windowId=" + windowId
			+ ";turnMetadataHeaderPresent=" + boolText(turnMetadataHeaderPresent) + ";nextSamplingRequestIndex=" + Std.string(nextSamplingRequestIndex)
			+ ";promptItemCount=" + Std.string(promptItemCount) + ";assembledItemCount=" + Std.string(assembledItemCount) + ";dispatchAttemptIndex="
			+ Std.string(dispatchAttemptIndex) + ";maxRetries=" + Std.string(maxRetries) + ";retryStateInitialized=" + boolText(retryStateInitialized)
			+ ";modelClientSessionTurnScoped=" + boolText(modelClientSessionTurnScoped) + ";modelClientSessionReused=" + boolText(modelClientSessionReused)
			+ ";stickyRoutingTokenPreserved=" + boolText(stickyRoutingTokenPreserved) + ";cancellationChildTokenCreated="
			+ boolText(cancellationChildTokenCreated) + ";promptOrderingPreserved=" + boolText(promptOrderingPreserved) + ";liveProviderRequestAttempted="
			+ boolText(liveProviderRequestAttempted) + ";providerStreamOpened=" + boolText(providerStreamOpened) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
