package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerPendingRequestRegistryRecordFields = {
	final requestId:String;
	final detail:String;
	final orderIndex:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerPendingRequestRegistryRecord {
	public final requestId:String;
	public final detail:String;
	public final orderIndex:Int;

	public function summary():String {
		return "request=" + requestId + ";order=" + orderIndex + ";detail=" + detail;
	}
}
