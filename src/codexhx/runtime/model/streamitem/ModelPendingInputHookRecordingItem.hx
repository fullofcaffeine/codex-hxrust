package codexhx.runtime.model.streamitem;

class ModelPendingInputHookRecordingItem {
	public final sourceKind:ModelPostSamplingPendingInputSourceKind;
	public final inputKind:ModelSamplingInputItemKind;
	public final orderIndex:Int;
	public final callId:String;
	public final responseKind:ModelPatchToolOutputItemKind;
	public final text:String;
	public final hookActionKind:ModelPendingInputHookActionKind;
	public final additionalContextCount:Int;

	public function new(
		sourceKind:ModelPostSamplingPendingInputSourceKind,
		inputKind:ModelSamplingInputItemKind,
		orderIndex:Int,
		callId:String,
		responseKind:ModelPatchToolOutputItemKind,
		text:String,
		hookActionKind:ModelPendingInputHookActionKind,
		additionalContextCount:Int
	) {
		this.sourceKind = sourceKind == null ? ModelPostSamplingPendingInputSourceKind.ActiveTurn : sourceKind;
		this.inputKind = inputKind == null ? ModelSamplingInputItemKind.PendingUserInput : inputKind;
		this.orderIndex = orderIndex < 0 ? 0 : orderIndex;
		this.callId = callId == null ? "" : callId;
		this.responseKind = responseKind == null ? ModelPatchToolOutputItemKind.FunctionCallOutput : responseKind;
		this.text = text == null ? "" : text;
		this.hookActionKind = hookActionKind == null ? ModelPendingInputHookActionKind.ContinueInput : hookActionKind;
		this.additionalContextCount = additionalContextCount < 0 ? 0 : additionalContextCount;
	}

	public function isUserInput():Bool {
		return inputKind == ModelSamplingInputItemKind.PendingUserInput;
	}

	public function isNonEmptyUserInput():Bool {
		return isUserInput() && text.length > 0;
	}

	public function shouldStop():Bool {
		return hookActionKind == ModelPendingInputHookActionKind.StopInput;
	}

	public function summary(inputRecorded:Bool, additionalContextRecorded:Bool):String {
		return "sourceKind=" + sourceKind
			+ ";inputKind=" + inputKind
			+ ";orderIndex=" + Std.string(orderIndex)
			+ ";callId=" + noneIfEmpty(callId)
			+ ";responseKind=" + responseKind
			+ ";hookActionKind=" + hookActionKind
			+ ";inputRecorded=" + boolText(inputRecorded)
			+ ";additionalContextRecorded=" + boolText(additionalContextRecorded)
			+ ";additionalContextCount=" + Std.string(additionalContextCount)
			+ ";text=" + text;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
