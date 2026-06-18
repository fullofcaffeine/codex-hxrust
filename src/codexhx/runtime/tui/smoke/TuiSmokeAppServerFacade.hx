package codexhx.runtime.tui.smoke;

class TuiSmokeAppServerFacade {
	var eventCount:Int;
	var requestCount:Int;
	var rejectedRequestCount:Int;
	var resolutionCount:Int;
	var staleResolutionCount:Int;
	var closed:Bool;
	var primaryThreadId:String;
	final pendingRequests:Array<TuiSmokeAppServerRequest>;

	public function new() {
		this.eventCount = 0;
		this.requestCount = 0;
		this.rejectedRequestCount = 0;
		this.resolutionCount = 0;
		this.staleResolutionCount = 0;
		this.closed = false;
		this.primaryThreadId = "";
		this.pendingRequests = [];
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
		pendingRequests.push(request);
		trace.push(
			"server.request." + request.kind
			+ "=" + request.requestId
			+ ":" + request.threadId
			+ ":" + targetForThread(request.threadId)
			+ ":" + request.displayId()
		);
		return TuiSmokeExitKind.Rendered;
	}

	public function handleResolution(resolution:TuiSmokeAppServerResolution, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("server.resolution.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (resolution == null || resolution.kind == TuiSmokeAppServerResolutionKind.Unknown) {
			staleResolutionCount = staleResolutionCount + 1;
			trace.push("server.resolution.unknown");
			return TuiSmokeExitKind.Rendered;
		}
		final request = resolution.kind == TuiSmokeAppServerResolutionKind.ServerRequestResolved
			? takePendingByRequestId(resolution.requestId)
			: takePendingForResolution(resolution);
		if (request == null) {
			staleResolutionCount = staleResolutionCount + 1;
			trace.push("server.resolution.stale=" + resolution.kind + ":" + resolutionKey(resolution));
			return TuiSmokeExitKind.Rendered;
		}
		resolutionCount = resolutionCount + 1;
		trace.push("server.resolution." + resolution.kind + "=" + request.requestId + ":" + request.displayId() + ":" + resolutionSummary(resolution));
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

	public function handledResolutions():Int {
		return resolutionCount;
	}

	public function staleResolutions():Int {
		return staleResolutionCount;
	}

	function takePendingForResolution(resolution:TuiSmokeAppServerResolution):Null<TuiSmokeAppServerRequest> {
		final requestKind = requestKindForResolution(resolution.kind);
		if (requestKind == TuiSmokeAppServerRequestKind.Unknown) return null;
		final key = resolution.id;
		var i = 0;
		while (i < pendingRequests.length) {
			final request = pendingRequests[i];
			if (request.kind == requestKind && pendingResolutionKey(request, resolution.kind) == key) {
				pendingRequests.splice(i, 1);
				return request;
			}
			i = i + 1;
		}
		return null;
	}

	function takePendingByRequestId(requestId:String):Null<TuiSmokeAppServerRequest> {
		if (requestId.length == 0) return null;
		var i = 0;
		while (i < pendingRequests.length) {
			final request = pendingRequests[i];
			if (request.requestId == requestId) {
				pendingRequests.splice(i, 1);
				return request;
			}
			i = i + 1;
		}
		return null;
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

	static function requestKindForResolution(kind:TuiSmokeAppServerResolutionKind):TuiSmokeAppServerRequestKind {
		return switch kind {
			case TuiSmokeAppServerResolutionKind.CommandApproval:
				TuiSmokeAppServerRequestKind.CommandApproval;
			case TuiSmokeAppServerResolutionKind.FileChangeApproval:
				TuiSmokeAppServerRequestKind.FileChangeApproval;
			case TuiSmokeAppServerResolutionKind.PermissionsApproval:
				TuiSmokeAppServerRequestKind.PermissionsApproval;
			case TuiSmokeAppServerResolutionKind.ToolUserInput:
				TuiSmokeAppServerRequestKind.ToolUserInput;
			case _:
				TuiSmokeAppServerRequestKind.Unknown;
		}
	}

	static function pendingResolutionKey(request:TuiSmokeAppServerRequest, kind:TuiSmokeAppServerResolutionKind):String {
		return kind == TuiSmokeAppServerResolutionKind.ToolUserInput ? request.turnId : request.displayId();
	}

	static function resolutionKey(resolution:TuiSmokeAppServerResolution):String {
		return resolution.requestId.length > 0 ? resolution.requestId : resolution.id;
	}

	static function resolutionSummary(resolution:TuiSmokeAppServerResolution):String {
		return switch resolution.kind {
			case TuiSmokeAppServerResolutionKind.CommandApproval
				| TuiSmokeAppServerResolutionKind.FileChangeApproval
				| TuiSmokeAppServerResolutionKind.PermissionsApproval:
				resolution.decision.length > 0 ? resolution.decision : "resolved";
			case TuiSmokeAppServerResolutionKind.ToolUserInput:
				resolution.response.length > 0 ? resolution.response : "answered";
			case TuiSmokeAppServerResolutionKind.ServerRequestResolved:
				"dismissed";
			case _:
				"unknown";
		}
	}
}
