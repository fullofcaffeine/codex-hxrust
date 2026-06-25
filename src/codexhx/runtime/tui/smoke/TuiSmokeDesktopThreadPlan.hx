package codexhx.runtime.tui.smoke;

typedef TuiSmokeDesktopThreadPlanFields = {
	final allowLiveDesktopLaunch:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeDesktopThreadAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeDesktopThreadPlan {
	public final allowLiveDesktopLaunch:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeDesktopThreadAction>;

	public function enabled():Bool {
		return !allowLiveDesktopLaunch && !allowModelCall && !allowAppServerMutation && actions != null && actions.length > 0;
	}
}
