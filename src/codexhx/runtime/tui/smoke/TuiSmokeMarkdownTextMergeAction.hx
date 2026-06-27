package codexhx.runtime.tui.smoke;

typedef TuiSmokeMarkdownTextMergeActionFields = {
	final kind:TuiSmokeMarkdownTextMergeActionKind;
	final name:String;
	final events:Array<TuiSmokeMarkdownTextEvent>;
	final expectedEvents:Array<TuiSmokeMarkdownTextEvent>;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMarkdownTextMergeAction {
	public final kind:TuiSmokeMarkdownTextMergeActionKind;
	public final name:String;
	public final events:Array<TuiSmokeMarkdownTextEvent>;
	public final expectedEvents:Array<TuiSmokeMarkdownTextEvent>;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
