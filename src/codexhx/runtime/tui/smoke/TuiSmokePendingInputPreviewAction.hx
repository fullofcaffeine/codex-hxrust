package codexhx.runtime.tui.smoke;

typedef TuiSmokePendingInputPreviewActionFields = {
	final kind:TuiSmokePendingInputPreviewActionKind;
	final name:String;
	final width:Int;
	final pendingSteers:Array<String>;
	final rejectedSteers:Array<String>;
	final queuedMessages:Array<String>;
	final editBinding:String;
	final interruptBinding:String;
	final expectedHeight:Int;
	final expectedRows:Array<String>;
	final expectedNoEllipsis:Bool;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokePendingInputPreviewAction {
	public final kind:TuiSmokePendingInputPreviewActionKind;
	public final name:String;
	public final width:Int;
	public final pendingSteers:Array<String>;
	public final rejectedSteers:Array<String>;
	public final queuedMessages:Array<String>;
	public final editBinding:String;
	public final interruptBinding:String;
	public final expectedHeight:Int;
	public final expectedRows:Array<String>;
	public final expectedNoEllipsis:Bool;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
