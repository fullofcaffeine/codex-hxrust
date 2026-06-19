package codexhx.runtime.tui.smoke;

typedef TuiSmokePermissionSelectionPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowFilesystemMutation:Bool;
	final actions:Array<TuiSmokePermissionSelectionAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokePermissionSelectionPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowFilesystemMutation:Bool;
	public final actions:Array<TuiSmokePermissionSelectionAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
