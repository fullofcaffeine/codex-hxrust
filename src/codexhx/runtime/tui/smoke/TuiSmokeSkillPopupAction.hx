package codexhx.runtime.tui.smoke;

typedef TuiSmokeSkillPopupActionFields = {
	final kind:TuiSmokeSkillPopupActionKind;
	final name:String;
	final query:String;
	final mentions:Array<TuiSmokeSkillPopupMention>;
	final expectedOrder:Array<String>;
	final expectedRows:Array<String>;
	final expectedHeight:Int;
	final expectedSelectedName:String;
	final expectedSelectedInsertText:String;
	final expectedSelectedPath:String;
	final expectedSelectedIndex:Int;
	final expectedScrollTop:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSkillPopupAction {
	public final kind:TuiSmokeSkillPopupActionKind;
	public final name:String;
	public final query:String;
	public final mentions:Array<TuiSmokeSkillPopupMention>;
	public final expectedOrder:Array<String>;
	public final expectedRows:Array<String>;
	public final expectedHeight:Int;
	public final expectedSelectedName:String;
	public final expectedSelectedInsertText:String;
	public final expectedSelectedPath:String;
	public final expectedSelectedIndex:Int;
	public final expectedScrollTop:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
