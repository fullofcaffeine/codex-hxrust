package codexhx.runtime.tui.smoke;

typedef TuiSmokeHistorySearchPlanFields = {
	final allowLiveHistoryLookup:Bool;
	final actions:Array<TuiSmokeHistorySearchAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeHistorySearchPlan {
	public final allowLiveHistoryLookup:Bool;
	public final actions:Array<TuiSmokeHistorySearchAction>;

	public function enabled():Bool {
		return !allowLiveHistoryLookup && actions.length > 0;
	}
}
