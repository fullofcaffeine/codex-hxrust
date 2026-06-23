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
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class ResumePickerPreviewGate {
	public static function run():ResumePickerPreviewReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 8);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = ResumePickerState.initial();
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;
		var previewLoads = 0;

		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.pageSize = 25;
		state.viewRows = 10;
		state.footerProgressLabel = "0%";
		scheduler.requestFrame("open");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest()));
		final pageEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("page")));
		eventSummaries.push(pageEvent.summary());
		if (pageEvent.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			state.scannedRows = 2;
			state.acceptedRows = 2;
			state.loadedRows = 2;
			state.filteredRows = 2;
			state.selectedIndex = 0;
			state.selectedThreadId = "thread-a";
			state.selectedLabel = "Resume kernel";
			state.visibleRows = visibleRows([]);
			state.footerProgressLabel = "50%";
		}
		scheduler.requestFrame("page-loaded");
		renderer.render(state);

		state.expandedThreadId = "thread-a";
		state.previewState = "loading";
		state.visibleRows = visibleRows(["loading preview..."]);
		scheduler.requestFrame("preview-loading");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.previewLoad(previewRequest()));
		final previewEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("preview")));
		eventSummaries.push(previewEvent.summary());
		if (previewEvent.kind == ResumePickerHostEventKind.PreviewLoaded) {
			previewLoads = previewLoads + 1;
			state.previewState = "loaded";
			state.previewRendered = true;
			state.previewLineCount = 2;
			state.previewUserLineCount = 1;
			state.previewAssistantLineCount = 1;
			state.visibleRows = visibleRows(["user: continue", "assistant: preview ready"]);
			state.footerProgressLabel = "100%";
		}
		scheduler.requestFrame("preview-loaded");
		renderer.render(state);

		return new ResumePickerPreviewReport({
			pageLoads: pageLoads,
			previewLoads: previewLoads,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			eventSummaries: eventSummaries
		});
	}

	static function pageRequest():ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: "page-1",
			cursor: "",
			query: "",
			pageSize: 25,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.Cwd,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: false,
			includeNonInteractive: false
		});
	}

	static function previewRequest():ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: "preview-1",
			threadId: "thread-a",
			includeTurns: true,
			previewOnly: true,
			maxPreviewLines: 4
		});
	}

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "page-1",
			rows: [
				new ResumePickerThreadRow({
					threadId: "thread-a",
					title: "Resume kernel",
					cwd: "/workspace/codex-hxrust",
					updatedAt: "2026-06-19T12:00:00Z",
					archived: false,
					turnCount: 3
				}),
				new ResumePickerThreadRow({
					threadId: "thread-b",
					title: "Host facade",
					cwd: "/workspace/codex-hxrust",
					updatedAt: "2026-06-19T12:05:00Z",
					archived: false,
					turnCount: 5
				})
			],
			nextCursor: "cursor-2",
			scannedRows: 2,
			acceptedRows: 2,
			invalidRows: 0,
			reachedScanCap: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "preview-1",
			threadId: "thread-a",
			previewLines: ["user: continue", "assistant: preview ready"],
			transcriptCells: [],
			truncated: false
		}));
		return source;
	}

	static function visibleRows(previewLines:Array<String>):Array<ResumePickerVisibleRow> {
		return [
			new ResumePickerVisibleRow({
				threadId: "thread-a",
				title: "Resume kernel",
				cwd: "/workspace/codex-hxrust",
				updatedAt: "2026-06-19T12:00:00Z",
				turnCount: 3,
				selected: true,
				previewLines: previewLines
			}),
			new ResumePickerVisibleRow({
				threadId: "thread-b",
				title: "Host facade",
				cwd: "/workspace/codex-hxrust",
				updatedAt: "2026-06-19T12:05:00Z",
				turnCount: 5,
				selected: false,
				previewLines: []
			})
		];
	}

	static function expectEvent(poll:AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>>):ResumePickerHostEvent {
		return switch poll {
			case Ready(item, _, _): item.value;
			case _: throw "expected host event";
		}
	}
}
