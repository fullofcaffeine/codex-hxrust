package codexhx.runtime.tui.smoke;

typedef TuiSmokePendingThreadApprovalsActionFields = {
	final kind:TuiSmokePendingThreadApprovalsActionKind;
	final name:String;
	final width:Int;
	final threads:Array<String>;
	final expectedChanged:Bool;
	final expectedEmpty:Bool;
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
class TuiSmokePendingThreadApprovalsAction {
	public final kind:TuiSmokePendingThreadApprovalsActionKind;
	public final name:String;
	public final width:Int;
	public final threads:Array<String>;
	public final expectedChanged:Bool;
	public final expectedEmpty:Bool;
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
