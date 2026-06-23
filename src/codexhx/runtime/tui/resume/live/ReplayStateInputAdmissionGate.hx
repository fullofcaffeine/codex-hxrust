package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.CompletionInputIntentKind;

class ReplayStateInputAdmissionGate {
	public static function run():ReplayStateInputAdmissionReport {
		final completionReport = ReplayStateCompletionHandoffGate.run();
		final policy = new ReplayStateInputAdmissionPolicy();
		final admission = policy.admit(completionReport, CompletionInputIntentKind.ConfirmRecoveredSelection);
		return new ReplayStateInputAdmissionReport({
			admissionKind: admission.kind,
			admissionSummary: admission.summary(),
			inputAdmitted: admission.kind == CompletionInputAdmissionKind.InputAdmitted,
			sourceReadinessDecisionCount: completionReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: completionReport.sourceRenderStateCount,
			sourceFrameRequests: completionReport.sourceFrameRequests,
			sourceKeyboardRenderCount: completionReport.sourceKeyboardRenderCount,
			replayCount: completionReport.replayCount,
			sourceReplayCount: completionReport.sourceReplayCount,
			sourceHandoffReplayCount: completionReport.sourceHandoffReplayCount,
			sourceHandoffReadinessDecisionCount: completionReport.sourceHandoffReadinessDecisionCount,
			sourceHandoffRenderStateCount: completionReport.sourceHandoffRenderStateCount,
			sourceHandoffFrameRequests: completionReport.sourceHandoffFrameRequests,
			sourceHandoffKeyboardRenderCount: completionReport.sourceHandoffKeyboardRenderCount,
			finalThreadId: admission.finalThreadId,
			finalFooter: admission.finalFooter,
			finalSelectionPreserved: admission.finalSelectionPreserved,
			finalFooterPreserved: admission.finalFooterPreserved,
			completionReady: admission.completionReady,
			nextSliceReady: admission.nextSliceReady,
			snapshotOrderPreserved: completionReport.snapshotOrderPreserved,
			selectedMarkersPreserved: completionReport.selectedMarkersPreserved,
			footerSummariesPreserved: completionReport.footerSummariesPreserved,
			selectedMarkerMoved: completionReport.selectedMarkerMoved,
			recoveredSelectionRestored: completionReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: completionReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: completionReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: completionReport.consumedScheduledRequestCount,
			sourcePostRenderRenderCount: completionReport.sourcePostRenderRenderCount,
			renderedSnapshotPreserved: completionReport.renderedSnapshotPreserved,
			sourceRenderedSnapshotPreserved: completionReport.sourceRenderedSnapshotPreserved,
			sourceInputAdmitted: completionReport.inputAdmitted,
			sourceLocalOnlyRenderIntent: completionReport.localOnlyRenderIntent,
			sourceHandoffInputAdmitted: completionReport.sourceInputAdmitted,
			sourceHandoffLocalOnlyRenderIntent: completionReport.sourceLocalOnlyRenderIntent,
			stalePromptActionInactive: admission.stalePromptActionInactive,
			staleSideParentActionInactive: admission.staleSideParentActionInactive,
			staleActiveThreadActionInactive: admission.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: admission.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: admission.noPressureDropRejection,
			liveTransportSuppressed: admission.liveTransportSuppressed,
			liveTerminalSuppressed: admission.liveTerminalSuppressed,
			stateDbUntouched: admission.stateDbUntouched,
			noModelCall: admission.noModelCall,
			noFilesystemMutation: admission.noFilesystemMutation,
			finalSnapshot: completionReport.finalSnapshot,
			completionSummary: completionReport.summary(),
			admissionLogSummaries: policy.summaries()
		});
	}
}
