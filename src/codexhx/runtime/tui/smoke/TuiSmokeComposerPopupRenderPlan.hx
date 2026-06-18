package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupRenderPlanFields = {
	final allowLiveTerminal:Bool;
	final allowRatatuiRender:Bool;
	final actions:Array<TuiSmokeComposerPopupRenderAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerPopupRenderPlan {
	public final allowLiveTerminal:Bool;
	public final allowRatatuiRender:Bool;
	public final actions:Array<TuiSmokeComposerPopupRenderAction>;

	public function enabled():Bool {
		return !allowLiveTerminal && !allowRatatuiRender && actions.length > 0;
	}
}
