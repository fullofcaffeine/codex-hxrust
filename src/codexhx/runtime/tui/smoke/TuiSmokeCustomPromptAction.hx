package codexhx.runtime.tui.smoke;

typedef TuiSmokeCustomPromptActionFields = {
	final kind:TuiSmokeCustomPromptActionKind;
	final name:String;
	final title:String;
	final placeholder:String;
	final contextLabel:String;
	final initialText:String;
	final width:Int;
	final areaHeight:Int;
	final pasteText:String;
	final steps:Array<TuiSmokeCustomPromptStep>;
	final expectedText:String;
	final expectedCursor:Int;
	final expectedSubmitted:String;
	final expectedCompletion:String;
	final expectedPasteAccepted:Bool;
	final expectedInputHeight:Int;
	final expectedDesiredHeight:Int;
	final expectedCursorAvailable:Bool;
	final expectedRows:Array<String>;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noPromptCallback:Bool;
	final noFilesystemMutation:Bool;
	final noClipboardMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeCustomPromptAction {
	@:recordDefault(TuiSmokeCustomPromptActionKind.Unknown)
	public final kind:TuiSmokeCustomPromptActionKind;
	public final name:String;
	public final title:String;
	public final placeholder:String;
	public final contextLabel:String;
	public final initialText:String;
	public final width:Int;
	public final areaHeight:Int;
	public final pasteText:String;
	public final steps:Array<TuiSmokeCustomPromptStep>;
	public final expectedText:String;
	public final expectedCursor:Int;
	public final expectedSubmitted:String;
	public final expectedCompletion:String;
	public final expectedPasteAccepted:Bool;
	public final expectedInputHeight:Int;
	public final expectedDesiredHeight:Int;
	public final expectedCursorAvailable:Bool;
	public final expectedRows:Array<String>;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noPromptCallback:Bool;
	public final noFilesystemMutation:Bool;
	public final noClipboardMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
