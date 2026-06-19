package codexhx.runtime.model.streamitem;

class ModelSamplingStreamEventHandoffOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final handoffKind:ModelSamplingStreamHandoffKind;
	public final eventClass:ModelSamplingStreamEventClassKind;
	public final attemptResultKind:ModelSamplingStreamAttemptResultKind;
	public final attemptErrorKind:ModelSamplingStreamErrorKind;
	public final terminal:Bool;
	public final turnEnded:Bool;
	public final continuationRequired:Bool;
	public final retryScheduled:Bool;
	public final unauthorizedRetryStatePrepared:Bool;
	public final streamEventsConsumed:Bool;
	public final responseCompleted:Bool;
	public final streamClosedBeforeCompleted:Bool;
	public final toolDrainRequired:Bool;
	public final tokenCountEventDeferredUntilToolDrain:Bool;
	public final turnDiffEventDeferredUntilToolDrain:Bool;
	public final needsFollowUp:Bool;
	public final terminalResponseId:String;
	public final totalTokens:Int;
	public final lastAgentMessage:String;
	public final dispatchAttemptIndex:Int;
	public final promptItemCount:Int;
	public final liveProviderRequestAttempted:Bool;
	public final providerStreamOpened:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, handoffKind:ModelSamplingStreamHandoffKind, eventClass:ModelSamplingStreamEventClassKind,
			attemptResultKind:ModelSamplingStreamAttemptResultKind, attemptErrorKind:ModelSamplingStreamErrorKind, terminal:Bool, turnEnded:Bool,
			continuationRequired:Bool, retryScheduled:Bool, unauthorizedRetryStatePrepared:Bool, streamEventsConsumed:Bool, responseCompleted:Bool,
			streamClosedBeforeCompleted:Bool, toolDrainRequired:Bool, tokenCountEventDeferredUntilToolDrain:Bool, turnDiffEventDeferredUntilToolDrain:Bool,
			needsFollowUp:Bool, terminalResponseId:String, totalTokens:Int, lastAgentMessage:String, dispatchAttemptIndex:Int, promptItemCount:Int,
			liveProviderRequestAttempted:Bool, providerStreamOpened:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.handoffKind = handoffKind;
		this.eventClass = eventClass;
		this.attemptResultKind = attemptResultKind;
		this.attemptErrorKind = attemptErrorKind;
		this.terminal = terminal;
		this.turnEnded = turnEnded;
		this.continuationRequired = continuationRequired;
		this.retryScheduled = retryScheduled;
		this.unauthorizedRetryStatePrepared = unauthorizedRetryStatePrepared;
		this.streamEventsConsumed = streamEventsConsumed;
		this.responseCompleted = responseCompleted;
		this.streamClosedBeforeCompleted = streamClosedBeforeCompleted;
		this.toolDrainRequired = toolDrainRequired;
		this.tokenCountEventDeferredUntilToolDrain = tokenCountEventDeferredUntilToolDrain;
		this.turnDiffEventDeferredUntilToolDrain = turnDiffEventDeferredUntilToolDrain;
		this.needsFollowUp = needsFollowUp;
		this.terminalResponseId = terminalResponseId == null ? "" : terminalResponseId;
		this.totalTokens = totalTokens;
		this.lastAgentMessage = lastAgentMessage == null ? "" : lastAgentMessage;
		this.dispatchAttemptIndex = dispatchAttemptIndex;
		this.promptItemCount = promptItemCount;
		this.liveProviderRequestAttempted = liveProviderRequestAttempted;
		this.providerStreamOpened = providerStreamOpened;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";handoffKind=" + handoffKind + ";eventClass=" + eventClass
			+ ";attemptResultKind=" + attemptResultKind + ";attemptErrorKind=" + attemptErrorKind + ";terminal=" + boolText(terminal) + ";turnEnded="
			+ boolText(turnEnded) + ";continuationRequired=" + boolText(continuationRequired) + ";retryScheduled=" + boolText(retryScheduled)
			+ ";unauthorizedRetryStatePrepared=" + boolText(unauthorizedRetryStatePrepared) + ";streamEventsConsumed=" + boolText(streamEventsConsumed)
			+ ";responseCompleted=" + boolText(responseCompleted) + ";streamClosedBeforeCompleted=" + boolText(streamClosedBeforeCompleted)
			+ ";toolDrainRequired=" + boolText(toolDrainRequired) + ";tokenCountEventDeferredUntilToolDrain="
			+ boolText(tokenCountEventDeferredUntilToolDrain) + ";turnDiffEventDeferredUntilToolDrain=" + boolText(turnDiffEventDeferredUntilToolDrain)
			+ ";needsFollowUp=" + boolText(needsFollowUp) + ";terminalResponseId=" + noneIfEmpty(terminalResponseId) + ";totalTokens="
			+ Std.string(totalTokens) + ";lastAgentMessage=" + noneIfEmpty(lastAgentMessage) + ";dispatchAttemptIndex=" + Std.string(dispatchAttemptIndex)
			+ ";promptItemCount=" + Std.string(promptItemCount) + ";liveProviderRequestAttempted=" + boolText(liveProviderRequestAttempted)
			+ ";providerStreamOpened=" + boolText(providerStreamOpened) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
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
