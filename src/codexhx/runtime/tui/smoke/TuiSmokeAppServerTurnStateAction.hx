package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerTurnStateActionFields = {
	final kind:TuiSmokeAppServerTurnStateActionKind;
	final threadId:String;
	final turnId:String;
	final itemId:String;
	final userText:String;
	final answerText:String;
	final feedbackCategory:String;
	final failureCode:String;
	final composerSubmitted:Bool;
	final userTurnOpQueued:Bool;
	final localPromptHistoryCells:Int;
	final incomingPromptHistoryCells:Int;
	final duplicateSuppressed:Bool;
	final turnStarted:Bool;
	final statusHeaderBefore:String;
	final statusHeaderAfter:String;
	final answerHistoryCells:Int;
	final taskRunningBefore:Bool;
	final taskRunningAfter:Bool;
	final statusWidgetCleared:Bool;
	final feedbackSubmitted:Bool;
	final submittedTurnId:String;
	final includeLogs:Bool;
	final noAppServerDelivery:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Typed headless evidence for one upstream ChatWidget app-server turn-state behavior. */
class TuiSmokeAppServerTurnStateAction {
	public final kind:TuiSmokeAppServerTurnStateActionKind;
	public final threadId:String;
	public final turnId:String;
	public final itemId:String;
	public final userText:String;
	public final answerText:String;
	public final feedbackCategory:String;
	public final failureCode:String;
	public final composerSubmitted:Bool;
	public final userTurnOpQueued:Bool;
	public final localPromptHistoryCells:Int;
	public final incomingPromptHistoryCells:Int;
	public final duplicateSuppressed:Bool;
	public final turnStarted:Bool;
	public final statusHeaderBefore:String;
	public final statusHeaderAfter:String;
	public final answerHistoryCells:Int;
	public final taskRunningBefore:Bool;
	public final taskRunningAfter:Bool;
	public final statusWidgetCleared:Bool;
	public final feedbackSubmitted:Bool;
	public final submittedTurnId:String;
	public final includeLogs:Bool;
	public final noAppServerDelivery:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
