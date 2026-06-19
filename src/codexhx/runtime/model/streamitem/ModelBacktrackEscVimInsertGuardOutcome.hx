package codexhx.runtime.model.streamitem;

typedef ModelBacktrackEscVimInsertGuardOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelBacktrackEscVimInsertGuardDecisionKind;
	final initialBacktrackEscAllowed:Bool;
	final vimNormalBacktrackEscAllowed:Bool;
	final vimInsertEscTakesPrecedence:Bool;
	final backtrackEscSuppressedDuringVimInsert:Bool;
	final vimEscHandled:Bool;
	final backtrackNotPrimedByVimEsc:Bool;
	final vimInsertClearedAfterEsc:Bool;
	final backtrackEscAllowedAfterVimEsc:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelBacktrackEscVimInsertGuardOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelBacktrackEscVimInsertGuardDecisionKind;
	public final initialBacktrackEscAllowed:Bool;
	public final vimNormalBacktrackEscAllowed:Bool;
	public final vimInsertEscTakesPrecedence:Bool;
	public final backtrackEscSuppressedDuringVimInsert:Bool;
	public final vimEscHandled:Bool;
	public final backtrackNotPrimedByVimEsc:Bool;
	public final vimInsertClearedAfterEsc:Bool;
	public final backtrackEscAllowedAfterVimEsc:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelBacktrackEscVimInsertGuardOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelBacktrackEscVimInsertGuardDecisionKind.BacktrackEscGuardUnavailable : fields.decisionKind;
		this.initialBacktrackEscAllowed = fields.initialBacktrackEscAllowed;
		this.vimNormalBacktrackEscAllowed = fields.vimNormalBacktrackEscAllowed;
		this.vimInsertEscTakesPrecedence = fields.vimInsertEscTakesPrecedence;
		this.backtrackEscSuppressedDuringVimInsert = fields.backtrackEscSuppressedDuringVimInsert;
		this.vimEscHandled = fields.vimEscHandled;
		this.backtrackNotPrimedByVimEsc = fields.backtrackNotPrimedByVimEsc;
		this.vimInsertClearedAfterEsc = fields.vimInsertClearedAfterEsc;
		this.backtrackEscAllowedAfterVimEsc = fields.backtrackEscAllowedAfterVimEsc;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";initialBacktrackEscAllowed="
			+ boolText(initialBacktrackEscAllowed) + ";vimNormalBacktrackEscAllowed=" + boolText(vimNormalBacktrackEscAllowed)
			+ ";vimInsertEscTakesPrecedence=" + boolText(vimInsertEscTakesPrecedence) + ";backtrackEscSuppressedDuringVimInsert="
			+ boolText(backtrackEscSuppressedDuringVimInsert) + ";vimEscHandled=" + boolText(vimEscHandled) + ";backtrackNotPrimedByVimEsc="
			+ boolText(backtrackNotPrimedByVimEsc) + ";vimInsertClearedAfterEsc=" + boolText(vimInsertClearedAfterEsc) + ";backtrackEscAllowedAfterVimEsc="
			+ boolText(backtrackEscAllowedAfterVimEsc) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
