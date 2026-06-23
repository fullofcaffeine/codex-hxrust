package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
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

class ResumePickerQueryReloadGate {
	public static function run():ResumePickerQueryReloadReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final requestSummaries:Array<String> = [];
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;
		var queryReloads = 0;

		final initialRequest = pageRequest("initial-page", "", "");
		requestSummaries.push(initialRequest.summary());
		final initialPage = loadPage(loader, initialRequest);
		eventSummaries.push(initialPage.summary());
		if (initialPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyInitialPage(state);
		}
		scheduler.requestFrame("initial-page");
		renderer.render(state);

		queryReloads = queryReloads + 1;
		applyQueryReloadReset(state, "kernel");
		scheduler.requestFrame("query-reload-reset");
		renderer.render(state);

		final queryRequest = pageRequest("query-page", "", "kernel");
		requestSummaries.push(queryRequest.summary());
		final queryPage = loadPage(loader, queryRequest);
		eventSummaries.push(queryPage.summary());
		if (queryPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyQueryResultPage(state);
		}
		scheduler.requestFrame("query-page");
		renderer.render(state);

		return new ResumePickerQueryReloadReport({
			pageLoads: pageLoads,
			queryReloads: queryReloads,
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
		state.pageSize = 3;
		state.viewRows = 3;
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyInitialPage(state:ResumePickerState):Void {
		state.query = "";
		state.scannedRows = 3;
		state.acceptedRows = 3;
		state.invalidRows = 0;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-host";
		state.nextCursor = "cursor-before-query";
		state.nextCursorPresent = true;
		state.reachedScanCap = false;
		state.moreBelow = true;
		state.visibleRows = [
			visibleRow("thread-kernel", "Resume kernel", "2026-06-19T14:00:00Z", 3, false),
			visibleRow("thread-host", "Host facade", "2026-06-19T14:05:00Z", 5, true),
			visibleRow("thread-preview", "Preview renderer", "2026-06-19T14:10:00Z", 8, false)
		];
		state.emptyStateMessage = "";
		state.loaderEventStatus = "initial_page_loaded";
		state.loaderEventDetail = "query=<empty>;cursor=cursor-before-query";
		state.footerProgressLabel = "initial 3/3";
	}

	static function applyQueryReloadReset(state:ResumePickerState, query:String):Void {
		state.query = query;
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
		state.emptyStateMessage = "Searching saved chats...";
		state.loaderEventStatus = "query_reload_requested";
		state.loaderEventDetail = "query=kernel;cursor=<empty>;reset=true";
		state.footerProgressLabel = "loading query";
	}

	static function applyQueryResultPage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-kernel";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreBelow = false;
		state.loadingPending = false;
		state.visibleRows = [
			visibleRow("thread-kernel", "Resume kernel", "2026-06-19T14:00:00Z", 3, true),
			visibleRow("thread-kernel-tools", "Kernel tool calls", "2026-06-19T14:15:00Z", 13, false)
		];
		state.emptyStateMessage = "";
		state.loaderEventStatus = "query_results_loaded";
		state.loaderEventDetail = "query=kernel;rows=2;cursor=<empty>";
		state.footerProgressLabel = "query ready 2/2";
	}

	static function loadPage(loader:DeterministicBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String, cursor:String, query:String):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 3,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.Cwd,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: false,
			includeNonInteractive: false
		});
	}

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "initial-page",
			rows: [
				row("thread-kernel", "Resume kernel", "2026-06-19T14:00:00Z", 3),
				row("thread-host", "Host facade", "2026-06-19T14:05:00Z", 5),
				row("thread-preview", "Preview renderer", "2026-06-19T14:10:00Z", 8)
			],
			nextCursor: "cursor-before-query",
			scannedRows: 3,
			acceptedRows: 3,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "query-page",
			rows: [
				row("thread-kernel", "Resume kernel", "2026-06-19T14:00:00Z", 3),
				row("thread-kernel-tools", "Kernel tool calls", "2026-06-19T14:15:00Z", 13)
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
