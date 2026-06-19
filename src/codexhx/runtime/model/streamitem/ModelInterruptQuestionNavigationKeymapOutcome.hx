package codexhx.runtime.model.streamitem;

typedef ModelInterruptQuestionNavigationKeymapOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelInterruptQuestionNavigationKeymapDecisionKind;
	final interruptActionNamePreserved:Bool;
	final questionNavigationActionNamePreserved:Bool;
	final interruptRemapAcceptedBeforeValidation:Bool;
	final questionNavigationBindingPreserved:Bool;
	final conflictingBindingDetected:Bool;
	final fixedBacktrackOverlapStillAllowed:Bool;
	final conflictRejected:Bool;
	final noFalseBacktrackConflict:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelInterruptQuestionNavigationKeymapOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelInterruptQuestionNavigationKeymapDecisionKind;
	public final interruptActionNamePreserved:Bool;
	public final questionNavigationActionNamePreserved:Bool;
	public final interruptRemapAcceptedBeforeValidation:Bool;
	public final questionNavigationBindingPreserved:Bool;
	public final conflictingBindingDetected:Bool;
	public final fixedBacktrackOverlapStillAllowed:Bool;
	public final conflictRejected:Bool;
	public final noFalseBacktrackConflict:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelInterruptQuestionNavigationKeymapOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelInterruptQuestionNavigationKeymapDecisionKind.InterruptQuestionNavigationConflictMissed : fields.decisionKind;
		this.interruptActionNamePreserved = fields.interruptActionNamePreserved;
		this.questionNavigationActionNamePreserved = fields.questionNavigationActionNamePreserved;
		this.interruptRemapAcceptedBeforeValidation = fields.interruptRemapAcceptedBeforeValidation;
		this.questionNavigationBindingPreserved = fields.questionNavigationBindingPreserved;
		this.conflictingBindingDetected = fields.conflictingBindingDetected;
		this.fixedBacktrackOverlapStillAllowed = fields.fixedBacktrackOverlapStillAllowed;
		this.conflictRejected = fields.conflictRejected;
		this.noFalseBacktrackConflict = fields.noFalseBacktrackConflict;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";interruptActionNamePreserved="
			+ boolText(interruptActionNamePreserved) + ";questionNavigationActionNamePreserved=" + boolText(questionNavigationActionNamePreserved)
			+ ";interruptRemapAcceptedBeforeValidation=" + boolText(interruptRemapAcceptedBeforeValidation) + ";questionNavigationBindingPreserved="
			+ boolText(questionNavigationBindingPreserved) + ";conflictingBindingDetected=" + boolText(conflictingBindingDetected)
			+ ";fixedBacktrackOverlapStillAllowed=" + boolText(fixedBacktrackOverlapStillAllowed) + ";conflictRejected=" + boolText(conflictRejected)
			+ ";noFalseBacktrackConflict=" + boolText(noFalseBacktrackConflict) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
