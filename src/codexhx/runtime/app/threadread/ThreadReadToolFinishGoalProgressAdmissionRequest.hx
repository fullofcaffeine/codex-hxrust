package codexhx.runtime.app.threadread;

class ThreadReadToolFinishGoalProgressAdmissionRequest {
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final turnId:String;
	public final callId:String;
	public final toolNamespace:String;
	public final toolName:String;
	public final outcomeKind:ThreadReadToolCallOutcomeKind;
	public final completedSuccess:Bool;
	public final failedHandlerExecuted:Bool;
	public final accountingOutcome:ThreadReadActiveGoalProgressAccountingOutcome;

	public function new(runtimeAvailable:Bool, runtimeEnabled:Bool, turnId:String, callId:String, toolNamespace:String, toolName:String,
			outcomeKind:ThreadReadToolCallOutcomeKind, completedSuccess:Bool, failedHandlerExecuted:Bool,
			accountingOutcome:ThreadReadActiveGoalProgressAccountingOutcome) {
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.turnId = turnId;
		this.callId = callId;
		this.toolNamespace = toolNamespace;
		this.toolName = toolName;
		this.outcomeKind = outcomeKind;
		this.completedSuccess = completedSuccess;
		this.failedHandlerExecuted = failedHandlerExecuted;
		this.accountingOutcome = accountingOutcome;
	}
}
