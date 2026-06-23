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

class HostBackpressureGate {
	public static function run():HostBackpressureReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 1);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final pollSummaries:Array<String> = [];
		final eventSummaries:Array<String> = [];

		scheduler.requestFrame("open");
		renderer.render(state);

		final firstFrame = loader.enqueue(ResumePickerBackgroundRequest.frame("draw-1"));
		pollSummaries.push("frame-1:" + AsyncPollSummary.summary(firstFrame));
		final droppedFrame = loader.enqueue(ResumePickerBackgroundRequest.frame("draw-2"));
		final droppedFrameSummary = AsyncPollSummary.summary(droppedFrame);
		pollSummaries.push("frame-2:" + droppedFrameSummary);
		final bestEffortDropped = droppedFrameSummary.indexOf("best_effort_dropped") >= 0 && loader.skippedCount() == 1;
		state.loaderEventStatus = "best_effort_frame_dropped";
		state.loaderEventDetail = "pending=" + loader.pendingCount() + ";skipped=" + loader.skippedCount();
		state.footerProgressLabel = "frame drop";
		scheduler.requestFrame("best-effort-drop");
		renderer.render(state);

		final frameEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("drain-frame")));
		eventSummaries.push(frameEvent.summary());

		final firstPage = loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("page-1")));
		pollSummaries.push("page-1:" + AsyncPollSummary.summary(firstPage));
		final blockedPage = loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("page-2")));
		final blockedPageSummary = AsyncPollSummary.summary(blockedPage);
		pollSummaries.push("page-2-blocked:" + blockedPageSummary);
		final losslessBackpressured = blockedPageSummary.indexOf("lossless_backpressure") >= 0 && loader.pendingCount() == 1;
		state.loaderEventStatus = "lossless_page_backpressured";
		state.loaderEventDetail = "pending=" + loader.pendingCount() + ";skipped=" + loader.skippedCount();
		state.footerProgressLabel = "page backpressure";
		scheduler.requestFrame("lossless-backpressure");
		renderer.render(state);

		final pageOneEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("page-1")));
		eventSummaries.push(pageOneEvent.summary());
		if (pageOneEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			applyPageOne(state);
		}

		final recoveredPage = loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("page-2")));
		final recoveredPageSummary = AsyncPollSummary.summary(recoveredPage);
		pollSummaries.push("page-2-recovered:" + recoveredPageSummary);
		final pageTwoEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("page-2")));
		eventSummaries.push(pageTwoEvent.summary());
		final recoverySucceeded = recoveredPageSummary.indexOf("kind=ready") >= 0
			&& pageTwoEvent.kind == ResumePickerHostEventKind.PageLoaded;
		if (recoverySucceeded) {
			applyPageTwo(state);
		}
		state.loaderEventStatus = "backpressure_recovered";
		state.loaderEventDetail = "pending=" + loader.pendingCount() + ";skipped=" + loader.skippedCount();
		state.footerProgressLabel = "backpressure recovered";
		scheduler.requestFrame("backpressure-recovered");
		renderer.render(state);

		return new HostBackpressureReport({
			bestEffortDropped: bestEffortDropped,
			losslessBackpressured: losslessBackpressured,
			recoverySucceeded: recoverySucceeded,
			skippedEvents: loader.skippedCount(),
			pendingEvents: loader.pendingCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			pollSummaries: pollSummaries,
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
		state.viewRows = 2;
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyPageOne(state:ResumePickerState):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-a";
		state.visibleRows = [
			visibleRow("thread-a", "Resume kernel", 3, true),
			visibleRow("thread-b", "Host facade", 5, false)
		];
		state.nextCursor = "cursor-2";
		state.nextCursorPresent = true;
		state.moreBelow = true;
	}

	static function applyPageTwo(state:ResumePickerState):Void {
		state.scannedRows = 4;
		state.acceptedRows = 4;
		state.loadedRows = 4;
		state.filteredRows = 4;
		state.selectedIndex = 2;
		state.selectedThreadId = "thread-c";
		state.visibleRows = [
			visibleRow("thread-a", "Resume kernel", 3, false),
			visibleRow("thread-b", "Host facade", 5, false),
			visibleRow("thread-c", "Recovered page", 8, true),
			visibleRow("thread-d", "Recovered tail", 13, false)
		];
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.moreBelow = false;
	}

	static function pageRequest(requestId:String):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: requestId == "page-1" ? "" : "cursor-2",
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
			requestId: "page-1",
			rows: [row("thread-a", "Resume kernel", 3), row("thread-b", "Host facade", 5)],
			nextCursor: "cursor-2",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "page-2",
			rows: [row("thread-c", "Recovered page", 8), row("thread-d", "Recovered tail", 13)],
			nextCursor: "",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		return source;
	}

	static function row(threadId:String, title:String, turnCount:Int):ResumePickerThreadRow {
		return new ResumePickerThreadRow({
			threadId: threadId,
			title: title,
			cwd: "/workspace/codex-hxrust",
			updatedAt: "2026-06-19T12:00:00Z",
			archived: false,
			turnCount: turnCount
		});
	}

	static function visibleRow(threadId:String, title:String, turnCount:Int, selected:Bool):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: title,
			cwd: "/workspace/codex-hxrust",
			updatedAt: "2026-06-19T12:00:00Z",
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
