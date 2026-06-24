package codexhx.validation.tui.resume.live;

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
import codexhx.runtime.tui.resume.host.ResumePickerThreadRow;

class InvalidRowProjectionGate {
	public static function run():InvalidRowProjectionReport {
		final source = fixtureSource();
		final loader = new DeterministicBackgroundLoader(source, 4);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final eventSummaries:Array<String> = [];
		var pageLoads = 0;

		scheduler.requestFrame("open");
		renderer.render(state);

		loader.enqueue(ResumePickerBackgroundRequest.pageLoad(pageRequest()));
		final event = expectEvent(loader.pollEvent(AsyncContext.fixture("projection-page")));
		eventSummaries.push(event.summary());
		if (event.kind == ResumePickerHostEventKind.PageLoaded) {
			pageLoads = pageLoads + 1;
			applyProjectedPage(state);
		}
		scheduler.requestFrame("invalid-row-projection");
		renderer.render(state);

		return new InvalidRowProjectionReport({
			pageLoads: pageLoads,
			scannedRows: state.scannedRows,
			acceptedRows: state.acceptedRows,
			invalidRows: state.invalidRows,
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			eventSummaries: eventSummaries
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.pageSize = 5;
		state.viewRows = 5;
		state.footerProgressLabel = "open";
		state.emptyStateMessage = "Loading saved chats...";
		return state;
	}

	static function applyProjectedPage(state:ResumePickerState):Void {
		state.scannedRows = 5;
		state.acceptedRows = 3;
		state.invalidRows = 2;
		state.loadedRows = 3;
		state.filteredRows = 3;
		state.selectedIndex = 1;
		state.selectedThreadId = "thread-preview";
		state.visibleRows = [
			visibleRow(row("thread-named", "Named thread", "/workspace/codex-hxrust", "2026-06-19T12:00:00Z", 4), false,
				["upstream name overrides raw preview"]),
			visibleRow(row("thread-preview", "assistant: trimmed preview", "/workspace/codex-hxrust/crates/codex", "2026-06-19T12:10:00Z", 7), true,
				["assistant: trimmed preview"]),
			visibleRow(row("thread-empty", "(no message yet)", "/tmp/empty-session", "2026-06-19T12:20:00Z", 0), false, ["(no message yet)"])
		];
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.moreBelow = false;
		state.emptyStateMessage = "";
		state.loaderEventStatus = "invalid_rows_skipped";
		state.loaderEventDetail = "invalid=2;accepted=3;scanned=5";
		state.footerProgressLabel = "accepted 3/5";
	}

	static function pageRequest():ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: "projection-page",
			cursor: "",
			query: "",
			pageSize: 5,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.Cwd,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: false,
			includeNonInteractive: false
		});
	}

	static function fixtureSource():InMemoryThreadSource {
		final source = new InMemoryThreadSource();
		source.addPage(new ResumePickerThreadListResponse({
			requestId: "projection-page",
			rows: [
				row("thread-named", "Named thread", "/workspace/codex-hxrust", "2026-06-19T12:00:00Z", 4),
				row("thread-preview", "assistant: trimmed preview", "/workspace/codex-hxrust/crates/codex", "2026-06-19T12:10:00Z", 7),
				row("thread-empty", "(no message yet)", "/tmp/empty-session", "2026-06-19T12:20:00Z", 0)
			],
			nextCursor: "",
			scannedRows: 5,
			acceptedRows: 3,
			invalidRows: 2,
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

	static function visibleRow(row:ResumePickerThreadRow, selected:Bool, previewLines:Array<String>):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: row.threadId,
			title: row.title,
			cwd: row.cwd,
			updatedAt: row.updatedAt,
			turnCount: row.turnCount,
			selected: selected,
			previewLines: previewLines
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
