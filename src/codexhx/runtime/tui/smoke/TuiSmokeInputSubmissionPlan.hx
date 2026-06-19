package codexhx.runtime.tui.smoke;

typedef TuiSmokeInputSubmissionPlanFields = {
	final allowLiveProcess:Bool;
	final allowFilesystemMutation:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeInputSubmissionAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeInputSubmissionPlan {
	public final allowLiveProcess:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeInputSubmissionAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
