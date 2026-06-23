package codexhx.runtime.tui.resume.host;

typedef RequestDispatchOptionsFields = {
	final appServerSessionAvailable:Bool;
	final transportSendSucceeds:Bool;
	final previousDispatchCount:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RequestDispatchOptions {
	public final appServerSessionAvailable:Bool;
	public final transportSendSucceeds:Bool;
	public final previousDispatchCount:Int;
}
