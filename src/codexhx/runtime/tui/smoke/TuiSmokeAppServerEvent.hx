package codexhx.runtime.tui.smoke;

class TuiSmokeAppServerEvent {
	public final kind:TuiSmokeAppServerEventKind;
	public final threadId:String;
	public final status:String;
	public final delta:String;
	public final message:String;

	public function new(kind:TuiSmokeAppServerEventKind, threadId:String, status:String, delta:String, message:String) {
		this.kind = kind == null ? TuiSmokeAppServerEventKind.Unknown : kind;
		this.threadId = threadId == null ? "" : threadId;
		this.status = status == null ? "" : status;
		this.delta = delta == null ? "" : delta;
		this.message = message == null ? "" : message;
	}
}
