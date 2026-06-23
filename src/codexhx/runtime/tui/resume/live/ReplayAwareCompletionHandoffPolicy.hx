package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoff;
import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoffKind;

class ReplayAwareCompletionHandoffPolicy {
	final log:Array<String>;

	public function new() {
		this.log = [];
	}

	public function handoff(report:ReplayAwareSnapshotReplayReport):RecoveryReplayCompletionHandoff {
		final completed = report.replayCount == 2
			&& report.sourceReplayCount == 2
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
			reason: completed ? "post_completion_post_render_replay_aware_replay_completed_for_next_slice" : "post_completion_post_render_replay_aware_replay_completion_rejected"
		});
		log.push("post-render-replay-aware-completion:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
