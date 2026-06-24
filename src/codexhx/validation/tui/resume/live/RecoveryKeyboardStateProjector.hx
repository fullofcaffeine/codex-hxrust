package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardRenderState;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardRenderStateKind;

class RecoveryKeyboardStateProjector {
	final scheduler:DeterministicFrameScheduler;
	final renderer:DeterministicTerminalRenderer;
	final states:Array<RecoveryKeyboardRenderState>;

	public function new() {
		this.scheduler = new DeterministicFrameScheduler();
		this.renderer = new DeterministicTerminalRenderer();
		this.states = [];
	}

	public function project(decision:RecoveryKeyboardDecision):RecoveryKeyboardRenderState {
		final state = baseState();
		state.selectedIndex = decision.selectedAfter;
		state.selectedThreadId = decision.threadAfter;
		state.selectedLabel = labelFor(decision.threadAfter);
		state.visibleRows = visibleRows(decision.selectedAfter);
		state.footerProgressLabel = "keyboard " + decision.intent;
		scheduler.requestFrame("recovery-keyboard-render-state-" + decision.sequence);
		renderer.render(state);

		final renderState = new RecoveryKeyboardRenderState({kind: RecoveryKeyboardRenderStateKind.NavigationRenderState,
			intent: decision.intent,
			sequence: decision.sequence,
			selectedIndex: state.selectedIndex,
			selectedThreadId: state.selectedThreadId,
			selectedLabel: state.selectedLabel,
			selectedMarker: "> "
			+ state.selectedLabel
			+ " | "
			+ state.selectedThreadId,
			footerLabel: state.footerProgressLabel,
			navigationApplied: decision.navigationApplied,
			recoveredThreadRestored: state.selectedThreadId == "thread-surface-a",
			stalePromptActionInactive: decision.promptActionInactive,
			staleSideParentActionInactive: decision.sideParentActionInactive,
			staleActiveThreadActionInactive: decision.activeThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: decision.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: decision.noPressureDropRejection,
			liveTransportSuppressed: decision.liveTransportSuppressed,
			liveTerminalSuppressed: true,
			stateDbUntouched: decision.stateDbUntouched,
			snapshot: renderer.lastSnapshot(),
			reason: "recovery_keyboard_render_state_projected"
		});
		states.push(renderState);
		return renderState;
	}

	public function frameRequests():Int {
		return scheduler.requestCount();
	}

	public function renderCount():Int {
		return renderer.renderCount();
	}

	public function renderSnapshots():Array<String> {
		return renderer.allSnapshots();
	}

	public function renderStateSummaries():Array<String> {
		final out:Array<String> = [];
		for (state in states)
			out.push(state.summary());
		return out;
	}

	function baseState():ResumePickerState {
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
		state.footerHintMode = "keyboard";
		state.footerWidth = 80;
		return state;
	}

	function visibleRows(selectedIndex:Int):Array<ResumePickerVisibleRow> {
		return [
			visibleRow("thread-surface-a", "Recovered surface thread", 8, selectedIndex == 0),
			visibleRow("thread-surface-b", "Recovered navigation target", 13, selectedIndex == 1)
		];
	}

	function visibleRow(threadId:String, title:String, turnCount:Int, selected:Bool):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: title,
			cwd: "/workspace/codex-hxrust",
			updatedAt: "2026-06-20T08:25:00Z",
			turnCount: turnCount,
			selected: selected,
			previewLines: []
		});
	}

	function labelFor(threadId:String):String {
		return switch threadId {
			case "thread-surface-a": "Recovered surface thread";
			case "thread-surface-b": "Recovered navigation target";
			case _: "";
		}
	}
}
