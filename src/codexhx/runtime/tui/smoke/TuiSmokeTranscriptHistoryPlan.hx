package codexhx.runtime.tui.smoke;

typedef TuiSmokeTranscriptHistoryPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeTranscriptHistoryAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTranscriptHistoryPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeTranscriptHistoryAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
