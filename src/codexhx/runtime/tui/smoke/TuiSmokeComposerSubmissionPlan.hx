package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerSubmissionPlanFields = {
	final allowLiveDispatch:Bool;
	final actions:Array<TuiSmokeComposerSubmissionAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerSubmissionPlan {
	public final allowLiveDispatch:Bool;
	public final actions:Array<TuiSmokeComposerSubmissionAction>;

	public function enabled():Bool {
		return !allowLiveDispatch && actions.length > 0;
	}
}
