package codexhx.runtime.tui.smoke;

typedef TuiSmokeSlashCommandActionFields = {
	final kind:TuiSmokeSlashCommandActionKind;
	final source:String;
	final command:String;
	final args:String;
	final appEvent:String;
	final notice:String;
	final statusCard:String;
	final failureCode:String;
	final requestId:Int;
	final historyStaged:Bool;
	final historyRecorded:Bool;
	final taskRunning:Bool;
	final sideConversation:Bool;
	final sideAllowed:Bool;
	final commandAllowed:Bool;
	final supportsInlineArgs:Bool;
	final argsTrimmed:Bool;
	final fallbackToBare:Bool;
	final rawOutputBefore:Bool;
	final rawOutputAfter:Bool;
	final configUpdated:Bool;
	final noticeInserted:Bool;
	final statusSurfacesRefreshed:Bool;
	final appEventSent:Bool;
	final statusOutputInserted:Bool;
	final rateLimitPrefetch:Bool;
	final statusRefreshing:Bool;
	final submissionDrained:Bool;
	final redrawRequested:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSlashCommandAction {
	public final kind:TuiSmokeSlashCommandActionKind;
	public final source:String;
	public final command:String;
	public final args:String;
	public final appEvent:String;
	public final notice:String;
	public final statusCard:String;
	public final failureCode:String;
	public final requestId:Int;
	public final historyStaged:Bool;
	public final historyRecorded:Bool;
	public final taskRunning:Bool;
	public final sideConversation:Bool;
	public final sideAllowed:Bool;
	public final commandAllowed:Bool;
	public final supportsInlineArgs:Bool;
	public final argsTrimmed:Bool;
	public final fallbackToBare:Bool;
	public final rawOutputBefore:Bool;
	public final rawOutputAfter:Bool;
	public final configUpdated:Bool;
	public final noticeInserted:Bool;
	public final statusSurfacesRefreshed:Bool;
	public final appEventSent:Bool;
	public final statusOutputInserted:Bool;
	public final rateLimitPrefetch:Bool;
	public final statusRefreshing:Bool;
	public final submissionDrained:Bool;
	public final redrawRequested:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final unsupportedRejected:Bool;
}
