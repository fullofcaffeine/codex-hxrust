package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.CompletionInputIntentKind;

class EighthInputAdmissionGate {
	public static function run():EighthInputAdmissionReport {
		final completionReport = EighthCompletionHandoffGate.run();
		final policy = new EighthInputAdmissionPolicy();
		final admission = policy.admit(completionReport, CompletionInputIntentKind.ConfirmRecoveredSelection);
		return new EighthInputAdmissionReport({
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
			sourceSecondCycleHandoffReplayCount: completionReport.sourceSecondCycleHandoffReplayCount,
			sourceSecondCycleHandoffReadinessDecisionCount: completionReport.sourceSecondCycleHandoffReadinessDecisionCount,
			sourceSecondCycleHandoffRenderStateCount: completionReport.sourceSecondCycleHandoffRenderStateCount,
			sourceSecondCycleHandoffFrameRequests: completionReport.sourceSecondCycleHandoffFrameRequests,
			sourceSecondCycleHandoffKeyboardRenderCount: completionReport.sourceSecondCycleHandoffKeyboardRenderCount,
			sourceThirdCycleHandoffReplayCount: completionReport.sourceThirdCycleHandoffReplayCount,
			sourceThirdCycleHandoffReadinessDecisionCount: completionReport.sourceThirdCycleHandoffReadinessDecisionCount,
			sourceThirdCycleHandoffRenderStateCount: completionReport.sourceThirdCycleHandoffRenderStateCount,
			sourceThirdCycleHandoffFrameRequests: completionReport.sourceThirdCycleHandoffFrameRequests,
			sourceThirdCycleHandoffKeyboardRenderCount: completionReport.sourceThirdCycleHandoffKeyboardRenderCount,
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
			sourceSecondCycleHandoffInputAdmitted: completionReport.sourceHandoffInputAdmitted,
			sourceSecondCycleHandoffLocalOnlyRenderIntent: completionReport.sourceHandoffLocalOnlyRenderIntent,
			sourceThirdCycleHandoffInputAdmitted: completionReport.sourceSecondCycleHandoffInputAdmitted,
			sourceThirdCycleHandoffLocalOnlyRenderIntent: completionReport.sourceSecondCycleHandoffLocalOnlyRenderIntent,
			sourceFourthCycleHandoffInputAdmitted: completionReport.sourceFourthCycleHandoffInputAdmitted,
			sourceFourthCycleHandoffLocalOnlyRenderIntent: completionReport.sourceFourthCycleHandoffLocalOnlyRenderIntent,
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
