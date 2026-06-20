package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerPendingRequestRegistryEventFields = {
	final kind:ResumePickerAppServerPendingRequestRegistryEventKind;
	final requestId:String;
	final detail:String;
	final pendingBefore:Int;
	final pendingAfter:Int;
	final orderIndex:Int;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerPendingRequestRegistryEvent {
	@:recordDefault(ResumePickerAppServerPendingRequestRegistryEventKind.Unknown)
	public final kind:ResumePickerAppServerPendingRequestRegistryEventKind;
	public final requestId:String;
	public final detail:String;
	public final pendingBefore:Int;
	public final pendingAfter:Int;
	public final orderIndex:Int;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";request=" + requestId + ";order=" + orderIndex + ";before=" + pendingBefore + ";after=" + pendingAfter + ";reason="
			+ emptyLabel(reason) + ";detail=" + detail;
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "none" : value;
	}
}
