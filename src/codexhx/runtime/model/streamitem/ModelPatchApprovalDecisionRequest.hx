package codexhx.runtime.model.streamitem;

class ModelPatchApprovalDecisionRequest {
	public final requestId:String;
	public final verificationOutcome:ModelPatchVerificationOutcome;
	public final applicationOutcome:ModelPatchApplicationOutcome;
	public final environmentId:String;
	public final approvalRequirement:ModelPatchApprovalRequirement;
	public final permissionsPreapproved:Bool;
	public final additionalPermissionRoot:String;
	public final retryReason:String;
	public final sandboxApprovalAllowed:Bool;
	public final sandboxAttempt:ModelPatchSandboxAttemptKind;
	public final sandboxDenied:Bool;
	public final reviewDecision:ModelPatchReviewDecision;
	public final secretProbe:String;

	public function new(requestId:String, verificationOutcome:ModelPatchVerificationOutcome, applicationOutcome:ModelPatchApplicationOutcome,
			environmentId:String, approvalRequirement:ModelPatchApprovalRequirement, permissionsPreapproved:Bool, additionalPermissionRoot:String,
			retryReason:String, sandboxApprovalAllowed:Bool, sandboxAttempt:ModelPatchSandboxAttemptKind, sandboxDenied:Bool,
			reviewDecision:ModelPatchReviewDecision, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.verificationOutcome = verificationOutcome;
		this.applicationOutcome = applicationOutcome;
		this.environmentId = environmentId == null ? "" : environmentId;
		this.approvalRequirement = approvalRequirement;
		this.permissionsPreapproved = permissionsPreapproved;
		this.additionalPermissionRoot = additionalPermissionRoot == null ? "" : additionalPermissionRoot;
		this.retryReason = retryReason == null ? "" : retryReason;
		this.sandboxApprovalAllowed = sandboxApprovalAllowed;
		this.sandboxAttempt = sandboxAttempt;
		this.sandboxDenied = sandboxDenied;
		this.reviewDecision = reviewDecision;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
