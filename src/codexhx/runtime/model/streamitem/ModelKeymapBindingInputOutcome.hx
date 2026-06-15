package codexhx.runtime.model.streamitem;

typedef ModelKeymapBindingInputOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapBindingInputDecisionKind;
	final stringOrArrayInputValidated:Bool;
	final invalidModifierPathPreserved:Bool;
	final validMultiBindingCount:Int;
	final dedupeOrderPreserved:Bool;
	final contextFallbackPreserved:Bool;
	final invalidGlobalPathsPreserved:Bool;
	final defaultCopyBindingPreserved:Bool;
	final defaultMainSurfaceActionsPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapBindingInputOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapBindingInputDecisionKind;
	public final stringOrArrayInputValidated:Bool;
	public final invalidModifierPathPreserved:Bool;
	public final validMultiBindingCount:Int;
	public final dedupeOrderPreserved:Bool;
	public final contextFallbackPreserved:Bool;
	public final invalidGlobalPathsPreserved:Bool;
	public final defaultCopyBindingPreserved:Bool;
	public final defaultMainSurfaceActionsPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapBindingInputOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapBindingInputDecisionKind.KeymapBindingInputsRejected : fields.decisionKind;
		this.stringOrArrayInputValidated = fields.stringOrArrayInputValidated;
		this.invalidModifierPathPreserved = fields.invalidModifierPathPreserved;
		this.validMultiBindingCount = fields.validMultiBindingCount;
		this.dedupeOrderPreserved = fields.dedupeOrderPreserved;
		this.contextFallbackPreserved = fields.contextFallbackPreserved;
		this.invalidGlobalPathsPreserved = fields.invalidGlobalPathsPreserved;
		this.defaultCopyBindingPreserved = fields.defaultCopyBindingPreserved;
		this.defaultMainSurfaceActionsPreserved = fields.defaultMainSurfaceActionsPreserved;
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
			+ ";stringOrArrayInputValidated=" + boolText(stringOrArrayInputValidated)
			+ ";invalidModifierPathPreserved=" + boolText(invalidModifierPathPreserved)
			+ ";validMultiBindingCount=" + validMultiBindingCount
			+ ";dedupeOrderPreserved=" + boolText(dedupeOrderPreserved)
			+ ";contextFallbackPreserved=" + boolText(contextFallbackPreserved)
			+ ";invalidGlobalPathsPreserved=" + boolText(invalidGlobalPathsPreserved)
			+ ";defaultCopyBindingPreserved=" + boolText(defaultCopyBindingPreserved)
			+ ";defaultMainSurfaceActionsPreserved=" + boolText(defaultMainSurfaceActionsPreserved)
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
