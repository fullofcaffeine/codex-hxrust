package codexhx.runtime.model.streamitem;

typedef ModelKeymapListConflictOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapListConflictDecisionKind;
	final outerBindingPreserved:Bool;
	final innerBindingPreserved:Bool;
	final conflictActionNamesPreserved:Bool;
	final conflictRejectionPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapListConflictOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapListConflictDecisionKind;
	public final outerBindingPreserved:Bool;
	public final innerBindingPreserved:Bool;
	public final conflictActionNamesPreserved:Bool;
	public final conflictRejectionPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapListConflictOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapListConflictDecisionKind.KeymapListConflictMissed : fields.decisionKind;
		this.outerBindingPreserved = fields.outerBindingPreserved;
		this.innerBindingPreserved = fields.innerBindingPreserved;
		this.conflictActionNamesPreserved = fields.conflictActionNamesPreserved;
		this.conflictRejectionPreserved = fields.conflictRejectionPreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";outerBindingPreserved="
			+ boolText(outerBindingPreserved) + ";innerBindingPreserved=" + boolText(innerBindingPreserved) + ";conflictActionNamesPreserved="
			+ boolText(conflictActionNamesPreserved) + ";conflictRejectionPreserved=" + boolText(conflictRejectionPreserved) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
