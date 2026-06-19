package codexhx.runtime.tui.smoke;

typedef TuiSmokeGoalMenuActionFields = {
	final kind:TuiSmokeGoalMenuActionKind;
	final status:String;
	final objective:String;
	final commandHint:String;
	final indicator:String;
	final usage:String;
	final validationSource:String;
	final failureCode:String;
	final tokenBudget:Int;
	final tokensUsed:Int;
	final timeUsedSeconds:Int;
	final actualChars:Int;
	final maxChars:Int;
	final activeTurnElapsedSeconds:Int;
	final budgetPresent:Bool;
	final summaryInserted:Bool;
	final editPromptOpened:Bool;
	final editedStatus:String;
	final setObjectiveEvent:Bool;
	final resumePromptOpened:Bool;
	final resumeDefaultSelected:Bool;
	final setStatusEvent:Bool;
	final leavePausedSelected:Bool;
	final allowed:Bool;
	final errorInserted:Bool;
	final composerCleared:Bool;
	final pendingSubmissionDrained:Bool;
	final activeGoalPaused:Bool;
	final currentGoalCleared:Bool;
	final collaborationIndicatorUpdated:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeGoalMenuAction {
	public final kind:TuiSmokeGoalMenuActionKind;
	public final status:String;
	public final objective:String;
	public final commandHint:String;
	public final indicator:String;
	public final usage:String;
	public final validationSource:String;
	public final failureCode:String;
	public final tokenBudget:Int;
	public final tokensUsed:Int;
	public final timeUsedSeconds:Int;
	public final actualChars:Int;
	public final maxChars:Int;
	public final activeTurnElapsedSeconds:Int;
	public final budgetPresent:Bool;
	public final summaryInserted:Bool;
	public final editPromptOpened:Bool;
	public final editedStatus:String;
	public final setObjectiveEvent:Bool;
	public final resumePromptOpened:Bool;
	public final resumeDefaultSelected:Bool;
	public final setStatusEvent:Bool;
	public final leavePausedSelected:Bool;
	public final allowed:Bool;
	public final errorInserted:Bool;
	public final composerCleared:Bool;
	public final pendingSubmissionDrained:Bool;
	public final activeGoalPaused:Bool;
	public final currentGoalCleared:Bool;
	public final collaborationIndicatorUpdated:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final unsupportedRejected:Bool;
}
