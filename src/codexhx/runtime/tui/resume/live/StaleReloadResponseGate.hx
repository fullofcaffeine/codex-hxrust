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
import codexhx.runtime.tui.resume.host.DeterministicBackgroundLoader;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.InMemoryThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerBackgroundRequest;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class StaleReloadResponseGate {
	public static function run():StaleReloadResponseReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];
		var activePageLoads = 0;
		var stalePageRefusals = 0;

		final activeEvent = loadPage(loader,
			pageRequest("active-sort-filter-page", "", "kernel", ResumePickerSortKey.CreatedAt, ResumePickerFilterMode.All, true));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			activePageLoads = activePageLoads + 1;
			applyActivePage(state);
		}
		scheduler.requestFrame("active-page");
		renderer.render(state);
		final activeSnapshot = renderer.lastSnapshot();
		stateSummaries.push("active:" + stateSummary(state));

		final staleQueryEvent = loadPage(loader, pageRequest("stale-query-page", "", "host", ResumePickerSortKey.UpdatedAt, ResumePickerFilterMode.Cwd, false));
		eventSummaries.push(staleQueryEvent.summary());
		if (staleQueryEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			stalePageRefusals = stalePageRefusals + 1;
			applyStaleRefusal(state, "stale_query_response_ignored", staleQueryEvent.requestId);
		}
		stateSummaries.push("stale-query:" + stateSummary(state));
		scheduler.requestFrame("stale-query-refused");
		renderer.render(state);

		final staleSortEvent = loadPage(loader,
			pageRequest("stale-sort-page", "old-cursor", "kernel", ResumePickerSortKey.UpdatedAt, ResumePickerFilterMode.Cwd, false));
		eventSummaries.push(staleSortEvent.summary());
		if (staleSortEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			stalePageRefusals = stalePageRefusals + 1;
			applyStaleRefusal(state, "stale_sort_response_ignored", staleSortEvent.requestId);
		}
		stateSummaries.push("stale-sort:" + stateSummary(state));
		scheduler.requestFrame("stale-sort-refused");
		renderer.render(state);

		return new StaleReloadResponseReport({
			activePageLoads: activePageLoads,
			stalePageRefusals: stalePageRefusals,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			activeSnapshot: activeSnapshot,
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			stateSummaries: stateSummaries,
			eventSummaries: eventSummaries
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.pageSize = 3;
		state.viewRows = 3;
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyActivePage(state:ResumePickerState):Void {
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
		state.visibleRows = [
			visibleRow("thread-archived", "Archived kernel match", "/archive/codex-hxrust", "2026-06-18T15:00:00Z", 2, true),
			visibleRow("thread-kernel", "Resume kernel", "/workspace/codex-hxrust", "2026-06-19T15:00:00Z", 3, false),
			visibleRow("thread-remote", "Remote kernel result", "/remote/workspace", "2026-06-19T15:15:00Z", 13, false)
		];
		state.emptyStateMessage = "";
		state.loaderEventStatus = "active_results_loaded";
		state.loaderEventDetail = "request=active-sort-filter-page;sort=created_at;filter=all;query=kernel";
		state.footerProgressLabel = "active all results 3/4";
	}

	static function applyStaleRefusal(state:ResumePickerState, status:String, requestId:String):Void {
		state.loaderEventStatus = status;
		state.loaderEventDetail = "request=" + requestId + ";activeQuery=kernel;activeSort=created_at;activeFilter=all";
		state.footerProgressLabel = "stale response ignored";
	}

	static function stateSummary(state:ResumePickerState):String {
		return "query=" + state.query + ";sort=" + state.sortKey + ";filter=" + state.filterMode + ";selected=" + state.selectedIndex + ";thread="
			+ state.selectedThreadId + ";next=" + state.nextCursor + ";rows=" + state.loadedRows + ";footer=" + state.footerProgressLabel + ";loader="
			+ state.loaderEventStatus;
	}

	static function loadPage(loader:DeterministicBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
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

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "active-sort-filter-page",
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
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "stale-query-page",
			rows: [
				row("thread-host", "Stale host result", "/workspace/codex-hxrust", "2026-06-19T14:05:00Z", 5)
			],
			nextCursor: "stale-query-cursor",
			scannedRows: 1,
			acceptedRows: 1,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "stale-sort-page",
			rows: [
				row("thread-cwd", "Stale cwd result", "/workspace/codex-hxrust", "2026-06-19T15:05:00Z", 5),
				row("thread-local", "Stale local result", "/workspace/codex-hxrust", "2026-06-19T15:10:00Z", 8)
			],
			nextCursor: "stale-sort-cursor",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
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
}
