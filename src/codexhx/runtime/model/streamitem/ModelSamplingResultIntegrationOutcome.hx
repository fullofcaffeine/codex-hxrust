package codexhx.runtime.model.streamitem;

class ModelSamplingResultIntegrationOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelSamplingResultIntegrationDecisionKind;
	public final statusKind:ModelSamplingResultIntegrationStatusKind;
	public final modelNeedsFollowUp:Bool;
	public final hasPendingInput:Bool;
	public final needsFollowUp:Bool;
	public final pendingInputDrainEnabled:Bool;
	public final canDrainPendingInputAfterAutoCompact:Bool;
	public final tokenLimitReached:Bool;
	public final lastAgentMessageUpdated:Bool;
	public final lastAgentMessage:String;
	public final previousLastAgentMessage:String;
	public final samplingOutcomeReturned:Bool;
	public final stopHooksEligible:Bool;
	public final continueLoop:Bool;
	public final breakTurnLoop:Bool;
	public final bypassedForCancellation:Bool;
	public final bypassedForError:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		decisionKind:ModelSamplingResultIntegrationDecisionKind,
		statusKind:ModelSamplingResultIntegrationStatusKind,
		modelNeedsFollowUp:Bool,
		hasPendingInput:Bool,
		needsFollowUp:Bool,
		pendingInputDrainEnabled:Bool,
		canDrainPendingInputAfterAutoCompact:Bool,
		tokenLimitReached:Bool,
		lastAgentMessageUpdated:Bool,
		lastAgentMessage:String,
		previousLastAgentMessage:String,
		samplingOutcomeReturned:Bool,
		stopHooksEligible:Bool,
		continueLoop:Bool,
		breakTurnLoop:Bool,
		bypassedForCancellation:Bool,
		bypassedForError:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.decisionKind = decisionKind;
		this.statusKind = statusKind;
		this.modelNeedsFollowUp = modelNeedsFollowUp;
		this.hasPendingInput = hasPendingInput;
		this.needsFollowUp = needsFollowUp;
		this.pendingInputDrainEnabled = pendingInputDrainEnabled;
		this.canDrainPendingInputAfterAutoCompact = canDrainPendingInputAfterAutoCompact;
		this.tokenLimitReached = tokenLimitReached;
		this.lastAgentMessageUpdated = lastAgentMessageUpdated;
		this.lastAgentMessage = lastAgentMessage == null ? "" : lastAgentMessage;
		this.previousLastAgentMessage = previousLastAgentMessage == null ? "" : previousLastAgentMessage;
		this.samplingOutcomeReturned = samplingOutcomeReturned;
		this.stopHooksEligible = stopHooksEligible;
		this.continueLoop = continueLoop;
		this.breakTurnLoop = breakTurnLoop;
		this.bypassedForCancellation = bypassedForCancellation;
		this.bypassedForError = bypassedForError;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";decisionKind=" + decisionKind
			+ ";statusKind=" + statusKind
			+ ";modelNeedsFollowUp=" + boolText(modelNeedsFollowUp)
			+ ";hasPendingInput=" + boolText(hasPendingInput)
			+ ";needsFollowUp=" + boolText(needsFollowUp)
			+ ";pendingInputDrainEnabled=" + boolText(pendingInputDrainEnabled)
			+ ";canDrainPendingInputAfterAutoCompact=" + boolText(canDrainPendingInputAfterAutoCompact)
			+ ";tokenLimitReached=" + boolText(tokenLimitReached)
			+ ";lastAgentMessageUpdated=" + boolText(lastAgentMessageUpdated)
			+ ";lastAgentMessage=" + noneIfEmpty(lastAgentMessage)
			+ ";previousLastAgentMessage=" + noneIfEmpty(previousLastAgentMessage)
			+ ";samplingOutcomeReturned=" + boolText(samplingOutcomeReturned)
			+ ";stopHooksEligible=" + boolText(stopHooksEligible)
			+ ";continueLoop=" + boolText(continueLoop)
			+ ";breakTurnLoop=" + boolText(breakTurnLoop)
			+ ";bypassedForCancellation=" + boolText(bypassedForCancellation)
			+ ";bypassedForError=" + boolText(bypassedForError)
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
