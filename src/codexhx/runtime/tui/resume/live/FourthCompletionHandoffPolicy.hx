package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoff;
import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoffKind;

class FourthCompletionHandoffPolicy {
	final log:Array<String>;

	public function new() {
		this.log = [];
	}

	public function handoff(report:FourthSnapshotReplayReport):RecoveryReplayCompletionHandoff {
		final completed = report.replayCount == 2
			&& report.sourceReplayCount == 2
			&& report.sourceHandoffReplayCount == 2
			&& report.sourceHandoffReadinessDecisionCount == 2
			&& report.sourceHandoffRenderStateCount == 2
			&& report.sourceHandoffFrameRequests == 2
			&& report.sourceHandoffKeyboardRenderCount == 2
			&& report.sourceSecondCycleHandoffReplayCount == 2
			&& report.sourceSecondCycleHandoffReadinessDecisionCount == 2
			&& report.sourceSecondCycleHandoffRenderStateCount == 2
			&& report.sourceSecondCycleHandoffFrameRequests == 2
			&& report.sourceSecondCycleHandoffKeyboardRenderCount == 2
			&& report.sourceThirdCycleHandoffReplayCount == 2
			&& report.sourceThirdCycleHandoffReadinessDecisionCount == 2
			&& report.sourceThirdCycleHandoffRenderStateCount == 2
			&& report.sourceThirdCycleHandoffFrameRequests == 2
			&& report.sourceThirdCycleHandoffKeyboardRenderCount == 2
			&& report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved
			&& report.footerSummariesPreserved
			&& report.selectedMarkerMoved
			&& report.recoveredSelectionRestored
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalFooter == "footer keyboard move_up selected=0 selectedThread=thread-surface-a"
			&& report.noLeftoverScheduledRenderRequest
			&& report.renderedSnapshotPreserved
			&& report.sourceRenderedSnapshotPreserved
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.inputAdmitted
			&& report.localOnlyRenderIntent
			&& report.completionReady
			&& report.nextSliceReady
			&& report.sourceInputAdmitted
			&& report.sourceLocalOnlyRenderIntent
			&& report.sourceHandoffInputAdmitted
			&& report.sourceHandoffLocalOnlyRenderIntent
			&& report.sourceSecondCycleHandoffInputAdmitted
			&& report.sourceSecondCycleHandoffLocalOnlyRenderIntent
			&& report.sourceThirdCycleHandoffInputAdmitted
			&& report.sourceThirdCycleHandoffLocalOnlyRenderIntent
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
		final out = new RecoveryReplayCompletionHandoff({
			kind: completed ? RecoveryReplayCompletionHandoffKind.CompletedRecoveredSelection : RecoveryReplayCompletionHandoffKind.CompletionRejected,
			completed: completed,
			replayCount: report.replayCount,
			finalThreadId: report.finalThreadId,
			finalFooter: report.finalFooter,
			finalSelectionRestored: report.recoveredSelectionRestored && report.finalSelectionPreserved,
			finalFooterStable: report.finalFooterPreserved,
			snapshotOrderPreserved: report.snapshotOrderPreserved,
			selectedMarkersPreserved: report.selectedMarkersPreserved,
			footerSummariesPreserved: report.footerSummariesPreserved,
			stalePromptActionInactive: report.stalePromptActionInactive,
			staleSideParentActionInactive: report.staleSideParentActionInactive,
			staleActiveThreadActionInactive: report.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			liveTerminalSuppressed: report.liveTerminalSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			nextSliceReady: completed,
			reason: completed ? "post_completion_post_render_replay_aware_rendered_state_fourth_cycle_replay_completed_for_next_slice" : "post_completion_post_render_replay_aware_rendered_state_fourth_cycle_replay_completion_rejected"
		});
		log.push("post-render-replay-aware-rendered-state-fourth-cycle-completion:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
