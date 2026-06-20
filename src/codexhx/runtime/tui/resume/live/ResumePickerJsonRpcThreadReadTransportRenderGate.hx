package codexhx.runtime.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerBackgroundLoader;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcResumePickerThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerBackgroundRequest;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;

class ResumePickerJsonRpcThreadReadTransportRenderGate {
	public static function run():ResumePickerJsonRpcThreadReadTransportRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 4);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];

		renderFrame(scheduler, renderer, state, "jsonrpc-thread-read-open");

		final previewEvent = loadPreview(loader, readRequest("jsonrpc-preview-read", "thread-jsonrpc-a", true, 2));
		hostEvents.push(previewEvent.summary());
		if (previewEvent.kind == ResumePickerHostEventKind.PreviewLoaded)
			applyPreview(state, previewEvent);
		stateSummaries.push("preview:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "jsonrpc-thread-read-preview");

		final errorEvent = loadPreview(loader, readRequest("jsonrpc-read-error", "thread-jsonrpc-missing", true, 2));
		hostEvents.push(errorEvent.summary());
		if (errorEvent.kind == ResumePickerHostEventKind.Failed)
			applyJsonRpcError(state, errorEvent);
		stateSummaries.push("error:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "jsonrpc-thread-read-error");

		final transcriptEvent = loadTranscript(loader, readRequest("jsonrpc-transcript-read", "thread-jsonrpc-a", false, 0));
		hostEvents.push(transcriptEvent.summary());
		if (transcriptEvent.kind == ResumePickerHostEventKind.TranscriptLoaded)
			applyTranscript(state, transcriptEvent);
		stateSummaries.push("transcript:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "jsonrpc-thread-read-transcript");

		final requestSummaries = source.requestSummaries();
		final transportSummaries = source.transportSummaries();
		final transportEvents = source.drainedEventSummaries();

		return new ResumePickerJsonRpcThreadReadTransportRenderGateReport({
			requestShapePreserved: requestShapePreserved(requestSummaries, transportSummaries),
			previewDecoded: previewEvent.kind == ResumePickerHostEventKind.PreviewLoaded
			&& previewEvent.detail.indexOf("preview=2") >= 0
			&& previewEvent.detail.indexOf("truncated=true") >= 0,
			transcriptDecoded: transcriptEvent.kind == ResumePickerHostEventKind.TranscriptLoaded
			&& transcriptEvent.detail.indexOf("cells=3") >= 0
			&& state.transcriptCellCount == 3,
			errorMapped: errorEvent.kind == ResumePickerHostEventKind.Failed
			&& stateSummaries[1].indexOf("failure=json_rpc_thread_read_error") >= 0,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			requestSummaries: requestSummaries,
			transportSummaries: transportSummaries,
			transportEventSummaries: transportEvents,
			hostEventSummaries: hostEvents,
			stateSummaries: stateSummaries
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "kernel";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.scannedRows = 1;
		state.acceptedRows = 1;
		state.loadedRows = 1;
		state.filteredRows = 1;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-jsonrpc-a";
		state.selectedLabel = "JSON-RPC kernel row";
		state.visibleRows = visibleRows([]);
		state.footerProgressLabel = "json-rpc read open";
		return state;
	}

	static function applyPreview(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.expandedThreadId = event.threadId;
		state.previewState = "loaded";
		state.previewRendered = true;
		state.previewLineCount = 2;
		state.previewUserLineCount = 1;
		state.previewAssistantLineCount = 1;
		state.visibleRows = visibleRows(["user: continue raw codex", "assistant: preview ready"]);
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "json_rpc_thread_read_preview_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "json-rpc preview";
	}

	static function applyJsonRpcError(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = "json_rpc_thread_read_error_mapped";
		state.loaderEventDetail = "request=" + event.requestId + ";thread=" + event.threadId + ";sourceCode=" + event.failureCode + ";previewThread="
			+ state.expandedThreadId;
		state.footerProgressLabel = "json-rpc read error";
	}

	static function applyTranscript(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.pendingThreadId = event.threadId;
		state.transcriptState = "loaded";
		state.transcriptCells = [
			"user: continue raw codex",
			"assistant: transcript ready",
			"plan: keep upstream read shape"
		];
		state.transcriptCellCount = state.transcriptCells.length;
		state.transcriptUserCellCount = 1;
		state.transcriptAssistantCellCount = 1;
		state.transcriptPlanCellCount = 1;
		state.transcriptFallbackCellCount = 0;
		state.overlayOpen = true;
		state.loadingOverlayMessage = "";
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "json_rpc_thread_read_transcript_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "json-rpc transcript";
	}

	static function readRequest(requestId:String, threadId:String, previewOnly:Bool, maxPreviewLines:Int):ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: requestId,
			threadId: threadId,
			includeTurns: true,
			previewOnly: previewOnly,
			maxPreviewLines: maxPreviewLines
		});
	}

	static function fixtureSource():JsonRpcResumePickerThreadSource {
		final source = new JsonRpcResumePickerThreadSource(8);
		source.addThreadReadResult("jsonrpc-preview-read",
			"{\"thread\":" + threadJson("thread-jsonrpc-a", "user: continue raw codex\nassistant: preview ready\nplan: hidden by preview cap") + "}");
		source.addThreadReadError("jsonrpc-read-error", "{\"code\":-32602,\"message\":\"thread not loaded\"}");
		source.addThreadReadResult("jsonrpc-transcript-read",
			"{\"thread\":" + threadJson("thread-jsonrpc-a", "user: continue raw codex\nassistant: preview ready") + "}");
		return source;
	}

	static function threadJson(threadId:String, preview:String):String {
		return "{"
			+ "\"id\":"
			+ CodexJson.quote(threadId)
			+ ",\"sessionId\":\"session-jsonrpc-a\""
			+ ",\"forkedFromId\":null"
			+ ",\"parentThreadId\":null"
			+ ",\"preview\":"
			+ CodexJson.quote(preview)
			+ ",\"ephemeral\":false"
			+ ",\"modelProvider\":\"openai\""
			+ ",\"createdAt\":1781892000"
			+ ",\"updatedAt\":1781892300"
			+ ",\"status\":{\"type\":\"idle\"}"
			+ ",\"path\":null"
			+ ",\"cwd\":\"/workspace/codex-hxrust\""
			+ ",\"cliVersion\":\"0.0.0-test\""
			+ ",\"source\":\"cli\""
			+ ",\"threadSource\":null"
			+ ",\"agentNickname\":null"
			+ ",\"agentRole\":null"
			+ ",\"gitInfo\":null"
			+ ",\"name\":\"JSON-RPC kernel row\""
			+ ",\"turns\":["
			+ turnJson("turn-1", [
				userMessageJson("item-user-1", "continue raw codex"),
				textItemJson("agentMessage", "item-agent-1", "transcript ready")
			])
			+ ","
			+ turnJson("turn-2", [textItemJson("plan", "item-plan-1", "keep upstream read shape")])
			+ "]}";
	}

	static function turnJson(turnId:String, items:Array<String>):String {
		return "{\"id\":"
			+ CodexJson.quote(turnId)
			+ ",\"items\":["
			+ items.join(",")
			+ "],\"itemsView\":{\"type\":\"full\"},\"status\":\"completed\""
			+ ",\"error\":null,\"startedAt\":1781892000,\"completedAt\":1781892060,\"durationMs\":60000}";
	}

	static function userMessageJson(id:String, text:String):String {
		return "{\"type\":\"userMessage\",\"id\":"
			+ CodexJson.quote(id)
			+ ",\"content\":[{\"type\":\"text\",\"text\":"
			+ CodexJson.quote(text)
			+ "}]}";
	}

	static function textItemJson(type:String, id:String, text:String):String {
		return "{\"type\":" + CodexJson.quote(type) + ",\"id\":" + CodexJson.quote(id) + ",\"text\":" + CodexJson.quote(text) + "}";
	}

	static function visibleRows(previewLines:Array<String>):Array<ResumePickerVisibleRow> {
		return [
			new ResumePickerVisibleRow({
				threadId: "thread-jsonrpc-a",
				title: "JSON-RPC kernel row",
				cwd: "/workspace/codex-hxrust",
				updatedAt: "2026-06-19T22:00:00Z",
				turnCount: 2,
				selected: true,
				previewLines: previewLines
			})
		];
	}

	static function loadPreview(loader:DeterministicResumePickerBackgroundLoader, request:ResumePickerThreadReadRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.previewLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function loadTranscript(loader:DeterministicResumePickerBackgroundLoader, request:ResumePickerThreadReadRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.transcriptLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function renderFrame(scheduler:DeterministicResumePickerFrameScheduler, renderer:DeterministicResumePickerTerminalRenderer,
			state:ResumePickerState, reason:String):Void {
		scheduler.requestFrame(reason);
		renderer.render(state);
	}

	static function requestShapePreserved(requests:Array<String>, transport:Array<String>):Bool {
		return contains(requests, "id=jsonrpc-preview-read;thread=thread-jsonrpc-a;includeTurns=true;previewOnly=true;maxPreview=2")
			&& contains(requests, "jsonMethod=thread/read")
			&& contains(requests, "\"threadId\":\"thread-jsonrpc-a\"")
			&& contains(requests, "\"includeTurns\":true")
			&& !contains(requests, "\"previewOnly\"")
			&& !contains(requests, "\"maxPreviewLines\"")
			&& contains(transport, "send:ok=true;code=accepted;request=jsonrpc-preview-read;method=thread/read")
			&& contains(transport, "complete:ok=true;code=completed;request=jsonrpc-transcript-read;method=thread/read");
	}

	static function stateSummary(state:ResumePickerState):String {
		return "thread=" + state.selectedThreadId + ";previewState=" + state.previewState + ";previewLines=" + state.previewLineCount + ";overlay="
			+ boolLabel(state.overlayOpen) + ";cells=" + state.transcriptCellCount + ";errorShown=" + boolLabel(state.inlineErrorShown) + ";failure="
			+ emptyLabel(state.lastFailureCode) + ";footer=" + state.footerProgressLabel + ";loader=" + state.loaderEventStatus + ";detail="
			+ state.loaderEventDetail;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}

	static function expectEvent(poll:AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>>):ResumePickerHostEvent {
		return switch poll {
			case Ready(item, _, _): item.value;
			case Pending(_, _): throw "expected host event, got pending";
			case Failed(error, _, _): throw "expected host event, got failure: " + error.code;
			case Cancelled(reason, _, _): throw "expected host event, got cancellation: " + reason;
			case Closed(_, _): throw "expected host event, got closed";
			case Backpressured(error, _, _): throw "expected host event, got backpressure: " + error.code;
		}
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
