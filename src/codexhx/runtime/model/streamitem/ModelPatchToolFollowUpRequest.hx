package codexhx.runtime.model.streamitem;

class ModelPatchToolFollowUpRequest {
	public final requestId:String;
	public final reducerOutcome:ModelStreamItemReducerOutcome;
	public final applicationOutcome:ModelPatchApplicationOutcome;
	public final projectionOutcome:ModelPatchProjectionOutcome;
	public final secretProbe:String;

	public function new(
		requestId:String,
		reducerOutcome:ModelStreamItemReducerOutcome,
		applicationOutcome:ModelPatchApplicationOutcome,
		projectionOutcome:ModelPatchProjectionOutcome,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.reducerOutcome = reducerOutcome;
		this.applicationOutcome = applicationOutcome;
		this.projectionOutcome = projectionOutcome;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
