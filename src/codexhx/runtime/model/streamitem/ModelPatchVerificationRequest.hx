package codexhx.runtime.model.streamitem;

class ModelPatchVerificationRequest {
	public final requestId:String;
	public final reducerOutcome:ModelStreamItemReducerOutcome;
	public final callId:String;
	public final turnId:String;
	public final autoApproved:Bool;
	public final desiredStatus:ModelPatchApplyStatus;
	public final stdout:String;
	public final stderr:String;
	public final files:Array<ModelPatchVirtualFile>;
	public final secretProbe:String;

	public function new(requestId:String, reducerOutcome:ModelStreamItemReducerOutcome, callId:String, turnId:String, autoApproved:Bool,
			desiredStatus:ModelPatchApplyStatus, stdout:String, stderr:String, files:Array<ModelPatchVirtualFile>, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.reducerOutcome = reducerOutcome;
		this.callId = callId == null ? "" : callId;
		this.turnId = turnId == null ? "" : turnId;
		this.autoApproved = autoApproved;
		this.desiredStatus = desiredStatus;
		this.stdout = stdout == null ? "" : stdout;
		this.stderr = stderr == null ? "" : stderr;
		this.files = files == null ? [] : files;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
