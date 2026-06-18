package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerResolutionFields = {
	final kind:TuiSmokeAppServerResolutionKind;
	final id:String;
	final requestId:String;
	final decision:String;
	final response:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAppServerResolution {
	public final kind:TuiSmokeAppServerResolutionKind;
	public final id:String;
	public final requestId:String;
	public final decision:String;
	public final response:String;
}
