package codexhx.runtime.tui.smoke;

typedef TuiSmokeGoalDisplayActionFields = {
	final kind:TuiSmokeGoalDisplayActionKind;
	final status:String;
	final objective:String;
	final expectedLabel:String;
	final expectedElapsed:String;
	final expectedSummary:String;
	final failureCode:String;
	final seconds:Int;
	final tokenBudget:Int;
	final tokensUsed:Int;
	final timeUsedSeconds:Int;
	final hasTokenBudget:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeGoalDisplayAction {
	public final kind:TuiSmokeGoalDisplayActionKind;
	public final status:String;
	public final objective:String;
	public final expectedLabel:String;
	public final expectedElapsed:String;
	public final expectedSummary:String;
	public final failureCode:String;
	public final seconds:Int;
	public final tokenBudget:Int;
	public final tokensUsed:Int;
	public final timeUsedSeconds:Int;
	public final hasTokenBudget:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final unsupportedRejected:Bool;
}
