package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerTextareaRenderPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final actions:Array<TuiSmokeComposerTextareaRenderAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerTextareaRenderPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final actions:Array<TuiSmokeComposerTextareaRenderAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && actions.length > 0;
	}
}
