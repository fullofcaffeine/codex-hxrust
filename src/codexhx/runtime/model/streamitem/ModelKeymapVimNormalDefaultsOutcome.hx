package codexhx.runtime.model.streamitem;

typedef ModelKeymapVimNormalDefaultsOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeymapVimNormalDefaultsDecisionKind;
	final enterInsertDefaultsPreserved:Bool;
	final moveLeftDefaultsPreserved:Bool;
	final moveRightDefaultsPreserved:Bool;
	final moveUpDefaultsPreserved:Bool;
	final moveDownDefaultsPreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeymapVimNormalDefaultsOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeymapVimNormalDefaultsDecisionKind;
	public final enterInsertDefaultsPreserved:Bool;
	public final moveLeftDefaultsPreserved:Bool;
	public final moveRightDefaultsPreserved:Bool;
	public final moveUpDefaultsPreserved:Bool;
	public final moveDownDefaultsPreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeymapVimNormalDefaultsOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeymapVimNormalDefaultsDecisionKind.KeymapVimNormalDefaultsRejected : fields.decisionKind;
		this.enterInsertDefaultsPreserved = fields.enterInsertDefaultsPreserved;
		this.moveLeftDefaultsPreserved = fields.moveLeftDefaultsPreserved;
		this.moveRightDefaultsPreserved = fields.moveRightDefaultsPreserved;
		this.moveUpDefaultsPreserved = fields.moveUpDefaultsPreserved;
		this.moveDownDefaultsPreserved = fields.moveDownDefaultsPreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";enterInsertDefaultsPreserved="
			+ boolText(enterInsertDefaultsPreserved) + ";moveLeftDefaultsPreserved=" + boolText(moveLeftDefaultsPreserved) + ";moveRightDefaultsPreserved="
			+ boolText(moveRightDefaultsPreserved) + ";moveUpDefaultsPreserved=" + boolText(moveUpDefaultsPreserved) + ";moveDownDefaultsPreserved="
			+ boolText(moveDownDefaultsPreserved) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
