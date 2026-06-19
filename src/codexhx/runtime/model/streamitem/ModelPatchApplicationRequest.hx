package codexhx.runtime.model.streamitem;

class ModelPatchApplicationRequest {
	public final requestId:String;
	public final verificationOutcome:ModelPatchVerificationOutcome;
	public final beforeFiles:Array<ModelPatchVirtualFile>;
	public final secretProbe:String;

	public function new(requestId:String, verificationOutcome:ModelPatchVerificationOutcome, beforeFiles:Array<ModelPatchVirtualFile>, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.verificationOutcome = verificationOutcome;
		this.beforeFiles = beforeFiles == null ? [] : beforeFiles;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
