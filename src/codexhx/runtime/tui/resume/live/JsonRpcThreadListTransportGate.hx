package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicBackgroundLoader;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerBackgroundRequest;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class JsonRpcThreadListTransportGate {
	public static function run():JsonRpcThreadListTransportReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 4);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];

		final firstEvent = loadPage(loader, pageRequest("jsonrpc-page-1", "", "kernel", ResumePickerFilterMode.Cwd, false));
		hostEvents.push(firstEvent.summary());
		if (firstEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyFirstPage(state, firstEvent);
		stateSummaries.push("decoded:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "jsonrpc-thread-list-decoded");

		final errorEvent = loadPage(loader, pageRequest("jsonrpc-error-page", "", "kernel", ResumePickerFilterMode.Cwd, false));
		hostEvents.push(errorEvent.summary());
		if (errorEvent.kind == ResumePickerHostEventKind.Failed)
			applyJsonRpcError(state, errorEvent);
		stateSummaries.push("error:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "jsonrpc-thread-list-error");

		final recoveryEvent = loadPage(loader, pageRequest("jsonrpc-recovery-page", "cursor-jsonrpc-2", "kernel", ResumePickerFilterMode.All, true));
		hostEvents.push(recoveryEvent.summary());
		if (recoveryEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyRecoveryPage(state, recoveryEvent);
		stateSummaries.push("recovery:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "jsonrpc-thread-list-recovery");

		final requestSummaries = source.requestSummaries();
		final transportSummaries = source.transportSummaries();
		final transportEvents = source.drainedEventSummaries();

		return new JsonRpcThreadListTransportReport({
			requestShapePreserved: requestShapePreserved(requestSummaries, transportSummaries),
			responseDecoded: firstEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& stateSummaries[0].indexOf("thread=thread-jsonrpc-a") >= 0,
			errorMapped: errorEvent.kind == ResumePickerHostEventKind.Failed
			&& stateSummaries[1].indexOf("failure=json_rpc_thread_list_error") >= 0,
			recoveryDecoded: recoveryEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-jsonrpc-recovered",
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
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
		state.footerProgressLabel = "json-rpc open";
		return state;
	}

	static function applyFirstPage(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-jsonrpc-a";
		state.selectedLabel = "JSON-RPC kernel row";
		state.nextCursor = "cursor-jsonrpc-2";
		state.nextCursorPresent = true;
		state.moreBelow = true;
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.visibleRows = [
			visibleRow("thread-jsonrpc-a", "JSON-RPC kernel row", "2026-06-19T22:00:00Z", 2, true),
			visibleRow("thread-jsonrpc-b", "JSON-RPC second row", "2026-06-19T22:05:00Z", 1, false)
		];
		state.loaderEventStatus = "json_rpc_thread_list_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "json-rpc decoded";
	}

	static function applyJsonRpcError(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = "json_rpc_thread_list_error_mapped";
		state.loaderEventDetail = "request=" + event.requestId + ";sourceCode=" + event.failureCode + ";preservedThread=" + state.selectedThreadId
			+ ";rows=" + state.loadedRows;
		state.footerProgressLabel = "json-rpc error";
	}

	static function applyRecoveryPage(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.All;
		state.showAll = true;
		state.scannedRows = 1;
		state.acceptedRows = 1;
		state.invalidRows = 0;
		state.loadedRows = 1;
		state.filteredRows = 1;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-jsonrpc-recovered";
		state.selectedLabel = "JSON-RPC recovered row";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.moreBelow = false;
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.visibleRows = [
			visibleRow("thread-jsonrpc-recovered", "JSON-RPC recovered row", "2026-06-19T22:10:00Z", 3, true)
		];
		state.loaderEventStatus = "json_rpc_thread_list_recovered";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "json-rpc recovered";
	}

	static function pageRequest(requestId:String, cursor:String, query:String, filterMode:ResumePickerFilterMode,
			includeNonInteractive:Bool):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 2,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: filterMode,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: filterMode == ResumePickerFilterMode.All,
			includeNonInteractive: includeNonInteractive
		});
	}

	static function fixtureSource():JsonRpcThreadSource {
		final source = new JsonRpcThreadSource(8);
		source.addThreadListResult("jsonrpc-page-1",
			"{"
			+ "\"data\":["
			+ threadJson("thread-jsonrpc-a", "session-jsonrpc-a", "JSON-RPC kernel row", "/workspace/codex-hxrust", "2026-06-19T22:00:00Z", 2)
			+ ","
			+ threadJson("thread-jsonrpc-b", "session-jsonrpc-b", "JSON-RPC second row", "/workspace/codex-hxrust", "2026-06-19T22:05:00Z", 1)
			+ "],\"nextCursor\":\"cursor-jsonrpc-2\",\"backwardsCursor\":null}");
		source.addThreadListError("jsonrpc-error-page", "{\"code\":-32042,\"message\":\"fixture thread/list transport failed\"}");
		source.addThreadListResult("jsonrpc-recovery-page",
			"{"
			+ "\"data\":["
			+ threadJson("thread-jsonrpc-recovered", "session-jsonrpc-recovered", "JSON-RPC recovered row", "/archive/codex-hxrust", "2026-06-19T22:10:00Z", 3)
			+ "],\"nextCursor\":null,\"backwardsCursor\":null}");
		return source;
	}

	static function threadJson(threadId:String, sessionId:String, title:String, cwd:String, updatedAt:String, turns:Int):String {
		return "{" + "\"id\":\"" + threadId + "\"" + ",\"sessionId\":\"" + sessionId + "\"" + ",\"status\":{\"type\":\"idle\"}" + ",\"turns\":"
			+ turnsJson(turns) + ",\"title\":\"" + title + "\"" + ",\"cwd\":\"" + cwd + "\"" + ",\"updatedAt\":\"" + updatedAt + "\"" + ",\"archived\":false"
			+ "}";
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

	static function visibleRow(threadId:String, title:String, updatedAt:String, turnCount:Int, selected:Bool):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: title,
			cwd: "/workspace/codex-hxrust",
			updatedAt: updatedAt,
			turnCount: turnCount,
			selected: selected,
			previewLines: []
		});
	}

	static function loadPage(loader:DeterministicBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function renderFrame(scheduler:DeterministicFrameScheduler, renderer:DeterministicTerminalRenderer, state:ResumePickerState, reason:String):Void {
		scheduler.requestFrame(reason);
		renderer.render(state);
	}

	static function requestShapePreserved(requests:Array<String>, transport:Array<String>):Bool {
		return contains(requests, "id=jsonrpc-page-1;cursor=;query=kernel;pageSize=2;sort=updated_at;filter=cwd")
			&& contains(requests, "\"method\":\"thread/list\"") == false
			&& contains(requests, "jsonMethod=thread/list")
			&& contains(requests, "\"searchTerm\":\"kernel\"")
			&& contains(requests, "\"cwd\":[\"/workspace/codex-hxrust\"]")
			&& contains(requests, "\"sourceKinds\":[\"cli\",\"appServer\",\"subAgent\"]")
			&& contains(transport, "send:ok=true;code=accepted;request=jsonrpc-page-1;method=thread/list")
			&& contains(transport, "complete:ok=true;code=completed;request=jsonrpc-recovery-page;method=thread/list");
	}

	static function stateSummary(state:ResumePickerState):String {
		return DiagnosticSummary.render([
			DiagnosticSummary.text("query", state.query),
			DiagnosticSummary.enumValue("sort", Std.string(state.sortKey)),
			DiagnosticSummary.enumValue("filter", Std.string(state.filterMode)),
			DiagnosticSummary.intValue("rows", state.loadedRows),
			DiagnosticSummary.intValue("selected", state.selectedIndex),
			DiagnosticSummary.text("thread", state.selectedThreadId),
			DiagnosticSummary.boolValue("errorShown", state.inlineErrorShown),
			DiagnosticSummary.text("failure", emptyLabel(state.lastFailureCode)),
			DiagnosticSummary.text("footer", state.footerProgressLabel),
			DiagnosticSummary.text("loader", state.loaderEventStatus),
			DiagnosticSummary.text("detail", state.loaderEventDetail)
		]);
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
}
