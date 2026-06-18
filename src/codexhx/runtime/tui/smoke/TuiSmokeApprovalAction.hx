package codexhx.runtime.tui.smoke;

typedef TuiSmokeApprovalActionFields = {
	final kind:TuiSmokeApprovalActionKind;
	final requestKind:TuiSmokeApprovalRequestKind;
	final decision:TuiSmokeApprovalDecisionKind;
	final requestId:String;
	final approvalId:String;
	final threadLabel:String;
	final promptTitle:String;
	final options:Int;
	final selectedIndex:Int;
	final queueBefore:Int;
	final queueAfter:Int;
	final delayedBefore:Int;
	final delayedAfter:Int;
	final viewStackBefore:Int;
	final viewStackAfter:Int;
	final consumedByActiveView:Bool;
	final promptDelayed:Bool;
	final delayMs:Int;
	final statusTimerPaused:Bool;
	final statusTimerResumed:Bool;
	final historyCellInserted:Bool;
	final appCommandSent:Bool;
	final resolutionSent:Bool;
	final resolvedDismissed:Bool;
	final staleResolution:Bool;
	final unsupportedRejected:Bool;
	final completeBefore:Bool;
	final completeAfter:Bool;
	final frameScheduled:Bool;
	final keyAction:String;
	final conflictPrevious:String;
	final conflictAction:String;
	final failureCode:String;
}

class TuiSmokeApprovalAction {
	public final kind:TuiSmokeApprovalActionKind;
	public final requestKind:TuiSmokeApprovalRequestKind;
	public final decision:TuiSmokeApprovalDecisionKind;
	public final requestId:String;
	public final approvalId:String;
	public final threadLabel:String;
	public final promptTitle:String;
	public final options:Int;
	public final selectedIndex:Int;
	public final queueBefore:Int;
	public final queueAfter:Int;
	public final delayedBefore:Int;
	public final delayedAfter:Int;
	public final viewStackBefore:Int;
	public final viewStackAfter:Int;
	public final consumedByActiveView:Bool;
	public final promptDelayed:Bool;
	public final delayMs:Int;
	public final statusTimerPaused:Bool;
	public final statusTimerResumed:Bool;
	public final historyCellInserted:Bool;
	public final appCommandSent:Bool;
	public final resolutionSent:Bool;
	public final resolvedDismissed:Bool;
	public final staleResolution:Bool;
	public final unsupportedRejected:Bool;
	public final completeBefore:Bool;
	public final completeAfter:Bool;
	public final frameScheduled:Bool;
	public final keyAction:String;
	public final conflictPrevious:String;
	public final conflictAction:String;
	public final failureCode:String;

	public function new(fields:TuiSmokeApprovalActionFields) {
		this.kind = fields.kind == null ? TuiSmokeApprovalActionKind.Unknown : fields.kind;
		this.requestKind = fields.requestKind == null ? TuiSmokeApprovalRequestKind.Unknown : fields.requestKind;
		this.decision = fields.decision == null ? TuiSmokeApprovalDecisionKind.Unknown : fields.decision;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.approvalId = fields.approvalId == null ? "" : fields.approvalId;
		this.threadLabel = fields.threadLabel == null ? "" : fields.threadLabel;
		this.promptTitle = fields.promptTitle == null ? "" : fields.promptTitle;
		this.options = fields.options;
		this.selectedIndex = fields.selectedIndex;
		this.queueBefore = fields.queueBefore;
		this.queueAfter = fields.queueAfter;
		this.delayedBefore = fields.delayedBefore;
		this.delayedAfter = fields.delayedAfter;
		this.viewStackBefore = fields.viewStackBefore;
		this.viewStackAfter = fields.viewStackAfter;
		this.consumedByActiveView = fields.consumedByActiveView;
		this.promptDelayed = fields.promptDelayed;
		this.delayMs = fields.delayMs;
		this.statusTimerPaused = fields.statusTimerPaused;
		this.statusTimerResumed = fields.statusTimerResumed;
		this.historyCellInserted = fields.historyCellInserted;
		this.appCommandSent = fields.appCommandSent;
		this.resolutionSent = fields.resolutionSent;
		this.resolvedDismissed = fields.resolvedDismissed;
		this.staleResolution = fields.staleResolution;
		this.unsupportedRejected = fields.unsupportedRejected;
		this.completeBefore = fields.completeBefore;
		this.completeAfter = fields.completeAfter;
		this.frameScheduled = fields.frameScheduled;
		this.keyAction = fields.keyAction == null ? "" : fields.keyAction;
		this.conflictPrevious = fields.conflictPrevious == null ? "" : fields.conflictPrevious;
		this.conflictAction = fields.conflictAction == null ? "" : fields.conflictAction;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
	}

	public function queueTransitionText():String {
		return queueBefore + "->" + queueAfter;
	}

	public function delayedTransitionText():String {
		return delayedBefore + "->" + delayedAfter;
	}

	public function viewStackTransitionText():String {
		return viewStackBefore + "->" + viewStackAfter;
	}

	public function completeTransitionText():String {
		return completeBefore + "->" + completeAfter;
	}
}
