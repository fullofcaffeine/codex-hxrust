package codexhx.runtime.tui.smoke;

typedef TuiSmokeBrowserOpenActionFields = {
	final kind:TuiSmokeBrowserOpenActionKind;
	final url:String;
	final message:String;
	final errorMessage:String;
	final opened:Bool;
	final infoInserted:Bool;
	final errorInserted:Bool;
	final noLiveBrowserLaunch:Bool;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeBrowserOpenAction {
	@:recordDefault(TuiSmokeBrowserOpenActionKind.Unknown)
	public final kind:TuiSmokeBrowserOpenActionKind;
	public final url:String;
	public final message:String;
	public final errorMessage:String;
	public final opened:Bool;
	public final infoInserted:Bool;
	public final errorInserted:Bool;
	public final noLiveBrowserLaunch:Bool;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final unsupportedRejected:Bool;
}
