package codexhx.runtime.tui.smoke;

typedef TuiSmokeComposerAttachmentPlanFields = {
	final allowLiveFilesystem:Bool;
	final allowLiveClipboard:Bool;
	final allowProcessSpawn:Bool;
	final actions:Array<TuiSmokeComposerAttachmentAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeComposerAttachmentPlan {
	public final allowLiveFilesystem:Bool;
	public final allowLiveClipboard:Bool;
	public final allowProcessSpawn:Bool;
	public final actions:Array<TuiSmokeComposerAttachmentAction>;

	public function enabled():Bool {
		return !allowLiveFilesystem && !allowLiveClipboard && !allowProcessSpawn && actions.length > 0;
	}
}
