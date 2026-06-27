package codexhx.runtime.tui.smoke;

typedef TuiSmokeFileSearchPopupActionFields = {
	final kind:TuiSmokeFileSearchPopupActionKind;
	final name:String;
	final query:String;
	final paths:Array<String>;
	final expectedDisplayQuery:String;
	final expectedPendingQuery:String;
	final expectedWaiting:Bool;
	final expectedMatches:Array<String>;
	final expectedHeight:Int;
	final expectedSelectedPath:String;
	final expectedEmptyMessage:String;
	final expectedSelectedIndex:Int;
	final expectedScrollTop:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeFileSearchPopupAction {
	public final kind:TuiSmokeFileSearchPopupActionKind;
	public final name:String;
	public final query:String;
	public final paths:Array<String>;
	public final expectedDisplayQuery:String;
	public final expectedPendingQuery:String;
	public final expectedWaiting:Bool;
	public final expectedMatches:Array<String>;
	public final expectedHeight:Int;
	public final expectedSelectedPath:String;
	public final expectedEmptyMessage:String;
	public final expectedSelectedIndex:Int;
	public final expectedScrollTop:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
