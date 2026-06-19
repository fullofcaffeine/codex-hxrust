package codexhx.runtime.model.streamitem;

class ModelToolArgumentDiffConsumerEvent {
	public final kind:ModelToolArgumentDiffConsumerKind;
	public final callId:String;
	public final changes:Array<ModelPatchFileChange>;
	public final finished:Bool;
	public final index:Int;

	public function new(kind:ModelToolArgumentDiffConsumerKind, callId:String, changes:Array<ModelPatchFileChange>, finished:Bool, index:Int) {
		this.kind = kind;
		this.callId = callId;
		this.changes = changes == null ? [] : changes;
		this.finished = finished;
		this.index = index;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (change in changes)
			parts.push(change.summary());
		return "consumer=" + kind + ";callId=" + callId + ";finished=" + boolText(finished) + ";index=" + Std.string(index) + ";changes=["
			+ parts.join("||") + "]";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
