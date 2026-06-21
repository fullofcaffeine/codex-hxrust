package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoff;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffPolicy {
	final log:Array<String>;

	public function new() {
		this.log = [];
	}

	public function handoff(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionRenderGateReport):ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoff {
		final noLeftoverScheduledRenderRequest = report.sourceSchedulerRequestCount == 1
			&& report.consumedScheduledRequestCount == report.sourceSchedulerRequestCount;
		final ready = report.executionKind == ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind.LocalRenderExecuted
			&& report.executionRequested
			&& report.rendered
			&& report.renderedSnapshotMatchesSchedule
			&& report.renderCount == 1
			&& noLeftoverScheduledRenderRequest
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
		final out = new ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoff({
			kind: ready ? ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffKind.RenderedIdleListReady : ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffKind.RenderedStateHandoffRejected,
			sourceExecutionKind: report.executionKind,
			postRenderIdleListReady: ready,
			keyboardInputReady: ready,
			listNavigationReady: ready,
			noLeftoverScheduledRenderRequest: noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: report.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: report.consumedScheduledRequestCount,
			renderCount: report.renderCount,
			renderedSnapshotPreserved: report.renderedSnapshotMatchesSchedule,
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
			finalSnapshot: report.renderedSnapshot,
			reason: ready ? "post_completion_rendered_state_handed_to_idle_list" : "post_completion_rendered_state_handoff_rejected"
		});
		log.push("renderedStateHandoff:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
