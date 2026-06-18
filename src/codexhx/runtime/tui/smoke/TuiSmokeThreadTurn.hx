package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadTurnFields = {
	final turnId:String;
	final status:TuiSmokeThreadTurnStatus;
	final items:Array<TuiSmokeThreadItem>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadTurn {
	public final turnId:String;
	public final status:TuiSmokeThreadTurnStatus;
	public final items:Array<TuiSmokeThreadItem>;

	public function isTerminal():Bool {
		return status == TuiSmokeThreadTurnStatus.Completed
			|| status == TuiSmokeThreadTurnStatus.Interrupted
			|| status == TuiSmokeThreadTurnStatus.Failed;
	}
}
