package codexhx.runtime.tui.smoke;

typedef TuiSmokeMarkdownTextMergePlanFields = {
	final allowTerminalMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeMarkdownTextMergeAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMarkdownTextMergePlan {
	public final allowTerminalMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeMarkdownTextMergeAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
