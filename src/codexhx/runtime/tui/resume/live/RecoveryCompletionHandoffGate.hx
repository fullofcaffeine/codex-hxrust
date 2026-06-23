package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoffKind;

class RecoveryCompletionHandoffGate {
	public static function run():RecoveryCompletionHandoffReport {
		final replayReport = RecoveryRenderSnapshotReplayGate.run();
		final policy = new RecoveryCompletionHandoffPolicy();
		final handoff = policy.handoff(replayReport);
		return new RecoveryCompletionHandoffReport({
			handoffKind: handoff.kind,
			handoffSummary: handoff.summary(),
			completionReady: handoff.kind == RecoveryReplayCompletionHandoffKind.CompletedRecoveredSelection,
			replayCount: handoff.replayCount,
			finalThreadId: handoff.finalThreadId,
			finalFooterStable: handoff.finalFooterStable,
			finalSelectionRestored: handoff.finalSelectionRestored,
			snapshotOrderPreserved: handoff.snapshotOrderPreserved,
			selectedMarkersPreserved: handoff.selectedMarkersPreserved,
			footerSummariesPreserved: handoff.footerSummariesPreserved,
			stalePromptActionInactive: handoff.stalePromptActionInactive,
			staleSideParentActionInactive: handoff.staleSideParentActionInactive,
			staleActiveThreadActionInactive: handoff.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: handoff.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: handoff.noPressureDropRejection,
			liveTransportSuppressed: handoff.liveTransportSuppressed,
			liveTerminalSuppressed: handoff.liveTerminalSuppressed,
			stateDbUntouched: handoff.stateDbUntouched,
			nextSliceReady: handoff.nextSliceReady,
			finalSnapshot: replayReport.finalSnapshot,
			replaySummary: replayReport.summary(),
			handoffLogSummaries: policy.summaries()
		});
	}
}
