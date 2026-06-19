package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
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

class ResumePickerPaginationRenderGate {
	public static function run():ResumePickerPaginationRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = ResumePickerState.initial();
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;

		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "0%";
		scheduler.requestFrame("open");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("page-1", "")));
		final firstPage = expectEvent(loader.pollEvent(AsyncContext.fixture("page-1")));
		eventSummaries.push(firstPage.summary());
		if (firstPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			state.scannedRows = 2;
			state.acceptedRows = 2;
			state.loadedRows = 2;
			state.filteredRows = 2;
			state.selectedIndex = 1;
			state.selectedThreadId = "thread-b";
			state.nextCursor = "cursor-2";
			state.nextCursorPresent = true;
			state.moreBelow = true;
			state.visibleRows = visibleRows(1, false);
			state.footerProgressLabel = "50%";
		}
		scheduler.requestFrame("page-1-loaded");
		renderer.render(state);

		state.loadingOlderShown = true;
		state.loadingPending = true;
		state.footerProgressLabel = "loading older";
		scheduler.requestFrame("load-more");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("page-2", "cursor-2")));
		final secondPage = expectEvent(loader.pollEvent(AsyncContext.fixture("page-2")));
		eventSummaries.push(secondPage.summary());
		if (secondPage.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			state.scannedRows = 4;
			state.acceptedRows = 4;
			state.loadedRows = 4;
			state.filteredRows = 4;
			state.selectedIndex = 2;
			state.selectedThreadId = "thread-c";
			state.nextCursor = "";
			state.nextCursorPresent = false;
			state.moreBelow = false;
			state.loadingOlderShown = false;
			state.loadingPending = false;
			state.visibleRows = visibleRows(2, true);
			state.footerProgressLabel = "100%";
		}
		scheduler.requestFrame("page-2-loaded");
		renderer.render(state);

		return new ResumePickerPaginationRenderGateReport({
			pageLoads: pageLoads,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			eventSummaries: eventSummaries
		});
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

	static function fixtureSource():InMemoryResumePickerThreadSource {
		final source = new InMemoryResumePickerThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "page-1",
			rows: [row("thread-a", "Resume kernel", "2026-06-19T12:00:00Z", 3), row("thread-b", "Host facade", "2026-06-19T12:05:00Z", 5)],
			nextCursor: "cursor-2",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "page-2",
			rows: [row("thread-c", "Preview renderer", "2026-06-19T12:10:00Z", 8), row("thread-d", "Pagination renderer", "2026-06-19T12:15:00Z", 13)],
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

	static function visibleRows(selectedIndex:Int, includeSecondPage:Bool):Array<ResumePickerVisibleRow> {
		final rows = [
			visibleRow("thread-a", "Resume kernel", "2026-06-19T12:00:00Z", 3, selectedIndex == 0),
			visibleRow("thread-b", "Host facade", "2026-06-19T12:05:00Z", 5, selectedIndex == 1)
		];
		if (includeSecondPage) {
			rows.push(visibleRow("thread-c", "Preview renderer", "2026-06-19T12:10:00Z", 8, selectedIndex == 2));
			rows.push(visibleRow("thread-d", "Pagination renderer", "2026-06-19T12:15:00Z", 13, selectedIndex == 3));
		}
		return rows;
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
			case _: throw "expected host event";
		}
	}
}
