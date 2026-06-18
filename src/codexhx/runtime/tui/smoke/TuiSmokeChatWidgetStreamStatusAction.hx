package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetStreamStatusActionFields = {
	final kind:TuiSmokeChatWidgetStreamStatusActionKind;
	final phase:String;
	final titleKind:String;
	final runState:String;
	final header:String;
	final details:String;
	final failureCode:String;
	final reasoningDelta:String;
	final extractedHeader:String;
	final reasoningBufferLength:Int;
	final fullReasoningBufferLength:Int;
	final detailsMaxLines:Int;
	final queuedLines:Int;
	final pendingSteers:Int;
	final pendingRestoreBefore:Bool;
	final pendingRestoreAfter:Bool;
	final taskRunning:Bool;
	final streamIdle:Bool;
	final statusEnsured:Bool;
	final statusUpdated:Bool;
	final statusHidden:Bool;
	final statusRestored:Bool;
	final titleUsesStatus:Bool;
	final statusSurfacesRefreshed:Bool;
	final retryHeaderRemembered:Bool;
	final historyInserted:Bool;
	final reasoningCleared:Bool;
	final unifiedExecWaitActive:Bool;
	final requestRedraw:Bool;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeChatWidgetStreamStatusAction {
	public final kind:TuiSmokeChatWidgetStreamStatusActionKind;
	public final phase:String;
	public final titleKind:String;
	public final runState:String;
	public final header:String;
	public final details:String;
	public final failureCode:String;
	public final reasoningDelta:String;
	public final extractedHeader:String;
	public final reasoningBufferLength:Int;
	public final fullReasoningBufferLength:Int;
	public final detailsMaxLines:Int;
	public final queuedLines:Int;
	public final pendingSteers:Int;
	public final pendingRestoreBefore:Bool;
	public final pendingRestoreAfter:Bool;
	public final taskRunning:Bool;
	public final streamIdle:Bool;
	public final statusEnsured:Bool;
	public final statusUpdated:Bool;
	public final statusHidden:Bool;
	public final statusRestored:Bool;
	public final titleUsesStatus:Bool;
	public final statusSurfacesRefreshed:Bool;
	public final retryHeaderRemembered:Bool;
	public final historyInserted:Bool;
	public final reasoningCleared:Bool;
	public final unifiedExecWaitActive:Bool;
	public final requestRedraw:Bool;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;

}
