package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupSyncPlanFields = {
	final allowLiveFileSearch:Bool;
	final actions:Array<TuiSmokeComposerPopupSyncAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerPopupSyncPlan {
	public final allowLiveFileSearch:Bool;
	public final actions:Array<TuiSmokeComposerPopupSyncAction>;

	public function enabled():Bool {
		return !allowLiveFileSearch && actions.length > 0;
	}
}
