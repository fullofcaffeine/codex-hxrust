package codexhx.runtime.model.streamitem;

class ModelPatchApprovalDecisionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final approvalRequired:Bool;
	public final approvalRequestEmitted:Bool;
	public final canRun:Bool;
	public final sandboxPreference:String;
	public final escalatesOnFailure:Bool;
	public final sandboxRetryRequested:Bool;
	public final permissionRequestPayload:String;
	public final reviewDecision:ModelPatchReviewDecision;
	public final approvalKeys:Array<ModelPatchApprovalKey>;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, approvalRequired:Bool, approvalRequestEmitted:Bool, canRun:Bool, sandboxPreference:String,
			escalatesOnFailure:Bool, sandboxRetryRequested:Bool, permissionRequestPayload:String, reviewDecision:ModelPatchReviewDecision,
			approvalKeys:Array<ModelPatchApprovalKey>, liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool,
			errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.approvalRequired = approvalRequired;
		this.approvalRequestEmitted = approvalRequestEmitted;
		this.canRun = canRun;
		this.sandboxPreference = sandboxPreference == null ? "" : sandboxPreference;
		this.escalatesOnFailure = escalatesOnFailure;
		this.sandboxRetryRequested = sandboxRetryRequested;
		this.permissionRequestPayload = permissionRequestPayload == null ? "" : permissionRequestPayload;
		this.reviewDecision = reviewDecision;
		this.approvalKeys = approvalKeys == null ? [] : approvalKeys;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (key in approvalKeys)
			parts.push(key.summary());
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";approvalRequired=" + boolText(approvalRequired)
			+ ";approvalRequestEmitted=" + boolText(approvalRequestEmitted) + ";canRun=" + boolText(canRun) + ";sandboxPreference=" + sandboxPreference
			+ ";escalatesOnFailure=" + boolText(escalatesOnFailure) + ";sandboxRetryRequested=" + boolText(sandboxRetryRequested)
			+ ";permissionRequestPayload=" + permissionRequestPayload + ";reviewDecision=" + reviewDecision + ";approvalKeys=[" + parts.join("||") + "]"
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
