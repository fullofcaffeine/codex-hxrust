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

@:build(codexhx.macros.FieldRecordConstructor.build())
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
