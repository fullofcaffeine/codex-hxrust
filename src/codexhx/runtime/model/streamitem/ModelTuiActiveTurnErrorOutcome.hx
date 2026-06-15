package codexhx.runtime.model.streamitem;

typedef ModelTuiActiveTurnErrorOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final requestKind:ModelTuiActiveTurnErrorRequestKind;
	final decisionKind:ModelTuiActiveTurnErrorDecisionKind;
	final method:String;
	final turnKind:ModelTuiActiveTurnErrorTurnKind;
	final userVisibleMessage:String;
	final sanitizedSessionMessage:String;
	final actualTurnId:String;
	final structuredTurnErrorExtracted:Bool;
	final steerRaceDetected:Bool;
	final interruptRaceDetected:Bool;
	final archivedGuidanceDetected:Bool;
	final shouldClearCachedActiveTurn:Bool;
	final shouldStartNewTurn:Bool;
	final shouldRetryWithActualTurn:Bool;
	final shouldQueueRejectedSteer:Bool;
	final shouldDisplayErrorMessage:Bool;
	final rolloutPathLeaked:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelTuiActiveTurnErrorOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final requestKind:ModelTuiActiveTurnErrorRequestKind;
	public final decisionKind:ModelTuiActiveTurnErrorDecisionKind;
	public final method:String;
	public final turnKind:ModelTuiActiveTurnErrorTurnKind;
	public final userVisibleMessage:String;
	public final sanitizedSessionMessage:String;
	public final actualTurnId:String;
	public final structuredTurnErrorExtracted:Bool;
	public final steerRaceDetected:Bool;
	public final interruptRaceDetected:Bool;
	public final archivedGuidanceDetected:Bool;
	public final shouldClearCachedActiveTurn:Bool;
	public final shouldStartNewTurn:Bool;
	public final shouldRetryWithActualTurn:Bool;
	public final shouldQueueRejectedSteer:Bool;
	public final shouldDisplayErrorMessage:Bool;
	public final rolloutPathLeaked:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelTuiActiveTurnErrorOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.requestKind = fields.requestKind == null ? ModelTuiActiveTurnErrorRequestKind.SteerRace : fields.requestKind;
		this.decisionKind = fields.decisionKind == null ? ModelTuiActiveTurnErrorDecisionKind.NoMatch : fields.decisionKind;
		this.method = fields.method == null ? "" : fields.method;
		this.turnKind = fields.turnKind == null ? ModelTuiActiveTurnErrorTurnKind.None : fields.turnKind;
		this.userVisibleMessage = fields.userVisibleMessage == null ? "" : fields.userVisibleMessage;
		this.sanitizedSessionMessage = fields.sanitizedSessionMessage == null ? "" : fields.sanitizedSessionMessage;
		this.actualTurnId = fields.actualTurnId == null ? "" : fields.actualTurnId;
		this.structuredTurnErrorExtracted = fields.structuredTurnErrorExtracted;
		this.steerRaceDetected = fields.steerRaceDetected;
		this.interruptRaceDetected = fields.interruptRaceDetected;
		this.archivedGuidanceDetected = fields.archivedGuidanceDetected;
		this.shouldClearCachedActiveTurn = fields.shouldClearCachedActiveTurn;
		this.shouldStartNewTurn = fields.shouldStartNewTurn;
		this.shouldRetryWithActualTurn = fields.shouldRetryWithActualTurn;
		this.shouldQueueRejectedSteer = fields.shouldQueueRejectedSteer;
		this.shouldDisplayErrorMessage = fields.shouldDisplayErrorMessage;
		this.rolloutPathLeaked = fields.rolloutPathLeaked;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";requestKind=" + requestKind
			+ ";decisionKind=" + decisionKind
			+ ";method=" + noneIfEmpty(method)
			+ ";turnKind=" + turnKind
			+ ";actualTurnId=" + noneIfEmpty(actualTurnId)
			+ ";structuredTurnErrorExtracted=" + boolText(structuredTurnErrorExtracted)
			+ ";steerRaceDetected=" + boolText(steerRaceDetected)
			+ ";interruptRaceDetected=" + boolText(interruptRaceDetected)
			+ ";archivedGuidanceDetected=" + boolText(archivedGuidanceDetected)
			+ ";shouldClearCachedActiveTurn=" + boolText(shouldClearCachedActiveTurn)
			+ ";shouldStartNewTurn=" + boolText(shouldStartNewTurn)
			+ ";shouldRetryWithActualTurn=" + boolText(shouldRetryWithActualTurn)
			+ ";shouldQueueRejectedSteer=" + boolText(shouldQueueRejectedSteer)
			+ ";shouldDisplayErrorMessage=" + boolText(shouldDisplayErrorMessage)
			+ ";rolloutPathLeaked=" + boolText(rolloutPathLeaked)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
