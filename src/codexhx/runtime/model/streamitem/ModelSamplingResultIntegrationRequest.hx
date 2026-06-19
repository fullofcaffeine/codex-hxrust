package codexhx.runtime.model.streamitem;

class ModelSamplingResultIntegrationRequest {
	public final requestId:String;
	public final postDrainEmissionOutcome:ModelPostDrainEmissionOutcome;
	public final modelNeedsFollowUp:Bool;
	public final hasPendingInput:Bool;
	public final pendingInputCount:Int;
	public final tokenLimitReached:Bool;
	public final lastAgentMessage:String;
	public final previousLastAgentMessage:String;
	public final statusKind:ModelSamplingResultIntegrationStatusKind;
	public final secretProbe:String;

	public function new(requestId:String, postDrainEmissionOutcome:ModelPostDrainEmissionOutcome, modelNeedsFollowUp:Bool, hasPendingInput:Bool,
			pendingInputCount:Int, tokenLimitReached:Bool, lastAgentMessage:String, previousLastAgentMessage:String,
			statusKind:ModelSamplingResultIntegrationStatusKind, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.postDrainEmissionOutcome = postDrainEmissionOutcome;
		this.modelNeedsFollowUp = modelNeedsFollowUp;
		this.hasPendingInput = hasPendingInput;
		this.pendingInputCount = pendingInputCount < 0 ? 0 : pendingInputCount;
		this.tokenLimitReached = tokenLimitReached;
		this.lastAgentMessage = lastAgentMessage == null ? "" : lastAgentMessage;
		this.previousLastAgentMessage = previousLastAgentMessage == null ? "" : previousLastAgentMessage;
		this.statusKind = statusKind == null ? ModelSamplingResultIntegrationStatusKind.Ok : statusKind;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
