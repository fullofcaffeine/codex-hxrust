package codexhx.runtime.model.streamitem;

class ModelPatchTurnDiffTrackerRequest {
	public final requestId:String;
	public final verificationOutcome:ModelPatchVerificationOutcome;
	public final applicationOutcome:ModelPatchApplicationOutcome;
	public final approvalOutcome:ModelPatchApprovalDecisionOutcome;
	public final environmentId:String;
	public final stage:ModelPatchToolEventStageKind;
	public final appliedDelta:ModelPatchAppliedDelta;
	public final previousUnifiedDiff:String;
	public final secretProbe:String;

	public function new(
		requestId:String,
		verificationOutcome:ModelPatchVerificationOutcome,
		applicationOutcome:ModelPatchApplicationOutcome,
		approvalOutcome:ModelPatchApprovalDecisionOutcome,
		environmentId:String,
		stage:ModelPatchToolEventStageKind,
		appliedDelta:ModelPatchAppliedDelta,
		previousUnifiedDiff:String,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.verificationOutcome = verificationOutcome;
		this.applicationOutcome = applicationOutcome;
		this.approvalOutcome = approvalOutcome;
		this.environmentId = environmentId == null ? "" : environmentId;
		this.stage = stage;
		this.appliedDelta = appliedDelta;
		this.previousUnifiedDiff = previousUnifiedDiff == null ? "" : previousUnifiedDiff;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
