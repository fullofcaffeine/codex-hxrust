package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputAdmissionRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputAdmissionRenderGateReport {
		final completionReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayCompletionHandoffRenderGate.run();
		final policy = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputAdmissionPolicy();
		final admission = policy.admit(completionReport, ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind.ConfirmRecoveredSelection);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputAdmissionRenderGateReport({
			admissionKind: admission.kind,
			admissionSummary: admission.summary(),
			inputAdmitted: admission.kind == ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind.InputAdmitted,
			finalThreadId: admission.finalThreadId,
			finalFooter: admission.finalFooter,
			finalSelectionPreserved: admission.finalSelectionPreserved,
			finalFooterPreserved: admission.finalFooterPreserved,
			completionReady: admission.completionReady,
			nextSliceReady: admission.nextSliceReady,
			replayCount: completionReport.replayCount,
			snapshotOrderPreserved: completionReport.snapshotOrderPreserved,
			selectedMarkersPreserved: completionReport.selectedMarkersPreserved,
			footerSummariesPreserved: completionReport.footerSummariesPreserved,
			selectedMarkerMoved: completionReport.selectedMarkerMoved,
			recoveredSelectionRestored: completionReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: completionReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: completionReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: completionReport.consumedScheduledRequestCount,
			sourceRenderCount: completionReport.sourceRenderCount,
			renderedSnapshotPreserved: completionReport.renderedSnapshotPreserved,
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
