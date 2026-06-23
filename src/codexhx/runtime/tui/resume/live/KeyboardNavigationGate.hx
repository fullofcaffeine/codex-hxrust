package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;

class KeyboardNavigationGate {
	public static function run():KeyboardNavigationReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();

		state.selectedIndex = 0;
		state.selectedThreadId = "thread-a";
		state.visibleRows = visibleRows(0);
		state.footerProgressLabel = "1/5";
		scheduler.requestFrame("initial-selection");
		renderer.render(state);

		state.selectedIndex = 1;
		state.selectedThreadId = "thread-b";
		state.visibleRows = visibleRows(1);
		state.footerProgressLabel = "2/5";
		scheduler.requestFrame("down-selection");
		renderer.render(state);

		state.selectedIndex = 4;
		state.selectedThreadId = "thread-e";
		state.scrollTop = 2;
		state.viewRows = 3;
		state.moreAbove = true;
		state.moreBelow = true;
		state.pendingPageDownCompleted = true;
		state.visibleRows = visibleRows(4);
		state.footerProgressLabel = "5/5";
		scheduler.requestFrame("page-end-navigation");
		renderer.render(state);

		state.query = "kernel";
		state.searchActive = true;
		state.selectedIndex = 2;
		state.selectedThreadId = "thread-c";
		state.scrollTop = 1;
		state.pendingPageDownCompleted = false;
		state.visibleRows = visibleRows(2);
		state.footerProgressLabel = "search";
		scheduler.requestFrame("search-query");
		renderer.render(state);

		state.query = "";
		state.searchActive = false;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-b";
		state.scrollTop = 0;
		state.moreAbove = false;
		state.moreBelow = false;
		state.visibleRows = visibleRows(1);
		state.footerProgressLabel = "start fresh";
		scheduler.requestFrame("query-clear-start-fresh");
		renderer.render(state);

		return new KeyboardNavigationReport({
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots()
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.loadedRows = 5;
		state.filteredRows = 5;
		state.scannedRows = 5;
		state.acceptedRows = 5;
		state.pageSize = 5;
		state.viewRows = 3;
		return state;
	}

	static function visibleRows(selectedIndex:Int):Array<ResumePickerVisibleRow> {
		return [
			visibleRow("thread-a", "Resume kernel", 3, selectedIndex == 0),
			visibleRow("thread-b", "Host facade", 5, selectedIndex == 1),
			visibleRow("thread-c", "Preview renderer", 8, selectedIndex == 2),
			visibleRow("thread-d", "Pagination renderer", 13, selectedIndex == 3),
			visibleRow("thread-e", "Navigation renderer", 21, selectedIndex == 4)
		];
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
}
