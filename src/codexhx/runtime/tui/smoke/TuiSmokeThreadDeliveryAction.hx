package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadDeliveryActionFields = {
	final kind:TuiSmokeThreadDeliveryActionKind;
	final threadId:String;
	final requestId:String;
}

class TuiSmokeThreadDeliveryAction {
	public final kind:TuiSmokeThreadDeliveryActionKind;
	public final threadId:String;
	public final requestId:String;

	public function new(fields:TuiSmokeThreadDeliveryActionFields) {
		this.kind = fields.kind == null ? TuiSmokeThreadDeliveryActionKind.Unknown : fields.kind;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
	}
}
