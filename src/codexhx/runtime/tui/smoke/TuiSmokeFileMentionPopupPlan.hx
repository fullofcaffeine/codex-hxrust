package codexhx.runtime.tui.smoke;

typedef TuiSmokeFileMentionPopupPlanFields = {
	final allowLiveFileSearch:Bool;
	final actions:Array<TuiSmokeFileMentionPopupAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeFileMentionPopupPlan {
	public final allowLiveFileSearch:Bool;
	public final actions:Array<TuiSmokeFileMentionPopupAction>;

	public function enabled():Bool {
		return !allowLiveFileSearch && actions.length > 0;
	}
}
