package codexhx.runtime.tui.smoke;

typedef TuiSmokePasteBurstActionFields = {
	final kind:TuiSmokePasteBurstActionKind;
	final name:String;
	final beforeText:String;
	final retroChars:Int;
	final firstChar:String;
	final secondChar:String;
	final thirdChar:String;
	final expectedTrace:String;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noTextareaMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noClipboardMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final noAppServerDelivery:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokePasteBurstAction {
	@:recordDefault(TuiSmokePasteBurstActionKind.Unknown)
	public final kind:TuiSmokePasteBurstActionKind;
	public final name:String;
	public final beforeText:String;
	public final retroChars:Int;
	public final firstChar:String;
	public final secondChar:String;
	public final thirdChar:String;
	public final expectedTrace:String;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noTextareaMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noClipboardMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final noAppServerDelivery:Bool;
	public final unsupportedRejected:Bool;
}
