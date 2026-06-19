package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerDensity;
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
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;
import codexhx.runtime.tui.resume.host.TempHomeResumePickerConfigPersistence;
import sys.io.File;

class ResumePickerNoCredentialGate {
	public static function run(codexHome:String):ResumePickerNoCredentialGateReport {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final persistence = new TempHomeResumePickerConfigPersistence(codexHome);
		final state = ResumePickerState.initial();
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;
		var transcriptLoads = 0;
		var keyEvents = 0;

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
			state.loadedRows = 2;
			state.filteredRows = 2;
			state.selectedIndex = 0;
			state.selectedThreadId = "thread-a";
			state.selectedLabel = "Resume kernel";
			state.nextCursor = "cursor-2";
			state.nextCursorPresent = true;
			state.footerProgressLabel = "50%";
			state.emptyStateMessage = "";
		}
		scheduler.requestFrame("page-loaded");
		renderer.render(state);

		final keys = [
			new ResumePickerNoCredentialKeyEvent({kind: ResumePickerNoCredentialKeyKind.Down, keyName: "Down"}),
			new ResumePickerNoCredentialKeyEvent({kind: ResumePickerNoCredentialKeyKind.OpenTranscript, keyName: "Enter"}),
			new ResumePickerNoCredentialKeyEvent({kind: ResumePickerNoCredentialKeyKind.ToggleDensity, keyName: "d"})
		];

		for (key in keys) {
			keyEvents = keyEvents + 1;
			switch key.kind {
				case ResumePickerNoCredentialKeyKind.Down:
					state.selectedIndex = 1;
					state.selectedThreadId = "thread-b";
					state.selectedLabel = "Host facade";
					state.footerProgressLabel = "100%";
					scheduler.requestFrame("key:" + key.keyName);
					renderer.render(state);
				case ResumePickerNoCredentialKeyKind.OpenTranscript:
					state.pendingThreadId = state.selectedThreadId;
					state.transcriptState = "loading";
					state.transcriptLoadingFrameShown = true;
					state.loadingOverlayMessage = "Loading transcript...";
					scheduler.requestFrame("key:" + key.keyName);
					renderer.render(state);
					loader.enqueue(ResumePickerBackgroundRequest.transcriptLoad(transcriptRequest()));
					final transcriptEvent = expectEvent(loader.pollEvent(AsyncContext.fixture("transcript")));
					eventSummaries.push(transcriptEvent.summary());
					if (transcriptEvent.kind == ResumePickerHostEventKind.TranscriptLoaded) {
						transcriptLoads = transcriptLoads + 1;
						state.transcriptState = "loaded";
						state.transcriptCellCount = 3;
						state.overlayOpen = true;
						state.pendingThreadId = "thread-b";
						state.loadingOverlayMessage = "";
					}
					scheduler.requestFrame("transcript-loaded");
					renderer.render(state);
				case ResumePickerNoCredentialKeyKind.ToggleDensity:
					state.density = ResumePickerDensity.Dense;
					final poll = persistence.persistDensity(state.density).poll(AsyncContext.fixture("persist-density"));
					switch poll {
						case Ready(outcome, _, _):
							if (!outcome.ok) throw "density persistence failed: " + outcome.summary();
						case _:
							throw "density persistence did not complete";
					}
					scheduler.requestFrame("key:" + key.keyName);
					renderer.render(state);
				case ResumePickerNoCredentialKeyKind.Unknown:
			}
		}

		final configText = File.getContent(persistence.configPath());
		return new ResumePickerNoCredentialGateReport({
			pageLoads: pageLoads,
			transcriptLoads: transcriptLoads,
			keyEvents: keyEvents,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			overlayOpened: state.overlayOpen,
			densityPersisted: configText.indexOf("session_picker_view = \"dense\"") >= 0,
			configPath: persistence.configPath(),
			configText: configText,
			finalSummary: state.summary(),
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

	static function transcriptRequest():ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: "transcript-1",
			threadId: "thread-b",
			includeTurns: true,
			previewOnly: false,
			maxPreviewLines: 0
		});
	}

	static function fixtureSource():InMemoryResumePickerThreadSource {
		final source = new InMemoryResumePickerThreadSource();
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
			requestId: "transcript-1",
			threadId: "thread-b",
			previewLines: [],
			transcriptCells: ["user: continue", "assistant: host facade ready", "plan: render gate"],
			truncated: false
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
