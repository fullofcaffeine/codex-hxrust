package codexhx.runtime.model.streamitem;

enum abstract ModelInterruptQuestionNavigationKeymapDecisionKind(String) to String {
	final InterruptQuestionNavigationConflictRejected = "interrupt_question_navigation_conflict_rejected";
	final InterruptQuestionNavigationConflictMissed = "interrupt_question_navigation_conflict_missed";
}
