package codexhx.runtime.tui.smoke;

typedef TuiSmokeSessionArchiveCommandActionFields = {
	final kind:TuiSmokeSessionArchiveCommandActionKind;
	final action:String;
	final requestId:String;
	final method:String;
	final target:String;
	final searchScope:String;
	final threadId:String;
	final threadName:String;
	final responseThreadId:String;
	final responseThreadName:String;
	final failureCode:String;
	final errorMessage:String;
	final successMessage:String;
	final cursor:String;
	final nextCursor:String;
	final pageSize:Int;
	final rowCount:Int;
	final validThreadId:Bool;
	final uuidParsed:Bool;
	final lookupRequested:Bool;
	final archivedScope:Bool;
	final includeNonInteractive:Bool;
	final exactNameMatched:Bool;
	final resolved:Bool;
	final archiveRequested:Bool;
	final unarchiveRequested:Bool;
	final mutationSucceeded:Bool;
	final responseEmpty:Bool;
	final responseHasThread:Bool;
	final errorWrapped:Bool;
	final noLiveTerminal:Bool;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final noFilesystemMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSessionArchiveCommandAction {
	@:recordDefault(TuiSmokeSessionArchiveCommandActionKind.Unknown)
	public final kind:TuiSmokeSessionArchiveCommandActionKind;
	public final action:String;
	public final requestId:String;
	public final method:String;
	public final target:String;
	public final searchScope:String;
	public final threadId:String;
	public final threadName:String;
	public final responseThreadId:String;
	public final responseThreadName:String;
	public final failureCode:String;
	public final errorMessage:String;
	public final successMessage:String;
	public final cursor:String;
	public final nextCursor:String;
	public final pageSize:Int;
	public final rowCount:Int;
	public final validThreadId:Bool;
	public final uuidParsed:Bool;
	public final lookupRequested:Bool;
	public final archivedScope:Bool;
	public final includeNonInteractive:Bool;
	public final exactNameMatched:Bool;
	public final resolved:Bool;
	public final archiveRequested:Bool;
	public final unarchiveRequested:Bool;
	public final mutationSucceeded:Bool;
	public final responseEmpty:Bool;
	public final responseHasThread:Bool;
	public final errorWrapped:Bool;
	public final noLiveTerminal:Bool;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final unsupportedRejected:Bool;
}
