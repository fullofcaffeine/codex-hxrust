package codexhx.runtime.tui.smoke;

typedef TuiSmokePopupConstsActionFields = {
	final kind:TuiSmokePopupConstsActionKind;
	final name:String;
	final acceptBindings:Array<String>;
	final acceptLabel:String;
	final cancelBindings:Array<String>;
	final cancelLabel:String;
	final expected:String;
	final expectedMaxRows:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokePopupConstsAction {
	public final kind:TuiSmokePopupConstsActionKind;
	public final name:String;
	public final acceptBindings:Array<String>;
	public final acceptLabel:String;
	public final cancelBindings:Array<String>;
	public final cancelLabel:String;
	public final expected:String;
	public final expectedMaxRows:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
