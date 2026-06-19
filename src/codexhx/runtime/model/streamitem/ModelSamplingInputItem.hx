package codexhx.runtime.model.streamitem;

class ModelSamplingInputItem {
	public final kind:ModelSamplingInputItemKind;
	public final orderIndex:Int;
	public final callId:String;
	public final responseKind:ModelPatchToolOutputItemKind;
	public final text:String;
	public final fromPendingInput:Bool;
	public final recordedInHistory:Bool;

	public function new(kind:ModelSamplingInputItemKind, orderIndex:Int, callId:String, responseKind:ModelPatchToolOutputItemKind, text:String,
			fromPendingInput:Bool, recordedInHistory:Bool) {
		this.kind = kind;
		this.orderIndex = orderIndex < 0 ? 0 : orderIndex;
		this.callId = callId == null ? "" : callId;
		this.responseKind = responseKind;
		this.text = text == null ? "" : text;
		this.fromPendingInput = fromPendingInput;
		this.recordedInHistory = recordedInHistory;
	}

	public function summary():String {
		return "kind=" + kind + ";orderIndex=" + Std.string(orderIndex) + ";callId=" + noneIfEmpty(callId) + ";responseKind=" + responseKind
			+ ";fromPendingInput=" + boolText(fromPendingInput) + ";recordedInHistory=" + boolText(recordedInHistory) + ";text=" + text;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
