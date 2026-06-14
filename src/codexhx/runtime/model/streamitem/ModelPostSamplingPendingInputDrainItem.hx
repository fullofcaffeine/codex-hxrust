package codexhx.runtime.model.streamitem;

class ModelPostSamplingPendingInputDrainItem {
	public final sourceKind:ModelPostSamplingPendingInputSourceKind;
	public final inputKind:ModelSamplingInputItemKind;
	public final orderIndex:Int;
	public final callId:String;
	public final responseKind:ModelPatchToolOutputItemKind;
	public final text:String;

	public function new(
		sourceKind:ModelPostSamplingPendingInputSourceKind,
		inputKind:ModelSamplingInputItemKind,
		orderIndex:Int,
		callId:String,
		responseKind:ModelPatchToolOutputItemKind,
		text:String
	) {
		this.sourceKind = sourceKind == null ? ModelPostSamplingPendingInputSourceKind.ActiveTurn : sourceKind;
		this.inputKind = inputKind == null ? ModelSamplingInputItemKind.PendingUserInput : inputKind;
		this.orderIndex = orderIndex < 0 ? 0 : orderIndex;
		this.callId = callId == null ? "" : callId;
		this.responseKind = responseKind == null ? ModelPatchToolOutputItemKind.FunctionCallOutput : responseKind;
		this.text = text == null ? "" : text;
	}

	public function summary():String {
		return "sourceKind=" + sourceKind
			+ ";inputKind=" + inputKind
			+ ";orderIndex=" + Std.string(orderIndex)
			+ ";callId=" + noneIfEmpty(callId)
			+ ";responseKind=" + responseKind
			+ ";text=" + text;
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
