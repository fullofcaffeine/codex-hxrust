package codexhx.runtime.model.streamitem;

class ModelSamplingErrorTerminalOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final errorKind:ModelSamplingErrorTerminalKind;
	public final decisionKind:ModelSamplingErrorTerminalDecisionKind;
	public final terminalStopHookRequestId:String;
	public final stopHooksBypassed:Bool;
	public final turnAborted:Bool;
	public final invalidImageSanitizationAttempted:Bool;
	public final historyImagesReplaced:Bool;
	public final retrySamplingLoop:Bool;
	public final codexErrorTracked:Bool;
	public final lifecycleErrorEmitted:Bool;
	public final errorEventEmitted:Bool;
	public final codexErrorInfo:String;
	public final lastAgentMessagePreserved:Bool;
	public final lastAgentMessage:String;
	public final continueLoop:Bool;
	public final breakTurnLoop:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, errorKind:ModelSamplingErrorTerminalKind, decisionKind:ModelSamplingErrorTerminalDecisionKind,
			terminalStopHookRequestId:String, stopHooksBypassed:Bool, turnAborted:Bool, invalidImageSanitizationAttempted:Bool, historyImagesReplaced:Bool,
			retrySamplingLoop:Bool, codexErrorTracked:Bool, lifecycleErrorEmitted:Bool, errorEventEmitted:Bool, codexErrorInfo:String,
			lastAgentMessagePreserved:Bool, lastAgentMessage:String, continueLoop:Bool, breakTurnLoop:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.errorKind = errorKind == null ? ModelSamplingErrorTerminalKind.GenericCodexError : errorKind;
		this.decisionKind = decisionKind == null ? ModelSamplingErrorTerminalDecisionKind.EmitErrorAndBreak : decisionKind;
		this.terminalStopHookRequestId = terminalStopHookRequestId == null ? "" : terminalStopHookRequestId;
		this.stopHooksBypassed = stopHooksBypassed;
		this.turnAborted = turnAborted;
		this.invalidImageSanitizationAttempted = invalidImageSanitizationAttempted;
		this.historyImagesReplaced = historyImagesReplaced;
		this.retrySamplingLoop = retrySamplingLoop;
		this.codexErrorTracked = codexErrorTracked;
		this.lifecycleErrorEmitted = lifecycleErrorEmitted;
		this.errorEventEmitted = errorEventEmitted;
		this.codexErrorInfo = codexErrorInfo == null ? "" : codexErrorInfo;
		this.lastAgentMessagePreserved = lastAgentMessagePreserved;
		this.lastAgentMessage = lastAgentMessage == null ? "" : lastAgentMessage;
		this.continueLoop = continueLoop;
		this.breakTurnLoop = breakTurnLoop;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";errorKind=" + errorKind + ";decisionKind=" + decisionKind
			+ ";terminalStopHookRequest=" + noneIfEmpty(terminalStopHookRequestId) + ";stopHooksBypassed=" + boolText(stopHooksBypassed) + ";turnAborted="
			+ boolText(turnAborted) + ";invalidImageSanitizationAttempted=" + boolText(invalidImageSanitizationAttempted) + ";historyImagesReplaced="
			+ boolText(historyImagesReplaced) + ";retrySamplingLoop=" + boolText(retrySamplingLoop) + ";codexErrorTracked=" + boolText(codexErrorTracked)
			+ ";lifecycleErrorEmitted=" + boolText(lifecycleErrorEmitted) + ";errorEventEmitted=" + boolText(errorEventEmitted) + ";codexErrorInfo="
			+ noneIfEmpty(codexErrorInfo) + ";lastAgentMessagePreserved=" + boolText(lastAgentMessagePreserved) + ";lastAgentMessage="
			+ noneIfEmpty(lastAgentMessage) + ";continueLoop=" + boolText(continueLoop) + ";breakTurnLoop=" + boolText(breakTurnLoop)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
