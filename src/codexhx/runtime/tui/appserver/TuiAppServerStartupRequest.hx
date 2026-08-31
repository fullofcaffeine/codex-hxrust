package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.ThreadId;

typedef TuiAppServerStartupRequestFields = {
	final requestId:RequestId;
	final mode:TuiAppServerThreadOpenMode;
	final ?resumeThreadId:ThreadId;
	final modelLabel:String;
	final clientName:String;
	final clientVersion:String;
}

/** Typed client intent for initialize plus thread start or resume. */
class TuiAppServerStartupRequest {
	public final requestId:RequestId;
	public final mode:TuiAppServerThreadOpenMode;

	public final resumeThreadId:Null<ThreadId>;

	public final modelLabel:String;
	public final clientName:String;
	public final clientVersion:String;

	public function new(fields:TuiAppServerStartupRequestFields) {
		this.requestId = fields.requestId;
		this.mode = fields.mode;
		this.resumeThreadId = fields.resumeThreadId;
		this.modelLabel = fields.modelLabel;
		this.clientName = fields.clientName;
		this.clientVersion = fields.clientVersion;
	}
}
