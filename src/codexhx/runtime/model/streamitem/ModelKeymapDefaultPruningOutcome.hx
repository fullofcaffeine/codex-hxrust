package codexhx.runtime.model.streamitem;

typedef ModelKeymapDefaultPruningOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapDefaultPruningDecisionKind;
	final tailMainSurfaceDefaultsPreserved:Bool;
	final listPageAndJumpDefaultsPreserved:Bool;
	final reasoningFallbackPruningPreserved:Bool;
	final explicitReasoningEditorConflictPreserved:Bool;
	final legacyListOverlapPruningPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapDefaultPruningOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapDefaultPruningDecisionKind;
	public final tailMainSurfaceDefaultsPreserved:Bool;
	public final listPageAndJumpDefaultsPreserved:Bool;
	public final reasoningFallbackPruningPreserved:Bool;
	public final explicitReasoningEditorConflictPreserved:Bool;
	public final legacyListOverlapPruningPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapDefaultPruningOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapDefaultPruningDecisionKind.KeymapDefaultPruningRejected : fields.decisionKind;
		this.tailMainSurfaceDefaultsPreserved = fields.tailMainSurfaceDefaultsPreserved;
		this.listPageAndJumpDefaultsPreserved = fields.listPageAndJumpDefaultsPreserved;
		this.reasoningFallbackPruningPreserved = fields.reasoningFallbackPruningPreserved;
		this.explicitReasoningEditorConflictPreserved = fields.explicitReasoningEditorConflictPreserved;
		this.legacyListOverlapPruningPreserved = fields.legacyListOverlapPruningPreserved;
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
			+ ";tailMainSurfaceDefaultsPreserved=" + boolText(tailMainSurfaceDefaultsPreserved)
			+ ";listPageAndJumpDefaultsPreserved=" + boolText(listPageAndJumpDefaultsPreserved)
			+ ";reasoningFallbackPruningPreserved=" + boolText(reasoningFallbackPruningPreserved)
			+ ";explicitReasoningEditorConflictPreserved=" + boolText(explicitReasoningEditorConflictPreserved)
			+ ";legacyListOverlapPruningPreserved=" + boolText(legacyListOverlapPruningPreserved)
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
