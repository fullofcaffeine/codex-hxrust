package codexhx.runtime.model.streamitem;

typedef ModelInterruptWithoutActiveTurnOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelInterruptWithoutActiveTurnDecisionKind;
	final primaryThreadRegistered:Bool;
	final activeTurnPresent:Bool;
	final turnInterruptSubmitted:Bool;
	final startupInterruptSubmitted:Bool;
	final startupInterruptSucceeded:Bool;
	final handled:Bool;
	final retryAttempted:Bool;
	final activeTurnRaceRetryUsed:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelInterruptWithoutActiveTurnOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelInterruptWithoutActiveTurnDecisionKind;
	public final primaryThreadRegistered:Bool;
	public final activeTurnPresent:Bool;
	public final turnInterruptSubmitted:Bool;
	public final startupInterruptSubmitted:Bool;
	public final startupInterruptSucceeded:Bool;
	public final handled:Bool;
	public final retryAttempted:Bool;
	public final activeTurnRaceRetryUsed:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelInterruptWithoutActiveTurnOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelInterruptWithoutActiveTurnDecisionKind.InterruptNotHandled : fields.decisionKind;
		this.primaryThreadRegistered = fields.primaryThreadRegistered;
		this.activeTurnPresent = fields.activeTurnPresent;
		this.turnInterruptSubmitted = fields.turnInterruptSubmitted;
		this.startupInterruptSubmitted = fields.startupInterruptSubmitted;
		this.startupInterruptSucceeded = fields.startupInterruptSucceeded;
		this.handled = fields.handled;
		this.retryAttempted = fields.retryAttempted;
		this.activeTurnRaceRetryUsed = fields.activeTurnRaceRetryUsed;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";primaryThreadRegistered="
			+ boolText(primaryThreadRegistered) + ";activeTurnPresent=" + boolText(activeTurnPresent) + ";turnInterruptSubmitted="
			+ boolText(turnInterruptSubmitted) + ";startupInterruptSubmitted=" + boolText(startupInterruptSubmitted) + ";startupInterruptSucceeded="
			+ boolText(startupInterruptSucceeded) + ";handled=" + boolText(handled) + ";retryAttempted=" + boolText(retryAttempted)
			+ ";activeTurnRaceRetryUsed=" + boolText(activeTurnRaceRetryUsed) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
