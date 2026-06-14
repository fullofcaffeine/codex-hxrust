package codexhx.runtime.model.streamitem;

class ModelPatchToolResponseInputRequest {
	public final requestId:String;
	public final followUpOutcome:ModelPatchToolFollowUpOutcome;
	public final previousResponseCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		followUpOutcome:ModelPatchToolFollowUpOutcome,
		previousResponseCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.followUpOutcome = followUpOutcome;
		this.previousResponseCount = previousResponseCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
