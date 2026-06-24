package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputRenderIntentKind;

class CompletionInputRenderIntentGate {
	public static function run():CompletionInputRenderIntentReport {
		final admissionReport = CompletionInputAdmissionGate.run();
		final planner = new CompletionInputRenderIntentPlanner();
		final intent = planner.plan(admissionReport);
		return new CompletionInputRenderIntentReport({
			renderIntentKind: intent.kind,
			renderIntentSummary: intent.summary(),
			renderRequested: intent.kind == CompletionInputRenderIntentKind.LocalRenderRequested,
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
