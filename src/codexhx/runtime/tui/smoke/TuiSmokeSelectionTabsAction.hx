package codexhx.runtime.tui.smoke;

typedef TuiSmokeSelectionTabsActionFields = {
	final kind:TuiSmokeSelectionTabsActionKind;
	final name:String;
	final tabs:Array<TuiSmokeSelectionTab>;
	final activeIdx:Int;
	final width:Int;
	final areaHeight:Int;
	final expectedHeight:Int;
	final expectedLines:Array<String>;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSelectionTabsAction {
	public final kind:TuiSmokeSelectionTabsActionKind;
	public final name:String;
	public final tabs:Array<TuiSmokeSelectionTab>;
	public final activeIdx:Int;
	public final width:Int;
	public final areaHeight:Int;
	public final expectedHeight:Int;
	public final expectedLines:Array<String>;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
