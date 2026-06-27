package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusLineStyleActionFields = {
	final kind:TuiSmokeStatusLineStyleActionKind;
	final name:String;
	final useThemeColors:Bool;
	final themeAccent:String;
	final themeColor:String;
	final segments:Array<TuiSmokeStatusLineStyleSegment>;
	final expectedPresent:Bool;
	final expectedText:String;
	final expectedSpans:Array<String>;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusLineStyleAction {
	public final kind:TuiSmokeStatusLineStyleActionKind;
	public final name:String;
	public final useThemeColors:Bool;
	public final themeAccent:String;
	public final themeColor:String;
	public final segments:Array<TuiSmokeStatusLineStyleSegment>;
	public final expectedPresent:Bool;
	public final expectedText:String;
	public final expectedSpans:Array<String>;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
