package codexhx.runtime.tui.smoke;

typedef TuiSmokeTurnRuntimePlanFields = {
	final allowLiveProcess:Bool;
	final allowFilesystemMutation:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeTurnRuntimeAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTurnRuntimePlan {
	public final allowLiveProcess:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeTurnRuntimeAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
