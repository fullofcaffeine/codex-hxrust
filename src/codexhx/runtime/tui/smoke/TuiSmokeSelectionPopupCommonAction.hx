package codexhx.runtime.tui.smoke;

typedef TuiSmokeSelectionPopupCommonActionFields = {
	final kind:TuiSmokeSelectionPopupCommonActionKind;
	final name:String;
	final rows:Array<TuiSmokeSelectionPopupRow>;
	final columnMode:TuiSmokeSelectionPopupColumnMode;
	final x:Int;
	final y:Int;
	final width:Int;
	final height:Int;
	final maxResults:Int;
	final scrollTop:Int;
	final selectedIndex:Int;
	final nameColumnWidth:Int;
	final hasNameColumnWidth:Bool;
	final emptyMessage:String;
	final rowIndex:Int;
	final expectedInset:String;
	final expectedPaddingHeight:Int;
	final expectedDescCol:Int;
	final expectedStartIndex:Int;
	final expectedRenderedLines:Int;
	final expectedMeasuredHeight:Int;
	final expectedRows:Array<String>;
	final expectedVisibleSelected:Bool;
	final expectedWrapIndent:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSelectionPopupCommonAction {
	public final kind:TuiSmokeSelectionPopupCommonActionKind;
	public final name:String;
	public final rows:Array<TuiSmokeSelectionPopupRow>;
	public final columnMode:TuiSmokeSelectionPopupColumnMode;
	public final x:Int;
	public final y:Int;
	public final width:Int;
	public final height:Int;
	public final maxResults:Int;
	public final scrollTop:Int;
	public final selectedIndex:Int;
	public final nameColumnWidth:Int;
	public final hasNameColumnWidth:Bool;
	public final emptyMessage:String;
	public final rowIndex:Int;
	public final expectedInset:String;
	public final expectedPaddingHeight:Int;
	public final expectedDescCol:Int;
	public final expectedStartIndex:Int;
	public final expectedRenderedLines:Int;
	public final expectedMeasuredHeight:Int;
	public final expectedRows:Array<String>;
	public final expectedVisibleSelected:Bool;
	public final expectedWrapIndent:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
