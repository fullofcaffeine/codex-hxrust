package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerErrorActionFields = {
	final kind:TuiSmokeAppServerErrorActionKind;
	final turnId:String;
	final itemId:String;
	final errorKind:String;
	final errorMessage:String;
	final renderedMessage:String;
	final streamSource:String;
	final statusHeaderBefore:String;
	final statusHeaderAfter:String;
	final verification:String;
	final failureCode:String;
	final firstHistoryCells:Int;
	final secondHistoryCells:Int;
	final warningHistoryCells:Int;
	final consolidateEvents:Int;
	final taskRunningBefore:Bool;
	final taskRunningAfter:Bool;
	final willRetry:Bool;
	final retryStatusStored:Bool;
	final retryStatusCleared:Bool;
	final duplicateSuppressed:Bool;
	final activeStreamConsolidated:Bool;
	final fallbackMessageSuppressed:Bool;
	final dedicatedNotice:Bool;
	final noAppServerDelivery:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Typed headless evidence for one upstream ChatWidget app-server error behavior. */
class TuiSmokeAppServerErrorAction {
	public final kind:TuiSmokeAppServerErrorActionKind;
	public final turnId:String;
	public final itemId:String;
	public final errorKind:String;
	public final errorMessage:String;
	public final renderedMessage:String;
	public final streamSource:String;
	public final statusHeaderBefore:String;
	public final statusHeaderAfter:String;
	public final verification:String;
	public final failureCode:String;
	public final firstHistoryCells:Int;
	public final secondHistoryCells:Int;
	public final warningHistoryCells:Int;
	public final consolidateEvents:Int;
	public final taskRunningBefore:Bool;
	public final taskRunningAfter:Bool;
	public final willRetry:Bool;
	public final retryStatusStored:Bool;
	public final retryStatusCleared:Bool;
	public final duplicateSuppressed:Bool;
	public final activeStreamConsolidated:Bool;
	public final fallbackMessageSuppressed:Bool;
	public final dedicatedNotice:Bool;
	public final noAppServerDelivery:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
