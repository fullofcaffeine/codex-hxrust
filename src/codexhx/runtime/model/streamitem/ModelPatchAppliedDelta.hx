package codexhx.runtime.model.streamitem;

class ModelPatchAppliedDelta {
	public final known:Bool;
	public final exact:Bool;
	public final changes:Array<ModelPatchFileChange>;

	public function new(known:Bool, exact:Bool, changes:Array<ModelPatchFileChange>) {
		this.known = known;
		this.exact = exact;
		this.changes = changes == null ? [] : changes;
	}

	public function isEmpty():Bool {
		return changes.length == 0;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (change in changes) parts.push(change.summary());
		return "known=" + boolText(known) + ";exact=" + boolText(exact) + ";changes=[" + parts.join("||") + "]";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
