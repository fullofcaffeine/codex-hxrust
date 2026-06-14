package codexhx.runtime.model.streamitem;

class ModelSamplingContinuationRequest {
	public final requestId:String;
	public final responseInputOutcome:ModelPatchToolResponseInputOutcome;
	public final hasPendingInput:Bool;
	public final pendingInputCount:Int;
	public final tokenLimitReached:Bool;
	public final activeContextTokens:Int;
	public final estimatedTokenCount:Int;
	public final previousSamplingRequestCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		responseInputOutcome:ModelPatchToolResponseInputOutcome,
		hasPendingInput:Bool,
		pendingInputCount:Int,
		tokenLimitReached:Bool,
		activeContextTokens:Int,
		estimatedTokenCount:Int,
		previousSamplingRequestCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.responseInputOutcome = responseInputOutcome;
		this.hasPendingInput = hasPendingInput;
		this.pendingInputCount = pendingInputCount < 0 ? 0 : pendingInputCount;
		this.tokenLimitReached = tokenLimitReached;
		this.activeContextTokens = activeContextTokens < 0 ? 0 : activeContextTokens;
		this.estimatedTokenCount = estimatedTokenCount < 0 ? 0 : estimatedTokenCount;
		this.previousSamplingRequestCount = previousSamplingRequestCount < 0 ? 0 : previousSamplingRequestCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
