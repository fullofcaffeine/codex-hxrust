package codexhx.runtime.tui.smoke;

typedef TuiSmokeTextAreaActionFields = {
	final kind:TuiSmokeTextAreaActionKind;
	final name:String;
	final text:String;
	final cursor:Int;
	final newText:String;
	final insertText:String;
	final replaceText:String;
	final insertPos:Int;
	final rangeStart:Int;
	final rangeEnd:Int;
	final count:Int;
	final width:Int;
	final areaX:Int;
	final areaY:Int;
	final areaHeight:Int;
	final scroll:Int;
	final vimEnabled:Bool;
	final vimMode:String;
	final killBuffer:String;
	final elements:Array<TuiSmokeTextAreaElement>;
	final expectedTrace:String;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noClipboardMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final noAppServerDelivery:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTextAreaAction {
	@:recordDefault(TuiSmokeTextAreaActionKind.Unknown)
	public final kind:TuiSmokeTextAreaActionKind;
	public final name:String;
	public final text:String;
	public final cursor:Int;
	public final newText:String;
	public final insertText:String;
	public final replaceText:String;
	public final insertPos:Int;
	public final rangeStart:Int;
	public final rangeEnd:Int;
	public final count:Int;
	public final width:Int;
	public final areaX:Int;
	public final areaY:Int;
	public final areaHeight:Int;
	public final scroll:Int;
	public final vimEnabled:Bool;
	public final vimMode:String;
	public final killBuffer:String;
	public final elements:Array<TuiSmokeTextAreaElement>;
	public final expectedTrace:String;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noClipboardMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final noAppServerDelivery:Bool;
	public final unsupportedRejected:Bool;
}
