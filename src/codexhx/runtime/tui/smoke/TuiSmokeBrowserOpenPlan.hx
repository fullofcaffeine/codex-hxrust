package codexhx.runtime.tui.smoke;

typedef TuiSmokeBrowserOpenPlanFields = {
	final allowLiveBrowserLaunch:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeBrowserOpenAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeBrowserOpenPlan {
	public final allowLiveBrowserLaunch:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeBrowserOpenAction>;

	public function enabled():Bool {
		return !allowLiveBrowserLaunch && !allowModelCall && !allowAppServerMutation && actions != null && actions.length > 0;
	}
}
