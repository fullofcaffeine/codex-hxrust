package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryIdleStateHandoffKind;

class RecoveryIdleStateHandoffGate {
	public static function run():RecoveryIdleStateHandoffReport {
		final followUpReport = RecoveryFollowUpActionGate.run();
		final policy = new RecoveryIdleStateHandoffPolicy();
		final handoff = policy.handoff(followUpReport);
		return new RecoveryIdleStateHandoffReport({
			handoffKind: handoff.kind,
			handoffSummary: handoff.summary(),
			idleListReady: handoff.kind == RecoveryIdleStateHandoffKind.IdleListReady,
			recoveredThreadId: handoff.recoveredThreadId,
			keyboardInputReady: handoff.keyboardInputReady,
			listNavigationReady: handoff.listNavigationReady,
			promptActionCleared: handoff.promptActionCleared,
			sideParentActionCleared: handoff.sideParentActionCleared,
			activeThreadActionCleared: handoff.activeThreadActionCleared,
			restoredStatusAccepted: handoff.restoredStatusAccepted,
			frameRequestAccepted: handoff.frameRequestAccepted,
			selectionAccepted: handoff.selectionAccepted,
			ignoredNoSurfaceRecordsAbsent: handoff.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: handoff.noPressureDropRejection,
			liveTransportSuppressed: handoff.liveTransportSuppressed,
			stateDbUntouched: handoff.stateDbUntouched,
			finalSnapshot: followUpReport.finalSnapshot,
			actionSummaries: followUpReport.actionSummaries,
			handoffLogSummaries: policy.summaries()
		});
	}
}
