package codexhx.runtime.tui.smoke;

typedef TuiSmokeSlashPopupPlanFields = {
	final allowLiveInput:Bool;
	final actions:Array<TuiSmokeSlashPopupAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSlashPopupPlan {
	public final allowLiveInput:Bool;
	public final actions:Array<TuiSmokeSlashPopupAction>;

	public function enabled():Bool {
		return !allowLiveInput && actions.length > 0;
	}
}
