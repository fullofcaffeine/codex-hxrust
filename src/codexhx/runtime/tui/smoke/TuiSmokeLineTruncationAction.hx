package codexhx.runtime.tui.smoke;

typedef TuiSmokeLineTruncationActionFields = {
	final kind:TuiSmokeLineTruncationActionKind;
	final name:String;
	final maxWidth:Int;
	final spans:Array<TuiSmokeLineTruncationSpan>;
	final expectedSpans:Array<TuiSmokeLineTruncationSpan>;
	final expectedWidth:Int;
	final failureCode:String;
	final noRatatuiRender:Bool;
	final noTerminalMutation:Bool;
	final noFilesystemMutation:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLineTruncationAction {
	public final kind:TuiSmokeLineTruncationActionKind;
	public final name:String;
	public final maxWidth:Int;
	public final spans:Array<TuiSmokeLineTruncationSpan>;
	public final expectedSpans:Array<TuiSmokeLineTruncationSpan>;
	public final expectedWidth:Int;
	public final failureCode:String;
	public final noRatatuiRender:Bool;
	public final noTerminalMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
