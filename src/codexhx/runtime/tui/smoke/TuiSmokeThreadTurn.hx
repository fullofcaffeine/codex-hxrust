package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadTurnFields = {
	final turnId:String;
	final status:TuiSmokeThreadTurnStatus;
	final items:Array<TuiSmokeThreadItem>;
}

class TuiSmokeThreadTurn {
	public final turnId:String;
	public final status:TuiSmokeThreadTurnStatus;
	public final items:Array<TuiSmokeThreadItem>;

	public function new(fields:TuiSmokeThreadTurnFields) {
		this.turnId = fields.turnId == null ? "" : fields.turnId;
		this.status = fields.status == null ? TuiSmokeThreadTurnStatus.Unknown : fields.status;
		this.items = fields.items == null ? [] : fields.items;
	}

	public function isTerminal():Bool {
		return status == TuiSmokeThreadTurnStatus.Completed
			|| status == TuiSmokeThreadTurnStatus.Interrupted
			|| status == TuiSmokeThreadTurnStatus.Failed;
	}
}
