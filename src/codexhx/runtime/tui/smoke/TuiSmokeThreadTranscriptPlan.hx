package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadTranscriptPlanFields = {
	final allowAppServerRead:Bool;
	final allowRatatuiRender:Bool;
	final allowFilesystemMutation:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeThreadTranscriptAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadTranscriptPlan {
	public final allowAppServerRead:Bool;
	public final allowRatatuiRender:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeThreadTranscriptAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
