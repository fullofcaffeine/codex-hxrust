package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadSessionFields = {
	final threadId:String;
	final model:String;
	final title:String;
	final isSideThread:Bool;
}

class TuiSmokeThreadSession {
	public final threadId:String;
	public final model:String;
	public final title:String;
	public final isSideThread:Bool;

	public function new(fields:TuiSmokeThreadSessionFields) {
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.model = fields.model == null ? "" : fields.model;
		this.title = fields.title == null ? "" : fields.title;
		this.isSideThread = fields.isSideThread;
	}

	public function displayFor(suppressReplayNotices:Bool):TuiSmokeThreadSessionDisplay {
		if (isSideThread) return TuiSmokeThreadSessionDisplay.SideConversation;
		return suppressReplayNotices ? TuiSmokeThreadSessionDisplay.Quiet : TuiSmokeThreadSessionDisplay.Normal;
	}
}
