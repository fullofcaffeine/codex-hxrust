package codexhx.runtime.model.streamitem;

class ModelPatchVerificationEvent {
	public final kind:ModelPatchVerificationEventKind;
	public final callId:String;
	public final turnId:String;
	public final autoApproved:Bool;
	public final status:ModelPatchApplyStatus;
	public final success:Bool;
	public final changes:Array<ModelPatchFileChange>;
	public final stdout:String;
	public final stderr:String;

	public function new(kind:ModelPatchVerificationEventKind, callId:String, turnId:String, autoApproved:Bool, status:ModelPatchApplyStatus, success:Bool,
			changes:Array<ModelPatchFileChange>, stdout:String, stderr:String) {
		this.kind = kind;
		this.callId = callId == null ? "" : callId;
		this.turnId = turnId == null ? "" : turnId;
		this.autoApproved = autoApproved;
		this.status = status;
		this.success = success;
		this.changes = changes == null ? [] : changes;
		this.stdout = stdout == null ? "" : stdout;
		this.stderr = stderr == null ? "" : stderr;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (change in changes)
			parts.push(change.summary());
		return "event=" + kind + ";callId=" + noneIfEmpty(callId) + ";turnId=" + noneIfEmpty(turnId) + ";autoApproved=" + boolText(autoApproved)
			+ ";status=" + status + ";success=" + boolText(success) + ";stdout=" + stdout + ";stderr=" + stderr + ";changes=[" + parts.join("||") + "]";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
