package codexhx.runtime.model.streamitem;

class ModelPostDrainEmissionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final emissionKind:ModelPostDrainEmissionKind;
	public final cancellationKind:ModelPostDrainCancellationKind;
	public final tokenCountPending:Bool;
	public final tokenCountProjected:Bool;
	public final tokenInfoAvailable:Bool;
	public final cancellationCheckedAfterTokenCount:Bool;
	public final turnDiffPending:Bool;
	public final turnDiffTrackerRead:Bool;
	public final unifiedDiffAvailable:Bool;
	public final turnDiffProjected:Bool;
	public final turnDiffSkippedByCancellation:Bool;
	public final turnDiffSkippedNoDiff:Bool;
	public final samplingOutcomeReturned:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, emissionKind:ModelPostDrainEmissionKind, cancellationKind:ModelPostDrainCancellationKind,
			tokenCountPending:Bool, tokenCountProjected:Bool, tokenInfoAvailable:Bool, cancellationCheckedAfterTokenCount:Bool, turnDiffPending:Bool,
			turnDiffTrackerRead:Bool, unifiedDiffAvailable:Bool, turnDiffProjected:Bool, turnDiffSkippedByCancellation:Bool, turnDiffSkippedNoDiff:Bool,
			samplingOutcomeReturned:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.emissionKind = emissionKind;
		this.cancellationKind = cancellationKind;
		this.tokenCountPending = tokenCountPending;
		this.tokenCountProjected = tokenCountProjected;
		this.tokenInfoAvailable = tokenInfoAvailable;
		this.cancellationCheckedAfterTokenCount = cancellationCheckedAfterTokenCount;
		this.turnDiffPending = turnDiffPending;
		this.turnDiffTrackerRead = turnDiffTrackerRead;
		this.unifiedDiffAvailable = unifiedDiffAvailable;
		this.turnDiffProjected = turnDiffProjected;
		this.turnDiffSkippedByCancellation = turnDiffSkippedByCancellation;
		this.turnDiffSkippedNoDiff = turnDiffSkippedNoDiff;
		this.samplingOutcomeReturned = samplingOutcomeReturned;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";emissionKind=" + emissionKind + ";cancellationKind=" + cancellationKind
			+ ";tokenCountPending=" + boolText(tokenCountPending) + ";tokenCountProjected=" + boolText(tokenCountProjected) + ";tokenInfoAvailable="
			+ boolText(tokenInfoAvailable) + ";cancellationCheckedAfterTokenCount=" + boolText(cancellationCheckedAfterTokenCount) + ";turnDiffPending="
			+ boolText(turnDiffPending) + ";turnDiffTrackerRead=" + boolText(turnDiffTrackerRead) + ";unifiedDiffAvailable=" + boolText(unifiedDiffAvailable)
			+ ";turnDiffProjected=" + boolText(turnDiffProjected) + ";turnDiffSkippedByCancellation=" + boolText(turnDiffSkippedByCancellation)
			+ ";turnDiffSkippedNoDiff=" + boolText(turnDiffSkippedNoDiff) + ";samplingOutcomeReturned=" + boolText(samplingOutcomeReturned)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
