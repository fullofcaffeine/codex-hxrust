package codexhx.runtime.tui.smoke;

class TuiSmokeAppServerFacade {
	var eventCount:Int;
	var requestCount:Int;
	var rejectedRequestCount:Int;
	var closed:Bool;
	var primaryThreadId:String;

	public function new() {
		this.eventCount = 0;
		this.requestCount = 0;
		this.rejectedRequestCount = 0;
		this.closed = false;
		this.primaryThreadId = "";
	}

	public function handle(event:TuiSmokeAppServerEvent, state:TuiSmokeAppState, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("server.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (event == null || event.kind == TuiSmokeAppServerEventKind.Unknown) {
			trace.push("server.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		eventCount = eventCount + 1;
		return switch event.kind {
			case TuiSmokeAppServerEventKind.ThreadStatus:
				state.updateStatus(event.status);
				trace.push("server.thread_status=" + event.threadId + ":" + event.status);
				TuiSmokeExitKind.Rendered;
			case TuiSmokeAppServerEventKind.AssistantDelta:
				state.appendTranscript(new TuiSmokeTranscriptRow({
					source: TuiSmokeTranscriptSource.Assistant,
					text: event.delta
				}));
				trace.push("server.assistant_delta=" + event.threadId + ":" + event.delta);
				TuiSmokeExitKind.Rendered;
			case TuiSmokeAppServerEventKind.Disconnected:
				state.updateStatus("disconnected");
				trace.push("server.disconnected=" + event.message);
				TuiSmokeExitKind.Rejected;
			case TuiSmokeAppServerEventKind.StreamClosed:
				closed = true;
				trace.push("server.stream_closed");
				TuiSmokeExitKind.Rendered;
			case _:
				trace.push("server.unknown");
				TuiSmokeExitKind.Rejected;
		}
	}

	public function handleRequest(request:TuiSmokeAppServerRequest, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("server.request.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (request == null || request.kind == TuiSmokeAppServerRequestKind.Unknown) {
			trace.push("server.request.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		final unsupported = unsupportedReason(request.kind);
		if (unsupported.length > 0) {
			rejectedRequestCount = rejectedRequestCount + 1;
			trace.push("server.request.reject=" + request.requestId + ":" + unsupported);
			return TuiSmokeExitKind.Rendered;
		}
		if (!isThreadBound(request.kind)) {
			trace.push("server.request.threadless=" + request.kind + ":" + request.requestId);
			return TuiSmokeExitKind.Rendered;
		}
		if (request.threadId.length == 0) {
			trace.push("server.request.missing_thread=" + request.kind + ":" + request.requestId);
			return TuiSmokeExitKind.Rendered;
		}
		requestCount = requestCount + 1;
		trace.push(
			"server.request." + request.kind
			+ "=" + request.requestId
			+ ":" + request.threadId
			+ ":" + targetForThread(request.threadId)
			+ ":" + request.displayId()
		);
		return TuiSmokeExitKind.Rendered;
	}

	public function handled():Int {
		return eventCount;
	}

	public function handledRequests():Int {
		return requestCount;
	}

	public function rejectedRequests():Int {
		return rejectedRequestCount;
	}

	function targetForThread(threadId:String):String {
		if (primaryThreadId.length == 0) {
			primaryThreadId = threadId;
			return "primary";
		}
		return primaryThreadId == threadId ? "primary" : "side";
	}

	static function isThreadBound(kind:TuiSmokeAppServerRequestKind):Bool {
		return switch kind {
			case TuiSmokeAppServerRequestKind.CommandApproval
				| TuiSmokeAppServerRequestKind.FileChangeApproval
				| TuiSmokeAppServerRequestKind.PermissionsApproval
				| TuiSmokeAppServerRequestKind.ToolUserInput
				| TuiSmokeAppServerRequestKind.McpElicitation:
				true;
			case _:
				false;
		}
	}

	static function unsupportedReason(kind:TuiSmokeAppServerRequestKind):String {
		return switch kind {
			case TuiSmokeAppServerRequestKind.DynamicToolCall:
				"Dynamic tool calls are not available in TUI yet.";
			case TuiSmokeAppServerRequestKind.AttestationGenerate:
				"Attestation generation is not available in TUI.";
			case TuiSmokeAppServerRequestKind.LegacyPatchApproval:
				"Legacy patch approval requests are not available in TUI yet.";
			case TuiSmokeAppServerRequestKind.LegacyCommandApproval:
				"Legacy command approval requests are not available in TUI yet.";
			case _:
				"";
		}
	}
}
