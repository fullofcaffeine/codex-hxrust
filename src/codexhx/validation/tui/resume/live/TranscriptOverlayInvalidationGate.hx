package codexhx.validation.tui.resume.live;

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
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class TranscriptOverlayInvalidationGate {
	public static function run():TranscriptOverlayInvalidationReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		final stateSummaries:Array<String> = [];
		var pageLoads = 0;
		var transcriptLoads = 0;
		var preservedOverlays = 0;
		var invalidatedOverlays = 0;

		final activeEvent = loadPage(loader, pageRequest("active-overlay-page", 3));
		eventSummaries.push(activeEvent.summary());
		if (activeEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyActivePage(state);
		}
		final transcriptEvent = loadTranscript(loader, transcriptRequest("transcript-thread-a", "thread-a"));
		eventSummaries.push(transcriptEvent.summary());
		if (transcriptEvent.kind == ResumePickerHostEventKind.TranscriptLoaded && transcriptEvent.threadId == state.selectedThreadId) {
			transcriptLoads = transcriptLoads + 1;
			applyLoadedTranscriptOverlay(state);
		}
		stateSummaries.push("loaded-overlay:" + stateSummary(state));
		scheduler.requestFrame("loaded-overlay");
		renderer.render(state);

		final preservedEvent = loadPage(loader, pageRequest("preserve-overlay-page", 3));
		eventSummaries.push(preservedEvent.summary());
		if (preservedEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			preservedOverlays = preservedOverlays + 1;
			applyPreservedOverlayReload(state);
		}
		stateSummaries.push("preserved:" + stateSummary(state));
		scheduler.requestFrame("preserve-overlay-page");
		renderer.render(state);

		final invalidatedEvent = loadPage(loader, pageRequest("invalidate-overlay-page", 2));
		eventSummaries.push(invalidatedEvent.summary());
		if (invalidatedEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			invalidatedOverlays = invalidatedOverlays + 1;
			applyInvalidatedOverlayReload(state);
		}
		stateSummaries.push("invalidated:" + stateSummary(state));
		scheduler.requestFrame("invalidate-overlay-page");
		renderer.render(state);

		return new TranscriptOverlayInvalidationReport({
			pageLoads: pageLoads,
			transcriptLoads: transcriptLoads,
			preservedOverlays: preservedOverlays,
			invalidatedOverlays: invalidatedOverlays,
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
		state.query = "overlay";
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
		state.selectedLabel = "Overlay anchor";
		state.visibleRows = [
			visibleRow("thread-a", "Overlay anchor", "2026-06-19T19:00:00Z", 3, true),
			visibleRow("thread-b", "Replacement overlay target", "2026-06-19T19:05:00Z", 5, false),
			visibleRow("thread-c", "Overlay sibling", "2026-06-19T19:10:00Z", 8, false)
		];
		applyLoadedCommon(state, "active_overlay_page_loaded", "selected=thread-a;overlay=pending", "active overlay page");
	}

	static function applyLoadedTranscriptOverlay(state:ResumePickerState):Void {
		state.pendingThreadId = "thread-a";
		state.transcriptState = "loaded";
		state.transcriptCells = detailCells();
		state.transcriptCellCount = state.transcriptCells.length;
		state.transcriptUserCellCount = 1;
		state.transcriptAssistantCellCount = 1;
		state.transcriptPlanCellCount = 1;
		state.transcriptReasoningCellCount = 0;
		state.transcriptFallbackCellCount = 0;
		state.transcriptLoadingFrameShown = false;
		state.loadingOverlayMessage = "";
		state.overlayOpen = true;
		state.visibleRows = [
			visibleRow("thread-a", "Overlay anchor", "2026-06-19T19:00:00Z", 3, true),
			visibleRow("thread-b", "Replacement overlay target", "2026-06-19T19:05:00Z", 5, false),
			visibleRow("thread-c", "Overlay sibling", "2026-06-19T19:10:00Z", 8, false)
		];
		applyLoadedCommon(state, "transcript_overlay_loaded_for_selected_thread", "thread=thread-a;cells=3", "overlay loaded");
	}

	static function applyPreservedOverlayReload(state:ResumePickerState):Void {
		state.scannedRows = 4;
		state.acceptedRows = 3;
		state.invalidRows = 1;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-a";
		state.selectedLabel = "Overlay anchor";
		state.pendingThreadId = "thread-a";
		state.transcriptState = "loaded";
		state.transcriptCells = detailCells();
		state.transcriptCellCount = state.transcriptCells.length;
		state.transcriptUserCellCount = 1;
		state.transcriptAssistantCellCount = 1;
		state.transcriptPlanCellCount = 1;
		state.transcriptFallbackCellCount = 0;
		state.overlayOpen = true;
		state.visibleRows = [
			visibleRow("thread-new", "Reloaded overlay neighbor", "2026-06-19T19:15:00Z", 13, false),
			visibleRow("thread-a", "Overlay anchor", "2026-06-19T19:00:00Z", 3, true),
			visibleRow("thread-c", "Overlay sibling", "2026-06-19T19:10:00Z", 8, false)
		];
		applyLoadedCommon(state, "transcript_overlay_preserved_for_selected_thread", "selected=thread-a;index=1;pending=thread-a;cells=3", "overlay preserved");
	}

	static function applyInvalidatedOverlayReload(state:ResumePickerState):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.invalidRows = 0;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-b";
		state.selectedLabel = "Replacement overlay target";
		state.pendingThreadId = "";
		state.transcriptState = "";
		state.transcriptLoadingFrameShown = false;
		state.transcriptCells = [];
		state.transcriptCellCount = 0;
		state.transcriptUserCellCount = 0;
		state.transcriptAssistantCellCount = 0;
		state.transcriptPlanCellCount = 0;
		state.transcriptReasoningCellCount = 0;
		state.transcriptFallbackCellCount = 0;
		state.loadingOverlayMessage = "";
		state.overlayOpen = false;
		state.overlayCloseCount = state.overlayCloseCount + 1;
		state.visibleRows = [
			visibleRow("thread-b", "Replacement overlay target", "2026-06-19T19:05:00Z", 5, true),
			visibleRow("thread-d", "Fresh overlay row", "2026-06-19T19:20:00Z", 21, false)
		];
		applyLoadedCommon(state, "transcript_overlay_invalidated_after_selection_change",
			"missing=thread-a;selected=thread-b;pendingCleared=true;overlayClosed=true;cells=0", "overlay invalidated");
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
			DiagnosticSummary.text("pending", emptyLabel(state.pendingThreadId)),
			DiagnosticSummary.text("transcript", emptyLabel(state.transcriptState)),
			DiagnosticSummary.boolValue("overlayOpen", state.overlayOpen),
			DiagnosticSummary.intValue("overlayCloseCount", state.overlayCloseCount),
			DiagnosticSummary.intValue("cells", state.transcriptCellCount),
			DiagnosticSummary.text("footer", state.footerProgressLabel),
			DiagnosticSummary.text("loader", state.loaderEventStatus),
			DiagnosticSummary.text("detail", state.loaderEventDetail)
		]);
	}

	static function loadPage(loader:DeterministicBackgroundLoader, request:ResumePickerThreadListRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function loadTranscript(loader:DeterministicBackgroundLoader, request:ResumePickerThreadReadRequest):ResumePickerHostEvent {
		loader.enqueue(ResumePickerBackgroundRequest.transcriptLoad(request));
		return expectEvent(loader.pollEvent(AsyncContext.fixture(request.requestId)));
	}

	static function pageRequest(requestId:String, pageSize:Int):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: "",
			query: "overlay",
			pageSize: pageSize,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.All,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: true,
			includeNonInteractive: false
		});
	}

	static function transcriptRequest(requestId:String, threadId:String):ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: requestId,
			threadId: threadId,
			includeTurns: true,
			previewOnly: false,
			maxPreviewLines: 0
		});
	}

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "active-overlay-page",
			rows: [
				row("thread-a", "Overlay anchor", "2026-06-19T19:00:00Z", 3),
				row("thread-b", "Replacement overlay target", "2026-06-19T19:05:00Z", 5),
				row("thread-c", "Overlay sibling", "2026-06-19T19:10:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 3,
			acceptedRows: 3,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "transcript-thread-a",
			threadId: "thread-a",
			previewLines: [],
			transcriptCells: detailCells(),
			truncated: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "preserve-overlay-page",
			rows: [
				row("thread-new", "Reloaded overlay neighbor", "2026-06-19T19:15:00Z", 13),
				row("thread-a", "Overlay anchor", "2026-06-19T19:00:00Z", 3),
				row("thread-c", "Overlay sibling", "2026-06-19T19:10:00Z", 8)
			],
			nextCursor: "",
			scannedRows: 4,
			acceptedRows: 3,
			invalidRows: 1,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "invalidate-overlay-page",
			rows: [
				row("thread-b", "Replacement overlay target", "2026-06-19T19:05:00Z", 5),
				row("thread-d", "Fresh overlay row", "2026-06-19T19:20:00Z", 21)
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

	static function detailCells():Array<String> {
		return [
			"user: inspect overlay",
			"assistant: overlay survives same thread",
			"plan: invalidate stale overlay"
		];
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
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
