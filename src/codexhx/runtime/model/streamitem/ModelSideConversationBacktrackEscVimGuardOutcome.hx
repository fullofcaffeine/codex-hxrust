package codexhx.runtime.model.streamitem;

typedef ModelSideConversationBacktrackEscVimGuardOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelSideConversationBacktrackEscVimGuardDecisionKind;
	final initialBacktrackEscHandled:Bool;
	final initialSideBacktrackEscRejected:Bool;
	final vimInsertEscTakesPrecedence:Bool;
	final backtrackEscSuppressedDuringVimInsert:Bool;
	final sideRejectionSuppressedDuringVimInsert:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelSideConversationBacktrackEscVimGuardOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelSideConversationBacktrackEscVimGuardDecisionKind;
	public final initialBacktrackEscHandled:Bool;
	public final initialSideBacktrackEscRejected:Bool;
	public final vimInsertEscTakesPrecedence:Bool;
	public final backtrackEscSuppressedDuringVimInsert:Bool;
	public final sideRejectionSuppressedDuringVimInsert:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelSideConversationBacktrackEscVimGuardOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelSideConversationBacktrackEscVimGuardDecisionKind.SideBacktrackRejectionUnavailable : fields.decisionKind;
		this.initialBacktrackEscHandled = fields.initialBacktrackEscHandled;
		this.initialSideBacktrackEscRejected = fields.initialSideBacktrackEscRejected;
		this.vimInsertEscTakesPrecedence = fields.vimInsertEscTakesPrecedence;
		this.backtrackEscSuppressedDuringVimInsert = fields.backtrackEscSuppressedDuringVimInsert;
		this.sideRejectionSuppressedDuringVimInsert = fields.sideRejectionSuppressedDuringVimInsert;
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
			+ ";initialBacktrackEscHandled=" + boolText(initialBacktrackEscHandled)
			+ ";initialSideBacktrackEscRejected=" + boolText(initialSideBacktrackEscRejected)
			+ ";vimInsertEscTakesPrecedence=" + boolText(vimInsertEscTakesPrecedence)
			+ ";backtrackEscSuppressedDuringVimInsert=" + boolText(backtrackEscSuppressedDuringVimInsert)
			+ ";sideRejectionSuppressedDuringVimInsert=" + boolText(sideRejectionSuppressedDuringVimInsert)
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
