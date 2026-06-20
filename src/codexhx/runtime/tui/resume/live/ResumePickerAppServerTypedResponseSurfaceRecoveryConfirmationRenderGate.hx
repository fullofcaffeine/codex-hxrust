package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind;

class ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationRenderGate {
	public static function run():ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationRenderGateReport {
		final surfaceReport = ResumePickerAppServerTypedResponseReplaySurfaceUpdateRenderGate.run();
		final confirmer = new DeterministicResumePickerAppServerTypedResponseSurfaceRecoveryConfirmer();
		final confirmation = confirmer.confirm(surfaceReport);
		return new ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationRenderGateReport({
			confirmationKind: confirmation.kind,
			confirmationSummary: confirmation.summary(),
			recoveryConfirmed: confirmation.kind == ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind.RecoveryConfirmed,
			surfaceUpdateCount: surfaceReport.surfaceUpdateCount,
			recoveryFrameIndex: confirmation.recoveryFrameIndex,
			recoveredThreadId: confirmation.recoveredThreadId,
			recoveredFooterLabel: confirmation.recoveredFooterLabel,
			recoveredLoaderStatus: confirmation.recoveredLoaderStatus,
			pendingInteractiveSurfaceCleared: confirmation.pendingInteractiveSurfaceCleared,
			sideParentSurfaceCleared: confirmation.sideParentSurfaceCleared,
			activeThreadSurfaceReplaced: confirmation.activeThreadSurfaceReplaced,
			staleSurfaceLoaderAbsent: confirmation.staleSurfaceLoaderAbsent,
			ignoredNoSurfaceRecordsAbsent: confirmation.ignoredNoSurfaceRecordsAbsent,
			recoveryPageDecoded: confirmation.recoveryPageDecoded,
			recoverySelectionPreserved: confirmation.recoverySelectionPreserved,
			noPressureDropRejection: confirmation.noPressureDropRejection,
			liveTransportSuppressed: confirmation.liveTransportSuppressed,
			stateDbUntouched: confirmation.stateDbUntouched,
			frameRequests: surfaceReport.frameRequests,
			renderCount: surfaceReport.renderCount,
			pageRequests: surfaceReport.pageRequests,
			readRequests: surfaceReport.readRequests,
			finalSnapshot: surfaceReport.finalSnapshot,
			confirmationLogSummaries: confirmer.summaries(),
			stateSummaries: surfaceReport.stateSummaries,
			surfaceUpdateSummaries: surfaceReport.surfaceUpdateSummaries
		});
	}
}
