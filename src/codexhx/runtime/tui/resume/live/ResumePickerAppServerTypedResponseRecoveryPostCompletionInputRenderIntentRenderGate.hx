package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentRenderGateReport {
		final admissionReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionRenderGate.run();
		final planner = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentPlanner();
		final intent = planner.plan(admissionReport);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentRenderGateReport({
			renderIntentKind: intent.kind,
			renderIntentSummary: intent.summary(),
			renderRequested: intent.kind == ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind.LocalRenderRequested,
			localOnlyRenderIntent: intent.localOnlyRenderIntent,
			finalThreadId: intent.finalThreadId,
			finalSelectionPreserved: intent.finalSelectionPreserved,
			finalFooterPreserved: intent.finalFooterPreserved,
			inputAdmitted: intent.inputAdmitted,
			stalePromptActionInactive: intent.stalePromptActionInactive,
			staleSideParentActionInactive: intent.staleSideParentActionInactive,
			staleActiveThreadActionInactive: intent.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: intent.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: intent.noPressureDropRejection,
			liveTransportSuppressed: intent.liveTransportSuppressed,
			liveTerminalSuppressed: intent.liveTerminalSuppressed,
			stateDbUntouched: intent.stateDbUntouched,
			noModelCall: intent.noModelCall,
			noFilesystemMutation: intent.noFilesystemMutation,
			finalSnapshot: admissionReport.finalSnapshot,
			admissionSummary: admissionReport.summary(),
			renderIntentLogSummaries: planner.summaries()
		});
	}
}
