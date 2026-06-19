package codexhx.runtime.model.streamitem;

typedef ModelClearOnlySkillWarningRerenderOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelClearOnlySkillWarningRerenderDecisionKind;
	final warningKeyPresent:Bool;
	final firstWarningRendered:Bool;
	final repeatedWarningSuppressed:Bool;
	final resetClearedWarningMemory:Bool;
	final postResetWarningRenderedAgain:Bool;
	final sameWarningKeyReused:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelClearOnlySkillWarningRerenderOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelClearOnlySkillWarningRerenderDecisionKind;
	public final warningKeyPresent:Bool;
	public final firstWarningRendered:Bool;
	public final repeatedWarningSuppressed:Bool;
	public final resetClearedWarningMemory:Bool;
	public final postResetWarningRenderedAgain:Bool;
	public final sameWarningKeyReused:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelClearOnlySkillWarningRerenderOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningUnavailable : fields.decisionKind;
		this.warningKeyPresent = fields.warningKeyPresent;
		this.firstWarningRendered = fields.firstWarningRendered;
		this.repeatedWarningSuppressed = fields.repeatedWarningSuppressed;
		this.resetClearedWarningMemory = fields.resetClearedWarningMemory;
		this.postResetWarningRenderedAgain = fields.postResetWarningRenderedAgain;
		this.sameWarningKeyReused = fields.sameWarningKeyReused;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";warningKeyPresent="
			+ boolText(warningKeyPresent) + ";firstWarningRendered=" + boolText(firstWarningRendered) + ";repeatedWarningSuppressed="
			+ boolText(repeatedWarningSuppressed) + ";resetClearedWarningMemory=" + boolText(resetClearedWarningMemory) + ";postResetWarningRenderedAgain="
			+ boolText(postResetWarningRenderedAgain) + ";sameWarningKeyReused=" + boolText(sameWarningKeyReused) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
