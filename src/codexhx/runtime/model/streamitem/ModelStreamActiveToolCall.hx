package codexhx.runtime.model.streamitem;

class ModelStreamActiveToolCall {
	public final itemKind:ModelStreamOutputItemKind;
	public final itemId:String;
	public final callId:String;
	public final toolName:String;
	public final namespace:String;
	var input:String;
	var acceptedCount:Int;
	var ignoredCount:Int;

	public function new(
		itemKind:ModelStreamOutputItemKind,
		itemId:String,
		callId:String,
		toolName:String,
		namespace:String,
		initialInput:String
	) {
		this.itemKind = itemKind;
		this.itemId = itemId;
		this.callId = callId;
		this.toolName = toolName;
		this.namespace = namespace;
		this.input = initialInput == null ? "" : initialInput;
		this.acceptedCount = 0;
		this.ignoredCount = 0;
	}

	public static function fromItem(item:ModelStreamOutputItem):ModelStreamActiveToolCall {
		return new ModelStreamActiveToolCall(
			item.kind,
			item.itemId,
			item.callId,
			item.toolName,
			item.namespace,
			item.kind == ModelStreamOutputItemKind.CustomToolCall ? item.customInput : item.arguments
		);
	}

	public function accepts(callId:String):Bool {
		if (callId == null || callId.length == 0) return true;
		return callId == this.callId;
	}

	public function accept(delta:String):ModelStreamToolInputDelta {
		input = input + delta;
		acceptedCount = acceptedCount + 1;
		return new ModelStreamToolInputDelta(callId, itemId, delta, input, ModelStreamToolInputDeltaStatus.Accepted, acceptedCount);
	}

	public function ignore(callId:String, delta:String, status:ModelStreamToolInputDeltaStatus):ModelStreamToolInputDelta {
		ignoredCount = ignoredCount + 1;
		return new ModelStreamToolInputDelta(callId, itemId, delta, input, status, ignoredCount);
	}

	public function inputSnapshot():String {
		return input;
	}

	public function acceptedDeltaCount():Int {
		return acceptedCount;
	}

	public function ignoredDeltaCount():Int {
		return ignoredCount;
	}

	public function displayName():String {
		if (namespace.length > 0) return namespace + "." + toolName;
		return toolName;
	}
}
