package codexhx.runtime.tui.smoke;

typedef TuiSmokeMcpElicitationPlanFields = {
	final allowLiveElicitation:Bool;
	final actions:Array<TuiSmokeMcpElicitationAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMcpElicitationPlan {
	public final allowLiveElicitation:Bool;
	public final actions:Array<TuiSmokeMcpElicitationAction>;

	public function enabled():Bool {
		return !allowLiveElicitation && actions.length > 0;
	}
}
