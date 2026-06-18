package codexhx.runtime.tui.smoke;

class TuiSmokeAppServerFacade {
	var eventCount:Int;
	var requestCount:Int;
	var rejectedRequestCount:Int;
	var resolutionCount:Int;
	var staleResolutionCount:Int;
	var deliveredRequestCount:Int;
	var evictedRequestCount:Int;
	var closed:Bool;
	var primaryThreadId:String;
	var activeThreadId:String;
	final pendingRequests:Array<TuiSmokeAppServerRequest>;
	final queuedRequests:Array<TuiSmokeAppServerRequest>;

	public function new() {
		this.eventCount = 0;
		this.requestCount = 0;
		this.rejectedRequestCount = 0;
		this.resolutionCount = 0;
		this.staleResolutionCount = 0;
		this.deliveredRequestCount = 0;
		this.evictedRequestCount = 0;
		this.closed = false;
		this.primaryThreadId = "";
		this.activeThreadId = "";
		this.pendingRequests = [];
		this.queuedRequests = [];
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
		queuedRequests.push(request);
		final target = targetForThread(request.threadId);
		final deliveryState = activeThreadId == request.threadId ? "active" : "buffered";
		trace.push(
			"server.request." + request.kind
			+ "=" + request.requestId
			+ ":" + request.threadId
			+ ":" + target
			+ ":" + request.displayId()
			+ ":" + deliveryState
		);
		return TuiSmokeExitKind.Rendered;
	}

	public function handleThreadDelivery(action:TuiSmokeThreadDeliveryAction, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("thread.delivery.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (action == null || action.kind == TuiSmokeThreadDeliveryActionKind.Unknown) {
			trace.push("thread.delivery.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		return switch action.kind {
			case TuiSmokeThreadDeliveryActionKind.DrainActive:
				deliverActive(trace);
				TuiSmokeExitKind.Rendered;
			case TuiSmokeThreadDeliveryActionKind.SwitchActive:
				if (action.threadId.length == 0) {
					trace.push("thread.active.stale=");
				} else {
					activeThreadId = action.threadId;
					trace.push("thread.active=" + activeThreadId);
					deliverActive(trace);
				}
				TuiSmokeExitKind.Rendered;
			case TuiSmokeThreadDeliveryActionKind.EvictQueued:
				evictQueued(action.requestId, trace);
				TuiSmokeExitKind.Rendered;
			case _:
				trace.push("thread.delivery.unknown");
				TuiSmokeExitKind.Rejected;
		}
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

	public function deliveredRequests():Int {
		return deliveredRequestCount;
	}

	public function evictedRequests():Int {
		return evictedRequestCount;
	}

	function deliverActive(trace:Array<String>):Void {
		if (activeThreadId.length == 0) {
			trace.push("thread.deliver.stale=no_active");
			return;
		}
		var delivered = 0;
		var i = 0;
		while (i < queuedRequests.length) {
			final request = queuedRequests[i];
			if (request.threadId == activeThreadId) {
				queuedRequests.splice(i, 1);
				delivered = delivered + 1;
				deliveredRequestCount = deliveredRequestCount + 1;
				trace.push("thread.deliver=" + activeThreadId + ":" + request.requestId + ":" + request.displayId());
			} else {
				i = i + 1;
			}
		}
		if (delivered == 0) trace.push("thread.deliver.empty=" + activeThreadId);
	}

	function evictQueued(requestId:String, trace:Array<String>):Void {
		if (requestId.length == 0) {
			trace.push("thread.evict.stale=");
			return;
		}
		var i = 0;
		while (i < queuedRequests.length) {
			final request = queuedRequests[i];
			if (request.requestId == requestId) {
				queuedRequests.splice(i, 1);
				evictedRequestCount = evictedRequestCount + 1;
				trace.push("thread.evict=" + requestId + ":" + request.displayId());
				return;
			}
			i = i + 1;
		}
		trace.push("thread.evict.stale=" + requestId);
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
			activeThreadId = threadId;
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
