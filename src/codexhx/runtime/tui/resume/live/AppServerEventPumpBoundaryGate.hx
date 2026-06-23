package codexhx.runtime.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.EventPumpDispatch;
import codexhx.runtime.tui.resume.host.EventPumpDispatchKind;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;

class AppServerEventPumpBoundaryGate {
	public static function run():AppServerEventPumpBoundaryReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final firstSource = new JsonRpcThreadSource(8);
		final firstFanout = new StreamFanout(firstSource);
		final recoverySource = new JsonRpcThreadSource(8);
		final recoveryFanout = new StreamFanout(recoverySource);
		final pump = new EventPump(1, firstFanout, scheduler, 8);
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];

		renderFrame(scheduler, renderer, state, "event-pump-open");

		final pageAccepted = firstFanout.enqueuePage(pageRequest("pump-page-1", "", "pump", ResumePickerFilterMode.Cwd));
		final readAccepted = firstFanout.enqueuePreview(readRequest("pump-read-preview", "thread-pump-a", true, 2));
		stateSummaries.push("enqueued:first-page=" + outcomeSummary(pageAccepted) + ";first-read=" + outcomeSummary(readAccepted));

		pump.enqueue(StreamEvent.frameRequested(1, "stream-page-ready"));
		final frameDispatch = pump.dispatchNext(AsyncContext.fixture("frame"));
		dispatchSummaries.push(frameDispatch.summary);
		hostEvents.push(frameDispatch.hostEvent.summary());
		applyFrameIntent(state, frameDispatch.hostEvent);
		stateSummaries.push("frame:" + stateSummary(state));
		renderer.render(state);

		pump.enqueue(StreamEvent.pageResult(1, "pump-page-1", threadListResultJson("pump")));
		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "pump");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "event-pump-page");

		pump.enqueue(StreamEvent.readResult(0, "pump-stale-preview", "thread-stale", threadReadResultJson("thread-stale", "stale")));
		final staleDispatch = pump.dispatchNext(AsyncContext.fixture("stale"));
		dispatchSummaries.push(staleDispatch.summary);
		hostEvents.push(staleDispatch.hostEvent.summary());
		applyStaleIgnored(state, staleDispatch.hostEvent);
		stateSummaries.push("stale:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "event-pump-stale");

		pump.enqueue(StreamEvent.readResult(1, "pump-read-preview", "thread-pump-a",
			threadReadResultJson("thread-pump-a", "user: event pump\nassistant: preview active\nplan: hidden")));
		final readDispatch = pump.dispatchNext(AsyncContext.fixture("read"));
		dispatchSummaries.push(readDispatch.summary);
		hostEvents.push(readDispatch.hostEvent.summary());
		if (readDispatch.hostEvent.kind == ResumePickerHostEventKind.PreviewLoaded)
			applyPreview(state, readDispatch.hostEvent);
		stateSummaries.push("preview:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "event-pump-preview");

		pump.enqueue(StreamEvent.disconnected(1, "event pump disconnected"));
		final disconnectDispatch = pump.dispatchNext(AsyncContext.fixture("disconnect"));
		dispatchSummaries.push(disconnectDispatch.summary);
		hostEvents.push(disconnectDispatch.hostEvent.summary());
		applyFailure(state, disconnectDispatch.hostEvent, "event_pump_disconnected");
		stateSummaries.push("disconnect:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "event-pump-disconnect");

		pump.attachSession(2, recoveryFanout);
		final recoveryAccepted = recoveryFanout.enqueuePage(pageRequest("pump-recovery-page", "", "pump", ResumePickerFilterMode.Cwd));
		stateSummaries.push("enqueued:recovery-page=" + outcomeSummary(recoveryAccepted));

		pump.enqueue(StreamEvent.pageResult(1, "pump-late-old-page", threadListResultJson("old")));
		final lateOldDispatch = pump.dispatchNext(AsyncContext.fixture("late-old"));
		dispatchSummaries.push(lateOldDispatch.summary);
		hostEvents.push(lateOldDispatch.hostEvent.summary());
		applyStaleIgnored(state, lateOldDispatch.hostEvent);
		stateSummaries.push("late-old:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "event-pump-late-old");

		pump.enqueue(StreamEvent.pageResult(2, "pump-recovery-page", threadListResultJson("recovery")));
		final recoveryDispatch = pump.dispatchNext(AsyncContext.fixture("recovery"));
		dispatchSummaries.push(recoveryDispatch.summary);
		hostEvents.push(recoveryDispatch.hostEvent.summary());
		if (recoveryDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, recoveryDispatch.hostEvent, "recovery");
		stateSummaries.push("recovery:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "event-pump-recovery");

		final pumpSummaries = pump.summaries();
		final fanoutSummaries = firstFanout.fanoutSummaries().concat(recoveryFanout.fanoutSummaries());
		final requestSummaries = firstFanout.requestSummaries().concat(recoveryFanout.requestSummaries());
		final transportSummaries = firstFanout.transportSummaries().concat(recoveryFanout.transportSummaries());

		return new AppServerEventPumpBoundaryReport({
			eventPumpModeled: eventPumpModeled(pumpSummaries, dispatchSummaries),
			eventConversionRouted: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& readDispatch.hostEvent.kind == ResumePickerHostEventKind.PreviewLoaded,
			staleGenerationFiltered: staleDispatch.kind == EventPumpDispatchKind.StaleIgnored
			&& lateOldDispatch.kind == EventPumpDispatchKind.StaleIgnored
			&& stateSummaries[7].indexOf("thread=thread-pump-a") >= 0,
			frameSchedulingRecorded: frameDispatch.hostEvent.kind == ResumePickerHostEventKind.FrameRequested
			&& scheduler.requestCount() == 8
			&& stateSummaries[1].indexOf("loader=event_pump_frame_requested") >= 0,
			disconnectPropagated: disconnectDispatch.hostEvent.failureCode == "app_server_stream_disconnected"
			&& firstFanout.pendingCount() == 0,
			recoveryDecoded: recoveryDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-recovery-a"
			&& !state.inlineErrorShown,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: firstSource.pageRequestCount() + recoverySource.pageRequestCount(),
			readRequests: firstSource.readRequestCount() + recoverySource.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			requestSummaries: requestSummaries,
			transportSummaries: transportSummaries,
			dispatchSummaries: dispatchSummaries,
			pumpSummaries: pumpSummaries,
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
		state.query = "pump";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "event pump open";
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
		state.loaderEventStatus = "event_pump_frame_requested";
		state.loaderEventDetail = "reason=" + event.detail;
		state.footerProgressLabel = "event pump frame";
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-19T23:30:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-19T23:31:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "event_pump_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "event pump page " + prefix;
	}

	static function applyPreview(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.expandedThreadId = event.threadId;
		state.previewState = "loaded";
		state.previewRendered = true;
		state.previewLineCount = 2;
		state.previewUserLineCount = 1;
		state.previewAssistantLineCount = 1;
		state.visibleRows = [
			visibleRow("thread-pump-a", title("pump", "A"), "2026-06-19T23:30:00Z", 2, true, ["user: event pump", "assistant: preview active"]),
			visibleRow("thread-pump-b", title("pump", "B"), "2026-06-19T23:31:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "event_pump_preview_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "event pump preview";
	}

	static function applyStaleIgnored(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = "event_pump_stale_ignored";
		state.loaderEventDetail = "request=" + event.requestId + ";thread=" + event.threadId + ";sourceCode=" + event.failureCode;
		state.footerProgressLabel = "stale app-server event ignored";
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
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-19T23:30:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-19T23:31:00Z", 1)
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
			+ ",\"sessionId\":\"session-pump-a\",\"forkedFromId\":null,\"parentThreadId\":null"
			+ ",\"preview\":"
			+ CodexJson.quote(preview)
			+ ",\"ephemeral\":false,\"modelProvider\":\"openai\",\"createdAt\":1781897400"
			+ ",\"updatedAt\":1781897460,\"status\":{\"type\":\"idle\"},\"path\":null,\"cwd\":\"/workspace/codex-hxrust\",\"cliVersion\":\"0.0.0-test\""
			+ ",\"source\":\"cli\",\"threadSource\":null,\"agentNickname\":null,\"agentRole\":null,\"gitInfo\":null,\"name\":\"Pump row\""
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

	static function eventPumpModeled(pump:Array<String>, dispatches:Array<String>):Bool {
		return contains(pump, "session:attach:generation=1")
			&& contains(pump, "session:attach:generation=2")
			&& contains(pump, "kind=page_result")
			&& contains(pump, "kind=read_result")
			&& contains(pump, "kind=frame_requested")
			&& contains(pump, "kind=disconnected")
			&& contains(dispatches, "dispatch:active")
			&& contains(dispatches, "dispatch:stale");
	}

	static function stateSummary(state:ResumePickerState):String {
		return "thread=" + state.selectedThreadId + ";previewState=" + state.previewState + ";previewLines=" + state.previewLineCount + ";errorShown="
			+ boolLabel(state.inlineErrorShown) + ";failure=" + emptyLabel(state.lastFailureCode) + ";footer=" + state.footerProgressLabel + ";loader="
			+ state.loaderEventStatus + ";detail=" + state.loaderEventDetail;
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return "ok=" + boolLabel(outcome.ok) + ";code=" + outcome.code + ";request=" + outcome.requestId + ";method=" + outcome.method + ";pending="
			+ outcome.pendingCount + ";message=" + outcome.message;
	}

	static function title(prefix:String, suffix:String):String {
		return "Event pump " + prefix + " row " + suffix;
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

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
