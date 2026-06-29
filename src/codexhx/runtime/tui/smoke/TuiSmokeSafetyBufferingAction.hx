package codexhx.runtime.tui.smoke;

typedef TuiSmokeSafetyBufferingActionFields = {
	final kind:TuiSmokeSafetyBufferingActionKind;
	final threadId:String;
	final turnId:String;
	final fasterModel:String;
	final replayKind:String;
	final message:String;
	final renderedPopup:String;
	final failureCode:String;
	final promptShown:Bool;
	final retryPromptShownBefore:Bool;
	final retryEventQueued:Bool;
	final retryClearedPrompt:Bool;
	final turnCaptured:Bool;
	final agentMessageStarted:Bool;
	final canRetryBefore:Bool;
	final canRetryAfter:Bool;
	final statusShown:Bool;
	final shortMessage:Bool;
	final ignoredHidden:Bool;
	final ignoredStale:Bool;
	final ignoredHistorical:Bool;
	final hiddenCleared:Bool;
	final statusDetailsCleared:Bool;
	final noAppServerDelivery:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Typed headless evidence for one upstream ChatWidget safety-buffering behavior. */
class TuiSmokeSafetyBufferingAction {
	public final kind:TuiSmokeSafetyBufferingActionKind;
	public final threadId:String;
	public final turnId:String;
	public final fasterModel:String;
	public final replayKind:String;
	public final message:String;
	public final renderedPopup:String;
	public final failureCode:String;
	public final promptShown:Bool;
	public final retryPromptShownBefore:Bool;
	public final retryEventQueued:Bool;
	public final retryClearedPrompt:Bool;
	public final turnCaptured:Bool;
	public final agentMessageStarted:Bool;
	public final canRetryBefore:Bool;
	public final canRetryAfter:Bool;
	public final statusShown:Bool;
	public final shortMessage:Bool;
	public final ignoredHidden:Bool;
	public final ignoredStale:Bool;
	public final ignoredHistorical:Bool;
	public final hiddenCleared:Bool;
	public final statusDetailsCleared:Bool;
	public final noAppServerDelivery:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
