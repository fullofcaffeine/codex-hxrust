package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.SurfaceRecoveryConfirmationKind;

class SurfaceRecoveryConfirmationGate {
	public static function run():SurfaceRecoveryConfirmationReport {
		final surfaceReport = ReplaySurfaceUpdateGate.run();
		final confirmer = new SurfaceRecoveryConfirmer();
		final confirmation = confirmer.confirm(surfaceReport);
		return new SurfaceRecoveryConfirmationReport({
			confirmationKind: confirmation.kind,
			confirmationSummary: confirmation.summary(),
			recoveryConfirmed: confirmation.kind == SurfaceRecoveryConfirmationKind.RecoveryConfirmed,
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
