package codexhx.runtime.tui.smoke;

typedef TuiSmokeAgentNavigationActionFields = {
	final kind:TuiSmokeAgentNavigationActionKind;
	final threadId:String;
	final agentNickname:String;
	final agentRole:String;
	final agentPath:String;
	final isPrimary:Bool;
	final isRunning:Bool;
	final isClosed:Bool;
	final currentThreadId:String;
	final primaryThreadId:String;
	final direction:TuiSmokeAgentNavigationDirectionKind;
	final expectedThreadId:String;
	final expectedLabel:String;
	final expectedSubtitle:String;
	final expectedOrder:Array<String>;
	final expectedHasNonPrimary:Bool;
	final loadedThreads:Array<TuiSmokeLoadedThread>;
	final lastBackfillPrimaryThreadId:String;
	final expectedBackfillAttempted:Bool;
	final expectedBackfillSucceeded:Bool;
	final expectedLastBackfillPrimaryThreadId:String;
	final failureCode:String;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final noFilesystemMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAgentNavigationAction {
	@:recordDefault(TuiSmokeAgentNavigationActionKind.Unknown)
	public final kind:TuiSmokeAgentNavigationActionKind;
	public final threadId:String;
	public final agentNickname:String;
	public final agentRole:String;
	public final agentPath:String;
	public final isPrimary:Bool;
	public final isRunning:Bool;
	public final isClosed:Bool;
	public final currentThreadId:String;
	public final primaryThreadId:String;
	@:recordDefault(TuiSmokeAgentNavigationDirectionKind.Unknown)
	public final direction:TuiSmokeAgentNavigationDirectionKind;
	public final expectedThreadId:String;
	public final expectedLabel:String;
	public final expectedSubtitle:String;
	public final expectedOrder:Array<String>;
	public final expectedHasNonPrimary:Bool;
	public final loadedThreads:Array<TuiSmokeLoadedThread>;
	public final lastBackfillPrimaryThreadId:String;
	public final expectedBackfillAttempted:Bool;
	public final expectedBackfillSucceeded:Bool;
	public final expectedLastBackfillPrimaryThreadId:String;
	public final failureCode:String;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final unsupportedRejected:Bool;
}
