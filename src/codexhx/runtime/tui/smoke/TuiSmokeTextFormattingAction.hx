package codexhx.runtime.tui.smoke;

typedef TuiSmokeTextFormattingActionFields = {
	final kind:TuiSmokeTextFormattingActionKind;
	final name:String;
	final input:String;
	final items:Array<String>;
	final maxGraphemes:Int;
	final maxLines:Int;
	final lineWidth:Int;
	final maxWidth:Int;
	final expected:String;
	final expectedFormatted:Bool;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTextFormattingAction {
	public final kind:TuiSmokeTextFormattingActionKind;
	public final name:String;
	public final input:String;
	public final items:Array<String>;
	public final maxGraphemes:Int;
	public final maxLines:Int;
	public final lineWidth:Int;
	public final maxWidth:Int;
	public final expected:String;
	public final expectedFormatted:Bool;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
