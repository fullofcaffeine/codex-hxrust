package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.diagnostics.DiagnosticSummary;
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

class ScrollPreservationGate {
	public static function run():ScrollPreservationReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];
		var pageLoads = 0;
		var preservedScrolls = 0;
		var clampedScrolls = 0;

		final activeEvent = loadPage(loader, pageRequest("active-scrolled-page", 6));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyActiveScrolledPage(state);
		}
		stateSummaries.push("active:" + stateSummary(state));
		scheduler.requestFrame("active-scrolled-page");
		renderer.render(state);

		final preservedEvent = loadPage(loader, pageRequest("preserve-scroll-page", 6));
		eventSummaries.push(preservedEvent.summary());
		if (preservedEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			preservedScrolls = preservedScrolls + 1;
			applyPreservedScrollPage(state);
		}
		stateSummaries.push("preserved:" + stateSummary(state));
		scheduler.requestFrame("preserve-scroll-page");
		renderer.render(state);

		final clampedEvent = loadPage(loader, pageRequest("clamp-scroll-page", 3));
		eventSummaries.push(clampedEvent.summary());
		if (clampedEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			clampedScrolls = clampedScrolls + 1;
			applyClampedScrollPage(state);
		}
		stateSummaries.push("clamped:" + stateSummary(state));
		scheduler.requestFrame("clamp-scroll-page");
		renderer.render(state);

		return new ScrollPreservationReport({
			pageLoads: pageLoads,
			preservedScrolls: preservedScrolls,
			clampedScrolls: clampedScrolls,
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
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.All;
		state.toolbarFocus = ResumePickerToolbarFocus.Filter;
		state.toolbarRenderMode = "compact";
		state.pageSize = 6;
		state.viewRows = 3;
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyActiveScrolledPage(state:ResumePickerState):Void {
		state.query = "scroll";
		state.scannedRows = 6;
		state.acceptedRows = 6;
		state.invalidRows = 0;
		state.loadedRows = 6;
		state.filteredRows = 6;
		state.selectedIndex = 4;
		state.selectedThreadId = "thread-anchor";
		state.scrollTop = 2;
		state.visibleRows = [
			rowView("thread-visible-2", "Visible scroll row two", "2026-06-19T17:02:00Z", 2, false),
			rowView("thread-visible-3", "Visible scroll row three", "2026-06-19T17:03:00Z", 3, false),
			rowView("thread-anchor", "Anchor scroll row", "2026-06-19T17:04:00Z", 5, true)
		];
		applyLoadedCommon(state, "active_scrolled_loaded", "selected=thread-anchor;index=4;scrollTop=2", "scrolled active", true, false);
	}

	static function applyPreservedScrollPage(state:ResumePickerState):Void {
		state.query = "scroll";
		state.scannedRows = 7;
		state.acceptedRows = 6;
		state.invalidRows = 1;
		state.loadedRows = 6;
		state.filteredRows = 6;
		state.selectedIndex = 4;
		state.selectedThreadId = "thread-anchor";
		state.scrollTop = 2;
		state.visibleRows = [
			rowView("thread-visible-2b", "Reloaded scroll row two", "2026-06-19T17:12:00Z", 8, false),
			rowView("thread-visible-3b", "Reloaded scroll row three", "2026-06-19T17:13:00Z", 13, false),
			rowView("thread-anchor", "Anchor scroll row", "2026-06-19T17:04:00Z", 5, true)
		];
		applyLoadedCommon(state, "scroll_preserved_by_window", "selected=thread-anchor;index=4;scrollTop=2;previousScrollTop=2", "scroll preserved", true,
			false);
	}

	static function applyClampedScrollPage(state:ResumePickerState):Void {
		state.query = "scroll";
		state.scannedRows = 3;
		state.acceptedRows = 3;
		state.invalidRows = 0;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 2;
		state.selectedThreadId = "thread-anchor";
		state.scrollTop = 0;
		state.visibleRows = [
			rowView("thread-compact-0", "Compact scroll row zero", "2026-06-19T17:20:00Z", 21, false),
			rowView("thread-compact-1", "Compact scroll row one", "2026-06-19T17:21:00Z", 34, false),
			rowView("thread-anchor", "Anchor scroll row", "2026-06-19T17:04:00Z", 5, true)
		];
		applyLoadedCommon(state, "scroll_clamped_after_shrink", "selected=thread-anchor;index=2;scrollTop=0;previousScrollTop=2;maxScrollTop=0",
			"scroll clamped", false, false);
	}

	static function applyLoadedCommon(state:ResumePickerState, status:String, detail:String, footer:String, moreAbove:Bool, moreBelow:Bool):Void {
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreAbove = moreAbove;
		state.moreBelow = moreBelow;
		state.loadingOlderShown = false;
		state.pendingPageDownCompleted = false;
		state.loadingPending = false;
		state.emptyStateMessage = "";
		state.loaderEventStatus = status;
		state.loaderEventDetail = detail;
		state.footerProgressLabel = footer;
	}

	static function stateSummary(state:ResumePickerState):String {
		return DiagnosticSummary.render([
			DiagnosticSummary.text("query", state.query),
			DiagnosticSummary.intValue("rows", state.loadedRows),
			DiagnosticSummary.intValue("selected", state.selectedIndex),
			DiagnosticSummary.text("thread", state.selectedThreadId),
			DiagnosticSummary.intValue("scrollTop", state.scrollTop),
			DiagnosticSummary.intValue("viewRows", state.viewRows),
			DiagnosticSummary.boolValue("moreAbove", state.moreAbove),
			DiagnosticSummary.boolValue("moreBelow", state.moreBelow),
			DiagnosticSummary.text("footer", state.footerProgressLabel),
			DiagnosticSummary.text("loader", state.loaderEventStatus),
			DiagnosticSummary.text("detail", state.loaderEventDetail)
		]);
	}

	static function loadPage(loader:DeterministicBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String, pageSize:Int):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: "",
			query: "scroll",
			pageSize: pageSize,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.All,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: true,
			includeNonInteractive: false
		});
	}

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "active-scrolled-page",
			rows: [
				row("thread-hidden-0", "Hidden scroll row zero", "2026-06-19T17:00:00Z", 1),
				row("thread-hidden-1", "Hidden scroll row one", "2026-06-19T17:01:00Z", 1),
				row("thread-visible-2", "Visible scroll row two", "2026-06-19T17:02:00Z", 2),
				row("thread-visible-3", "Visible scroll row three", "2026-06-19T17:03:00Z", 3),
				row("thread-anchor", "Anchor scroll row", "2026-06-19T17:04:00Z", 5),
				row("thread-hidden-5", "Hidden scroll row five", "2026-06-19T17:05:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 6,
			acceptedRows: 6,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "preserve-scroll-page",
			rows: [
				row("thread-hidden-0b", "Reloaded hidden row zero", "2026-06-19T17:10:00Z", 3),
				row("thread-hidden-1b", "Reloaded hidden row one", "2026-06-19T17:11:00Z", 5),
				row("thread-visible-2b", "Reloaded scroll row two", "2026-06-19T17:12:00Z", 8),
				row("thread-visible-3b", "Reloaded scroll row three", "2026-06-19T17:13:00Z", 13),
				row("thread-anchor", "Anchor scroll row", "2026-06-19T17:04:00Z", 5),
				row("thread-hidden-5b", "Reloaded hidden row five", "2026-06-19T17:15:00Z", 21)
			],
			nextCursor: "",
			scannedRows: 7,
			acceptedRows: 6,
			invalidRows: 1,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "clamp-scroll-page",
			rows: [
				row("thread-compact-0", "Compact scroll row zero", "2026-06-19T17:20:00Z", 21),
				row("thread-compact-1", "Compact scroll row one", "2026-06-19T17:21:00Z", 34),
				row("thread-anchor", "Anchor scroll row", "2026-06-19T17:04:00Z", 5)
			],
			nextCursor: "",
			scannedRows: 3,
			acceptedRows: 3,
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

	static function rowView(threadId:String, title:String, updatedAt:String, turnCount:Int, selected:Bool):ResumePickerVisibleRow {
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
