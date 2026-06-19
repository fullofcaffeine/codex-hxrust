package codexhx.runtime.model.streamitem;

class ModelPostDrainEmissionRequest {
	public final requestId:String;
	public final drainOutcome:ModelInFlightToolDrainOutcome;
	public final cancellationRequestedAfterDrain:Bool;
	public final unifiedDiffAvailable:Bool;
	public final tokenInfoAvailable:Bool;
	public final secretProbe:String;

	public function new(requestId:String, drainOutcome:ModelInFlightToolDrainOutcome, cancellationRequestedAfterDrain:Bool, unifiedDiffAvailable:Bool,
			tokenInfoAvailable:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.drainOutcome = drainOutcome;
		this.cancellationRequestedAfterDrain = cancellationRequestedAfterDrain;
		this.unifiedDiffAvailable = unifiedDiffAvailable;
		this.tokenInfoAvailable = tokenInfoAvailable;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
