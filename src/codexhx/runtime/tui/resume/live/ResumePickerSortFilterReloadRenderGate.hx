package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerToolbarFocus;
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

class ResumePickerSortFilterReloadRenderGate {
	public static function run():ResumePickerSortFilterReloadRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final requestSummaries:Array<String> = [];
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;
		var sortFilterReloads = 0;

		final initialRequest = pageRequest("initial-query-page", "cursor-query", "kernel", ResumePickerSortKey.UpdatedAt, ResumePickerFilterMode.Cwd, false);
		requestSummaries.push(requestFacts(initialRequest));
		final initialPage = loadPage(loader, initialRequest);
		eventSummaries.push(initialPage.summary());
		if (initialPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyInitialQueriedPage(state);
		}
		scheduler.requestFrame("initial-query-page");
		renderer.render(state);

		sortFilterReloads = sortFilterReloads + 1;
		applySortFilterReloadReset(state);
		scheduler.requestFrame("sort-filter-reload-reset");
		renderer.render(state);

		final reloadedRequest = pageRequest("sort-filter-page", "", "kernel", ResumePickerSortKey.CreatedAt, ResumePickerFilterMode.All, true);
		requestSummaries.push(requestFacts(reloadedRequest));
		final reloadedPage = loadPage(loader, reloadedRequest);
		eventSummaries.push(reloadedPage.summary());
		if (reloadedPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyReloadedPage(state);
		}
		scheduler.requestFrame("sort-filter-page");
		renderer.render(state);

		return new ResumePickerSortFilterReloadRenderGateReport({
			pageLoads: pageLoads,
			sortFilterReloads: sortFilterReloads,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			requestSummaries: requestSummaries,
			eventSummaries: eventSummaries
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarFocus = ResumePickerToolbarFocus.Sort;
		state.toolbarRenderMode = "expanded";
		state.pageSize = 3;
		state.viewRows = 3;
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyInitialQueriedPage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarFocus = ResumePickerToolbarFocus.Sort;
		state.toolbarRenderMode = "expanded";
		state.scannedRows = 3;
		state.acceptedRows = 3;
		state.invalidRows = 0;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-cwd";
		state.nextCursor = "cursor-query-next";
		state.nextCursorPresent = true;
		state.reachedScanCap = false;
		state.moreBelow = true;
		state.visibleRows = [
			visibleRow("thread-kernel", "Resume kernel", "/workspace/codex-hxrust", "2026-06-19T15:00:00Z", 3, false),
			visibleRow("thread-cwd", "Kernel cwd result", "/workspace/codex-hxrust", "2026-06-19T15:05:00Z", 5, true),
			visibleRow("thread-local", "Local kernel tools", "/workspace/codex-hxrust", "2026-06-19T15:10:00Z", 8, false)
		];
		state.emptyStateMessage = "";
		state.loaderEventStatus = "query_page_loaded";
		state.loaderEventDetail = "sort=updated_at;filter=cwd;query=kernel;showAll=false";
		state.footerProgressLabel = "cwd query 3/3";
	}

	static function applySortFilterReloadReset(state:ResumePickerState):Void {
		state.query = "kernel";
		state.sortKey = ResumePickerSortKey.CreatedAt;
		state.filterMode = ResumePickerFilterMode.All;
		state.toolbarFocus = ResumePickerToolbarFocus.Filter;
		state.toolbarRenderMode = "expanded";
		state.scannedRows = 0;
		state.acceptedRows = 0;
		state.invalidRows = 0;
		state.loadedRows = 0;
		state.filteredRows = 0;
		state.selectedIndex = 0;
		state.selectedThreadId = "";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreBelow = false;
		state.loadingOlderShown = false;
		state.loadingPending = true;
		state.visibleRows = [];
		state.emptyStateMessage = "Reloading saved chats...";
		state.loaderEventStatus = "sort_filter_reload_requested";
		state.loaderEventDetail = "sort=created_at;filter=all;query=kernel;showAll=true;cursor=<empty>";
		state.footerProgressLabel = "reloading sort/filter";
	}

	static function applyReloadedPage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.sortKey = ResumePickerSortKey.CreatedAt;
		state.filterMode = ResumePickerFilterMode.All;
		state.toolbarFocus = ResumePickerToolbarFocus.Filter;
		state.toolbarRenderMode = "compact";
		state.scannedRows = 4;
		state.acceptedRows = 3;
		state.invalidRows = 1;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-archived";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreBelow = false;
		state.loadingPending = false;
		state.visibleRows = [
			visibleRow("thread-archived", "Archived kernel match", "/archive/codex-hxrust", "2026-06-18T15:00:00Z", 2, true),
			visibleRow("thread-kernel", "Resume kernel", "/workspace/codex-hxrust", "2026-06-19T15:00:00Z", 3, false),
			visibleRow("thread-remote", "Remote kernel result", "/remote/workspace", "2026-06-19T15:15:00Z", 13, false)
		];
		state.emptyStateMessage = "";
		state.loaderEventStatus = "sort_filter_results_loaded";
		state.loaderEventDetail = "sort=created_at;filter=all;query=kernel;rows=3;invalid=1";
		state.footerProgressLabel = "all results 3/4";
	}

	static function loadPage(loader:DeterministicResumePickerBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String, cursor:String, query:String, sortKey:ResumePickerSortKey, filterMode:ResumePickerFilterMode,
			showAll:Bool):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 3,
			sortKey: sortKey,
			filterMode: filterMode,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: showAll,
			includeNonInteractive: false
		});
	}

	static function requestFacts(request:ResumePickerThreadListRequest):String {
		return request.summary() + ";cwd=" + request.cwdFilter + ";showAll=" + boolLabel(request.showAll) + ";includeNonInteractive="
			+ boolLabel(request.includeNonInteractive);
	}

	static function fixtureSource():InMemoryResumePickerThreadSource {
		final source = new InMemoryResumePickerThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "initial-query-page",
			rows: [
				row("thread-kernel", "Resume kernel", "/workspace/codex-hxrust", "2026-06-19T15:00:00Z", 3),
				row("thread-cwd", "Kernel cwd result", "/workspace/codex-hxrust", "2026-06-19T15:05:00Z", 5),
				row("thread-local", "Local kernel tools", "/workspace/codex-hxrust", "2026-06-19T15:10:00Z", 8)
			],
			nextCursor: "cursor-query-next",
			scannedRows: 3,
			acceptedRows: 3,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "sort-filter-page",
			rows: [
				row("thread-archived", "Archived kernel match", "/archive/codex-hxrust", "2026-06-18T15:00:00Z", 2),
				row("thread-kernel", "Resume kernel", "/workspace/codex-hxrust", "2026-06-19T15:00:00Z", 3),
				row("thread-remote", "Remote kernel result", "/remote/workspace", "2026-06-19T15:15:00Z", 13)
			],
			nextCursor: "",
			scannedRows: 4,
			acceptedRows: 3,
			invalidRows: 1,
			reachedScanCap: false
		}));
		return source;
	}

	static function row(threadId:String, title:String, cwd:String, updatedAt:String, turnCount:Int):ResumePickerThreadRow {
		return new ResumePickerThreadRow({
			threadId: threadId,
			title: title,
			cwd: cwd,
			updatedAt: updatedAt,
			archived: false,
			turnCount: turnCount
		});
	}

	static function visibleRow(threadId:String, title:String, cwd:String, updatedAt:String, turnCount:Int, selected:Bool):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: title,
			cwd: cwd,
			updatedAt: updatedAt,
			turnCount: turnCount,
			selected: selected,
			previewLines: []
		});
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

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
