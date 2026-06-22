package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderedStateHandoff;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateHandoffPolicy {
	static final FinalFooter = "footer keyboard move_up selected=0 selectedThread=thread-surface-a";

	final log:Array<String>;

	public function new() {
		this.log = [];
	}

	public function handoff(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareScheduledRenderExecutionRenderGateReport):ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderedStateHandoff {
		final noLeftoverScheduledRenderRequest = report.noLeftoverScheduledRenderRequest
			&& report.sourceSchedulerRequestCount == 1
			&& report.consumedScheduledRequestCount == report.sourceSchedulerRequestCount;
		final replayEvidencePreserved = report.replayCount == 2 && report.sourceReplayCount == 2 && report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved && report.footerSummariesPreserved && report.selectedMarkerMoved && report.recoveredSelectionRestored;
		final sourceRenderEvidencePreserved = report.sourceReadinessDecisionCount == 2
			&& report.sourceRenderStateCount == 2
			&& report.sourceFrameRequests == 2
			&& report.sourceKeyboardRenderCount == 2;
		final preExecutionEvidencePreserved = report.sourcePreExecutionSchedulerRequestCount == 1
			&& report.sourcePreExecutionConsumedRequestCount == 1
			&& report.sourcePreExecutionRenderCount == 1
			&& report.sourceRenderedSnapshotPreserved
			&& report.sourceInputAdmitted
			&& report.sourceLocalOnlyRenderIntent;
		final ready = report.executionKind == ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind.LocalRenderExecuted
			&& report.executionRequested
			&& report.rendered
			&& report.renderedSnapshotMatchesSchedule
			&& report.renderCount == 1
			&& noLeftoverScheduledRenderRequest
			&& report.localOnlyRenderIntent
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalFooter == FinalFooter
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.inputAdmitted
			&& replayEvidencePreserved
			&& sourceRenderEvidencePreserved
			&& preExecutionEvidencePreserved
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
		final out = new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderedStateHandoff({
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
			finalFooter: report.finalFooter,
			finalSelectionPreserved: report.finalSelectionPreserved,
			finalFooterPreserved: report.finalFooterPreserved,
			inputAdmitted: report.inputAdmitted,
			localOnlyRenderIntent: report.localOnlyRenderIntent,
			replayCount: report.replayCount,
			snapshotOrderPreserved: report.snapshotOrderPreserved,
			selectedMarkersPreserved: report.selectedMarkersPreserved,
			footerSummariesPreserved: report.footerSummariesPreserved,
			selectedMarkerMoved: report.selectedMarkerMoved,
			recoveredSelectionRestored: report.recoveredSelectionRestored,
			sourcePreExecutionSchedulerRequestCount: report.sourcePreExecutionSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: report.sourcePreExecutionConsumedRequestCount,
			sourcePreExecutionRenderCount: report.sourcePreExecutionRenderCount,
			sourceRenderedSnapshotPreserved: report.sourceRenderedSnapshotPreserved,
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
			reason: ready ? "post_completion_post_render_replay_aware_rendered_state_handed_to_idle_list" : "post_completion_post_render_replay_aware_rendered_state_handoff_rejected"
		});
		log.push("postRenderReplayAwareRenderedStateHandoff:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
