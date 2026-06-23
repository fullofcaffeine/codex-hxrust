package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncCancelReason;
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
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class LoaderCancellationGate {
	public static function run():LoaderCancellationReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = ResumePickerState.initial();
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;
		var staleIgnored = 0;

		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "loading";
		scheduler.requestFrame("open");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("page-current", "")));
		final currentPage = expectEvent(loader.pollEvent(AsyncContext.fixture("page-current")));
		eventSummaries.push(currentPage.summary());
		if (currentPage.kind == ResumePickerHostEventKind.PageLoaded && currentPage.requestId == "page-current") {
			pageLoads = pageLoads + 1;
			applyCurrentPage(state);
		}
		scheduler.requestFrame("page-current-loaded");
		renderer.render(state);
		final baselineSummary = stableSummary(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest("page-stale", "cursor-stale")));
		final stalePage = expectEvent(loader.pollEvent(AsyncContext.fixture("page-stale")));
		eventSummaries.push(stalePage.summary());
		if (stalePage.kind == ResumePickerHostEventKind.PageLoaded && stalePage.requestId != "page-current") {
			staleIgnored = staleIgnored + 1;
			state.loaderEventStatus = "stale_page_ignored";
			state.loaderEventDetail = stalePage.requestId;
			state.footerProgressLabel = "stale page ignored";
		}
		scheduler.requestFrame("stale-page-ignored");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.previewLoad(readRequest("preview-stale", "thread-b", true)));
		final stalePreview = expectEvent(loader.pollEvent(AsyncContext.fixture("preview-stale")));
		eventSummaries.push(stalePreview.summary());
		if (stalePreview.kind == ResumePickerHostEventKind.PreviewLoaded && stalePreview.threadId != state.selectedThreadId) {
			staleIgnored = staleIgnored + 1;
			state.loaderEventStatus = "stale_preview_ignored";
			state.loaderEventDetail = stalePreview.requestId + ":" + stalePreview.threadId;
			state.footerProgressLabel = "stale preview ignored";
		}
		scheduler.requestFrame("stale-preview-ignored");
		renderer.render(state);

		state.pendingThreadId = "thread-a";
		loader.enqueue(ResumePickerBackgroundRequest.transcriptLoad(readRequest("transcript-stale", "thread-b", false)));
		final staleTranscript = expectEvent(loader.pollEvent(AsyncContext.fixture("transcript-stale")));
		eventSummaries.push(staleTranscript.summary());
		if (staleTranscript.kind == ResumePickerHostEventKind.TranscriptLoaded && staleTranscript.threadId != state.pendingThreadId) {
			staleIgnored = staleIgnored + 1;
			state.loaderEventStatus = "stale_transcript_ignored";
			state.loaderEventDetail = staleTranscript.requestId + ":" + staleTranscript.threadId;
			state.footerProgressLabel = "stale transcript ignored";
		}
		scheduler.requestFrame("stale-transcript-ignored");
		renderer.render(state);

		final cancelPoll = loader.cancel(AsyncCancelReason.ConsumerDropped);
		final cancellationObserved = switch cancelPoll {
			case Cancelled(reason, _, _):
				state.loaderEventStatus = "loader_cancelled";
				state.loaderEventDetail = Std.string(reason);
				state.footerProgressLabel = "loader cancelled";
				reason == AsyncCancelReason.ConsumerDropped;
			case _:
				throw "expected loader cancellation";
		};
		scheduler.requestFrame("loader-cancelled");
		renderer.render(state);

		return new LoaderCancellationReport({
			pageLoads: pageLoads,
			staleIgnored: staleIgnored,
			cancellationObserved: cancellationObserved,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			baselineSummary: baselineSummary,
			finalSummary: stableSummary(state),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			eventSummaries: eventSummaries
		});
	}

	static function applyCurrentPage(state:ResumePickerState):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-a";
		state.selectedLabel = "Resume kernel";
		state.visibleRows = visibleRows();
		state.nextCursor = "cursor-2";
		state.nextCursorPresent = true;
		state.moreBelow = true;
		state.footerProgressLabel = "50%";
	}

	static function stableSummary(state:ResumePickerState):String {
		return "loaded=" + state.loadedRows + ";filtered=" + state.filteredRows + ";selected=" + state.selectedIndex + ";selectedThread="
			+ state.selectedThreadId + ";preview=" + state.previewState + ";transcript=" + state.transcriptState + ";overlay="
			+ (state.overlayOpen ? "true" : "false");
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

	static function readRequest(requestId:String, threadId:String, previewOnly:Bool):ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: requestId,
			threadId: threadId,
			includeTurns: true,
			previewOnly: previewOnly,
			maxPreviewLines: previewOnly ? 4 : 0
		});
	}

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "page-current",
			rows: [row("thread-a", "Resume kernel", 3), row("thread-b", "Host facade", 5)],
			nextCursor: "cursor-2",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "page-stale",
			rows: [row("thread-z", "Stale result", 99)],
			nextCursor: "",
			scannedRows: 1,
			acceptedRows: 1,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "preview-stale",
			threadId: "thread-b",
			previewLines: ["assistant: stale preview"],
			transcriptCells: [],
			truncated: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "transcript-stale",
			threadId: "thread-b",
			previewLines: [],
			transcriptCells: ["assistant: stale transcript"],
			truncated: false
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

	static function visibleRows():Array<ResumePickerVisibleRow> {
		return [
			visibleRow("thread-a", "Resume kernel", 3, true),
			visibleRow("thread-b", "Host facade", 5, false)
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
