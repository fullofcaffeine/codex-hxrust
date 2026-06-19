package codexhx.runtime.model.streamitem;

class ModelPendingInputHookRecordingOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final drainRequestId:String;
	public final decisionKind:ModelPendingInputHookRecordingDecisionKind;
	public final hookItemCount:Int;
	public final blockedInput:Bool;
	public final acceptedUserInput:Bool;
	public final userInputRecordedCount:Int;
	public final responseItemRecordedCount:Int;
	public final additionalContextRecordedCount:Int;
	public final blockedAdditionalContextRecordedCount:Int;
	public final promptPrepContinues:Bool;
	public final breakBeforePrompt:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final orderedItemsSummary:String;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, drainRequestId:String, decisionKind:ModelPendingInputHookRecordingDecisionKind,
			hookItemCount:Int, blockedInput:Bool, acceptedUserInput:Bool, userInputRecordedCount:Int, responseItemRecordedCount:Int,
			additionalContextRecordedCount:Int, blockedAdditionalContextRecordedCount:Int, promptPrepContinues:Bool, breakBeforePrompt:Bool,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, orderedItemsSummary:String, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.drainRequestId = drainRequestId == null ? "" : drainRequestId;
		this.decisionKind = decisionKind == null ? ModelPendingInputHookRecordingDecisionKind.Skipped : decisionKind;
		this.hookItemCount = hookItemCount < 0 ? 0 : hookItemCount;
		this.blockedInput = blockedInput;
		this.acceptedUserInput = acceptedUserInput;
		this.userInputRecordedCount = userInputRecordedCount < 0 ? 0 : userInputRecordedCount;
		this.responseItemRecordedCount = responseItemRecordedCount < 0 ? 0 : responseItemRecordedCount;
		this.additionalContextRecordedCount = additionalContextRecordedCount < 0 ? 0 : additionalContextRecordedCount;
		this.blockedAdditionalContextRecordedCount = blockedAdditionalContextRecordedCount < 0 ? 0 : blockedAdditionalContextRecordedCount;
		this.promptPrepContinues = promptPrepContinues;
		this.breakBeforePrompt = breakBeforePrompt;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.orderedItemsSummary = orderedItemsSummary == null ? "" : orderedItemsSummary;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";drainRequest=" + drainRequestId + ";decisionKind=" + decisionKind
			+ ";hookItemCount=" + Std.string(hookItemCount) + ";blockedInput=" + boolText(blockedInput) + ";acceptedUserInput=" + boolText(acceptedUserInput)
			+ ";userInputRecordedCount=" + Std.string(userInputRecordedCount) + ";responseItemRecordedCount=" + Std.string(responseItemRecordedCount)
			+ ";additionalContextRecordedCount=" + Std.string(additionalContextRecordedCount) + ";blockedAdditionalContextRecordedCount="
			+ Std.string(blockedAdditionalContextRecordedCount) + ";promptPrepContinues=" + boolText(promptPrepContinues) + ";breakBeforePrompt="
			+ boolText(breakBeforePrompt) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";orderedItems=["
			+ orderedItemsSummary + "]" + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
