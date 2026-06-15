package codexhx.runtime.model.streamitem;

typedef ModelKeyParserOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelKeyParserDecisionKind;
	final acceptedFunctionKeyCount:Int;
	final rejectedFunctionKeyCount:Int;
	final namedKeyCount:Int;
	final spaceAliasPreserved:Bool;
	final minusAliasPreserved:Bool;
	final modifierOnlyRejected:Bool;
	final nonnumericFunctionRejected:Bool;
	final altMinusAliasPreserved:Bool;
	final legacyAltLiteralMinusPreserved:Bool;
	final literalMinusPreserved:Bool;
	final allExpectedCasesMatched:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelKeyParserOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelKeyParserDecisionKind;
	public final acceptedFunctionKeyCount:Int;
	public final rejectedFunctionKeyCount:Int;
	public final namedKeyCount:Int;
	public final spaceAliasPreserved:Bool;
	public final minusAliasPreserved:Bool;
	public final modifierOnlyRejected:Bool;
	public final nonnumericFunctionRejected:Bool;
	public final altMinusAliasPreserved:Bool;
	public final legacyAltLiteralMinusPreserved:Bool;
	public final literalMinusPreserved:Bool;
	public final allExpectedCasesMatched:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelKeyParserOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelKeyParserDecisionKind.KeyParserCasesRejected : fields.decisionKind;
		this.acceptedFunctionKeyCount = fields.acceptedFunctionKeyCount;
		this.rejectedFunctionKeyCount = fields.rejectedFunctionKeyCount;
		this.namedKeyCount = fields.namedKeyCount;
		this.spaceAliasPreserved = fields.spaceAliasPreserved;
		this.minusAliasPreserved = fields.minusAliasPreserved;
		this.modifierOnlyRejected = fields.modifierOnlyRejected;
		this.nonnumericFunctionRejected = fields.nonnumericFunctionRejected;
		this.altMinusAliasPreserved = fields.altMinusAliasPreserved;
		this.legacyAltLiteralMinusPreserved = fields.legacyAltLiteralMinusPreserved;
		this.literalMinusPreserved = fields.literalMinusPreserved;
		this.allExpectedCasesMatched = fields.allExpectedCasesMatched;
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
			+ ";acceptedFunctionKeyCount=" + acceptedFunctionKeyCount
			+ ";rejectedFunctionKeyCount=" + rejectedFunctionKeyCount
			+ ";namedKeyCount=" + namedKeyCount
			+ ";spaceAliasPreserved=" + boolText(spaceAliasPreserved)
			+ ";minusAliasPreserved=" + boolText(minusAliasPreserved)
			+ ";modifierOnlyRejected=" + boolText(modifierOnlyRejected)
			+ ";nonnumericFunctionRejected=" + boolText(nonnumericFunctionRejected)
			+ ";altMinusAliasPreserved=" + boolText(altMinusAliasPreserved)
			+ ";legacyAltLiteralMinusPreserved=" + boolText(legacyAltLiteralMinusPreserved)
			+ ";literalMinusPreserved=" + boolText(literalMinusPreserved)
			+ ";allExpectedCasesMatched=" + boolText(allExpectedCasesMatched)
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
