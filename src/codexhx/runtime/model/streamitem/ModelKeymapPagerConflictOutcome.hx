package codexhx.runtime.model.streamitem;

typedef ModelKeymapPagerConflictOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapPagerConflictDecisionKind;
	final scrollUpBindingPreserved:Bool;
	final scrollDownBindingPreserved:Bool;
	final conflictActionNamesPreserved:Bool;
	final conflictRejectionPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapPagerConflictOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapPagerConflictDecisionKind;
	public final scrollUpBindingPreserved:Bool;
	public final scrollDownBindingPreserved:Bool;
	public final conflictActionNamesPreserved:Bool;
	public final conflictRejectionPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapPagerConflictOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapPagerConflictDecisionKind.KeymapPagerConflictMissed : fields.decisionKind;
		this.scrollUpBindingPreserved = fields.scrollUpBindingPreserved;
		this.scrollDownBindingPreserved = fields.scrollDownBindingPreserved;
		this.conflictActionNamesPreserved = fields.conflictActionNamesPreserved;
		this.conflictRejectionPreserved = fields.conflictRejectionPreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";scrollUpBindingPreserved="
			+ boolText(scrollUpBindingPreserved) + ";scrollDownBindingPreserved=" + boolText(scrollDownBindingPreserved) + ";conflictActionNamesPreserved="
			+ boolText(conflictActionNamesPreserved) + ";conflictRejectionPreserved=" + boolText(conflictRejectionPreserved) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
