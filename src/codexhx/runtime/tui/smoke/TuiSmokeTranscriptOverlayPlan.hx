package codexhx.runtime.tui.smoke;

typedef TuiSmokeTranscriptOverlayPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowAppServerMutation:Bool;
	final actions:Array<TuiSmokeTranscriptOverlayAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTranscriptOverlayPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerMutation:Bool;
	public final actions:Array<TuiSmokeTranscriptOverlayAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
