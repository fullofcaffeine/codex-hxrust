package codexhx.runtime.tui.smoke;

typedef TuiSmokeWindowsSandboxPlanFields = {
	final allowOsSandboxMutation:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeWindowsSandboxAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeWindowsSandboxPlan {
	public final allowOsSandboxMutation:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeWindowsSandboxAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
