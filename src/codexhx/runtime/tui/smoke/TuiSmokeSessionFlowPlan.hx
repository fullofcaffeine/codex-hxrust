package codexhx.runtime.tui.smoke;

typedef TuiSmokeSessionFlowPlanFields = {
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeSessionFlowAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSessionFlowPlan {
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeSessionFlowAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
