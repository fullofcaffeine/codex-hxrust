package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerFooterRenderPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final actions:Array<TuiSmokeComposerFooterRenderAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerFooterRenderPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final actions:Array<TuiSmokeComposerFooterRenderAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && actions.length > 0;
	}
}
