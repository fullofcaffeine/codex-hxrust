package codexhx.runtime.model.streamitem;

typedef ModelKeymapVimOperatorTextObjectOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapVimOperatorTextObjectDecisionKind;
	final legacyMotionPruningPreserved:Bool;
	final explicitTextObjectConflictPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapVimOperatorTextObjectOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapVimOperatorTextObjectDecisionKind;
	public final legacyMotionPruningPreserved:Bool;
	public final explicitTextObjectConflictPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapVimOperatorTextObjectOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapVimOperatorTextObjectDecisionKind.KeymapVimOperatorTextObjectsRejected : fields.decisionKind;
		this.legacyMotionPruningPreserved = fields.legacyMotionPruningPreserved;
		this.explicitTextObjectConflictPreserved = fields.explicitTextObjectConflictPreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";legacyMotionPruningPreserved="
			+ boolText(legacyMotionPruningPreserved) + ";explicitTextObjectConflictPreserved=" + boolText(explicitTextObjectConflictPreserved)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error="
			+ errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
