package codexhx.runtime.tui.smoke;

typedef TuiSmokeMultiSelectActionFields = {
	final kind:TuiSmokeMultiSelectActionKind;
	final name:String;
	final items:Array<TuiSmokeMultiSelectItem>;
	final query:String;
	final selectedIndex:Int;
	final scrollTop:Int;
	final maxVisibleRows:Int;
	final width:Int;
	final headerHeight:Int;
	final hasPreview:Bool;
	final orderingEnabled:Bool;
	final moveCount:Int;
	final expectedQuery:String;
	final expectedFilteredIndices:Array<Int>;
	final expectedOrder:Array<String>;
	final expectedEnabledIds:Array<String>;
	final expectedRows:Array<String>;
	final expectedSelectedIndex:Int;
	final expectedSelectedActual:Int;
	final expectedScrollTop:Int;
	final expectedChangeCount:Int;
	final expectedConfirmedIds:Array<String>;
	final expectedCancelled:Bool;
	final expectedComplete:Bool;
	final expectedPreview:String;
	final expectedHeight:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noClipboardMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final noAppEventDelivery:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMultiSelectAction {
	@:recordDefault(TuiSmokeMultiSelectActionKind.Unknown)
	public final kind:TuiSmokeMultiSelectActionKind;
	public final name:String;
	public final items:Array<TuiSmokeMultiSelectItem>;
	public final query:String;
	public final selectedIndex:Int;
	public final scrollTop:Int;
	public final maxVisibleRows:Int;
	public final width:Int;
	public final headerHeight:Int;
	public final hasPreview:Bool;
	public final orderingEnabled:Bool;
	public final moveCount:Int;
	public final expectedQuery:String;
	public final expectedFilteredIndices:Array<Int>;
	public final expectedOrder:Array<String>;
	public final expectedEnabledIds:Array<String>;
	public final expectedRows:Array<String>;
	public final expectedSelectedIndex:Int;
	public final expectedSelectedActual:Int;
	public final expectedScrollTop:Int;
	public final expectedChangeCount:Int;
	public final expectedConfirmedIds:Array<String>;
	public final expectedCancelled:Bool;
	public final expectedComplete:Bool;
	public final expectedPreview:String;
	public final expectedHeight:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noClipboardMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final noAppEventDelivery:Bool;
	public final unsupportedRejected:Bool;
}
