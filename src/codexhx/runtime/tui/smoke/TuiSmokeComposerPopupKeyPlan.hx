package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupKeyPlanFields = {
	final allowLiveInput:Bool;
	final allowLiveFileProbe:Bool;
	final actions:Array<TuiSmokeComposerPopupKeyAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerPopupKeyPlan {
	public final allowLiveInput:Bool;
	public final allowLiveFileProbe:Bool;
	public final actions:Array<TuiSmokeComposerPopupKeyAction>;

	public function enabled():Bool {
		return !allowLiveInput && !allowLiveFileProbe && actions.length > 0;
	}
}
