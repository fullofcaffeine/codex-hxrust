package codexhx.runtime.model.streamitem;

typedef ModelKeymapEditorAssignmentOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapEditorAssignmentDecisionKind;
	final actionKindPreserved:Bool;
	final defaultBindingEmptyPreserved:Bool;
	final configuredBindingPreserved:Bool;
	final runtimeBindingPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapEditorAssignmentOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapEditorAssignmentDecisionKind;
	public final actionKindPreserved:Bool;
	public final defaultBindingEmptyPreserved:Bool;
	public final configuredBindingPreserved:Bool;
	public final runtimeBindingPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapEditorAssignmentOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapEditorAssignmentDecisionKind.KeymapEditorAssignmentRejected : fields.decisionKind;
		this.actionKindPreserved = fields.actionKindPreserved;
		this.defaultBindingEmptyPreserved = fields.defaultBindingEmptyPreserved;
		this.configuredBindingPreserved = fields.configuredBindingPreserved;
		this.runtimeBindingPreserved = fields.runtimeBindingPreserved;
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
			+ ";actionKindPreserved=" + boolText(actionKindPreserved)
			+ ";defaultBindingEmptyPreserved=" + boolText(defaultBindingEmptyPreserved)
			+ ";configuredBindingPreserved=" + boolText(configuredBindingPreserved)
			+ ";runtimeBindingPreserved=" + boolText(runtimeBindingPreserved)
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
