package codexhx.runtime.tui.smoke;

typedef TuiSmokeApprovalPlanFields = {
	final allowLiveApproval:Bool;
	final actions:Array<TuiSmokeApprovalAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeApprovalPlan {
	public final allowLiveApproval:Bool;
	public final actions:Array<TuiSmokeApprovalAction>;

	public function enabled():Bool {
		return !allowLiveApproval && actions.length > 0;
	}
}
