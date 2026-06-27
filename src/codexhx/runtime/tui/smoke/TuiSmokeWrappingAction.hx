package codexhx.runtime.tui.smoke;

typedef TuiSmokeWrappingActionFields = {
	final kind:TuiSmokeWrappingActionKind;
	final name:String;
	final text:String;
	final spans:Array<TuiSmokeWrappingSpan>;
	final width:Int;
	final subsequentIndent:String;
	final expectedBool:Bool;
	final expectedLines:Array<String>;
	final expectedRanges:Array<TuiSmokeWrappingRange>;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeWrappingAction {
	public final kind:TuiSmokeWrappingActionKind;
	public final name:String;
	public final text:String;
	public final spans:Array<TuiSmokeWrappingSpan>;
	public final width:Int;
	public final subsequentIndent:String;
	public final expectedBool:Bool;
	public final expectedLines:Array<String>;
	public final expectedRanges:Array<TuiSmokeWrappingRange>;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
