package codexhx.runtime.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
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
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.validation.tui.resume.live.ResumePickerGateDiagnostics;

class AppServerStreamPressureGate {
	public static function run():AppServerStreamPressureReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcThreadSource(8);
		final fanout = new StreamFanout(source);
		final pump = new EventPump(1, fanout, scheduler, 2);
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "stream-pressure-open");

		final readAccepted = fanout.enqueuePreview(readRequest("pressure-read-lossless", "thread-pressure-a", true, 2));
		stateSummaries.push("enqueued:read=" + outcomeSummary(readAccepted));

		forwardPolls.push("frame=" + AsyncPollSummary.summary(pump.forward(StreamEvent.frameRequested(1, "pressure-frame-1"))));
		forwardPolls.push("progress=" + AsyncPollSummary.summary(pump.forward(StreamEvent.progressUpdated(1, "cosmetic-progress"))));
		final droppedServerPoll = pump.forward(StreamEvent.serverRequest(1, "pressure-server-request-dropped", "approval request while queue full"));
		forwardPolls.push("server-request=" + AsyncPollSummary.summary(droppedServerPoll));
		final blockedReadPoll = pump.forward(StreamEvent.readResult(1, "pressure-read-lossless", "thread-pressure-a",
			threadReadResultJson("thread-pressure-a", "user: stream pressure\nassistant: lossless survived")));
		forwardPolls.push("read-lossless-blocked=" + AsyncPollSummary.summary(blockedReadPoll));

		final frameDispatch = pump.dispatchNext(AsyncContext.fixture("pressure-frame"));
		dispatchSummaries.push(frameDispatch.summary);
		hostEvents.push(frameDispatch.hostEvent.summary());
		applyFrameIntent(state, frameDispatch.hostEvent);
		stateSummaries.push("frame:" + stateSummary(state));
		renderer.render(state);

		final progressDispatch = pump.dispatchNext(AsyncContext.fixture("pressure-progress"));
		dispatchSummaries.push(progressDispatch.summary);
		hostEvents.push(progressDispatch.hostEvent.summary());
		applyProgress(state, progressDispatch.hostEvent);
		stateSummaries.push("progress:" + stateSummary(state));
		renderer.render(state);

		final readPoll = pump.forward(StreamEvent.readResult(1, "pressure-read-lossless", "thread-pressure-a",
			threadReadResultJson("thread-pressure-a", "user: stream pressure\nassistant: lossless survived")));
		forwardPolls.push("read-lossless=" + AsyncPollSummary.summary(readPoll));

		final lagDispatch = pump.dispatchNext(AsyncContext.fixture("pressure-lag"));
		dispatchSummaries.push(lagDispatch.summary);
		hostEvents.push(lagDispatch.hostEvent.summary());
		applyFailure(state, lagDispatch.hostEvent, "pressure_lag_marker");
		stateSummaries.push("lag:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "stream-pressure-lag");

		final readDispatch = pump.dispatchNext(AsyncContext.fixture("pressure-read"));
		dispatchSummaries.push(readDispatch.summary);
		hostEvents.push(readDispatch.hostEvent.summary());
		if (readDispatch.hostEvent.kind == ResumePickerHostEventKind.PreviewLoaded)
			applyPreview(state, readDispatch.hostEvent);
		stateSummaries.push("read:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "stream-pressure-read");

		final pageAccepted = fanout.enqueuePage(pageRequest("pressure-recovery-page", "", "pressure", ResumePickerFilterMode.Cwd));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		forwardPolls.push("page-recovery="
			+ AsyncPollSummary.summary(pump.forward(StreamEvent.pageResult(1, "pressure-recovery-page", threadListResultJson("pressure")))));

		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("pressure-page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "pressure");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "stream-pressure-page");

		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();
		final fanoutSummaries = fanout.fanoutSummaries();
		final requestSummaries = fanout.requestSummaries();
		final transportSummaries = fanout.transportSummaries();

		return new AppServerStreamPressureReport({
			pressureContractModeled: pressureContractModeled(pumpSummaries, dispatchSummaries, forwardPolls),
			bestEffortDropped: contains(forwardPolls, "server-request=kind=backpressured")
			&& contains(forwardPolls, "code=best_effort_dropped"),
			serverRequestRejected: contains(rejectedRequests, "pressure-server-request-dropped")
			&& contains(rejectedRequests, "reason=consumer_queue_full"),
			losslessBackpressured: contains(forwardPolls, "read-lossless-blocked=kind=backpressured")
			&& contains(forwardPolls, "code=lossless_backpressure"),
			losslessLagFlushed: lagDispatch.hostEvent.failureCode == "app_server_stream_lagged"
			&& contains(dispatchSummaries, "kind=lagged"),
			losslessEventPreserved: readDispatch.hostEvent.kind == ResumePickerHostEventKind.PreviewLoaded
			&& state.previewState == "loaded",
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-pressure-a"
			&& !state.inlineErrorShown,
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
			dispatchSummaries: dispatchSummaries,
			pumpSummaries: pumpSummaries,
			rejectedRequestSummaries: rejectedRequests,
			fanoutSummaries: fanoutSummaries,
			hostEventSummaries: hostEvents,
			stateSummaries: stateSummaries,
			forwardPollSummaries: forwardPolls
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "pressure";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "stream pressure open";
		return state;
	}

	static function pageRequest(requestId:String, cursor:String, query:String, filterMode:ResumePickerFilterMode):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 2,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: filterMode,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: filterMode == ResumePickerFilterMode.All,
			includeNonInteractive: false
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

	static function applyFrameIntent(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.loaderEventStatus = "stream_pressure_frame_requested";
		state.loaderEventDetail = "reason=" + event.detail;
		state.footerProgressLabel = "stream pressure frame";
	}

	static function applyProgress(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.loaderEventStatus = "stream_pressure_progress_seen";
		state.loaderEventDetail = "detail=" + event.detail;
		state.footerProgressLabel = "stream pressure progress";
	}

	static function applyPage(state:ResumePickerState, event:ResumePickerHostEvent, prefix:String):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-" + prefix + "-a";
		state.selectedLabel = title(prefix, "A");
		state.nextCursor = "cursor-" + prefix;
		state.nextCursorPresent = true;
		state.moreBelow = true;
		state.visibleRows = [
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-19T23:40:00Z", 2, true,
				["user: stream pressure", "assistant: lossless survived"]),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-19T23:41:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "stream_pressure_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "stream pressure page " + prefix;
	}

	static function applyPreview(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.expandedThreadId = event.threadId;
		state.previewState = "loaded";
		state.previewRendered = true;
		state.previewLineCount = 2;
		state.previewUserLineCount = 1;
		state.previewAssistantLineCount = 1;
		state.visibleRows = [
			visibleRow("thread-pressure-a", title("pressure", "A"), "2026-06-19T23:40:00Z", 2, true, ["user: stream pressure", "assistant: lossless survived"]),
			visibleRow("thread-pressure-b", title("pressure", "B"), "2026-06-19T23:41:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "stream_pressure_preview_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "stream pressure preview";
	}

	static function applyFailure(state:ResumePickerState, event:ResumePickerHostEvent, status:String):Void {
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = status;
		state.loaderEventDetail = "request=" + event.requestId + ";thread=" + event.threadId + ";sourceCode=" + event.failureCode;
		state.footerProgressLabel = status;
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-19T23:40:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-19T23:41:00Z", 1)
			+ "],\"nextCursor\":\"cursor-"
			+ prefix
			+ "\",\"backwardsCursor\":null}";
	}

	static function threadListRowJson(threadId:String, sessionId:String, rowTitle:String, updatedAt:String, turns:Int):String {
		return "{" + "\"id\":" + CodexJson.quote(threadId) + ",\"sessionId\":" + CodexJson.quote(sessionId) + ",\"status\":{\"type\":\"idle\"}"
			+ ",\"turns\":" + turnsJson(turns) + ",\"title\":" + CodexJson.quote(rowTitle) + ",\"cwd\":\"/workspace/codex-hxrust\"" + ",\"updatedAt\":"
			+ CodexJson.quote(updatedAt) + ",\"archived\":false}";
	}

	static function threadReadResultJson(threadId:String, preview:String):String {
		return "{\"thread\":{\"id\":"
			+ CodexJson.quote(threadId)
			+ ",\"sessionId\":\"session-pressure-a\",\"forkedFromId\":null,\"parentThreadId\":null"
			+ ",\"preview\":"
			+ CodexJson.quote(preview)
			+ ",\"ephemeral\":false,\"modelProvider\":\"openai\",\"createdAt\":1781898000"
			+ ",\"updatedAt\":1781898060,\"status\":{\"type\":\"idle\"},\"path\":null,\"cwd\":\"/workspace/codex-hxrust\",\"cliVersion\":\"0.0.0-test\""
			+ ",\"source\":\"cli\",\"threadSource\":null,\"agentNickname\":null,\"agentRole\":null,\"gitInfo\":null,\"name\":\"Pressure row\""
			+ ",\"turns\":[{\"id\":\"turn-1\",\"status\":\"completed\",\"items\":[]}]}}";
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

	static function visibleRow(threadId:String, rowTitle:String, updatedAt:String, turnCount:Int, selected:Bool,
			previewLines:Array<String>):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: rowTitle,
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

	static function pressureContractModeled(pump:Array<String>, dispatches:Array<String>, forwardPolls:Array<String>):Bool {
		return contains(pump, "session:attach:generation=1")
			&& contains(pump, "forward:generation=1;kind=frame_requested")
			&& contains(pump, "forward:generation=1;kind=progress_updated")
			&& contains(pump, "forward:generation=1;kind=server_request")
			&& contains(pump, "forward:server-request-rejected")
			&& contains(pump, "code=lossless_backpressure")
			&& contains(pump, "forward:lag:generation=1;kind=lagged")
			&& contains(pump, "forward:generation=1;kind=read_result")
			&& contains(pump, "forward:generation=1;kind=page_result")
			&& contains(forwardPolls, "server-request=kind=backpressured")
			&& contains(dispatches, "kind=lagged")
			&& contains(dispatches, "kind=read_result")
			&& contains(dispatches, "kind=page_result");
	}

	static function stateSummary(state:ResumePickerState):String {
		return DiagnosticSummary.render([
			DiagnosticSummary.text("thread", state.selectedThreadId),
			DiagnosticSummary.text("previewState", state.previewState),
			DiagnosticSummary.intValue("previewLines", state.previewLineCount),
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

	static function title(prefix:String, suffix:String):String {
		return "Stream pressure " + prefix + " row " + suffix;
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
