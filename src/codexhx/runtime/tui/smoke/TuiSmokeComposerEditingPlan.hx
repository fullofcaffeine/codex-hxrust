package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerEditingPlanFields = {
	final allowLiveInput:Bool;
	final actions:Array<TuiSmokeComposerEditingAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerEditingPlan {
	public final allowLiveInput:Bool;
	public final actions:Array<TuiSmokeComposerEditingAction>;

	public function enabled():Bool {
		return !allowLiveInput && actions.length > 0;
	}
}
