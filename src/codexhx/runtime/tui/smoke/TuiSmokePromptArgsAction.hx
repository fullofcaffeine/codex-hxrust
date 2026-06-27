package codexhx.runtime.tui.smoke;

typedef TuiSmokePromptArgsActionFields = {
	final kind:TuiSmokePromptArgsActionKind;
	final name:String;
	final line:String;
	final expectedPresent:Bool;
	final expectedName:String;
	final expectedRest:String;
	final expectedRestOffset:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokePromptArgsAction {
	public final kind:TuiSmokePromptArgsActionKind;
	public final name:String;
	public final line:String;
	public final expectedPresent:Bool;
	public final expectedName:String;
	public final expectedRest:String;
	public final expectedRestOffset:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
