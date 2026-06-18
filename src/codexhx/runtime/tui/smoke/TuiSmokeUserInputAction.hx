package codexhx.runtime.tui.smoke;

typedef TuiSmokeUserInputActionFields = {
	final kind:TuiSmokeUserInputActionKind;
	final requestKind:TuiSmokeUserInputRequestKind;
	final focus:TuiSmokeUserInputFocusKind;
	final requestId:String;
	final turnId:String;
	final itemId:String;
	final questionId:String;
	final callId:String;
	final questionCount:Int;
	final currentIndexBefore:Int;
	final currentIndexAfter:Int;
	final optionCount:Int;
	final selectedOptionBefore:Int;
	final selectedOptionAfter:Int;
	final draftCharsBefore:Int;
	final draftCharsAfter:Int;
	final pendingPasteCount:Int;
	final notesVisible:Bool;
	final answeredBefore:Int;
	final answeredAfter:Int;
	final unansweredBefore:Int;
	final unansweredAfter:Int;
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
	final historyCellInserted:Bool;
	final resolutionSent:Bool;
	final resolvedDismissed:Bool;
	final staleResolution:Bool;
	final unsupportedRejected:Bool;
	final completeBefore:Bool;
	final completeAfter:Bool;
	final answerCount:Int;
	final secretQuestionCount:Int;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeUserInputAction {
	public final kind:TuiSmokeUserInputActionKind;
	public final requestKind:TuiSmokeUserInputRequestKind;
	public final focus:TuiSmokeUserInputFocusKind;
	public final requestId:String;
	public final turnId:String;
	public final itemId:String;
	public final questionId:String;
	public final callId:String;
	public final questionCount:Int;
	public final currentIndexBefore:Int;
	public final currentIndexAfter:Int;
	public final optionCount:Int;
	public final selectedOptionBefore:Int;
	public final selectedOptionAfter:Int;
	public final draftCharsBefore:Int;
	public final draftCharsAfter:Int;
	public final pendingPasteCount:Int;
	public final notesVisible:Bool;
	public final answeredBefore:Int;
	public final answeredAfter:Int;
	public final unansweredBefore:Int;
	public final unansweredAfter:Int;
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
	public final historyCellInserted:Bool;
	public final resolutionSent:Bool;
	public final resolvedDismissed:Bool;
	public final staleResolution:Bool;
	public final unsupportedRejected:Bool;
	public final completeBefore:Bool;
	public final completeAfter:Bool;
	public final answerCount:Int;
	public final secretQuestionCount:Int;
	public final failureCode:String;


	public function queueTransitionText():String {
		return queueBefore + "->" + queueAfter;
	}

	public function viewStackTransitionText():String {
		return viewStackBefore + "->" + viewStackAfter;
	}

	public function questionTransitionText():String {
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

	public function unansweredTransitionText():String {
		return unansweredBefore + "->" + unansweredAfter;
	}

	public function completeTransitionText():String {
		return completeBefore + "->" + completeAfter;
	}
}
