package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoff;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffPolicy {
	final log:Array<String>;

	public function new() {
		this.log = [];
	}

	public function handoff(report:ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderGateReport):ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoff {
		final finalFooter = "footer keyboard move_up selected=0 selectedThread=thread-surface-a";
		final finalSelectionRestored = report.finalThreadId == "thread-surface-a"
			&& containsText(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		final finalFooterStable = containsText(report.finalSnapshot, finalFooter);
		final completed = report.replayCount == 2
			&& report.sourceRenderStateCount == 2
			&& report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved
			&& report.footerSummariesPreserved
			&& finalSelectionRestored
			&& finalFooterStable
			&& report.stalePromptActionInactive
			&& report.staleSideParentActionInactive
			&& report.staleActiveThreadActionInactive
			&& report.ignoredNoSurfaceRecordsAbsent
			&& report.noPressureDropRejection
			&& report.liveTransportSuppressed
			&& report.liveTerminalSuppressed
			&& report.stateDbUntouched;
		final out = new ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoff({
			kind: completed ? ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind.CompletedRecoveredSelection : ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind.CompletionRejected,
			completed: completed,
			replayCount: report.replayCount,
			finalThreadId: report.finalThreadId,
			finalFooter: finalFooter,
			finalSelectionRestored: finalSelectionRestored,
			finalFooterStable: finalFooterStable,
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
			reason: completed ? "recovery_replay_completed_for_next_slice" : "recovery_replay_completion_rejected"
		});
		log.push("completion:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	static function containsText(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
