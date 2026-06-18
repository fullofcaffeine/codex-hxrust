package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadReplayActionFields = {
	final kind:TuiSmokeThreadReplayActionKind;
	final threadId:String;
}

class TuiSmokeThreadReplayAction {
	public final kind:TuiSmokeThreadReplayActionKind;
	public final threadId:String;

	public function new(fields:TuiSmokeThreadReplayActionFields) {
		this.kind = fields.kind == null ? TuiSmokeThreadReplayActionKind.Unknown : fields.kind;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
	}
}
