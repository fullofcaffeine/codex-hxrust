package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppLinkPlanFields = {
	final allowLiveBrowser:Bool;
	final actions:Array<TuiSmokeAppLinkAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAppLinkPlan {
	public final allowLiveBrowser:Bool;
	public final actions:Array<TuiSmokeAppLinkAction>;

	public function enabled():Bool {
		return !allowLiveBrowser && actions.length > 0;
	}
}
