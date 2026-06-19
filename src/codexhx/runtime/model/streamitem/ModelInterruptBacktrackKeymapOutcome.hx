package codexhx.runtime.model.streamitem;

typedef ModelInterruptBacktrackKeymapOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelInterruptBacktrackKeymapDecisionKind;
	final defaultEscInterruptPreserved:Bool;
	final fixedBacktrackEscPreserved:Bool;
	final backtrackOverlapAllowed:Bool;
	final remapToF12Accepted:Bool;
	final unbindAccepted:Bool;
	final otherFixedShortcutRejected:Bool;
	final conflictActionNamePreserved:Bool;
	final dispatchGatingDeferredToHandler:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelInterruptBacktrackKeymapOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelInterruptBacktrackKeymapDecisionKind;
	public final defaultEscInterruptPreserved:Bool;
	public final fixedBacktrackEscPreserved:Bool;
	public final backtrackOverlapAllowed:Bool;
	public final remapToF12Accepted:Bool;
	public final unbindAccepted:Bool;
	public final otherFixedShortcutRejected:Bool;
	public final conflictActionNamePreserved:Bool;
	public final dispatchGatingDeferredToHandler:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelInterruptBacktrackKeymapOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelInterruptBacktrackKeymapDecisionKind.InterruptBacktrackKeymapRejected : fields.decisionKind;
		this.defaultEscInterruptPreserved = fields.defaultEscInterruptPreserved;
		this.fixedBacktrackEscPreserved = fields.fixedBacktrackEscPreserved;
		this.backtrackOverlapAllowed = fields.backtrackOverlapAllowed;
		this.remapToF12Accepted = fields.remapToF12Accepted;
		this.unbindAccepted = fields.unbindAccepted;
		this.otherFixedShortcutRejected = fields.otherFixedShortcutRejected;
		this.conflictActionNamePreserved = fields.conflictActionNamePreserved;
		this.dispatchGatingDeferredToHandler = fields.dispatchGatingDeferredToHandler;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";defaultEscInterruptPreserved="
			+ boolText(defaultEscInterruptPreserved) + ";fixedBacktrackEscPreserved=" + boolText(fixedBacktrackEscPreserved) + ";backtrackOverlapAllowed="
			+ boolText(backtrackOverlapAllowed) + ";remapToF12Accepted=" + boolText(remapToF12Accepted) + ";unbindAccepted=" + boolText(unbindAccepted)
			+ ";otherFixedShortcutRejected=" + boolText(otherFixedShortcutRejected) + ";conflictActionNamePreserved=" + boolText(conflictActionNamePreserved)
			+ ";dispatchGatingDeferredToHandler=" + boolText(dispatchGatingDeferredToHandler) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
