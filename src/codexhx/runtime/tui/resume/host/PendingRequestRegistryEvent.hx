package codexhx.runtime.tui.resume.host;

typedef PendingRequestRegistryEventFields = {
	final kind:PendingRequestRegistryEventKind;
	final requestId:String;
	final detail:String;
	final pendingBefore:Int;
	final pendingAfter:Int;
	final orderIndex:Int;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PendingRequestRegistryEvent {
	@:recordDefault(PendingRequestRegistryEventKind.Unknown)
	public final kind:PendingRequestRegistryEventKind;
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
