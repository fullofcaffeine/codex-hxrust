package codexhx.runtime.model.streamitem;

typedef ModelKeymapInvalidGlobalCopyOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapInvalidGlobalCopyDecisionKind;
	final invalidBindingPreserved:Bool;
	final errorPathPreserved:Bool;
	final parseFailurePreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapInvalidGlobalCopyOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapInvalidGlobalCopyDecisionKind;
	public final invalidBindingPreserved:Bool;
	public final errorPathPreserved:Bool;
	public final parseFailurePreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapInvalidGlobalCopyOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null
			? ModelKeymapInvalidGlobalCopyDecisionKind.KeymapInvalidGlobalCopyPathRejected
			: fields.decisionKind;
		this.invalidBindingPreserved = fields.invalidBindingPreserved;
		this.errorPathPreserved = fields.errorPathPreserved;
		this.parseFailurePreserved = fields.parseFailurePreserved;
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
			+ ";invalidBindingPreserved=" + boolText(invalidBindingPreserved)
			+ ";errorPathPreserved=" + boolText(errorPathPreserved)
			+ ";parseFailurePreserved=" + boolText(parseFailurePreserved)
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
