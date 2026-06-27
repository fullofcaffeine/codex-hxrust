package codexhx.runtime.tui.smoke;

typedef TuiSmokeUnifiedExecFooterActionFields = {
	final kind:TuiSmokeUnifiedExecFooterActionKind;
	final name:String;
	final width:Int;
	final processes:Array<String>;
	final expectedChanged:Bool;
	final expectedEmpty:Bool;
	final expectedPresent:Bool;
	final expectedSummary:String;
	final expectedHeight:Int;
	final expectedRows:Array<String>;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeUnifiedExecFooterAction {
	public final kind:TuiSmokeUnifiedExecFooterActionKind;
	public final name:String;
	public final width:Int;
	public final processes:Array<String>;
	public final expectedChanged:Bool;
	public final expectedEmpty:Bool;
	public final expectedPresent:Bool;
	public final expectedSummary:String;
	public final expectedHeight:Int;
	public final expectedRows:Array<String>;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
