package codexhx.runtime.model.streamitem;

typedef ModelKeymapShadowOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapShadowDecisionKind;
	final canonicalBindingPreserved:Bool;
	final shadowConflictCount:Int;
	final composerShadowRejected:Bool;
	final editorShadowRejected:Bool;
	final approvalShadowRejected:Bool;
	final listShadowRejected:Bool;
	final actionNamesPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapShadowOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapShadowDecisionKind;
	public final canonicalBindingPreserved:Bool;
	public final shadowConflictCount:Int;
	public final composerShadowRejected:Bool;
	public final editorShadowRejected:Bool;
	public final approvalShadowRejected:Bool;
	public final listShadowRejected:Bool;
	public final actionNamesPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapShadowOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapShadowDecisionKind.KeymapShadowConflictsMissed : fields.decisionKind;
		this.canonicalBindingPreserved = fields.canonicalBindingPreserved;
		this.shadowConflictCount = fields.shadowConflictCount;
		this.composerShadowRejected = fields.composerShadowRejected;
		this.editorShadowRejected = fields.editorShadowRejected;
		this.approvalShadowRejected = fields.approvalShadowRejected;
		this.listShadowRejected = fields.listShadowRejected;
		this.actionNamesPreserved = fields.actionNamesPreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";canonicalBindingPreserved="
			+ boolText(canonicalBindingPreserved) + ";shadowConflictCount=" + shadowConflictCount + ";composerShadowRejected="
			+ boolText(composerShadowRejected) + ";editorShadowRejected=" + boolText(editorShadowRejected) + ";approvalShadowRejected="
			+ boolText(approvalShadowRejected) + ";listShadowRejected=" + boolText(listShadowRejected) + ";actionNamesPreserved="
			+ boolText(actionNamesPreserved) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
