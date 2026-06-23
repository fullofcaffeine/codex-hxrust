package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.CompletionInputIntentKind;

class CompletionInputAdmissionGate {
	public static function run():CompletionInputAdmissionReport {
		final completionReport = RecoveryCompletionHandoffGate.run();
		final policy = new CompletionInputAdmissionPolicy();
		final admission = policy.admit(completionReport, CompletionInputIntentKind.ConfirmRecoveredSelection);
		return new CompletionInputAdmissionReport({
			admissionKind: admission.kind,
			admissionSummary: admission.summary(),
			inputAdmitted: admission.kind == CompletionInputAdmissionKind.InputAdmitted,
			finalThreadId: admission.finalThreadId,
			finalSelectionPreserved: admission.finalSelectionPreserved,
			finalFooterPreserved: admission.finalFooterPreserved,
			completionReady: admission.completionReady,
			nextSliceReady: admission.nextSliceReady,
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
