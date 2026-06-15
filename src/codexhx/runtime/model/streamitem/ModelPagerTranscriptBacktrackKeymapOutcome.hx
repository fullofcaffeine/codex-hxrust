package codexhx.runtime.model.streamitem;

typedef ModelPagerTranscriptBacktrackKeymapOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelPagerTranscriptBacktrackKeymapDecisionKind;
	final pagerActionNamePreserved:Bool;
	final pagerBindingPreserved:Bool;
	final transcriptBacktrackActionNamePreserved:Bool;
	final transcriptLeftBindingPreserved:Bool;
	final reservedCollisionDetected:Bool;
	final conflictRejected:Bool;
	final fixedBacktrackOverlapStillAllowed:Bool;
	final noFalseInterruptBacktrackConflict:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelPagerTranscriptBacktrackKeymapOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelPagerTranscriptBacktrackKeymapDecisionKind;
	public final pagerActionNamePreserved:Bool;
	public final pagerBindingPreserved:Bool;
	public final transcriptBacktrackActionNamePreserved:Bool;
	public final transcriptLeftBindingPreserved:Bool;
	public final reservedCollisionDetected:Bool;
	public final conflictRejected:Bool;
	public final fixedBacktrackOverlapStillAllowed:Bool;
	public final noFalseInterruptBacktrackConflict:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelPagerTranscriptBacktrackKeymapOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null
			? ModelPagerTranscriptBacktrackKeymapDecisionKind.PagerTranscriptBacktrackConflictMissed
			: fields.decisionKind;
		this.pagerActionNamePreserved = fields.pagerActionNamePreserved;
		this.pagerBindingPreserved = fields.pagerBindingPreserved;
		this.transcriptBacktrackActionNamePreserved = fields.transcriptBacktrackActionNamePreserved;
		this.transcriptLeftBindingPreserved = fields.transcriptLeftBindingPreserved;
		this.reservedCollisionDetected = fields.reservedCollisionDetected;
		this.conflictRejected = fields.conflictRejected;
		this.fixedBacktrackOverlapStillAllowed = fields.fixedBacktrackOverlapStillAllowed;
		this.noFalseInterruptBacktrackConflict = fields.noFalseInterruptBacktrackConflict;
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
			+ ";decisionKind=" + decisionKind
			+ ";pagerActionNamePreserved=" + boolText(pagerActionNamePreserved)
			+ ";pagerBindingPreserved=" + boolText(pagerBindingPreserved)
			+ ";transcriptBacktrackActionNamePreserved=" + boolText(transcriptBacktrackActionNamePreserved)
			+ ";transcriptLeftBindingPreserved=" + boolText(transcriptLeftBindingPreserved)
			+ ";reservedCollisionDetected=" + boolText(reservedCollisionDetected)
			+ ";conflictRejected=" + boolText(conflictRejected)
			+ ";fixedBacktrackOverlapStillAllowed=" + boolText(fixedBacktrackOverlapStillAllowed)
			+ ";noFalseInterruptBacktrackConflict=" + boolText(noFalseInterruptBacktrackConflict)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
