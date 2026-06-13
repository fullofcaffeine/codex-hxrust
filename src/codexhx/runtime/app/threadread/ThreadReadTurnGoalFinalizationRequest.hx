package codexhx.runtime.app.threadread;

class ThreadReadTurnGoalFinalizationRequest {
	public final kind:ThreadReadTurnGoalFinalizationKind;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final turnId:String;
	public final accountingOutcome:ThreadReadActiveGoalProgressAccountingOutcome;

	public function new(
		kind:ThreadReadTurnGoalFinalizationKind,
		runtimeAvailable:Bool,
		runtimeEnabled:Bool,
		turnId:String,
		accountingOutcome:ThreadReadActiveGoalProgressAccountingOutcome
	) {
		this.kind = kind;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.turnId = turnId;
		this.accountingOutcome = accountingOutcome;
	}
}
