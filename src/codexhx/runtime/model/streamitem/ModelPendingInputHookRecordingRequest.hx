package codexhx.runtime.model.streamitem;

class ModelPendingInputHookRecordingRequest {
	public final requestId:String;
	public final drainOutcome:ModelPostSamplingPendingInputDrainOutcome;
	public final items:Array<ModelPendingInputHookRecordingItem>;
	public final secretProbe:String;

	public function new(
		requestId:String,
		drainOutcome:ModelPostSamplingPendingInputDrainOutcome,
		items:Array<ModelPendingInputHookRecordingItem>,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.drainOutcome = drainOutcome;
		this.items = items == null ? [] : items;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
