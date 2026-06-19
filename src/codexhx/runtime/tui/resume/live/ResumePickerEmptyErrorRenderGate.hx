package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerBackgroundLoader;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.InMemoryResumePickerThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerBackgroundRequest;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListResponse;

class ResumePickerEmptyErrorRenderGate {
	public static function run():ResumePickerEmptyErrorRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = ResumePickerState.initial();
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;
		var failures = 0;

		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.pageSize = 25;
		state.viewRows = 10;
		state.loadingPending = true;
		state.emptyStateMessage = "Loading sessions...";
		state.footerProgressLabel = "0%";
		scheduler.requestFrame("initial-loading");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("empty-page", "", "")));
		final emptyEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("empty-page")));
		eventSummaries.push(emptyEvent.summary());
		if (emptyEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			state.scannedRows = 0;
			state.acceptedRows = 0;
			state.loadedRows = 0;
			state.filteredRows = 0;
			state.loadingPending = false;
			state.emptyStateMessage = "No sessions yet";
			state.footerProgressLabel = "0%";
		}
		scheduler.requestFrame("empty-page-loaded");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("search-empty-page", "", "needle")));
		final searchEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("search-empty-page")));
		eventSummaries.push(searchEvent.summary());
		if (searchEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			state.query = "needle";
			state.searchActive = true;
			state.scannedRows = 4;
			state.acceptedRows = 0;
			state.loadedRows = 0;
			state.filteredRows = 0;
			state.reachedScanCap = true;
			state.emptyStateMessage = "No results for \"needle\"";
			state.footerProgressLabel = "0%";
		}
		scheduler.requestFrame("search-empty-loaded");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("missing-page", "", "")));
		final failedEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("missing-page")));
		eventSummaries.push(failedEvent.summary());
		if (failedEvent.kind == ResumePickerHostEventKind.Failed) {
			failures = failures + 1;
			state.query = "";
			state.searchActive = false;
			state.loadingPending = false;
			state.inlineErrorShown = true;
			state.lastFailureCode = failedEvent.failureCode;
			state.lastError = failedEvent.failureMessage;
			state.emptyStateMessage = "Could not load sessions";
			state.footerProgressLabel = "error";
		}
		scheduler.requestFrame("page-load-failed");
		renderer.render(state);

		return new ResumePickerEmptyErrorRenderGateReport({
			pageLoads: pageLoads,
			failures: failures,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			eventSummaries: eventSummaries
		});
	}

	static function pageRequest(requestId:String, cursor:String, query:String):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 25,
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
			requestId: "empty-page",
			rows: [],
			nextCursor: "",
			scannedRows: 0,
			acceptedRows: 0,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "search-empty-page",
			rows: [],
			nextCursor: "",
			scannedRows: 4,
			acceptedRows: 0,
			invalidRows: 0,
			reachedScanCap: true
		}));
		return source;
	}

	static function expectEvent(poll:AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>>):ResumePickerHostEvent {
		return switch poll {
			case Ready(item, _, _): item.value;
			case _: throw "expected host event";
		}
	}
}
