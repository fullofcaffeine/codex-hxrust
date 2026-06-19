package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadStartOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final cleanupRequestId:String;
	public final decisionKind:ModelThreadSideThreadStartDecisionKind;
	public final failureKind:ModelThreadSideThreadStartFailureKind;
	public final startBlocked:Bool;
	public final userMessageRestored:Bool;
	public final sideUiSynced:Bool;
	public final contextLabelCleared:Bool;
	public final telemetryRecorded:Bool;
	public final configRefreshAttempted:Bool;
	public final forkAttempted:Bool;
	public final forkConfigEphemeral:Bool;
	public final parentModelApplied:Bool;
	public final inheritedRuntimeSettings:Bool;
	public final developerInstructionsAppended:Bool;
	public final developerGuardrailsApplied:Bool;
	public final boundaryPromptItemBuilt:Bool;
	public final boundaryPromptInjected:Bool;
	public final snapshotInstalled:Bool;
	public final forkedParentTranscriptHidden:Bool;
	public final sideThreadRegistered:Bool;
	public final switchAttempted:Bool;
	public final discardCleanupAttempted:Bool;
	public final parentRestoreAttempted:Bool;
	public final userMessageSubmitted:Bool;
	public final errorMessageAdded:Bool;
	public final runControlContinue:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, cleanupRequestId:String, decisionKind:ModelThreadSideThreadStartDecisionKind,
			failureKind:ModelThreadSideThreadStartFailureKind, startBlocked:Bool, userMessageRestored:Bool, sideUiSynced:Bool, contextLabelCleared:Bool,
			telemetryRecorded:Bool, configRefreshAttempted:Bool, forkAttempted:Bool, forkConfigEphemeral:Bool, parentModelApplied:Bool,
			inheritedRuntimeSettings:Bool, developerInstructionsAppended:Bool, developerGuardrailsApplied:Bool, boundaryPromptItemBuilt:Bool,
			boundaryPromptInjected:Bool, snapshotInstalled:Bool, forkedParentTranscriptHidden:Bool, sideThreadRegistered:Bool, switchAttempted:Bool,
			discardCleanupAttempted:Bool, parentRestoreAttempted:Bool, userMessageSubmitted:Bool, errorMessageAdded:Bool, runControlContinue:Bool,
			eventOrderingPreserved:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.cleanupRequestId = cleanupRequestId == null ? "" : cleanupRequestId;
		this.decisionKind = decisionKind == null ? ModelThreadSideThreadStartDecisionKind.StartBlockedMainUnavailable : decisionKind;
		this.failureKind = failureKind == null ? ModelThreadSideThreadStartFailureKind.None : failureKind;
		this.startBlocked = startBlocked;
		this.userMessageRestored = userMessageRestored;
		this.sideUiSynced = sideUiSynced;
		this.contextLabelCleared = contextLabelCleared;
		this.telemetryRecorded = telemetryRecorded;
		this.configRefreshAttempted = configRefreshAttempted;
		this.forkAttempted = forkAttempted;
		this.forkConfigEphemeral = forkConfigEphemeral;
		this.parentModelApplied = parentModelApplied;
		this.inheritedRuntimeSettings = inheritedRuntimeSettings;
		this.developerInstructionsAppended = developerInstructionsAppended;
		this.developerGuardrailsApplied = developerGuardrailsApplied;
		this.boundaryPromptItemBuilt = boundaryPromptItemBuilt;
		this.boundaryPromptInjected = boundaryPromptInjected;
		this.snapshotInstalled = snapshotInstalled;
		this.forkedParentTranscriptHidden = forkedParentTranscriptHidden;
		this.sideThreadRegistered = sideThreadRegistered;
		this.switchAttempted = switchAttempted;
		this.discardCleanupAttempted = discardCleanupAttempted;
		this.parentRestoreAttempted = parentRestoreAttempted;
		this.userMessageSubmitted = userMessageSubmitted;
		this.errorMessageAdded = errorMessageAdded;
		this.runControlContinue = runControlContinue;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";cleanupRequest=" + noneIfEmpty(cleanupRequestId) + ";decisionKind="
			+ decisionKind + ";failureKind=" + failureKind + ";startBlocked=" + boolText(startBlocked) + ";userMessageRestored="
			+ boolText(userMessageRestored) + ";sideUiSynced=" + boolText(sideUiSynced) + ";contextLabelCleared=" + boolText(contextLabelCleared)
			+ ";telemetryRecorded=" + boolText(telemetryRecorded) + ";configRefreshAttempted=" + boolText(configRefreshAttempted) + ";forkAttempted="
			+ boolText(forkAttempted) + ";forkConfigEphemeral=" + boolText(forkConfigEphemeral) + ";parentModelApplied=" + boolText(parentModelApplied)
			+ ";inheritedRuntimeSettings=" + boolText(inheritedRuntimeSettings) + ";developerInstructionsAppended=" + boolText(developerInstructionsAppended)
			+ ";developerGuardrailsApplied=" + boolText(developerGuardrailsApplied) + ";boundaryPromptItemBuilt=" + boolText(boundaryPromptItemBuilt)
			+ ";boundaryPromptInjected=" + boolText(boundaryPromptInjected) + ";snapshotInstalled=" + boolText(snapshotInstalled)
			+ ";forkedParentTranscriptHidden=" + boolText(forkedParentTranscriptHidden) + ";sideThreadRegistered=" + boolText(sideThreadRegistered)
			+ ";switchAttempted=" + boolText(switchAttempted) + ";discardCleanupAttempted=" + boolText(discardCleanupAttempted) + ";parentRestoreAttempted="
			+ boolText(parentRestoreAttempted) + ";userMessageSubmitted=" + boolText(userMessageSubmitted) + ";errorMessageAdded="
			+ boolText(errorMessageAdded) + ";runControlContinue=" + boolText(runControlContinue) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
