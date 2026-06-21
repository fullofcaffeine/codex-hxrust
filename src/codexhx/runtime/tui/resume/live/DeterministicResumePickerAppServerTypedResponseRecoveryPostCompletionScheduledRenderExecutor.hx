package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecution;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostOutcomeKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutor {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function execute(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGateReport,
			renderer:DeterministicResumePickerTerminalRenderer):ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecution {
		final ready = report.scheduleKind == ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind.LocalRenderScheduled
			&& report.scheduleRequested
			&& report.scheduled
			&& report.scheduleSequence == nextSequence
			&& report.schedulerRequestCount == 1
			&& report.localOnlyRenderIntent
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.inputAdmitted
			&& report.stalePromptActionInactive
			&& report.staleSideParentActionInactive
			&& report.staleActiveThreadActionInactive
			&& report.ignoredNoSurfaceRecordsAbsent
			&& report.noPressureDropRejection
			&& report.liveTransportSuppressed
			&& report.liveTerminalSuppressed
			&& report.stateDbUntouched
			&& report.noModelCall
			&& report.noFilesystemMutation;
		final execution = ready ? executeReady(report, renderer) : rejected(report, renderer);
		nextSequence = nextSequence + 1;
		log.push("scheduledRenderExecution:" + execution.summary());
		return execution;
	}

	function executeReady(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGateReport,
			renderer:DeterministicResumePickerTerminalRenderer):ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecution {
		final outcome = renderer.render(recoveredState());
		final renderedSnapshot = renderer.lastSnapshot();
		final snapshotMatchesSchedule = renderedSnapshot == report.finalSnapshot;
		final rendered = outcome.ok
			&& outcome.kind == ResumePickerHostOutcomeKind.Rendered
			&& outcome.pendingCount == 1
			&& renderer.renderCount() == 1
			&& snapshotMatchesSchedule;
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecution({
			kind: rendered ? ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind.LocalRenderExecuted : ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind.RenderExecutionRejected,
			sourceScheduleKind: report.scheduleKind,
			executionRequested: true,
			rendered: rendered,
			executionSequence: nextSequence,
			sourceSchedulerRequestCount: report.schedulerRequestCount,
			consumedScheduledRequestCount: rendered ? 1 : 0,
			renderCount: renderer.renderCount(),
			renderOutcomeKind: outcome.kind,
			renderOutcomePendingCount: outcome.pendingCount,
			renderedSnapshotMatchesSchedule: snapshotMatchesSchedule,
			finalThreadId: report.finalThreadId,
			finalFooter: "footer keyboard move_up selected=0 selectedThread=thread-surface-a",
			finalSelectionPreserved: report.finalSelectionPreserved,
			finalFooterPreserved: report.finalFooterPreserved,
			inputAdmitted: report.inputAdmitted,
			localOnlyRenderIntent: report.localOnlyRenderIntent,
			stalePromptActionInactive: report.stalePromptActionInactive,
			staleSideParentActionInactive: report.staleSideParentActionInactive,
			staleActiveThreadActionInactive: report.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			liveTerminalSuppressed: report.liveTerminalSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			noModelCall: report.noModelCall,
			noFilesystemMutation: report.noFilesystemMutation,
			renderedSnapshot: renderedSnapshot,
			reason: rendered ? "post_completion_local_render_request_executed" : "post_completion_local_render_request_execution_failed"
		});
	}

	function rejected(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGateReport,
			renderer:DeterministicResumePickerTerminalRenderer):ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecution {
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecution({
			kind: ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind.RenderExecutionRejected,
			sourceScheduleKind: report.scheduleKind,
			executionRequested: false,
			rendered: false,
			executionSequence: nextSequence,
			sourceSchedulerRequestCount: report.schedulerRequestCount,
			consumedScheduledRequestCount: 0,
			renderCount: renderer.renderCount(),
			renderOutcomeKind: ResumePickerHostOutcomeKind.Unknown,
			renderOutcomePendingCount: 0,
			renderedSnapshotMatchesSchedule: false,
			finalThreadId: report.finalThreadId,
			finalFooter: "",
			finalSelectionPreserved: report.finalSelectionPreserved,
			finalFooterPreserved: report.finalFooterPreserved,
			inputAdmitted: report.inputAdmitted,
			localOnlyRenderIntent: report.localOnlyRenderIntent,
			stalePromptActionInactive: report.stalePromptActionInactive,
			staleSideParentActionInactive: report.staleSideParentActionInactive,
			staleActiveThreadActionInactive: report.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			liveTerminalSuppressed: report.liveTerminalSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			noModelCall: report.noModelCall,
			noFilesystemMutation: report.noFilesystemMutation,
			renderedSnapshot: "",
			reason: "post_completion_local_render_request_execution_rejected"
		});
	}

	function recoveredState():ResumePickerState {
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
		state.selectedThreadId = "thread-surface-a";
		state.selectedLabel = "Recovered surface thread";
		state.footerProgressLabel = "keyboard move_up";
		state.footerHintMode = "keyboard";
		state.footerWidth = 80;
		state.visibleRows = [
			visibleRow("thread-surface-a", "Recovered surface thread", 8, true),
			visibleRow("thread-surface-b", "Recovered navigation target", 13, false)
		];
		return state;
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

	public function summaries():Array<String> {
		return log.copy();
	}
}
