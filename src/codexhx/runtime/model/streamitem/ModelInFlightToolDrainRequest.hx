package codexhx.runtime.model.streamitem;

class ModelInFlightToolDrainRequest {
	public final requestId:String;
	public final handoffOutcome:ModelSamplingStreamEventHandoffOutcome;
	public final responseInputOutcome:ModelPatchToolResponseInputOutcome;
	public final items:Array<ModelInFlightToolDrainItem>;
	public final tokenCountPending:Bool;
	public final turnDiffPending:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		handoffOutcome:ModelSamplingStreamEventHandoffOutcome,
		responseInputOutcome:ModelPatchToolResponseInputOutcome,
		items:Array<ModelInFlightToolDrainItem>,
		tokenCountPending:Bool,
		turnDiffPending:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.handoffOutcome = handoffOutcome;
		this.responseInputOutcome = responseInputOutcome;
		this.items = items == null ? [] : items;
		this.tokenCountPending = tokenCountPending;
		this.turnDiffPending = turnDiffPending;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
