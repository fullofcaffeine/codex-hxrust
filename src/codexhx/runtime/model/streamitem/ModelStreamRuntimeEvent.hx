package codexhx.runtime.model.streamitem;

class ModelStreamRuntimeEvent {
	public final kind:ModelStreamRuntimeEventKind;
	public final itemKind:ModelStreamOutputItemKind;
	public final itemId:String;
	public final callId:String;
	public final toolName:String;
	public final delta:String;
	public final text:String;
	public final index:Int;

	public function new(kind:ModelStreamRuntimeEventKind, itemKind:ModelStreamOutputItemKind, itemId:String, callId:String, toolName:String, delta:String,
			text:String, index:Int) {
		this.kind = kind;
		this.itemKind = itemKind;
		this.itemId = itemId;
		this.callId = callId;
		this.toolName = toolName;
		this.delta = delta;
		this.text = text;
		this.index = index;
	}

	public function summary():String {
		return "event=" + kind + ";itemKind=" + itemKind + ";itemId=" + noneIfEmpty(itemId) + ";callId=" + noneIfEmpty(callId) + ";tool="
			+ noneIfEmpty(toolName) + ";delta=" + delta + ";text=" + text + ";index=" + Std.string(index);
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
