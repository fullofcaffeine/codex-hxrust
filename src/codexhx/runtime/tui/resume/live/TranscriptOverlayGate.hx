package codexhx.runtime.tui.resume.live;

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
import codexhx.runtime.tui.resume.host.ResumePickerThreadListResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class TranscriptOverlayGate {
	public static function run():TranscriptOverlayReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = ResumePickerState.initial();
		final eventSummaries:Array<String> = [];
		var transcriptLoads = 0;
		var fallbackLoads = 0;

		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.pageSize = 25;
		state.viewRows = 10;
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-detail";
		state.selectedLabel = "Detail transcript";
		state.visibleRows = visibleRows(0);
		state.footerProgressLabel = "50%";
		scheduler.requestFrame("page-loaded");
		renderer.render(state);

		state.pendingThreadId = "thread-detail";
		state.transcriptState = "loading";
		state.transcriptLoadingFrameShown = true;
		state.loadingOverlayMessage = "Loading transcript...";
		scheduler.requestFrame("detail-loading");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.transcriptLoad(transcriptRequest("transcript-detail", "thread-detail")));
		final detailEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("transcript-detail")));
		eventSummaries.push(detailEvent.summary());
		if (detailEvent.kind == ResumePickerHostEventKind.TranscriptLoaded) {
			transcriptLoads = transcriptLoads + 1;
			state.transcriptState = "loaded";
			state.transcriptCells = detailCells();
			state.transcriptCellCount = state.transcriptCells.length;
			state.transcriptUserCellCount = 1;
			state.transcriptAssistantCellCount = 1;
			state.transcriptPlanCellCount = 1;
			state.transcriptFallbackCellCount = 0;
			state.loadingOverlayMessage = "";
			state.overlayOpen = true;
			state.footerProgressLabel = "detail";
		}
		scheduler.requestFrame("detail-loaded");
		renderer.render(state);

		state.selectedIndex = 1;
		state.selectedThreadId = "thread-empty";
		state.selectedLabel = "Empty fallback";
		state.visibleRows = visibleRows(1);
		state.pendingThreadId = "thread-empty";
		state.transcriptState = "loading";
		state.transcriptLoadingFrameShown = true;
		state.loadingOverlayMessage = "Loading transcript...";
		state.overlayOpen = false;
		state.transcriptCells = [];
		state.transcriptCellCount = 0;
		state.footerProgressLabel = "loading fallback";
		scheduler.requestFrame("fallback-loading");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.transcriptLoad(transcriptRequest("transcript-empty", "thread-empty")));
		final fallbackEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("transcript-empty")));
		eventSummaries.push(fallbackEvent.summary());
		if (fallbackEvent.kind == ResumePickerHostEventKind.TranscriptLoaded) {
			transcriptLoads = transcriptLoads + 1;
			fallbackLoads = fallbackLoads + 1;
			state.transcriptState = "loaded";
			state.transcriptCells = fallbackCells();
			state.transcriptCellCount = state.transcriptCells.length;
			state.transcriptUserCellCount = 0;
			state.transcriptAssistantCellCount = 0;
			state.transcriptPlanCellCount = 0;
			state.transcriptFallbackCellCount = 1;
			state.loadingOverlayMessage = "";
			state.overlayOpen = true;
			state.footerProgressLabel = "fallback";
		}
		scheduler.requestFrame("fallback-loaded");
		renderer.render(state);

		return new TranscriptOverlayReport({
			transcriptLoads: transcriptLoads,
			fallbackLoads: fallbackLoads,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			eventSummaries: eventSummaries
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
			requestId: "unused-page-anchor",
			rows: [
				row("thread-detail", "Detail transcript", 3),
				row("thread-empty", "Empty fallback", 0)
			],
			nextCursor: "",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "transcript-detail",
			threadId: "thread-detail",
			previewLines: [],
			transcriptCells: detailCells(),
			truncated: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "transcript-empty",
			threadId: "thread-empty",
			previewLines: [],
			transcriptCells: fallbackCells(),
			truncated: false
		}));
		return source;
	}

	static function visibleRows(selectedIndex:Int):Array<ResumePickerVisibleRow> {
		return [
			visibleRow("thread-detail", "Detail transcript", 3, selectedIndex == 0),
			visibleRow("thread-empty", "Empty fallback", 0, selectedIndex == 1)
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

	static function detailCells():Array<String> {
		return [
			"user: continue",
			"assistant: transcript detail ready",
			"plan: render transcript cells"
		];
	}

	static function fallbackCells():Array<String> {
		return ["fallback: No transcript content"];
	}

	static function expectEvent(poll:AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>>):ResumePickerHostEvent {
		return switch poll {
			case Ready(item, _, _): item.value;
			case _: throw "expected host event";
		}
	}
}
