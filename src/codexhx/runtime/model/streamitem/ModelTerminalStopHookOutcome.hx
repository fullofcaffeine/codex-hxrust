package codexhx.runtime.model.streamitem;

class ModelTerminalStopHookOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final integrationRequestId:String;
	public final promptPreparationRequestId:String;
	public final decisionKind:ModelTerminalStopHookDecisionKind;
	public final targetKind:ModelTerminalStopHookTargetKind;
	public final stopHooksEligible:Bool;
	public final stopHookDispatched:Bool;
	public final stopHookAlreadyActive:Bool;
	public final previewRunCount:Int;
	public final completedRunCount:Int;
	public final completedRunStatusKind:ModelTerminalStopHookRunStatusKind;
	public final hookStartedEventsProjected:Int;
	public final hookCompletedEventsProjected:Int;
	public final shouldBlock:Bool;
	public final continuationFragmentCount:Int;
	public final continuationPromptRecorded:Bool;
	public final warningEmitted:Bool;
	public final shouldStop:Bool;
	public final legacyAfterAgentRan:Bool;
	public final legacyAfterAgentAbort:Bool;
	public final lastAgentMessage:String;
	public final continueLoop:Bool;
	public final breakTurnLoop:Bool;
	public final errorEmitted:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, integrationRequestId:String, promptPreparationRequestId:String,
			decisionKind:ModelTerminalStopHookDecisionKind, targetKind:ModelTerminalStopHookTargetKind, stopHooksEligible:Bool, stopHookDispatched:Bool,
			stopHookAlreadyActive:Bool, previewRunCount:Int, completedRunCount:Int, completedRunStatusKind:ModelTerminalStopHookRunStatusKind,
			hookStartedEventsProjected:Int, hookCompletedEventsProjected:Int, shouldBlock:Bool, continuationFragmentCount:Int,
			continuationPromptRecorded:Bool, warningEmitted:Bool, shouldStop:Bool, legacyAfterAgentRan:Bool, legacyAfterAgentAbort:Bool,
			lastAgentMessage:String, continueLoop:Bool, breakTurnLoop:Bool, errorEmitted:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.integrationRequestId = integrationRequestId == null ? "" : integrationRequestId;
		this.promptPreparationRequestId = promptPreparationRequestId == null ? "" : promptPreparationRequestId;
		this.decisionKind = decisionKind == null ? ModelTerminalStopHookDecisionKind.Skipped : decisionKind;
		this.targetKind = targetKind == null ? ModelTerminalStopHookTargetKind.Stop : targetKind;
		this.stopHooksEligible = stopHooksEligible;
		this.stopHookDispatched = stopHookDispatched;
		this.stopHookAlreadyActive = stopHookAlreadyActive;
		this.previewRunCount = previewRunCount < 0 ? 0 : previewRunCount;
		this.completedRunCount = completedRunCount < 0 ? 0 : completedRunCount;
		this.completedRunStatusKind = completedRunStatusKind == null ? ModelTerminalStopHookRunStatusKind.Completed : completedRunStatusKind;
		this.hookStartedEventsProjected = hookStartedEventsProjected < 0 ? 0 : hookStartedEventsProjected;
		this.hookCompletedEventsProjected = hookCompletedEventsProjected < 0 ? 0 : hookCompletedEventsProjected;
		this.shouldBlock = shouldBlock;
		this.continuationFragmentCount = continuationFragmentCount < 0 ? 0 : continuationFragmentCount;
		this.continuationPromptRecorded = continuationPromptRecorded;
		this.warningEmitted = warningEmitted;
		this.shouldStop = shouldStop;
		this.legacyAfterAgentRan = legacyAfterAgentRan;
		this.legacyAfterAgentAbort = legacyAfterAgentAbort;
		this.lastAgentMessage = lastAgentMessage == null ? "" : lastAgentMessage;
		this.continueLoop = continueLoop;
		this.breakTurnLoop = breakTurnLoop;
		this.errorEmitted = errorEmitted;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";integrationRequest=" + integrationRequestId
			+ ";promptPreparationRequest=" + noneIfEmpty(promptPreparationRequestId) + ";decisionKind=" + decisionKind + ";targetKind=" + targetKind
			+ ";stopHooksEligible=" + boolText(stopHooksEligible) + ";stopHookDispatched=" + boolText(stopHookDispatched) + ";stopHookAlreadyActive="
			+ boolText(stopHookAlreadyActive) + ";previewRunCount=" + Std.string(previewRunCount) + ";completedRunCount=" + Std.string(completedRunCount)
			+ ";completedRunStatusKind=" + completedRunStatusKind + ";hookStartedEventsProjected=" + Std.string(hookStartedEventsProjected)
			+ ";hookCompletedEventsProjected=" + Std.string(hookCompletedEventsProjected) + ";shouldBlock=" + boolText(shouldBlock)
			+ ";continuationFragmentCount=" + Std.string(continuationFragmentCount) + ";continuationPromptRecorded=" + boolText(continuationPromptRecorded)
			+ ";warningEmitted=" + boolText(warningEmitted) + ";shouldStop=" + boolText(shouldStop) + ";legacyAfterAgentRan=" + boolText(legacyAfterAgentRan)
			+ ";legacyAfterAgentAbort=" + boolText(legacyAfterAgentAbort) + ";lastAgentMessage=" + noneIfEmpty(lastAgentMessage) + ";continueLoop="
			+ boolText(continueLoop) + ";breakTurnLoop=" + boolText(breakTurnLoop) + ";errorEmitted=" + boolText(errorEmitted) + ";liveNetworkAttempted="
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
