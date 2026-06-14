package codexhx.runtime.model.streamitem;

class ModelInFlightToolDrainItem {
	public final callId:String;
	public final responseKind:ModelPatchToolOutputItemKind;
	public final orderIndex:Int;
	public final outputText:String;
	public final success:Bool;
	public final failureKind:ModelInFlightToolDrainFailureKind;
	public final fromResponseInput:Bool;
	public final externalContext:Bool;

	public function new(
		callId:String,
		responseKind:ModelPatchToolOutputItemKind,
		orderIndex:Int,
		outputText:String,
		success:Bool,
		failureKind:ModelInFlightToolDrainFailureKind,
		fromResponseInput:Bool,
		externalContext:Bool
	) {
		this.callId = callId == null ? "" : callId;
		this.responseKind = responseKind;
		this.orderIndex = orderIndex;
		this.outputText = outputText == null ? "" : outputText;
		this.success = success;
		this.failureKind = failureKind;
		this.fromResponseInput = fromResponseInput;
		this.externalContext = externalContext;
	}

	public function summary():String {
		return "orderIndex=" + Std.string(orderIndex)
			+ ";callId=" + noneIfEmpty(callId)
			+ ";responseKind=" + responseKind
			+ ";success=" + boolText(success)
			+ ";failureKind=" + failureKind
			+ ";fromResponseInput=" + boolText(fromResponseInput)
			+ ";externalContext=" + boolText(externalContext)
			+ ";text=" + outputText;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
