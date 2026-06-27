package codexhx.runtime.tui.smoke;

typedef TuiSmokeListSelectionActionFields = {
	final kind:TuiSmokeListSelectionActionKind;
	final name:String;
	final items:Array<TuiSmokeListSelectionItem>;
	final isSearchable:Bool;
	final query:String;
	final previousSelectedActual:Int;
	final initialSelectedActual:Int;
	final selectedVisibleIndex:Int;
	final scrollTop:Int;
	final maxVisibleRows:Int;
	final width:Int;
	final sideWidthKind:TuiSmokeListSelectionSideWidthKind;
	final sideWidth:Int;
	final sideMinWidth:Int;
	final rowDisplay:TuiSmokeListSelectionRowDisplay;
	final headerHeight:Int;
	final tabCount:Int;
	final footerNoteLines:Int;
	final footerHintPresent:Bool;
	final sideContentHeight:Int;
	final expectedContentWidth:Int;
	final expectedSideLayout:String;
	final expectedDesiredHeight:Int;
	final expectedFilteredIndices:Array<Int>;
	final expectedSelectedVisibleIndex:Int;
	final expectedSelectedActualIndex:Int;
	final expectedScrollTop:Int;
	final expectedRows:Array<String>;
	final expectedAccepted:Bool;
	final expectedCancelled:Bool;
	final expectedLastSelectedActual:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noClipboardMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeListSelectionAction {
	@:recordDefault(TuiSmokeListSelectionActionKind.Unknown)
	public final kind:TuiSmokeListSelectionActionKind;
	public final name:String;
	public final items:Array<TuiSmokeListSelectionItem>;
	public final isSearchable:Bool;
	public final query:String;
	public final previousSelectedActual:Int;
	public final initialSelectedActual:Int;
	public final selectedVisibleIndex:Int;
	public final scrollTop:Int;
	public final maxVisibleRows:Int;
	public final width:Int;
	@:recordDefault(TuiSmokeListSelectionSideWidthKind.Disabled)
	public final sideWidthKind:TuiSmokeListSelectionSideWidthKind;
	public final sideWidth:Int;
	public final sideMinWidth:Int;
	@:recordDefault(TuiSmokeListSelectionRowDisplay.SingleLine)
	public final rowDisplay:TuiSmokeListSelectionRowDisplay;
	public final headerHeight:Int;
	public final tabCount:Int;
	public final footerNoteLines:Int;
	public final footerHintPresent:Bool;
	public final sideContentHeight:Int;
	public final expectedContentWidth:Int;
	public final expectedSideLayout:String;
	public final expectedDesiredHeight:Int;
	public final expectedFilteredIndices:Array<Int>;
	public final expectedSelectedVisibleIndex:Int;
	public final expectedSelectedActualIndex:Int;
	public final expectedScrollTop:Int;
	public final expectedRows:Array<String>;
	public final expectedAccepted:Bool;
	public final expectedCancelled:Bool;
	public final expectedLastSelectedActual:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noClipboardMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
