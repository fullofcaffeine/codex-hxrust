package codexhx.runtime.model.streamitem;

typedef ModelKeymapEditorUnbindConflictOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapEditorUnbindConflictDecisionKind;
	final configuredKillWholeLinePreserved:Bool;
	final defaultKillLineStartPreserved:Bool;
	final conflictActionNamesPreserved:Bool;
	final conflictRejectionPreserved:Bool;
	final originalActionUnboundPreserved:Bool;
	final runtimeKillWholeLinePreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapEditorUnbindConflictOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapEditorUnbindConflictDecisionKind;
	public final configuredKillWholeLinePreserved:Bool;
	public final defaultKillLineStartPreserved:Bool;
	public final conflictActionNamesPreserved:Bool;
	public final conflictRejectionPreserved:Bool;
	public final originalActionUnboundPreserved:Bool;
	public final runtimeKillWholeLinePreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapEditorUnbindConflictOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapEditorUnbindConflictDecisionKind.KeymapEditorUnbindConflictRejected : fields.decisionKind;
		this.configuredKillWholeLinePreserved = fields.configuredKillWholeLinePreserved;
		this.defaultKillLineStartPreserved = fields.defaultKillLineStartPreserved;
		this.conflictActionNamesPreserved = fields.conflictActionNamesPreserved;
		this.conflictRejectionPreserved = fields.conflictRejectionPreserved;
		this.originalActionUnboundPreserved = fields.originalActionUnboundPreserved;
		this.runtimeKillWholeLinePreserved = fields.runtimeKillWholeLinePreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";configuredKillWholeLinePreserved="
			+ boolText(configuredKillWholeLinePreserved) + ";defaultKillLineStartPreserved=" + boolText(defaultKillLineStartPreserved)
			+ ";conflictActionNamesPreserved=" + boolText(conflictActionNamesPreserved) + ";conflictRejectionPreserved="
			+ boolText(conflictRejectionPreserved) + ";originalActionUnboundPreserved=" + boolText(originalActionUnboundPreserved)
			+ ";runtimeKillWholeLinePreserved=" + boolText(runtimeKillWholeLinePreserved) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
