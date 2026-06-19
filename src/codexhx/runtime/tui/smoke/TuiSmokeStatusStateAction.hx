package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusStateActionFields = {
	final kind:TuiSmokeStatusStateActionKind;
	final id:String;
	final header:String;
	final details:String;
	final detail:String;
	final entries:String;
	final terminalTitleStatusKind:String;
	final retryHeaderBefore:String;
	final retryHeaderAfter:String;
	final takenHeader:String;
	final failureCode:String;
	final entryCount:Int;
	final detailsMaxLines:Int;
	final overflowCount:Int;
	final changed:Bool;
	final guardianEmpty:Bool;
	final statusPresent:Bool;
	final guardianReviewHeader:Bool;
	final retryHeaderRemembered:Bool;
	final retryHeaderTaken:Bool;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusStateAction {
	public final kind:TuiSmokeStatusStateActionKind;
	public final id:String;
	public final header:String;
	public final details:String;
	public final detail:String;
	public final entries:String;
	public final terminalTitleStatusKind:String;
	public final retryHeaderBefore:String;
	public final retryHeaderAfter:String;
	public final takenHeader:String;
	public final failureCode:String;
	public final entryCount:Int;
	public final detailsMaxLines:Int;
	public final overflowCount:Int;
	public final changed:Bool;
	public final guardianEmpty:Bool;
	public final statusPresent:Bool;
	public final guardianReviewHeader:Bool;
	public final retryHeaderRemembered:Bool;
	public final retryHeaderTaken:Bool;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
