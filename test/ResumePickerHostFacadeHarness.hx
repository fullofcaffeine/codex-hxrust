import codexhx.runtime.asyncruntime.AsyncCancelReason;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.tui.resume.ResumePickerDensity;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerBackgroundLoader;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.InMemoryResumePickerConfigPersistence;
import codexhx.runtime.tui.resume.host.InMemoryResumePickerThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerBackgroundRequest;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostFacadeReport;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadResponse;
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class ResumePickerHostFacadeHarness {
	static function main():Void {
		final source = fixtureSource();
		final loader = new DeterministicResumePickerBackgroundLoader(source, 8);
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final persistence = new InMemoryResumePickerConfigPersistence(true);

		assertReadyBool(loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest())));
		assertReadyBool(loader.enqueue(ResumePickerBackgroundRequest.previewLoad(previewRequest())));
		assertReadyBool(loader.enqueue(ResumePickerBackgroundRequest.transcriptLoad(transcriptRequest())));
		assertReadyBool(loader.enqueue(ResumePickerBackgroundRequest.frame("page-loaded")));

		final summaries:Array<String> = [];
		var pageEvents = 0;
		var previewEvents = 0;
		var transcriptEvents = 0;
		var frameEvents = 0;
		var failureEvents = 0;
		var pollCount = 0;
		while (pollCount < 4) {
			final event = expectEvent(loader.pollEvent(AsyncContext.fixture("poll-" + pollCount)));
			summaries.push(event.summary());
			switch event.kind {
				case ResumePickerHostEventKind.PageLoaded:
					pageEvents = pageEvents + 1;
				case ResumePickerHostEventKind.PreviewLoaded:
					previewEvents = previewEvents + 1;
				case ResumePickerHostEventKind.TranscriptLoaded:
					transcriptEvents = transcriptEvents + 1;
				case ResumePickerHostEventKind.FrameRequested:
					frameEvents = frameEvents + 1;
				case ResumePickerHostEventKind.Failed:
					failureEvents = failureEvents + 1;
				case _:
			}
			pollCount = pollCount + 1;
		}

		final frameOutcome = scheduler.requestFrame("after-transcript");
		assertTrue(frameOutcome.ok, "frame scheduler should accept request");

		final renderOutcome = renderer.render(ResumePickerState.initial());
		assertTrue(renderOutcome.ok, "renderer should render deterministic state");

		final persistPoll = persistence.persistDensity(ResumePickerDensity.Dense).poll(AsyncContext.fixture("persist"));
		final persisted = expectPersisted(persistPoll);

		final missingSource = fixtureSource();
		final backpressureLoader = new DeterministicResumePickerBackgroundLoader(missingSource, 1);
		assertReadyBool(backpressureLoader.enqueue(ResumePickerBackgroundRequest.frame("first")));
		final dropped = backpressureLoader.enqueue(ResumePickerBackgroundRequest.frame("second"));
		assertContains(AsyncPollSummary.summary(dropped), "best_effort_dropped");
		assertEquals("1", Std.string(backpressureLoader.skippedCount()), "best-effort drop count");

		final cancelPoll = loader.cancel(AsyncCancelReason.Shutdown);
		assertContains(AsyncPollSummary.summary(cancelPoll), "cancelReason=shutdown");

		final unconfiguredPersistence = new InMemoryResumePickerConfigPersistence(false);
		final persistFailure = unconfiguredPersistence.persistDensity(ResumePickerDensity.Comfortable).poll(AsyncContext.fixture("persist-fail"));
		assertContains(AsyncPollSummary.summary(persistFailure), "persistence_unconfigured");

		final report = new ResumePickerHostFacadeReport({
			pageEvents: pageEvents,
			previewEvents: previewEvents,
			transcriptEvents: transcriptEvents,
			frameEvents: frameEvents,
			failureEvents: failureEvents,
			frameRequests: scheduler.requestCount(),
			renders: renderer.renderCount(),
			persistedDensity: persisted.detail,
			skippedEvents: backpressureLoader.skippedCount(),
			summaries: summaries
		});

		assertEquals("1", Std.string(report.pageEvents), "page events");
		assertEquals("1", Std.string(report.previewEvents), "preview events");
		assertEquals("1", Std.string(report.transcriptEvents), "transcript events");
		assertEquals("1", Std.string(report.frameEvents), "frame events");
		assertEquals("0", Std.string(report.failureEvents), "failure events");
		assertEquals("1", Std.string(report.frameRequests), "frame scheduler request count");
		assertEquals("1", Std.string(report.renders), "render count");
		assertEquals("dense", report.persistedDensity, "persisted density");
		assertContains(report.summary(), "kind=page_loaded");
		assertContains(report.summary(), "kind=preview_loaded");
		assertContains(report.summary(), "kind=transcript_loaded");
		assertContains(report.summary(), "kind=frame_requested");

		Sys.println(report.summary());
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
			requestId: "preview-1",
			threadId: "thread-a",
			previewLines: ["user: hello", "assistant: hi"],
			transcriptCells: [],
			truncated: false
		}));
		source.addRead(new ResumePickerThreadReadResponse({
			requestId: "transcript-1",
			threadId: "thread-a",
			previewLines: [],
			transcriptCells: ["user cell", "assistant cell", "plan cell"],
			truncated: false
		}));
		return source;
	}

	static function pageRequest():ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: "page-1",
			cursor: "",
			query: "host",
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

	static function transcriptRequest():ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: "transcript-1",
			threadId: "thread-a",
			includeTurns: true,
			previewOnly: false,
			maxPreviewLines: 0
		});
	}

	static function expectEvent(poll:AsyncPoll<AsyncStreamItem<ResumePickerHostEvent>>):ResumePickerHostEvent {
		return switch poll {
			case Ready(item, _, _): item.value;
			case _: throw "expected host event, got " + AsyncPollSummary.summary(poll);
		}
	}

	static function expectPersisted(poll:AsyncPoll<codexhx.runtime.tui.resume.host.ResumePickerHostOutcome>):codexhx.runtime.tui.resume.host.ResumePickerHostOutcome {
		return switch poll {
			case Ready(outcome, _, _):
				assertTrue(outcome.ok, "persistence should succeed");
				outcome;
			case _: throw "expected persisted outcome, got " + AsyncPollSummary.summary(poll);
		}
	}

	static function assertReadyBool(poll:AsyncPoll<Bool>):Void {
		switch poll {
			case Ready(value, _, _):
				assertTrue(value, "expected accepted enqueue");
			case _:
				throw "expected ready bool, got " + AsyncPollSummary.summary(poll);
		}
	}

	static function assertContains(value:String, needle:String):Void {
		if (value.indexOf(needle) < 0)
			throw "expected `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}
