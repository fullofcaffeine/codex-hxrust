package codexhx.runtime.tui.resume.live;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerDensity;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.InMemoryResumePickerConfigPersistence;
import codexhx.runtime.tui.resume.host.ResumePickerHostOutcome;
import codexhx.runtime.tui.resume.host.TempHomeResumePickerConfigPersistence;
import sys.io.File;

class ResumePickerDensityPersistenceRenderGate {
	public static function run(codexHome:String):ResumePickerDensityPersistenceRenderGateReport {
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final successState = baseState();
		final persistence = new TempHomeResumePickerConfigPersistence(codexHome);

		successState.density = ResumePickerDensity.Dense;
		final successOutcome = expectReady(persistence.persistDensity(successState.density).poll(AsyncContext.fixture("persist-density-success")));
		if (!successOutcome.ok) throw "expected density persistence success: " + successOutcome.summary();
		successState.configPersistenceStatus = "persisted";
		successState.configPersistencePath = persistence.configPath();
		successState.footerProgressLabel = "density saved";
		scheduler.requestFrame("density-persisted");
		renderer.render(successState);
		final successSnapshot = renderer.lastSnapshot();
		final successConfigText = File.getContent(persistence.configPath());

		final failureState = baseState();
		final failingPersistence = new InMemoryResumePickerConfigPersistence(false);
		failureState.density = ResumePickerDensity.Comfortable;
		final failure = expectFailure(failingPersistence.persistDensity(failureState.density).poll(AsyncContext.fixture("persist-density-failure")));
		failureState.inlineErrorShown = true;
		failureState.lastFailureCode = failure.code;
		failureState.lastError = failure.message;
		failureState.configPersistenceStatus = "failed";
		failureState.configPersistencePath = "";
		failureState.footerProgressLabel = "density not saved";
		scheduler.requestFrame("density-persist-failed");
		renderer.render(failureState);

		return new ResumePickerDensityPersistenceRenderGateReport({
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			successConfigPath: persistence.configPath(),
			successConfigText: successConfigText,
			successSnapshot: successSnapshot,
			failureSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			failureCode: failure.code,
			failureMessage: failure.message
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.pageSize = 2;
		state.viewRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-a";
		state.selectedLabel = "Resume kernel";
		state.visibleRows = [
			visibleRow("thread-a", "Resume kernel", 3, true),
			visibleRow("thread-b", "Host facade", 5, false)
		];
		return state;
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

	static function expectReady(poll:AsyncPoll<ResumePickerHostOutcome>):ResumePickerHostOutcome {
		return switch poll {
			case Ready(outcome, _, _): outcome;
			case Pending(_, _): throw "expected density persistence ready, got pending";
			case Failed(error, _, _): throw "expected density persistence ready, got failure: " + error.code;
			case Cancelled(reason, _, _): throw "expected density persistence ready, got cancellation: " + reason;
			case Closed(_, _): throw "expected density persistence ready, got closed";
			case Backpressured(error, _, _): throw "expected density persistence ready, got backpressure: " + error.code;
		}
	}

	static function expectFailure(poll:AsyncPoll<ResumePickerHostOutcome>):{final code:String; final message:String;} {
		return switch poll {
			case Failed(error, _, _): {code: error.code, message: error.message};
			case Ready(outcome, _, _): throw "expected density persistence failure, got ready: " + outcome.summary();
			case Pending(_, _): throw "expected density persistence failure, got pending";
			case Cancelled(reason, _, _): throw "expected density persistence failure, got cancellation: " + reason;
			case Closed(_, _): throw "expected density persistence failure, got closed";
			case Backpressured(error, _, _): throw "expected density persistence failure, got backpressure: " + error.code;
		}
	}
}
