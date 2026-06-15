package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadComposerHandoffOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final startRequestId:String;
	public final startupRoutingRequestId:String;
	public final decisionKind:ModelThreadSideThreadComposerHandoffDecisionKind;
	public final userMessagePreserved:Bool;
	public final restoreAttempted:Bool;
	public final composerMutated:Bool;
	public final composerTextAfter:String;
	public final submittedAsPlainUserTurn:Bool;
	public final duplicateSubmissionPrevented:Bool;
	public final sideUiSynced:Bool;
	public final contextLabelCleared:Bool;
	public final errorMessageDisplayed:Bool;
	public final runControlContinue:Bool;
	public final startupRoutingComposed:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		startRequestId:String,
		startupRoutingRequestId:String,
		decisionKind:ModelThreadSideThreadComposerHandoffDecisionKind,
		userMessagePreserved:Bool,
		restoreAttempted:Bool,
		composerMutated:Bool,
		composerTextAfter:String,
		submittedAsPlainUserTurn:Bool,
		duplicateSubmissionPrevented:Bool,
		sideUiSynced:Bool,
		contextLabelCleared:Bool,
		errorMessageDisplayed:Bool,
		runControlContinue:Bool,
		startupRoutingComposed:Bool,
		eventOrderingPreserved:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.startRequestId = startRequestId == null ? "" : startRequestId;
		this.startupRoutingRequestId = startupRoutingRequestId == null ? "" : startupRoutingRequestId;
		this.decisionKind = decisionKind == null ? ModelThreadSideThreadComposerHandoffDecisionKind.NoUserMessageNoop : decisionKind;
		this.userMessagePreserved = userMessagePreserved;
		this.restoreAttempted = restoreAttempted;
		this.composerMutated = composerMutated;
		this.composerTextAfter = composerTextAfter == null ? "" : composerTextAfter;
		this.submittedAsPlainUserTurn = submittedAsPlainUserTurn;
		this.duplicateSubmissionPrevented = duplicateSubmissionPrevented;
		this.sideUiSynced = sideUiSynced;
		this.contextLabelCleared = contextLabelCleared;
		this.errorMessageDisplayed = errorMessageDisplayed;
		this.runControlContinue = runControlContinue;
		this.startupRoutingComposed = startupRoutingComposed;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";startRequest=" + noneIfEmpty(startRequestId)
			+ ";startupRoutingRequest=" + noneIfEmpty(startupRoutingRequestId)
			+ ";decisionKind=" + decisionKind
			+ ";userMessagePreserved=" + boolText(userMessagePreserved)
			+ ";restoreAttempted=" + boolText(restoreAttempted)
			+ ";composerMutated=" + boolText(composerMutated)
			+ ";composerTextAfter=" + noneIfEmpty(composerTextAfter)
			+ ";submittedAsPlainUserTurn=" + boolText(submittedAsPlainUserTurn)
			+ ";duplicateSubmissionPrevented=" + boolText(duplicateSubmissionPrevented)
			+ ";sideUiSynced=" + boolText(sideUiSynced)
			+ ";contextLabelCleared=" + boolText(contextLabelCleared)
			+ ";errorMessageDisplayed=" + boolText(errorMessageDisplayed)
			+ ";runControlContinue=" + boolText(runControlContinue)
			+ ";startupRoutingComposed=" + boolText(startupRoutingComposed)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
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
