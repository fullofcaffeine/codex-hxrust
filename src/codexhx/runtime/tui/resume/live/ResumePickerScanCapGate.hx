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

class ResumePickerScanCapGate {
	public static function run():ResumePickerScanCapReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;
		var scanCapPageLoads = 0;
		var ordinaryPageLoads = 0;

		scheduler.requestFrame("open");
		renderer.render(state);

		final scanCapPage = loadPage(loader, "scan-cap-page", "");
		eventSummaries.push(scanCapPage.summary());
		if (scanCapPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			scanCapPageLoads = scanCapPageLoads + 1;
			applyScanCapPage(state);
		}
		scheduler.requestFrame("scan-cap-page");
		renderer.render(state);

		state.loadingOlderShown = true;
		state.loadingPending = true;
		state.footerProgressLabel = "loading capped cursor";
		scheduler.requestFrame("scan-cap-load-more");
		renderer.render(state);

		final ordinaryPage = loadPage(loader, "ordinary-page", "cursor-after-cap");
		eventSummaries.push(ordinaryPage.summary());
		if (ordinaryPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			ordinaryPageLoads = ordinaryPageLoads + 1;
			applyOrdinaryPage(state);
		}
		scheduler.requestFrame("ordinary-page");
		renderer.render(state);

		final finalPage = loadPage(loader, "final-page", "cursor-tail");
		eventSummaries.push(finalPage.summary());
		if (finalPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			ordinaryPageLoads = ordinaryPageLoads + 1;
			applyFinalPage(state);
		}
		scheduler.requestFrame("final-page");
		renderer.render(state);

		return new ResumePickerScanCapReport({
			pageLoads: pageLoads,
			scanCapPageLoads: scanCapPageLoads,
			ordinaryPageLoads: ordinaryPageLoads,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			eventSummaries: eventSummaries
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.pageSize = 2;
		state.viewRows = 3;
		state.footerProgressLabel = "open";
		state.emptyStateMessage = "Loading saved chats...";
		return state;
	}

	static function applyScanCapPage(state:ResumePickerState):Void {
		state.scannedRows = 64;
		state.acceptedRows = 2;
		state.invalidRows = 1;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-cap-a";
		state.nextCursor = "cursor-after-cap";
		state.nextCursorPresent = true;
		state.reachedScanCap = true;
		state.moreBelow = true;
		state.loadingOlderShown = false;
		state.loadingPending = false;
		state.visibleRows = [
			visibleRow("thread-cap-a", "Scan cap anchor", "2026-06-19T13:00:00Z", 6, true),
			visibleRow("thread-cap-b", "Scan cap tail", "2026-06-19T13:05:00Z", 8, false)
		];
		state.emptyStateMessage = "";
		state.loaderEventStatus = "scan_cap_reached";
		state.loaderEventDetail = "scanCap=true;next=cursor-after-cap;scanned=64";
		state.footerProgressLabel = "scan cap reached";
	}

	static function applyOrdinaryPage(state:ResumePickerState):Void {
		state.scannedRows = 66;
		state.acceptedRows = 4;
		state.invalidRows = 1;
		state.loadedRows = 4;
		state.filteredRows = 4;
		state.selectedIndex = 2;
		state.selectedThreadId = "thread-ordinary-a";
		state.nextCursor = "cursor-tail";
		state.nextCursorPresent = true;
		state.reachedScanCap = false;
		state.moreBelow = true;
		state.loadingOlderShown = false;
		state.loadingPending = false;
		state.visibleRows = [
			visibleRow("thread-cap-a", "Scan cap anchor", "2026-06-19T13:00:00Z", 6, false),
			visibleRow("thread-cap-b", "Scan cap tail", "2026-06-19T13:05:00Z", 8, false),
			visibleRow("thread-ordinary-a", "Ordinary page anchor", "2026-06-19T13:10:00Z", 10, true),
			visibleRow("thread-ordinary-b", "Ordinary page tail", "2026-06-19T13:15:00Z", 12, false)
		];
		state.loaderEventStatus = "scan_cap_cleared";
		state.loaderEventDetail = "scanCap=false;next=cursor-tail;scanned=66";
		state.footerProgressLabel = "ordinary page ready";
	}

	static function applyFinalPage(state:ResumePickerState):Void {
		state.scannedRows = 67;
		state.acceptedRows = 5;
		state.invalidRows = 1;
		state.loadedRows = 5;
		state.filteredRows = 5;
		state.selectedIndex = 4;
		state.selectedThreadId = "thread-final";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreBelow = false;
		state.loadingOlderShown = false;
		state.loadingPending = false;
		state.visibleRows = [
			visibleRow("thread-cap-a", "Scan cap anchor", "2026-06-19T13:00:00Z", 6, false),
			visibleRow("thread-cap-b", "Scan cap tail", "2026-06-19T13:05:00Z", 8, false),
			visibleRow("thread-ordinary-a", "Ordinary page anchor", "2026-06-19T13:10:00Z", 10, false),
			visibleRow("thread-ordinary-b", "Ordinary page tail", "2026-06-19T13:15:00Z", 12, false),
			visibleRow("thread-final", "Recovered final row", "2026-06-19T13:20:00Z", 14, true)
		];
		state.loaderEventStatus = "scan_cap_recovered";
		state.loaderEventDetail = "scanCap=false;next=<empty>;scanned=67";
		state.footerProgressLabel = "list recovered";
	}

	static function loadPage(loader:DeterministicBackgroundLoader, requestId:String, cursor:String):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest(requestId, cursor)));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(requestId)));
	}

	static function pageRequest(requestId:String, cursor:String):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: "",
			pageSize: 2,
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
			requestId: "scan-cap-page",
			rows: [
				row("thread-cap-a", "Scan cap anchor", "2026-06-19T13:00:00Z", 6),
				row("thread-cap-b", "Scan cap tail", "2026-06-19T13:05:00Z", 8)
			],
			nextCursor: "cursor-after-cap",
			scannedRows: 64,
			acceptedRows: 2,
			invalidRows: 1,
			reachedScanCap: true
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "ordinary-page",
			rows: [
				row("thread-ordinary-a", "Ordinary page anchor", "2026-06-19T13:10:00Z", 10),
				row("thread-ordinary-b", "Ordinary page tail", "2026-06-19T13:15:00Z", 12)
			],
			nextCursor: "cursor-tail",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "final-page",
			rows: [row("thread-final", "Recovered final row", "2026-06-19T13:20:00Z", 14)],
			nextCursor: "",
			scannedRows: 1,
			acceptedRows: 1,
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
