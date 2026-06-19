package codexhx.runtime.model.streamitem;

class ModelStreamToolInputDelta {
	public final callId:String;
	public final itemId:String;
	public final delta:String;
	public final accumulatedInput:String;
	public final status:ModelStreamToolInputDeltaStatus;
	public final index:Int;

	public function new(callId:String, itemId:String, delta:String, accumulatedInput:String, status:ModelStreamToolInputDeltaStatus, index:Int) {
		this.callId = callId;
		this.itemId = itemId;
		this.delta = delta;
		this.accumulatedInput = accumulatedInput;
		this.status = status;
		this.index = index;
	}

	public function summary():String {
		return "status=" + status + ";callId=" + noneIfEmpty(callId) + ";itemId=" + noneIfEmpty(itemId) + ";delta=" + delta + ";accumulatedInput="
			+ accumulatedInput + ";index=" + Std.string(index);
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
