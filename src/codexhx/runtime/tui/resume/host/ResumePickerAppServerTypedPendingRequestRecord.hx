package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedPendingRequestRecordFields = {
	final requestClass:ResumePickerAppServerPendingRequestClassKind;
	final requestId:String;
	final key:String;
	final turnId:String;
	final itemId:String;
	final serverName:String;
	final mcpRequestId:String;
	final detail:String;
	final orderIndex:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedPendingRequestRecord {
	@:recordDefault(ResumePickerAppServerPendingRequestClassKind.Unknown)
	public final requestClass:ResumePickerAppServerPendingRequestClassKind;
	public final requestId:String;
	public final key:String;
	public final turnId:String;
	public final itemId:String;
	public final serverName:String;
	public final mcpRequestId:String;
	public final detail:String;
	public final orderIndex:Int;

	public function summary():String {
		return "class=" + requestClass + ";request=" + requestId + ";key=" + emptyLabel(key) + ";turn=" + emptyLabel(turnId) + ";item=" + emptyLabel(itemId)
			+ ";server=" + emptyLabel(serverName) + ";mcp=" + emptyLabel(mcpRequestId) + ";order=" + orderIndex + ";detail=" + detail;
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}
}
