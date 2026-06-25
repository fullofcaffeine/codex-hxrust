package codexhx.runtime.tui.smoke;

typedef TuiSmokeDesktopThreadActionFields = {
	final kind:TuiSmokeDesktopThreadActionKind;
	final threadId:String;
	final url:String;
	final message:String;
	final errorMessage:String;
	final opened:Bool;
	final infoInserted:Bool;
	final errorInserted:Bool;
	final noLiveDesktopLaunch:Bool;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeDesktopThreadAction {
	@:recordDefault(TuiSmokeDesktopThreadActionKind.Unknown)
	public final kind:TuiSmokeDesktopThreadActionKind;
	public final threadId:String;
	public final url:String;
	public final message:String;
	public final errorMessage:String;
	public final opened:Bool;
	public final infoInserted:Bool;
	public final errorInserted:Bool;
	public final noLiveDesktopLaunch:Bool;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final unsupportedRejected:Bool;
}
