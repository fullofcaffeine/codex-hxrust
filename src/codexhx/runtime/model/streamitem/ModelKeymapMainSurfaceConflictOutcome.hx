package codexhx.runtime.model.streamitem;

typedef ModelKeymapMainSurfaceConflictOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapMainSurfaceConflictDecisionKind;
	final configuredToggleFastModeBindingPreserved:Bool;
	final defaultClearTerminalBindingPreserved:Bool;
	final conflictActionNamesPreserved:Bool;
	final conflictRejectionPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapMainSurfaceConflictOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapMainSurfaceConflictDecisionKind;
	public final configuredToggleFastModeBindingPreserved:Bool;
	public final defaultClearTerminalBindingPreserved:Bool;
	public final conflictActionNamesPreserved:Bool;
	public final conflictRejectionPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapMainSurfaceConflictOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapMainSurfaceConflictDecisionKind.KeymapMainSurfaceConflictMissed : fields.decisionKind;
		this.configuredToggleFastModeBindingPreserved = fields.configuredToggleFastModeBindingPreserved;
		this.defaultClearTerminalBindingPreserved = fields.defaultClearTerminalBindingPreserved;
		this.conflictActionNamesPreserved = fields.conflictActionNamesPreserved;
		this.conflictRejectionPreserved = fields.conflictRejectionPreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind
			+ ";configuredToggleFastModeBindingPreserved=" + boolText(configuredToggleFastModeBindingPreserved) + ";defaultClearTerminalBindingPreserved="
			+ boolText(defaultClearTerminalBindingPreserved) + ";conflictActionNamesPreserved=" + boolText(conflictActionNamesPreserved)
			+ ";conflictRejectionPreserved=" + boolText(conflictRejectionPreserved) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
