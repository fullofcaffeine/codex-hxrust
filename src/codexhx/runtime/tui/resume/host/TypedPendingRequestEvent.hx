package codexhx.runtime.tui.resume.host;

typedef TypedPendingRequestEventFields = {
	final kind:TypedPendingRequestEventKind;
	final requestClass:PendingRequestClassKind;
	final requestId:String;
	final key:String;
	final turnId:String;
	final itemId:String;
	final serverName:String;
	final mcpRequestId:String;
	final pendingBefore:Int;
	final pendingAfter:Int;
	final orderIndex:Int;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TypedPendingRequestEvent {
	@:recordDefault(TypedPendingRequestEventKind.Unknown)
	public final kind:TypedPendingRequestEventKind;
	@:recordDefault(PendingRequestClassKind.Unknown)
	public final requestClass:PendingRequestClassKind;
	public final requestId:String;
	public final key:String;
	public final turnId:String;
	public final itemId:String;
	public final serverName:String;
	public final mcpRequestId:String;
	public final pendingBefore:Int;
	public final pendingAfter:Int;
	public final orderIndex:Int;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";class=" + requestClass + ";request=" + requestId + ";key=" + emptyLabel(key) + ";turn=" + emptyLabel(turnId) + ";item="
			+ emptyLabel(itemId) + ";server=" + emptyLabel(serverName) + ";mcp=" + emptyLabel(mcpRequestId) + ";order=" + orderIndex + ";before="
			+ pendingBefore + ";after=" + pendingAfter + ";reason=" + emptyLabel(reason);
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "none" : value;
	}
}
