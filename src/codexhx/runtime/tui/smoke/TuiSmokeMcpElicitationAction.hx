package codexhx.runtime.tui.smoke;

typedef TuiSmokeMcpElicitationActionFields = {
	final kind:TuiSmokeMcpElicitationActionKind;
	final mode:TuiSmokeMcpElicitationModeKind;
	final fieldInput:TuiSmokeMcpElicitationFieldInputKind;
	final decision:TuiSmokeMcpElicitationDecisionKind;
	final requestId:String;
	final serverName:String;
	final threadId:String;
	final fieldId:String;
	final toolId:String;
	final toolName:String;
	final messageChars:Int;
	final fieldCount:Int;
	final requiredFieldCount:Int;
	final optionalFieldCount:Int;
	final secretFieldCount:Int;
	final approvalDisplayParamCount:Int;
	final currentIndexBefore:Int;
	final currentIndexAfter:Int;
	final optionCount:Int;
	final selectedOptionBefore:Int;
	final selectedOptionAfter:Int;
	final draftCharsBefore:Int;
	final draftCharsAfter:Int;
	final pendingPasteCount:Int;
	final answeredBefore:Int;
	final answeredAfter:Int;
	final requiredUnansweredBefore:Int;
	final requiredUnansweredAfter:Int;
	final queueBefore:Int;
	final queueAfter:Int;
	final viewStackBefore:Int;
	final viewStackAfter:Int;
	final hasInputFocus:Bool;
	final composerDisabled:Bool;
	final statusTimerPaused:Bool;
	final statusTimerResumed:Bool;
	final frameScheduled:Bool;
	final appCommandSent:Bool;
	final resolutionSent:Bool;
	final resolvedDismissed:Bool;
	final staleResolution:Bool;
	final unsupportedRejected:Bool;
	final completeBefore:Bool;
	final completeAfter:Bool;
	final contentFieldCount:Int;
	final metaPersisted:Bool;
	final toolSuggestionHasInstallUrl:Bool;
	final failureCode:String;
}

class TuiSmokeMcpElicitationAction {
	public final kind:TuiSmokeMcpElicitationActionKind;
	public final mode:TuiSmokeMcpElicitationModeKind;
	public final fieldInput:TuiSmokeMcpElicitationFieldInputKind;
	public final decision:TuiSmokeMcpElicitationDecisionKind;
	public final requestId:String;
	public final serverName:String;
	public final threadId:String;
	public final fieldId:String;
	public final toolId:String;
	public final toolName:String;
	public final messageChars:Int;
	public final fieldCount:Int;
	public final requiredFieldCount:Int;
	public final optionalFieldCount:Int;
	public final secretFieldCount:Int;
	public final approvalDisplayParamCount:Int;
	public final currentIndexBefore:Int;
	public final currentIndexAfter:Int;
	public final optionCount:Int;
	public final selectedOptionBefore:Int;
	public final selectedOptionAfter:Int;
	public final draftCharsBefore:Int;
	public final draftCharsAfter:Int;
	public final pendingPasteCount:Int;
	public final answeredBefore:Int;
	public final answeredAfter:Int;
	public final requiredUnansweredBefore:Int;
	public final requiredUnansweredAfter:Int;
	public final queueBefore:Int;
	public final queueAfter:Int;
	public final viewStackBefore:Int;
	public final viewStackAfter:Int;
	public final hasInputFocus:Bool;
	public final composerDisabled:Bool;
	public final statusTimerPaused:Bool;
	public final statusTimerResumed:Bool;
	public final frameScheduled:Bool;
	public final appCommandSent:Bool;
	public final resolutionSent:Bool;
	public final resolvedDismissed:Bool;
	public final staleResolution:Bool;
	public final unsupportedRejected:Bool;
	public final completeBefore:Bool;
	public final completeAfter:Bool;
	public final contentFieldCount:Int;
	public final metaPersisted:Bool;
	public final toolSuggestionHasInstallUrl:Bool;
	public final failureCode:String;

	public function new(fields:TuiSmokeMcpElicitationActionFields) {
		this.kind = fields.kind == null ? TuiSmokeMcpElicitationActionKind.Unknown : fields.kind;
		this.mode = fields.mode == null ? TuiSmokeMcpElicitationModeKind.Unknown : fields.mode;
		this.fieldInput = fields.fieldInput == null ? TuiSmokeMcpElicitationFieldInputKind.Unknown : fields.fieldInput;
		this.decision = fields.decision == null ? TuiSmokeMcpElicitationDecisionKind.Unknown : fields.decision;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.serverName = fields.serverName == null ? "" : fields.serverName;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.fieldId = fields.fieldId == null ? "" : fields.fieldId;
		this.toolId = fields.toolId == null ? "" : fields.toolId;
		this.toolName = fields.toolName == null ? "" : fields.toolName;
		this.messageChars = fields.messageChars;
		this.fieldCount = fields.fieldCount;
		this.requiredFieldCount = fields.requiredFieldCount;
		this.optionalFieldCount = fields.optionalFieldCount;
		this.secretFieldCount = fields.secretFieldCount;
		this.approvalDisplayParamCount = fields.approvalDisplayParamCount;
		this.currentIndexBefore = fields.currentIndexBefore;
		this.currentIndexAfter = fields.currentIndexAfter;
		this.optionCount = fields.optionCount;
		this.selectedOptionBefore = fields.selectedOptionBefore;
		this.selectedOptionAfter = fields.selectedOptionAfter;
		this.draftCharsBefore = fields.draftCharsBefore;
		this.draftCharsAfter = fields.draftCharsAfter;
		this.pendingPasteCount = fields.pendingPasteCount;
		this.answeredBefore = fields.answeredBefore;
		this.answeredAfter = fields.answeredAfter;
		this.requiredUnansweredBefore = fields.requiredUnansweredBefore;
		this.requiredUnansweredAfter = fields.requiredUnansweredAfter;
		this.queueBefore = fields.queueBefore;
		this.queueAfter = fields.queueAfter;
		this.viewStackBefore = fields.viewStackBefore;
		this.viewStackAfter = fields.viewStackAfter;
		this.hasInputFocus = fields.hasInputFocus;
		this.composerDisabled = fields.composerDisabled;
		this.statusTimerPaused = fields.statusTimerPaused;
		this.statusTimerResumed = fields.statusTimerResumed;
		this.frameScheduled = fields.frameScheduled;
		this.appCommandSent = fields.appCommandSent;
		this.resolutionSent = fields.resolutionSent;
		this.resolvedDismissed = fields.resolvedDismissed;
		this.staleResolution = fields.staleResolution;
		this.unsupportedRejected = fields.unsupportedRejected;
		this.completeBefore = fields.completeBefore;
		this.completeAfter = fields.completeAfter;
		this.contentFieldCount = fields.contentFieldCount;
		this.metaPersisted = fields.metaPersisted;
		this.toolSuggestionHasInstallUrl = fields.toolSuggestionHasInstallUrl;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
	}

	public function queueTransitionText():String {
		return queueBefore + "->" + queueAfter;
	}

	public function viewStackTransitionText():String {
		return viewStackBefore + "->" + viewStackAfter;
	}

	public function fieldTransitionText():String {
		return currentIndexBefore + "->" + currentIndexAfter;
	}

	public function selectionTransitionText():String {
		return selectedOptionBefore + "->" + selectedOptionAfter;
	}

	public function draftTransitionText():String {
		return draftCharsBefore + "->" + draftCharsAfter;
	}

	public function answerTransitionText():String {
		return answeredBefore + "->" + answeredAfter;
	}

	public function requiredUnansweredTransitionText():String {
		return requiredUnansweredBefore + "->" + requiredUnansweredAfter;
	}

	public function completeTransitionText():String {
		return completeBefore + "->" + completeAfter;
	}
}
