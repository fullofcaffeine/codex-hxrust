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

class SelectionPreservationGate {
	public static function run():SelectionPreservationReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];
		var pageLoads = 0;
		var preservedSelections = 0;
		var fallbackSelections = 0;

		final activeEvent = loadPage(loader, pageRequest("active-selection-page"));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyActiveSelectionPage(state);
		}
		stateSummaries.push("active:" + stateSummary(state));
		scheduler.requestFrame("active-selection-page");
		renderer.render(state);

		final preservedEvent = loadPage(loader, pageRequest("preserve-selection-page"));
		eventSummaries.push(preservedEvent.summary());
		if (preservedEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			preservedSelections = preservedSelections + 1;
			applyPreservedSelectionPage(state);
		}
		stateSummaries.push("preserved:" + stateSummary(state));
		scheduler.requestFrame("preserve-selection-page");
		renderer.render(state);

		final fallbackEvent = loadPage(loader, pageRequest("fallback-selection-page"));
		eventSummaries.push(fallbackEvent.summary());
		if (fallbackEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			fallbackSelections = fallbackSelections + 1;
			applyFallbackSelectionPage(state);
		}
		stateSummaries.push("fallback:" + stateSummary(state));
		scheduler.requestFrame("fallback-selection-page");
		renderer.render(state);

		return new SelectionPreservationReport({
			pageLoads: pageLoads,
			preservedSelections: preservedSelections,
			fallbackSelections: fallbackSelections,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
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
		state.sortKey = ResumePickerSortKey.CreatedAt;
		state.filterMode = ResumePickerFilterMode.All;
		state.toolbarFocus = ResumePickerToolbarFocus.Filter;
		state.toolbarRenderMode = "compact";
		state.pageSize = 3;
		state.viewRows = 3;
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyActiveSelectionPage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.scannedRows = 3;
		state.acceptedRows = 3;
		state.invalidRows = 0;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-stable";
		state.visibleRows = [
			visibleRow("thread-first", "First kernel match", "2026-06-19T16:00:00Z", 2, false),
			visibleRow("thread-stable", "Stable selected kernel", "2026-06-19T16:05:00Z", 5, true),
			visibleRow("thread-tail", "Tail kernel match", "2026-06-19T16:10:00Z", 8, false)
		];
		applyLoadedCommon(state, "active_selection_loaded", "selected=thread-stable;index=1", "selected stable row");
	}

	static function applyPreservedSelectionPage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.scannedRows = 4;
		state.acceptedRows = 3;
		state.invalidRows = 1;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 2;
		state.selectedThreadId = "thread-stable";
		state.visibleRows = [
			visibleRow("thread-newer", "Newer kernel match", "2026-06-19T16:15:00Z", 3, false),
			visibleRow("thread-first", "First kernel match", "2026-06-19T16:00:00Z", 2, false),
			visibleRow("thread-stable", "Stable selected kernel", "2026-06-19T16:05:00Z", 5, true)
		];
		applyLoadedCommon(state, "selection_preserved_by_thread", "selected=thread-stable;index=2;previousIndex=1", "selection preserved");
	}

	static function applyFallbackSelectionPage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-fallback";
		state.visibleRows = [
			visibleRow("thread-fallback", "Fallback kernel match", "2026-06-19T16:20:00Z", 13, true),
			visibleRow("thread-tail", "Tail kernel match", "2026-06-19T16:10:00Z", 8, false)
		];
		applyLoadedCommon(state, "selection_fallback_first_row", "missing=thread-stable;selected=thread-fallback;index=0", "selection fallback");
	}

	static function applyLoadedCommon(state:ResumePickerState, status:String, detail:String, footer:String):Void {
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreBelow = false;
		state.loadingPending = false;
		state.emptyStateMessage = "";
		state.loaderEventStatus = status;
		state.loaderEventDetail = detail;
		state.footerProgressLabel = footer;
	}

	static function stateSummary(state:ResumePickerState):String {
		return "query=" + state.query + ";rows=" + state.loadedRows + ";selected=" + state.selectedIndex + ";thread=" + state.selectedThreadId + ";footer="
			+ state.footerProgressLabel + ";loader=" + state.loaderEventStatus + ";detail=" + state.loaderEventDetail;
	}

	static function loadPage(loader:DeterministicBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: "",
			query: "kernel",
			pageSize: 3,
			sortKey: ResumePickerSortKey.CreatedAt,
			filterMode: ResumePickerFilterMode.All,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: true,
			includeNonInteractive: false
		});
	}

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "active-selection-page",
			rows: [
				row("thread-first", "First kernel match", "2026-06-19T16:00:00Z", 2),
				row("thread-stable", "Stable selected kernel", "2026-06-19T16:05:00Z", 5),
				row("thread-tail", "Tail kernel match", "2026-06-19T16:10:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 3,
			acceptedRows: 3,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "preserve-selection-page",
			rows: [
				row("thread-newer", "Newer kernel match", "2026-06-19T16:15:00Z", 3),
				row("thread-first", "First kernel match", "2026-06-19T16:00:00Z", 2),
				row("thread-stable", "Stable selected kernel", "2026-06-19T16:05:00Z", 5)
			],
			nextCursor: "",
			scannedRows: 4,
			acceptedRows: 3,
			invalidRows: 1,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "fallback-selection-page",
			rows: [
				row("thread-fallback", "Fallback kernel match", "2026-06-19T16:20:00Z", 13),
				row("thread-tail", "Tail kernel match", "2026-06-19T16:10:00Z", 8)
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
