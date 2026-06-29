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
	final mainThreadId:String;
	final agentThreadId:String;
	final agentLabel:String;
	final requestKind:String;
	final turnId:String;
	final callId:String;
	final pendingBefore:Int;
	final pendingAfter:Int;
	final turnCompletedMatched:Bool;
	final inactiveThread:Bool;
	final activeThreadPreserved:Bool;
	final badgeCleared:Bool;
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
	public final mainThreadId:String;
	public final agentThreadId:String;
	public final agentLabel:String;
	public final requestKind:String;
	public final turnId:String;
	public final callId:String;
	public final pendingBefore:Int;
	public final pendingAfter:Int;
	public final turnCompletedMatched:Bool;
	public final inactiveThread:Bool;
	public final activeThreadPreserved:Bool;
	public final badgeCleared:Bool;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
