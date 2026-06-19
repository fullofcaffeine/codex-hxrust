package codexhx.runtime.model.streamitem;

class ModelSamplingInputAssemblyRequest {
	public final requestId:String;
	public final responseInputOutcome:ModelPatchToolResponseInputOutcome;
	public final continuationOutcome:ModelSamplingContinuationOutcome;
	public final pendingInputItems:Array<ModelSamplingInputItem>;
	public final previousPromptItemCount:Int;
	public final modelSupportsImages:Bool;
	public final secretProbe:String;

	public function new(requestId:String, responseInputOutcome:ModelPatchToolResponseInputOutcome, continuationOutcome:ModelSamplingContinuationOutcome,
			pendingInputItems:Array<ModelSamplingInputItem>, previousPromptItemCount:Int, modelSupportsImages:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.responseInputOutcome = responseInputOutcome;
		this.continuationOutcome = continuationOutcome;
		this.pendingInputItems = pendingInputItems == null ? [] : pendingInputItems;
		this.previousPromptItemCount = previousPromptItemCount < 0 ? 0 : previousPromptItemCount;
		this.modelSupportsImages = modelSupportsImages;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
