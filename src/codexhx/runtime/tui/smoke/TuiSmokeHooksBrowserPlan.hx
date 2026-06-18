package codexhx.runtime.tui.smoke;

typedef TuiSmokeHooksBrowserPlanFields = {
	final allowLiveHooks:Bool;
	final actions:Array<TuiSmokeHooksBrowserAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeHooksBrowserPlan {
	public final allowLiveHooks:Bool;
	public final actions:Array<TuiSmokeHooksBrowserAction>;

	public function enabled():Bool {
		return !allowLiveHooks && actions.length > 0;
	}
}
