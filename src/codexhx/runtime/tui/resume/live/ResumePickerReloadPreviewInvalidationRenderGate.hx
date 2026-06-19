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
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class ResumePickerReloadPreviewInvalidationRenderGate {
	static final previewLines = ["user: inspect reload", "assistant: preview survives same thread"];

	public static function run():ResumePickerReloadPreviewInvalidationRenderGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];
		var pageLoads = 0;
		var previewLoads = 0;
		var preservedPreviews = 0;
		var invalidatedPreviews = 0;

		final activeEvent = loadPage(loader, pageRequest("active-preview-page", 3));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyActivePage(state);
		}
		final previewEvent = loadPreview(loader, previewRequest("preview-thread-a", "thread-a"));
		eventSummaries.push(previewEvent.summary());
		if (previewEvent.kind == ResumePickerHostEventKind.PreviewLoaded && previewEvent.threadId == state.selectedThreadId) {
			previewLoads = previewLoads + 1;
			applyLoadedPreview(state);
		}
		stateSummaries.push("loaded-preview:" + stateSummary(state));
		scheduler.requestFrame("loaded-preview");
		renderer.render(state);

		final preservedEvent = loadPage(loader, pageRequest("preserve-preview-page", 3));
		eventSummaries.push(preservedEvent.summary());
		if (preservedEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			preservedPreviews = preservedPreviews + 1;
			applyPreservedPreviewReload(state);
		}
		stateSummaries.push("preserved:" + stateSummary(state));
		scheduler.requestFrame("preserve-preview-page");
		renderer.render(state);

		final invalidatedEvent = loadPage(loader, pageRequest("invalidate-preview-page", 2));
		eventSummaries.push(invalidatedEvent.summary());
		if (invalidatedEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			invalidatedPreviews = invalidatedPreviews + 1;
			applyInvalidatedPreviewReload(state);
		}
		stateSummaries.push("invalidated:" + stateSummary(state));
		scheduler.requestFrame("invalidate-preview-page");
		renderer.render(state);

		return new ResumePickerReloadPreviewInvalidationRenderGateReport({
			pageLoads: pageLoads,
			previewLoads: previewLoads,
			preservedPreviews: preservedPreviews,
			invalidatedPreviews: invalidatedPreviews,
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
		state.query = "preview";
		state.footerProgressLabel = "open";
		return state;
	}

	static function applyActivePage(state:ResumePickerState):Void {
		state.scannedRows = 3;
		state.acceptedRows = 3;
		state.invalidRows = 0;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-a";
		state.selectedLabel = "Preview anchor";
		state.visibleRows = [
			visibleRow("thread-a", "Preview anchor", "2026-06-19T18:00:00Z", 3, true, []),
			visibleRow("thread-b", "Fallback preview target", "2026-06-19T18:05:00Z", 5, false, []),
			visibleRow("thread-c", "Preview sibling", "2026-06-19T18:10:00Z", 8, false, [])
		];
		applyLoadedCommon(state, "active_preview_page_loaded", "selected=thread-a;preview=pending", "active preview page");
	}

	static function applyLoadedPreview(state:ResumePickerState):Void {
		state.expandedThreadId = "thread-a";
		state.previewState = "loaded";
		state.previewRendered = true;
		state.previewLineCount = 2;
		state.previewUserLineCount = 1;
		state.previewAssistantLineCount = 1;
		state.pendingThreadId = "thread-a";
		state.transcriptState = "preview_loaded";
		state.visibleRows = [
			visibleRow("thread-a", "Preview anchor", "2026-06-19T18:00:00Z", 3, true, previewLines),
			visibleRow("thread-b", "Fallback preview target", "2026-06-19T18:05:00Z", 5, false, []),
			visibleRow("thread-c", "Preview sibling", "2026-06-19T18:10:00Z", 8, false, [])
		];
		applyLoadedCommon(state, "preview_loaded_for_selected_thread", "thread=thread-a;previewLines=2", "preview loaded");
	}

	static function applyPreservedPreviewReload(state:ResumePickerState):Void {
		state.scannedRows = 4;
		state.acceptedRows = 3;
		state.invalidRows = 1;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-a";
		state.selectedLabel = "Preview anchor";
		state.expandedThreadId = "thread-a";
		state.previewState = "loaded";
		state.previewRendered = true;
		state.previewLineCount = 2;
		state.previewUserLineCount = 1;
		state.previewAssistantLineCount = 1;
		state.pendingThreadId = "thread-a";
		state.transcriptState = "preview_loaded";
		state.visibleRows = [
			visibleRow("thread-new", "Reloaded preview neighbor", "2026-06-19T18:15:00Z", 13, false, []),
			visibleRow("thread-a", "Preview anchor", "2026-06-19T18:00:00Z", 3, true, previewLines),
			visibleRow("thread-c", "Preview sibling", "2026-06-19T18:10:00Z", 8, false, [])
		];
		applyLoadedCommon(
			state,
			"preview_preserved_for_selected_thread",
			"selected=thread-a;index=1;expanded=thread-a;previewLines=2",
			"preview preserved"
		);
	}

	static function applyInvalidatedPreviewReload(state:ResumePickerState):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-b";
		state.selectedLabel = "Fallback preview target";
		state.expandedThreadId = "";
		state.previewState = "";
		state.previewRendered = false;
		state.previewLineCount = 0;
		state.previewUserLineCount = 0;
		state.previewAssistantLineCount = 0;
		state.pendingThreadId = "";
		state.transcriptState = "";
		state.transcriptLoadingFrameShown = false;
		state.visibleRows = [
			visibleRow("thread-b", "Fallback preview target", "2026-06-19T18:05:00Z", 5, true, []),
			visibleRow("thread-d", "Replacement preview row", "2026-06-19T18:20:00Z", 21, false, [])
		];
		applyLoadedCommon(
			state,
			"preview_invalidated_after_selection_change",
			"missing=thread-a;selected=thread-b;expandedCleared=true;pendingCleared=true;previewLines=0",
			"preview invalidated"
		);
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
		return "query=" + state.query
			+ ";rows=" + state.loadedRows
			+ ";selected=" + state.selectedIndex
			+ ";thread=" + state.selectedThreadId
			+ ";expanded=" + emptyLabel(state.expandedThreadId)
			+ ";preview=" + emptyLabel(state.previewState)
			+ ";previewRendered=" + boolLabel(state.previewRendered)
			+ ";previewLines=" + state.previewLineCount
			+ ";pending=" + emptyLabel(state.pendingThreadId)
			+ ";transcript=" + emptyLabel(state.transcriptState)
			+ ";footer=" + state.footerProgressLabel
			+ ";loader=" + state.loaderEventStatus
			+ ";detail=" + state.loaderEventDetail;
	}

	static function loadPage(loader:DeterministicResumePickerBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function loadPreview(loader:DeterministicResumePickerBackgroundLoader, request:ResumePickerThreadReadRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.previewLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String, pageSize:Int):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: "",
			query: "preview",
			pageSize: pageSize,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.All,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: true,
			includeNonInteractive: false
		});
	}

	static function previewRequest(requestId:String, threadId:String):ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: requestId,
			threadId: threadId,
			includeTurns: true,
			previewOnly: true,
			maxPreviewLines: 4
		});
	}

	static function fixtureSource():InMemoryResumePickerThreadSource {
		final source = new InMemoryResumePickerThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "active-preview-page",
			rows: [
				row("thread-a", "Preview anchor", "2026-06-19T18:00:00Z", 3),
				row("thread-b", "Fallback preview target", "2026-06-19T18:05:00Z", 5),
				row("thread-c", "Preview sibling", "2026-06-19T18:10:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 3,
			acceptedRows: 3,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "preview-thread-a",
			threadId: "thread-a",
			previewLines: previewLines,
			transcriptCells: [],
			truncated: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "preserve-preview-page",
			rows: [
				row("thread-new", "Reloaded preview neighbor", "2026-06-19T18:15:00Z", 13),
				row("thread-a", "Preview anchor", "2026-06-19T18:00:00Z", 3),
				row("thread-c", "Preview sibling", "2026-06-19T18:10:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 4,
			acceptedRows: 3,
			invalidRows: 1,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "invalidate-preview-page",
			rows: [
				row("thread-b", "Fallback preview target", "2026-06-19T18:05:00Z", 5),
				row("thread-d", "Replacement preview row", "2026-06-19T18:20:00Z", 21)
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

	static function visibleRow(threadId:String, title:String, updatedAt:String, turnCount:Int, selected:Bool, previewLines:Array<String>):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: title,
			cwd: "/workspace/codex-hxrust",
			updatedAt: updatedAt,
			turnCount: turnCount,
			selected: selected,
			previewLines: previewLines
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
