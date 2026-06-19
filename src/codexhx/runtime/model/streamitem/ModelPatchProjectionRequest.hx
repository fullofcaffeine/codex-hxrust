package codexhx.runtime.model.streamitem;

class ModelPatchProjectionRequest {
	public final requestId:String;
	public final verificationOutcome:ModelPatchVerificationOutcome;
	public final applicationOutcome:ModelPatchApplicationOutcome;
	public final approvalOutcome:ModelPatchApprovalDecisionOutcome;
	public final trackerOutcome:ModelPatchTurnDiffTrackerOutcome;
	public final includeLegacyEvents:Bool;
	public final secretProbe:String;

	public function new(requestId:String, verificationOutcome:ModelPatchVerificationOutcome, applicationOutcome:ModelPatchApplicationOutcome,
			approvalOutcome:ModelPatchApprovalDecisionOutcome, trackerOutcome:ModelPatchTurnDiffTrackerOutcome, includeLegacyEvents:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.verificationOutcome = verificationOutcome;
		this.applicationOutcome = applicationOutcome;
		this.approvalOutcome = approvalOutcome;
		this.trackerOutcome = trackerOutcome;
		this.includeLegacyEvents = includeLegacyEvents;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
