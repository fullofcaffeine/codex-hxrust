package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerResolutionFields = {
	final kind:TuiSmokeAppServerResolutionKind;
	final id:String;
	final requestId:String;
	final decision:String;
	final response:String;
}

class TuiSmokeAppServerResolution {
	public final kind:TuiSmokeAppServerResolutionKind;
	public final id:String;
	public final requestId:String;
	public final decision:String;
	public final response:String;

	public function new(fields:TuiSmokeAppServerResolutionFields) {
		this.kind = fields.kind == null ? TuiSmokeAppServerResolutionKind.Unknown : fields.kind;
		this.id = fields.id == null ? "" : fields.id;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decision = fields.decision == null ? "" : fields.decision;
		this.response = fields.response == null ? "" : fields.response;
	}
}
