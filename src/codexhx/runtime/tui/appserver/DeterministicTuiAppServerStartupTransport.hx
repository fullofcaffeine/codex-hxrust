package codexhx.runtime.tui.appserver;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.RequestId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Credential-free protocol-shaped startup transport for the vertical tracer.

	It records the same ordered methods as a live JSON-RPC transport. The runner
	and session do not change when a process-backed implementation replaces it.
**/
class DeterministicTuiAppServerStartupTransport implements TuiAppServerStartupTransport {
	final sessionId:SessionId;
	final startedThreadId:ThreadId;
	var methodsValue:Array<String>;
	var outboundLinesValue:Array<String>;

	public function new(sessionId:SessionId, startedThreadId:ThreadId) {
		this.sessionId = sessionId;
		this.startedThreadId = startedThreadId;
		this.methodsValue = [];
		this.outboundLinesValue = [];
	}

	public function open(request:TuiAppServerStartupRequest):TuiAppServerStartupOutcome {
		methodsValue = [];
		outboundLinesValue = [];
		if (request == null)
			return TuiAppServerStartupOutcome.rejected("missing_startup_request");
		if (request.mode == TuiAppServerThreadOpenMode.Resume && request.resumeThreadId == null)
			return TuiAppServerStartupOutcome.rejected("missing_resume_thread_id");
		methodsValue.push("initialize");
		methodsValue.push("initialized");
		methodsValue.push(request.mode);
		outboundLinesValue.push(initializeLine(request));
		outboundLinesValue.push(encodeLine(JObject(["jsonrpc", "method"], [JString("2.0"), JString("initialized")])));
		outboundLinesValue.push(threadOpenLine(request));
		final threadId = request.mode == TuiAppServerThreadOpenMode.Resume ? request.resumeThreadId : startedThreadId;
		return threadId == null ? TuiAppServerStartupOutcome.rejected("missing_started_thread_id") : TuiAppServerStartupOutcome.accepted(sessionId, threadId,
			request.modelLabel, methodsValue, outboundLinesValue);
	}

	public function methods():Array<String>
		return methodsValue.copy();

	public function outboundLines():Array<String>
		return outboundLinesValue.copy();

	static function initializeLine(request:TuiAppServerStartupRequest):String {
		final clientInfo:Value = JObject(["name", "version"], [JString(request.clientName), JString(request.clientVersion)]);
		final capabilities:Value = JObject(["experimentalApi"], [JBool(true)]);
		final params:Value = JObject(["capabilities", "clientInfo"], [capabilities, clientInfo]);
		return encodeLine(JObject(["jsonrpc", "id", "method", "params"], [JString("2.0"), request.requestId.toJsonValue(), JString("initialize"), params]));
	}

	static function threadOpenLine(request:TuiAppServerStartupRequest):String {
		final keys = ["model"];
		final values:Array<Value> = [JString(request.modelLabel)];
		if (request.resumeThreadId != null) {
			keys.push("threadId");
			values.push(JString(request.resumeThreadId.toString()));
		}
		return encodeLine(JObject(["jsonrpc", "id", "method", "params"], [
			JString("2.0"),
			RequestId.fromInteger(2).toJsonValue(),
			JString(request.mode),
			JObject(keys, values)
		]));
	}

	static function encodeLine(value:Value):String
		return JsonValueCodec.encode(value) + "\n";
}
