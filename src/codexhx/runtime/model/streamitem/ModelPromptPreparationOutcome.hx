package codexhx.runtime.model.streamitem;

class ModelPromptPreparationOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final hookRecordingRequestId:String;
	public final decisionKind:ModelPromptPreparationDecisionKind;
	public final promptPrepared:Bool;
	public final historyClonedForPrompt:Bool;
	public final forPromptNormalized:Bool;
	public final modelSupportsImages:Bool;
	public final imageItemCountBefore:Int;
	public final imageItemCountAfter:Int;
	public final promptItemCount:Int;
	public final recordedPendingInputCount:Int;
	public final nextSamplingRequestIndex:Int;
	public final currentWindowIdRead:Bool;
	public final windowId:String;
	public final turnMetadataHeaderPresent:Bool;
	public final dispatchPreconditionsMet:Bool;
	public final breakBeforePrompt:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, hookRecordingRequestId:String, decisionKind:ModelPromptPreparationDecisionKind,
			promptPrepared:Bool, historyClonedForPrompt:Bool, forPromptNormalized:Bool, modelSupportsImages:Bool, imageItemCountBefore:Int,
			imageItemCountAfter:Int, promptItemCount:Int, recordedPendingInputCount:Int, nextSamplingRequestIndex:Int, currentWindowIdRead:Bool,
			windowId:String, turnMetadataHeaderPresent:Bool, dispatchPreconditionsMet:Bool, breakBeforePrompt:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.hookRecordingRequestId = hookRecordingRequestId == null ? "" : hookRecordingRequestId;
		this.decisionKind = decisionKind == null ? ModelPromptPreparationDecisionKind.Skipped : decisionKind;
		this.promptPrepared = promptPrepared;
		this.historyClonedForPrompt = historyClonedForPrompt;
		this.forPromptNormalized = forPromptNormalized;
		this.modelSupportsImages = modelSupportsImages;
		this.imageItemCountBefore = imageItemCountBefore < 0 ? 0 : imageItemCountBefore;
		this.imageItemCountAfter = imageItemCountAfter < 0 ? 0 : imageItemCountAfter;
		this.promptItemCount = promptItemCount < 0 ? 0 : promptItemCount;
		this.recordedPendingInputCount = recordedPendingInputCount < 0 ? 0 : recordedPendingInputCount;
		this.nextSamplingRequestIndex = nextSamplingRequestIndex < 0 ? 0 : nextSamplingRequestIndex;
		this.currentWindowIdRead = currentWindowIdRead;
		this.windowId = windowId == null ? "" : windowId;
		this.turnMetadataHeaderPresent = turnMetadataHeaderPresent;
		this.dispatchPreconditionsMet = dispatchPreconditionsMet;
		this.breakBeforePrompt = breakBeforePrompt;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";hookRecordingRequest=" + hookRecordingRequestId + ";decisionKind="
			+ decisionKind + ";promptPrepared=" + boolText(promptPrepared) + ";historyClonedForPrompt=" + boolText(historyClonedForPrompt)
			+ ";forPromptNormalized=" + boolText(forPromptNormalized) + ";modelSupportsImages=" + boolText(modelSupportsImages) + ";imageItemCountBefore="
			+ Std.string(imageItemCountBefore) + ";imageItemCountAfter=" + Std.string(imageItemCountAfter) + ";promptItemCount="
			+ Std.string(promptItemCount) + ";recordedPendingInputCount=" + Std.string(recordedPendingInputCount) + ";nextSamplingRequestIndex="
			+ Std.string(nextSamplingRequestIndex) + ";currentWindowIdRead=" + boolText(currentWindowIdRead) + ";windowId=" + noneIfEmpty(windowId)
			+ ";turnMetadataHeaderPresent=" + boolText(turnMetadataHeaderPresent) + ";dispatchPreconditionsMet=" + boolText(dispatchPreconditionsMet)
			+ ";breakBeforePrompt=" + boolText(breakBeforePrompt) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
