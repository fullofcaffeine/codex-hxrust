package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputRenderIntentKind;

class PostRenderInputRenderIntentGate {
	public static function run():PostRenderInputRenderIntentReport {
		final admissionReport = PostRenderInputAdmissionGate.run();
		final planner = new PostRenderInputRenderIntentPlanner();
		final intent = planner.plan(admissionReport);
		return new PostRenderInputRenderIntentReport({
			renderIntentKind: intent.kind,
			renderIntentSummary: intent.summary(),
			renderRequested: intent.kind == CompletionInputRenderIntentKind.LocalRenderRequested,
			localOnlyRenderIntent: intent.localOnlyRenderIntent,
			finalThreadId: intent.finalThreadId,
			finalFooter: intent.finalFooter,
			finalSelectionPreserved: intent.finalSelectionPreserved,
			finalFooterPreserved: intent.finalFooterPreserved,
			inputAdmitted: intent.inputAdmitted,
			replayCount: admissionReport.replayCount,
			snapshotOrderPreserved: admissionReport.snapshotOrderPreserved,
			selectedMarkersPreserved: admissionReport.selectedMarkersPreserved,
			footerSummariesPreserved: admissionReport.footerSummariesPreserved,
			selectedMarkerMoved: admissionReport.selectedMarkerMoved,
			recoveredSelectionRestored: admissionReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: admissionReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: admissionReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: admissionReport.consumedScheduledRequestCount,
			sourceRenderCount: admissionReport.sourceRenderCount,
			renderedSnapshotPreserved: admissionReport.renderedSnapshotPreserved,
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
