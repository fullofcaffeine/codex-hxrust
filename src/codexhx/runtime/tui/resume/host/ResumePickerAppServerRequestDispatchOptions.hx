package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerRequestDispatchOptionsFields = {
	final appServerSessionAvailable:Bool;
	final transportSendSucceeds:Bool;
	final previousDispatchCount:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerRequestDispatchOptions {
	public final appServerSessionAvailable:Bool;
	public final transportSendSucceeds:Bool;
	public final previousDispatchCount:Int;
}
