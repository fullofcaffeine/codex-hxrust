package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerAttachmentPlanFields = {
	final allowLiveFilesystem:Bool;
	final actions:Array<TuiSmokeComposerAttachmentAction>;
}

class TuiSmokeComposerAttachmentPlan {
	public final allowLiveFilesystem:Bool;
	public final actions:Array<TuiSmokeComposerAttachmentAction>;

	public function new(fields:TuiSmokeComposerAttachmentPlanFields) {
		this.allowLiveFilesystem = fields.allowLiveFilesystem;
		this.actions = fields.actions == null ? [] : fields.actions;
	}

	public function enabled():Bool {
		return !allowLiveFilesystem && actions.length > 0;
	}
}
