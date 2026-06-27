package codexhx.runtime.tui.smoke;

typedef TuiSmokeActionRequiredTitleActionFields = {
	final kind:TuiSmokeActionRequiredTitleActionKind;
	final name:String;
	final prefix:String;
	final items:Array<String>;
	final excludedItems:Array<String>;
	final values:Array<TuiSmokeActionRequiredTitleValue>;
	final expected:String;
	final failureCode:String;
	final noTerminalTitleMutation:Bool;
	final noRatatuiRender:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeActionRequiredTitleAction {
	public final kind:TuiSmokeActionRequiredTitleActionKind;
	public final name:String;
	public final prefix:String;
	public final items:Array<String>;
	public final excludedItems:Array<String>;
	public final values:Array<TuiSmokeActionRequiredTitleValue>;
	public final expected:String;
	public final failureCode:String;
	public final noTerminalTitleMutation:Bool;
	public final noRatatuiRender:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
