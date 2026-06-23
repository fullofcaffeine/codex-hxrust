package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerDensity;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerToolbarFocus;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;

class ToolbarFooterGate {
	public static function run():ToolbarFooterReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();

		state.toolbarFocus = ResumePickerToolbarFocus.Filter;
		state.toolbarRenderMode = "wide";
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.footerHintMode = "wide";
		state.footerWidth = 96;
		state.compactFallback = false;
		state.keyOnlyFallback = false;
		state.footerProgressLabel = "2/2";
		scheduler.requestFrame("toolbar-filter-wide");
		renderer.render(state);

		state.toolbarFocus = ResumePickerToolbarFocus.Sort;
		state.toolbarRenderMode = "compact";
		state.filterMode = ResumePickerFilterMode.All;
		state.sortKey = ResumePickerSortKey.CreatedAt;
		state.footerHintMode = "compact";
		state.footerWidth = 44;
		state.compactFallback = true;
		state.keyOnlyFallback = false;
		state.footerProgressLabel = "100%";
		scheduler.requestFrame("toolbar-sort-compact");
		renderer.render(state);

		state.toolbarFocus = ResumePickerToolbarFocus.Filter;
		state.toolbarRenderMode = "compact";
		state.query = "term";
		state.footerHintMode = "key-only";
		state.footerWidth = 18;
		state.compactFallback = true;
		state.keyOnlyFallback = true;
		state.footerProgressLabel = "search";
		scheduler.requestFrame("footer-key-only");
		renderer.render(state);

		state.query = "";
		state.loadingPending = true;
		state.footerHintMode = "loading";
		state.footerWidth = 28;
		state.footerProgressLabel = "loading 66%";
		scheduler.requestFrame("footer-loading-progress");
		renderer.render(state);

		return new ToolbarFooterReport({
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
		state.density = ResumePickerDensity.Comfortable;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-a";
		state.visibleRows = [
			visibleRow("thread-a", "Resume kernel", 3, true),
			visibleRow("thread-b", "Host facade", 5, false)
		];
		return state;
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
