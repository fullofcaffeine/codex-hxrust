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

class ResumePickerNoResultsReloadRecoveryRenderGate {
	public static function run():ResumePickerNoResultsReloadRecoveryRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];
		var pageLoads = 0;
		var emptyReloads = 0;
		var recoveryReloads = 0;

		final activeEvent = loadPage(loader, pageRequest("active-page", "", "kernel"));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyActivePage(state);
		}
		stateSummaries.push("active:" + stateSummary(state));
		scheduler.requestFrame("active-page");
		renderer.render(state);

		final emptyEvent = loadPage(loader, pageRequest("empty-page", "", "zz-no-results"));
		eventSummaries.push(emptyEvent.summary());
		if (emptyEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			emptyReloads = emptyReloads + 1;
			applyEmptyReload(state);
		}
		stateSummaries.push("empty:" + stateSummary(state));
		scheduler.requestFrame("empty-page");
		renderer.render(state);

		final recoveryEvent = loadPage(loader, pageRequest("recovery-page", "", "kernel"));
		eventSummaries.push(recoveryEvent.summary());
		if (recoveryEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			recoveryReloads = recoveryReloads + 1;
			applyRecoveryReload(state);
		}
		stateSummaries.push("recovery:" + stateSummary(state));
		scheduler.requestFrame("recovery-page");
		renderer.render(state);

		return new ResumePickerNoResultsReloadRecoveryRenderGateReport({
			pageLoads: pageLoads,
			emptyReloads: emptyReloads,
			recoveryReloads: recoveryReloads,
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

	static function applyActivePage(state:ResumePickerState):Void {
		state.query = "kernel";
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
		state.loaderEventDetail = "query=kernel;rows=3";
		state.footerProgressLabel = "active all results 3/4";
	}

	static function applyEmptyReload(state:ResumePickerState):Void {
		state.query = "zz-no-results";
		state.scannedRows = 5;
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
		state.loadingPending = false;
		state.visibleRows = [];
		state.emptyStateMessage = "No sessions match zz-no-results";
		state.loaderEventStatus = "current_empty_results_loaded";
		state.loaderEventDetail = "query=zz-no-results;rows=0;scanned=5";
		state.footerProgressLabel = "no results";
	}

	static function applyRecoveryReload(state:ResumePickerState):Void {
		state.query = "kernel";
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-kernel-tools";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreBelow = false;
		state.loadingPending = false;
		state.visibleRows = [
			visibleRow("thread-kernel", "Resume kernel", "/workspace/codex-hxrust", "2026-06-19T15:00:00Z", 3, false),
			visibleRow("thread-kernel-tools", "Kernel tool calls", "/workspace/codex-hxrust", "2026-06-19T15:20:00Z", 13, true)
		];
		state.emptyStateMessage = "";
		state.loaderEventStatus = "recovery_results_loaded";
		state.loaderEventDetail = "query=kernel;rows=2;previousEmpty=true";
		state.footerProgressLabel = "recovered results 2/2";
	}

	static function stateSummary(state:ResumePickerState):String {
		return "query=" + state.query + ";rows=" + state.loadedRows + ";filtered=" + state.filteredRows + ";selected=" + state.selectedIndex + ";thread="
			+ state.selectedThreadId + ";footer=" + state.footerProgressLabel + ";empty=" + state.emptyStateMessage + ";loader=" + state.loaderEventStatus;
	}

	static function loadPage(loader:DeterministicResumePickerBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String, cursor:String, query:String):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 3,
			sortKey: ResumePickerSortKey.CreatedAt,
			filterMode: ResumePickerFilterMode.All,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: true,
			includeNonInteractive: false
		});
	}

	static function fixtureSource():InMemoryResumePickerThreadSource {
		final source = new InMemoryResumePickerThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "active-page",
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
			requestId: "empty-page",
			rows: [],
			nextCursor: "",
			scannedRows: 5,
			acceptedRows: 0,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "recovery-page",
			rows: [
				row("thread-kernel", "Resume kernel", "/workspace/codex-hxrust", "2026-06-19T15:00:00Z", 3),
				row("thread-kernel-tools", "Kernel tool calls", "/workspace/codex-hxrust", "2026-06-19T15:20:00Z", 13)
			],
			nextCursor: "",
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
