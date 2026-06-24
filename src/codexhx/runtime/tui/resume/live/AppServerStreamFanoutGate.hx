package codexhx.runtime.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.validation.tui.resume.live.ResumePickerGateDiagnostics;

class AppServerStreamFanoutGate {
	public static function run():AppServerStreamFanoutReport {
		final source = new JsonRpcThreadSource(2);
		final fanout = new StreamFanout(source);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final pendingSummaries:Array<String> = [];
		final drainedTransportEvents:Array<String> = [];

		renderFrame(scheduler, renderer, state, "fanout-open");

		final pageAccepted = fanout.enqueuePage(pageRequest("fanout-page-1", "", ResumePickerFilterMode.Cwd, false));
		pendingSummaries.push("after-page=" + fanout.pendingCount() + ":" + outcomeSummary(pageAccepted));
		final previewAccepted = fanout.enqueuePreview(readRequest("fanout-preview-read", "thread-fanout-a", true, 2));
		pendingSummaries.push("after-preview=" + fanout.pendingCount() + ":" + outcomeSummary(previewAccepted));
		final blockedTranscriptAccepted = fanout.enqueueTranscript(readRequest("fanout-blocked-transcript", "thread-fanout-a", false, 0));
		pendingSummaries.push("after-transcript=" + fanout.pendingCount() + ":" + outcomeSummary(blockedTranscriptAccepted));

		final pageEvent = fanout.completePage("fanout-page-1", threadListResultJson());
		hostEvents.push(pageEvent.summary());
		if (pageEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageEvent);
		stateSummaries.push("page:" + stateSummary(state) + ";pending=" + fanout.pendingCount());
		renderFrame(scheduler, renderer, state, "fanout-page");

		final previewEvent = fanout.completeRead("fanout-preview-read",
			threadReadResultJson("thread-fanout-a", "user: stream fanout\nassistant: preview decoded\nplan: hidden by cap"));
		hostEvents.push(previewEvent.summary());
		if (previewEvent.kind == ResumePickerHostEventKind.PreviewLoaded)
			applyPreview(state, previewEvent);
		stateSummaries.push("preview:" + stateSummary(state) + ";pending=" + fanout.pendingCount());
		renderFrame(scheduler, renderer, state, "fanout-preview");

		final backpressureEvent = fanout.failRead("fanout-blocked-transcript", "{\"code\":-32099,\"message\":\"blocked while queue full\"}");
		hostEvents.push(backpressureEvent.summary());
		if (backpressureEvent.kind == ResumePickerHostEventKind.Failed)
			applyBackpressure(state, backpressureEvent);
		stateSummaries.push("backpressure:" + stateSummary(state) + ";pending=" + fanout.pendingCount());
		renderFrame(scheduler, renderer, state, "fanout-backpressure");

		for (summary in fanout.transportEventSummaries())
			drainedTransportEvents.push(summary);

		final errorAccepted = fanout.enqueuePreview(readRequest("fanout-read-error", "thread-fanout-missing", true, 2));
		pendingSummaries.push("after-error-enqueue=" + fanout.pendingCount() + ":" + outcomeSummary(errorAccepted));
		final errorEvent = fanout.failRead("fanout-read-error", "{\"code\":-32602,\"message\":\"thread not loaded\"}");
		hostEvents.push(errorEvent.summary());
		if (errorEvent.kind == ResumePickerHostEventKind.Failed)
			applyJsonRpcError(state, errorEvent);
		stateSummaries.push("jsonrpc-error:" + stateSummary(state) + ";pending=" + fanout.pendingCount());
		renderFrame(scheduler, renderer, state, "fanout-jsonrpc-error");

		final transcriptAccepted = fanout.enqueueTranscript(readRequest("fanout-transcript-read", "thread-fanout-a", false, 0));
		pendingSummaries.push("after-recovery-enqueue=" + fanout.pendingCount() + ":" + outcomeSummary(transcriptAccepted));
		final transcriptEvent = fanout.completeRead("fanout-transcript-read",
			threadReadResultJson("thread-fanout-a", "user: stream fanout\nassistant: transcript decoded"));
		hostEvents.push(transcriptEvent.summary());
		if (transcriptEvent.kind == ResumePickerHostEventKind.TranscriptLoaded)
			applyTranscript(state, transcriptEvent);
		stateSummaries.push("transcript:" + stateSummary(state) + ";pending=" + fanout.pendingCount());
		renderFrame(scheduler, renderer, state, "fanout-transcript");

		for (summary in fanout.transportEventSummaries())
			drainedTransportEvents.push(summary);

		final requestSummaries = fanout.requestSummaries();
		final transportSummaries = fanout.transportSummaries();
		final fanoutSummaries = fanout.fanoutSummaries().concat(pendingSummaries);

		return new AppServerStreamFanoutReport({
			requestShapePreserved: requestShapePreserved(requestSummaries, transportSummaries),
			pendingOwnershipModeled: pendingOwnershipModeled(fanoutSummaries),
			backpressureRouted: backpressureEvent.kind == ResumePickerHostEventKind.Failed
			&& backpressureEvent.failureMessage.indexOf("lossless event requires consumer capacity") >= 0
			&& stateSummaries[2].indexOf("failure=json_rpc_response_rejected") >= 0,
			jsonRpcErrorMapped: errorEvent.kind == ResumePickerHostEventKind.Failed
			&& stateSummaries[3].indexOf("failure=json_rpc_thread_read_error") >= 0,
			pageDecoded: pageEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& stateSummaries[0].indexOf("thread=thread-fanout-a") >= 0,
			previewDecoded: previewEvent.kind == ResumePickerHostEventKind.PreviewLoaded && previewEvent.detail.indexOf("preview=2") >= 0,
			transcriptDecoded: transcriptEvent.kind == ResumePickerHostEventKind.TranscriptLoaded && state.transcriptCellCount == 3,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			requestSummaries: requestSummaries,
			transportSummaries: transportSummaries,
			transportEventSummaries: drainedTransportEvents,
			fanoutSummaries: fanoutSummaries,
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
		state.query = "fanout";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "fanout open";
		return state;
	}

	static function pageRequest(requestId:String, cursor:String, filterMode:ResumePickerFilterMode, includeNonInteractive:Bool):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: "fanout",
			pageSize: 2,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: filterMode,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: filterMode == ResumePickerFilterMode.All,
			includeNonInteractive: includeNonInteractive
		});
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

	static function applyPage(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-fanout-a";
		state.selectedLabel = "Fanout kernel row";
		state.nextCursor = "cursor-fanout-2";
		state.nextCursorPresent = true;
		state.moreBelow = true;
		state.visibleRows = [
			visibleRow("thread-fanout-a", "Fanout kernel row", "2026-06-19T23:00:00Z", 2, true, []),
			visibleRow("thread-fanout-b", "Fanout second row", "2026-06-19T23:05:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "fanout_thread_list_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "fanout page";
	}

	static function applyPreview(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.expandedThreadId = event.threadId;
		state.previewState = "loaded";
		state.previewRendered = true;
		state.previewLineCount = 2;
		state.previewUserLineCount = 1;
		state.previewAssistantLineCount = 1;
		state.visibleRows = [
			visibleRow("thread-fanout-a", "Fanout kernel row", "2026-06-19T23:00:00Z", 2, true, ["user: stream fanout", "assistant: preview decoded"]),
			visibleRow("thread-fanout-b", "Fanout second row", "2026-06-19T23:05:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "fanout_thread_read_preview_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "fanout preview";
	}

	static function applyBackpressure(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = "fanout_backpressure_routed";
		state.loaderEventDetail = "request=" + event.requestId + ";thread=" + event.threadId + ";sourceCode=" + event.failureCode;
		state.footerProgressLabel = "fanout backpressure";
	}

	static function applyJsonRpcError(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = "fanout_json_rpc_error_mapped";
		state.loaderEventDetail = "request=" + event.requestId + ";thread=" + event.threadId + ";sourceCode=" + event.failureCode;
		state.footerProgressLabel = "fanout read error";
	}

	static function applyTranscript(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.pendingThreadId = event.threadId;
		state.transcriptState = "loaded";
		state.transcriptCells = [
			"user: stream fanout",
			"assistant: transcript decoded",
			"plan: stream fanout preserved"
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
		state.loaderEventStatus = "fanout_thread_read_transcript_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "fanout transcript";
	}

	static function threadListResultJson():String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-fanout-a", "session-fanout-a", "Fanout kernel row", "2026-06-19T23:00:00Z", 2)
			+ ","
			+ threadListRowJson("thread-fanout-b", "session-fanout-b", "Fanout second row", "2026-06-19T23:05:00Z", 1)
			+ "],\"nextCursor\":\"cursor-fanout-2\",\"backwardsCursor\":null}";
	}

	static function threadListRowJson(threadId:String, sessionId:String, title:String, updatedAt:String, turns:Int):String {
		return "{" + "\"id\":" + CodexJson.quote(threadId) + ",\"sessionId\":" + CodexJson.quote(sessionId) + ",\"status\":{\"type\":\"idle\"}"
			+ ",\"turns\":" + turnsJson(turns) + ",\"title\":" + CodexJson.quote(title) + ",\"cwd\":\"/workspace/codex-hxrust\"" + ",\"updatedAt\":"
			+ CodexJson.quote(updatedAt) + ",\"archived\":false}";
	}

	static function threadReadResultJson(threadId:String, preview:String):String {
		return "{\"thread\":" + threadJson(threadId, preview) + "}";
	}

	static function threadJson(threadId:String, preview:String):String {
		return "{"
			+ "\"id\":"
			+ CodexJson.quote(threadId)
			+ ",\"sessionId\":\"session-fanout-a\""
			+ ",\"forkedFromId\":null"
			+ ",\"parentThreadId\":null"
			+ ",\"preview\":"
			+ CodexJson.quote(preview)
			+ ",\"ephemeral\":false"
			+ ",\"modelProvider\":\"openai\""
			+ ",\"createdAt\":1781895600"
			+ ",\"updatedAt\":1781895900"
			+ ",\"status\":{\"type\":\"idle\"}"
			+ ",\"path\":null"
			+ ",\"cwd\":\"/workspace/codex-hxrust\""
			+ ",\"cliVersion\":\"0.0.0-test\""
			+ ",\"source\":\"cli\""
			+ ",\"threadSource\":null"
			+ ",\"agentNickname\":null"
			+ ",\"agentRole\":null"
			+ ",\"gitInfo\":null"
			+ ",\"name\":\"Fanout kernel row\""
			+ ",\"turns\":["
			+ turnJson("turn-1", [
				userMessageJson("item-user-1", "stream fanout"),
				textItemJson("agentMessage", "item-agent-1", "transcript decoded")
			])
			+ ","
			+ turnJson("turn-2", [textItemJson("plan", "item-plan-1", "stream fanout preserved")])
			+ "]}";
	}

	static function turnJson(turnId:String, items:Array<String>):String {
		return "{\"id\":" + CodexJson.quote(turnId) + ",\"items\":[" + items.join(",") + "],\"status\":\"completed\"}";
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

	static function turnsJson(count:Int):String {
		final parts:Array<String> = [];
		var i = 0;
		while (i < count) {
			parts.push("{\"id\":\"turn-" + Std.string(i + 1) + "\",\"status\":\"completed\",\"items\":[]}");
			i = i + 1;
		}
		return "[" + parts.join(",") + "]";
	}

	static function visibleRow(threadId:String, title:String, updatedAt:String, turnCount:Int, selected:Bool,
			previewLines:Array<String>):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: title,
			cwd: "/workspace/codex-hxrust",
			updatedAt: updatedAt,
			turnCount: turnCount,
			selected: selected,
			previewLines: previewLines
		});
	}

	static function renderFrame(scheduler:DeterministicFrameScheduler, renderer:DeterministicTerminalRenderer, state:ResumePickerState, reason:String):Void {
		scheduler.requestFrame(reason);
		renderer.render(state);
	}

	static function requestShapePreserved(requests:Array<String>, transport:Array<String>):Bool {
		return contains(requests, "id=fanout-page-1")
			&& contains(requests, "jsonMethod=thread/list")
			&& contains(requests, "\"searchTerm\":\"fanout\"")
			&& contains(requests, "id=fanout-preview-read;thread=thread-fanout-a")
			&& contains(requests, "jsonMethod=thread/read")
			&& contains(requests, "\"threadId\":\"thread-fanout-a\"")
			&& contains(requests, "\"includeTurns\":true")
			&& !contains(requests, "\"previewOnly\"")
			&& contains(transport, "fanout-send:ok=true;code=accepted;request=fanout-page-1;method=thread/list;pending=1")
			&& contains(transport, "fanout-send:ok=true;code=accepted;request=fanout-blocked-transcript;method=thread/read;pending=3");
	}

	static function pendingOwnershipModeled(fanout:Array<String>):Bool {
		return contains(fanout, "after-page=1")
			&& contains(fanout, "after-preview=2")
			&& contains(fanout, "after-transcript=3")
			&& contains(fanout, "resolve:page:")
			&& contains(fanout, "resolve:read:")
			&& contains(fanout, "pending=0");
	}

	static function stateSummary(state:ResumePickerState):String {
		return DiagnosticSummary.render([
			DiagnosticSummary.text("thread", state.selectedThreadId),
			DiagnosticSummary.text("previewState", state.previewState),
			DiagnosticSummary.intValue("previewLines", state.previewLineCount),
			DiagnosticSummary.boolValue("overlay", state.overlayOpen),
			DiagnosticSummary.intValue("cells", state.transcriptCellCount),
			DiagnosticSummary.boolValue("errorShown", state.inlineErrorShown),
			DiagnosticSummary.text("failure", emptyLabel(state.lastFailureCode)),
			DiagnosticSummary.text("footer", state.footerProgressLabel),
			DiagnosticSummary.text("loader", state.loaderEventStatus),
			DiagnosticSummary.text("detail", state.loaderEventDetail)
		]);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return ResumePickerGateDiagnostics.runtimeClientOutcome(outcome);
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}
}
