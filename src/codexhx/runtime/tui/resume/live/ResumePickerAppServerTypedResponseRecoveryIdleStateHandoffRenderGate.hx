package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffKind;

class ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffRenderGateReport {
		final followUpReport = ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGate.run();
		final policy = new DeterministicResumePickerAppServerTypedResponseRecoveryIdleStateHandoffPolicy();
		final handoff = policy.handoff(followUpReport);
		return new ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffRenderGateReport({
			handoffKind: handoff.kind,
			handoffSummary: handoff.summary(),
			idleListReady: handoff.kind == ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffKind.IdleListReady,
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
