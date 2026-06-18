package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerAttachmentPlanFields = {
	final allowLiveFilesystem:Bool;
	final actions:Array<TuiSmokeComposerAttachmentAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerAttachmentPlan {
	public final allowLiveFilesystem:Bool;
	public final actions:Array<TuiSmokeComposerAttachmentAction>;

	public function enabled():Bool {
		return !allowLiveFilesystem && actions.length > 0;
	}
}
