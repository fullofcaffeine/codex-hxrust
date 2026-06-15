package codexhx.runtime.model.streamitem;

typedef ModelKeymapFixedShortcutOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapFixedShortcutDecisionKind;
	final configuredCopyBindingPreserved:Bool;
	final defaultIncreaseReasoningBindingPreserved:Bool;
	final conflictActionNamesPreserved:Bool;
	final conflictRejectionPreserved:Bool;
	final originalActionUnboundPreserved:Bool;
	final runtimeCopyRemapPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapFixedShortcutOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapFixedShortcutDecisionKind;
	public final configuredCopyBindingPreserved:Bool;
	public final defaultIncreaseReasoningBindingPreserved:Bool;
	public final conflictActionNamesPreserved:Bool;
	public final conflictRejectionPreserved:Bool;
	public final originalActionUnboundPreserved:Bool;
	public final runtimeCopyRemapPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapFixedShortcutOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapFixedShortcutDecisionKind.KeymapFixedShortcutConflictRejected : fields.decisionKind;
		this.configuredCopyBindingPreserved = fields.configuredCopyBindingPreserved;
		this.defaultIncreaseReasoningBindingPreserved = fields.defaultIncreaseReasoningBindingPreserved;
		this.conflictActionNamesPreserved = fields.conflictActionNamesPreserved;
		this.conflictRejectionPreserved = fields.conflictRejectionPreserved;
		this.originalActionUnboundPreserved = fields.originalActionUnboundPreserved;
		this.runtimeCopyRemapPreserved = fields.runtimeCopyRemapPreserved;
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
			+ ";configuredCopyBindingPreserved=" + boolText(configuredCopyBindingPreserved)
			+ ";defaultIncreaseReasoningBindingPreserved=" + boolText(defaultIncreaseReasoningBindingPreserved)
			+ ";conflictActionNamesPreserved=" + boolText(conflictActionNamesPreserved)
			+ ";conflictRejectionPreserved=" + boolText(conflictRejectionPreserved)
			+ ";originalActionUnboundPreserved=" + boolText(originalActionUnboundPreserved)
			+ ";runtimeCopyRemapPreserved=" + boolText(runtimeCopyRemapPreserved)
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
