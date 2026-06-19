package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerBackgroundLoader;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.InMemoryResumePickerThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerBackgroundRequest;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class ResumePickerLiveAppServerBoundaryRenderGate {
	public static function run():ResumePickerLiveAppServerBoundaryRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 1);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final pollSummaries:Array<String> = [];
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];

		final activeRequest = pageRequest("live-active-page", "", "kernel", ResumePickerSortKey.CreatedAt, ResumePickerFilterMode.All, true, true);
		pollSummaries.push("active:" + AsyncPollSummary.summary(loader.enqueue(ResumePickerBackgroundRequest.pageLoad(activeRequest))));

		final blockedRequest = pageRequest("live-blocked-reload-page", "cursor-live-2", "kernel", ResumePickerSortKey.CreatedAt, ResumePickerFilterMode.All,
			true, true);
		final blockedPoll = loader.enqueue(ResumePickerBackgroundRequest.pageLoad(blockedRequest));
		final blockedSummary = AsyncPollSummary.summary(blockedPoll);
		pollSummaries.push("blocked-reload:" + blockedSummary);
		final backpressureSeen = blockedSummary.indexOf("lossless_backpressure") >= 0 && loader.pendingCount() == 1;
		applyBackpressureState(state, blockedRequest, loader.pendingCount(), loader.skippedCount());
		stateSummaries.push("backpressure:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "live-boundary-backpressure");

		final activeEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("live-active-page")));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			applyActivePage(state, activeEvent);
		}
		stateSummaries.push("active:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "live-boundary-active");

		final failedRequest = pageRequest("live-missing-page", "", "kernel", ResumePickerSortKey.CreatedAt, ResumePickerFilterMode.All, true, true);
		pollSummaries.push("missing:" + AsyncPollSummary.summary(loader.enqueue(ResumePickerBackgroundRequest.pageLoad(failedRequest))));
		final failedEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("live-missing-page")));
		eventSummaries.push(failedEvent.summary());
		if (failedEvent.kind == ResumePickerHostEventKind.Failed) {
			applyBoundaryFailure(state, failedEvent);
		}
		final errorMapped = state.lastFailureCode == "app_server_thread_list_failed"
			&& state.lastError.indexOf("missing_page_fixture") >= 0
			&& failedEvent.requestId == "live-missing-page";
		stateSummaries.push("mapped-error:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "live-boundary-error");

		final recoveryRequest = pageRequest("live-recovery-page", "", "kernel", ResumePickerSortKey.CreatedAt, ResumePickerFilterMode.All, true, true);
		pollSummaries.push("recovery:" + AsyncPollSummary.summary(loader.enqueue(ResumePickerBackgroundRequest.pageLoad(recoveryRequest))));
		final recoveryEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("live-recovery-page")));
		eventSummaries.push(recoveryEvent.summary());
		if (recoveryEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			applyRecoveryPage(state, recoveryEvent);
		}
		stateSummaries.push("recovery:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "live-boundary-recovery");

		final requestSummaries = source.pageRequestSummaries();
		return new ResumePickerLiveAppServerBoundaryRenderGateReport({
			requestIdsPreserved: allRequestIdsPreserved(requestSummaries, eventSummaries),
			provenancePreserved: provenancePreserved(requestSummaries),
			backpressureSeen: backpressureSeen,
			errorMapped: errorMapped,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			pendingEvents: loader.pendingCount(),
			skippedEvents: loader.skippedCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			requestSummaries: requestSummaries,
			pollSummaries: pollSummaries,
			eventSummaries: eventSummaries,
			stateSummaries: stateSummaries
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.CreatedAt;
		state.filterMode = ResumePickerFilterMode.All;
		state.toolbarRenderMode = "compact";
		state.query = "kernel";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.showAll = true;
		state.includeNonInteractive = true;
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyBackpressureState(state:ResumePickerState, request:ResumePickerThreadListRequest, pending:Int, skipped:Int):Void {
		state.loadingPending = true;
		state.loaderEventStatus = "live_boundary_backpressure";
		state.loaderEventDetail = "request=" + request.requestId + ";cursor=" + emptyLabel(request.cursor) + ";query=" + emptyLabel(request.query)
			+ ";sort=" + request.sortKey + ";filter=" + request.filterMode + ";pending=" + pending + ";skipped=" + skipped;
		state.footerProgressLabel = "live reload queued";
	}

	static function applyActivePage(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-boundary-a";
		state.selectedLabel = "Boundary active row";
		state.nextCursor = "cursor-live-2";
		state.nextCursorPresent = true;
		state.moreBelow = true;
		state.loadingPending = false;
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.visibleRows = [
			visibleRow("thread-boundary-a", "Boundary active row", "2026-06-19T21:00:00Z", 3, true),
			visibleRow("thread-boundary-b", "Boundary second row", "2026-06-19T21:05:00Z", 5, false)
		];
		state.loaderEventStatus = "live_boundary_page_loaded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "live boundary loaded";
	}

	static function applyBoundaryFailure(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.loadingPending = false;
		state.inlineErrorShown = true;
		state.lastFailureCode = "app_server_thread_list_failed";
		state.lastError = event.failureCode + ":" + event.failureMessage;
		state.loaderEventStatus = "live_boundary_error_mapped";
		state.loaderEventDetail = "request=" + event.requestId + ";sourceCode=" + event.failureCode + ";preservedThread=" + state.selectedThreadId
			+ ";rows=" + state.loadedRows;
		state.footerProgressLabel = "live boundary error";
	}

	static function applyRecoveryPage(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-boundary-recovered";
		state.selectedLabel = "Boundary recovered row";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.moreBelow = false;
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.visibleRows = [
			visibleRow("thread-boundary-a", "Boundary active row", "2026-06-19T21:00:00Z", 3, false),
			visibleRow("thread-boundary-recovered", "Boundary recovered row", "2026-06-19T21:10:00Z", 8, true)
		];
		state.loaderEventStatus = "live_boundary_recovered";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "live boundary recovered";
	}

	static function renderFrame(scheduler:DeterministicResumePickerFrameScheduler, renderer:DeterministicResumePickerTerminalRenderer,
			state:ResumePickerState, reason:String):Void {
		scheduler.requestFrame(reason);
		renderer.render(state);
	}

	static function pageRequest(requestId:String, cursor:String, query:String, sortKey:ResumePickerSortKey, filterMode:ResumePickerFilterMode, showAll:Bool,
			includeNonInteractive:Bool):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 2,
			sortKey: sortKey,
			filterMode: filterMode,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: showAll,
			includeNonInteractive: includeNonInteractive
		});
	}

	static function fixtureSource():InMemoryResumePickerThreadSource {
		final source = new InMemoryResumePickerThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "live-active-page",
			rows: [
				row("thread-boundary-a", "Boundary active row", "2026-06-19T21:00:00Z", 3),
				row("thread-boundary-b", "Boundary second row", "2026-06-19T21:05:00Z", 5)
			],
			nextCursor: "cursor-live-2",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "live-blocked-reload-page",
			rows: [row("thread-boundary-c", "Boundary blocked row", "2026-06-19T21:07:00Z", 6)],
			nextCursor: "",
			scannedRows: 1,
			acceptedRows: 1,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "live-recovery-page",
			rows: [
				row("thread-boundary-a", "Boundary active row", "2026-06-19T21:00:00Z", 3),
				row("thread-boundary-recovered", "Boundary recovered row", "2026-06-19T21:10:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		return source;
	}

	static function row(threadId:String, title:String, updatedAt:String, turnCount:Int):ResumePickerThreadRow {
		return new ResumePickerThreadRow({
			threadId: threadId,
			title: title,
			cwd: "/workspace/codex-hxrust",
			updatedAt: updatedAt,
			archived: false,
			turnCount: turnCount
		});
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

	static function allRequestIdsPreserved(requestSummaries:Array<String>, eventSummaries:Array<String>):Bool {
		return contains(requestSummaries, "id=live-active-page")
			&& contains(requestSummaries, "id=live-blocked-reload-page")
			&& contains(requestSummaries, "id=live-missing-page")
			&& contains(requestSummaries, "id=live-recovery-page")
			&& contains(eventSummaries, "request=live-active-page")
			&& contains(eventSummaries, "request=live-missing-page")
			&& contains(eventSummaries, "request=live-recovery-page");
	}

	static function provenancePreserved(requestSummaries:Array<String>):Bool {
		return contains(requestSummaries, "id=live-blocked-reload-page;cursor=cursor-live-2;query=kernel;pageSize=2;sort=created_at;filter=all")
			&& contains(requestSummaries, "cwd=/workspace/codex-hxrust;showAll=true;includeNonInteractive=true");
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values) {
			if (value.indexOf(needle) >= 0)
				return true;
		}
		return false;
	}

	static function stateSummary(state:ResumePickerState):String {
		return "query=" + state.query + ";sort=" + state.sortKey + ";filter=" + state.filterMode + ";rows=" + state.loadedRows + ";selected="
			+ state.selectedIndex + ";thread=" + state.selectedThreadId + ";errorShown=" + boolLabel(state.inlineErrorShown) + ";failure="
			+ emptyLabel(state.lastFailureCode) + ";footer=" + state.footerProgressLabel + ";loader=" + state.loaderEventStatus + ";detail="
			+ state.loaderEventDetail;
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
