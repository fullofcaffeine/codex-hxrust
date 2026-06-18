package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerPopupKeyPlanFields = {
	final allowLiveInput:Bool;
	final allowLiveFileProbe:Bool;
	final actions:Array<TuiSmokeComposerPopupKeyAction>;
}

class TuiSmokeComposerPopupKeyPlan {
	public final allowLiveInput:Bool;
	public final allowLiveFileProbe:Bool;
	public final actions:Array<TuiSmokeComposerPopupKeyAction>;

	public function new(fields:TuiSmokeComposerPopupKeyPlanFields) {
		this.allowLiveInput = fields.allowLiveInput;
		this.allowLiveFileProbe = fields.allowLiveFileProbe;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveInput && !allowLiveFileProbe && actions.length > 0;
	}
}
