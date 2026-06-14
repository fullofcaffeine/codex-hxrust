package codexhx.runtime.model.streamitem;

class ModelSamplingInputAssemblyOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final continuationKind:ModelSamplingContinuationKind;
	public final nextSamplingRequestIndex:Int;
	public final previousPromptItemCount:Int;
	public final assembledItemCount:Int;
	public final nextPromptItemCount:Int;
	public final responseInputItemCount:Int;
	public final pendingInputItemCount:Int;
	public final pendingInputDrained:Bool;
	public final historyClonedForPrompt:Bool;
	public final forPromptNormalized:Bool;
	public final modelSupportsImages:Bool;
	public final firstItemKind:ModelSamplingInputItemKind;
	public final lastItemKind:ModelSamplingInputItemKind;
	public final orderedItemSummary:String;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		continuationKind:ModelSamplingContinuationKind,
		nextSamplingRequestIndex:Int,
		previousPromptItemCount:Int,
		assembledItemCount:Int,
		nextPromptItemCount:Int,
		responseInputItemCount:Int,
		pendingInputItemCount:Int,
		pendingInputDrained:Bool,
		historyClonedForPrompt:Bool,
		forPromptNormalized:Bool,
		modelSupportsImages:Bool,
		firstItemKind:ModelSamplingInputItemKind,
		lastItemKind:ModelSamplingInputItemKind,
		orderedItemSummary:String,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.continuationKind = continuationKind;
		this.nextSamplingRequestIndex = nextSamplingRequestIndex;
		this.previousPromptItemCount = previousPromptItemCount;
		this.assembledItemCount = assembledItemCount;
		this.nextPromptItemCount = nextPromptItemCount;
		this.responseInputItemCount = responseInputItemCount;
		this.pendingInputItemCount = pendingInputItemCount;
		this.pendingInputDrained = pendingInputDrained;
		this.historyClonedForPrompt = historyClonedForPrompt;
		this.forPromptNormalized = forPromptNormalized;
		this.modelSupportsImages = modelSupportsImages;
		this.firstItemKind = firstItemKind;
		this.lastItemKind = lastItemKind;
		this.orderedItemSummary = orderedItemSummary == null ? "" : orderedItemSummary;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";continuationKind=" + continuationKind
			+ ";nextSamplingRequestIndex=" + Std.string(nextSamplingRequestIndex)
			+ ";previousPromptItemCount=" + Std.string(previousPromptItemCount)
			+ ";assembledItemCount=" + Std.string(assembledItemCount)
			+ ";nextPromptItemCount=" + Std.string(nextPromptItemCount)
			+ ";responseInputItemCount=" + Std.string(responseInputItemCount)
			+ ";pendingInputItemCount=" + Std.string(pendingInputItemCount)
			+ ";pendingInputDrained=" + boolText(pendingInputDrained)
			+ ";historyClonedForPrompt=" + boolText(historyClonedForPrompt)
			+ ";forPromptNormalized=" + boolText(forPromptNormalized)
			+ ";modelSupportsImages=" + boolText(modelSupportsImages)
			+ ";firstItemKind=" + firstItemKind
			+ ";lastItemKind=" + lastItemKind
			+ ";orderedItems=" + orderedItemSummary
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
