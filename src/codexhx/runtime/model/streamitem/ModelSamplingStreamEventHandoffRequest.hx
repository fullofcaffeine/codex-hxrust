package codexhx.runtime.model.streamitem;

class ModelSamplingStreamEventHandoffRequest {
	public final requestId:String;
	public final attemptOutcome:ModelSamplingStreamAttemptOutcome;
	public final reducerOutcome:ModelStreamItemReducerOutcome;
	public final streamClosedBeforeCompleted:Bool;
	public final inFlightToolCount:Int;
	public final tokenCountPending:Bool;
	public final turnDiffPending:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		attemptOutcome:ModelSamplingStreamAttemptOutcome,
		reducerOutcome:ModelStreamItemReducerOutcome,
		streamClosedBeforeCompleted:Bool,
		inFlightToolCount:Int,
		tokenCountPending:Bool,
		turnDiffPending:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.attemptOutcome = attemptOutcome;
		this.reducerOutcome = reducerOutcome;
		this.streamClosedBeforeCompleted = streamClosedBeforeCompleted;
		this.inFlightToolCount = inFlightToolCount < 0 ? 0 : inFlightToolCount;
		this.tokenCountPending = tokenCountPending;
		this.turnDiffPending = turnDiffPending;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
