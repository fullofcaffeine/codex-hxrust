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

class ResumePickerReloadFailurePreservationRenderGate {
	public static function run():ResumePickerReloadFailurePreservationRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];
		var pageLoads = 0;
		var reloadFailures = 0;
		var recoveryReloads = 0;

		final activeEvent = loadPage(loader, pageRequest("active-failure-baseline-page", "kernel", 3));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyActivePage(state);
		}
		stateSummaries.push("active:" + stateSummary(state));
		scheduler.requestFrame("active-failure-baseline-page");
		renderer.render(state);

		final failedEvent = loadPage(loader, pageRequest("missing-reload-page", "kernel", 3));
		eventSummaries.push(failedEvent.summary());
		if (failedEvent.kind == ResumePickerHostEventKind.Failed) {
			reloadFailures = reloadFailures + 1;
			applyReloadFailure(state, failedEvent);
		}
		stateSummaries.push("failure:" + stateSummary(state));
		scheduler.requestFrame("missing-reload-page");
		renderer.render(state);

		final recoveryEvent = loadPage(loader, pageRequest("recovery-after-failure-page", "kernel", 2));
		eventSummaries.push(recoveryEvent.summary());
		if (recoveryEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			recoveryReloads = recoveryReloads + 1;
			applyRecoveryPage(state);
		}
		stateSummaries.push("recovery:" + stateSummary(state));
		scheduler.requestFrame("recovery-after-failure-page");
		renderer.render(state);

		return new ResumePickerReloadFailurePreservationRenderGateReport({
			pageLoads: pageLoads,
			reloadFailures: reloadFailures,
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
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.All;
		state.toolbarFocus = ResumePickerToolbarFocus.Filter;
		state.toolbarRenderMode = "compact";
		state.pageSize = 3;
		state.viewRows = 3;
		state.query = "kernel";
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyActivePage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.scannedRows = 3;
		state.acceptedRows = 3;
		state.invalidRows = 0;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-stable";
		state.selectedLabel = "Stable failure row";
		state.scrollTop = 0;
		state.visibleRows = [
			visibleRow("thread-first", "First failure baseline", "2026-06-19T20:00:00Z", 2, false),
			visibleRow("thread-stable", "Stable failure row", "2026-06-19T20:05:00Z", 5, true),
			visibleRow("thread-tail", "Tail failure baseline", "2026-06-19T20:10:00Z", 8, false)
		];
		applyLoadedCommon(state, "active_results_loaded", "request=active-failure-baseline-page;query=kernel;rows=3", "active results 3/3");
	}

	static function applyReloadFailure(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.loadingPending = false;
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = "reload_failed_preserved_previous_results";
		state.loaderEventDetail = "request=" + event.requestId + ";code=" + event.failureCode + ";preservedThread=" + state.selectedThreadId + ";rows="
			+ state.loadedRows;
		state.footerProgressLabel = "reload failed";
		state.overlayOpen = false;
		state.loadingOverlayMessage = "";
	}

	static function applyRecoveryPage(state:ResumePickerState):Void {
		state.query = "kernel";
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-recovered";
		state.selectedLabel = "Recovered failure row";
		state.scrollTop = 0;
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.visibleRows = [
			visibleRow("thread-recovered", "Recovered failure row", "2026-06-19T20:15:00Z", 13, true),
			visibleRow("thread-tail", "Tail failure baseline", "2026-06-19T20:10:00Z", 8, false)
		];
		applyLoadedCommon(state, "reload_recovered_after_failure", "request=recovery-after-failure-page;previousFailure=true;rows=2", "reload recovered");
	}

	static function applyLoadedCommon(state:ResumePickerState, status:String, detail:String, footer:String):Void {
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.reachedScanCap = false;
		state.moreAbove = false;
		state.moreBelow = false;
		state.loadingOlderShown = false;
		state.pendingPageDownCompleted = false;
		state.loadingPending = false;
		state.emptyStateMessage = "";
		state.loadingOverlayMessage = "";
		state.overlayOpen = false;
		state.loaderEventStatus = status;
		state.loaderEventDetail = detail;
		state.footerProgressLabel = footer;
	}

	static function stateSummary(state:ResumePickerState):String {
		return "query=" + state.query + ";rows=" + state.loadedRows + ";filtered=" + state.filteredRows + ";selected=" + state.selectedIndex + ";thread="
			+ state.selectedThreadId + ";scrollTop=" + state.scrollTop + ";errorShown=" + boolLabel(state.inlineErrorShown) + ";failure="
			+ emptyLabel(state.lastFailureCode) + ";footer=" + state.footerProgressLabel + ";loader=" + state.loaderEventStatus + ";detail="
			+ state.loaderEventDetail;
	}

	static function loadPage(loader:DeterministicResumePickerBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String, query:String, pageSize:Int):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: "",
			query: query,
			pageSize: pageSize,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.All,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: true,
			includeNonInteractive: false
		});
	}

	static function fixtureSource():InMemoryResumePickerThreadSource {
		final source = new InMemoryResumePickerThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "active-failure-baseline-page",
			rows: [
				row("thread-first", "First failure baseline", "2026-06-19T20:00:00Z", 2),
				row("thread-stable", "Stable failure row", "2026-06-19T20:05:00Z", 5),
				row("thread-tail", "Tail failure baseline", "2026-06-19T20:10:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 3,
			acceptedRows: 3,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "recovery-after-failure-page",
			rows: [
				row("thread-recovered", "Recovered failure row", "2026-06-19T20:15:00Z", 13),
				row("thread-tail", "Tail failure baseline", "2026-06-19T20:10:00Z", 8)
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

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
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
