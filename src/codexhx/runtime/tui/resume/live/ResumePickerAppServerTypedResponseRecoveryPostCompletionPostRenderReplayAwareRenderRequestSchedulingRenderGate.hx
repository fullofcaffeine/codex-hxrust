package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderRequestSchedulingRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderRequestSchedulingRenderGateReport {
		final renderIntentReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareInputRenderIntentRenderGate.run();
		final frameScheduler = new DeterministicResumePickerFrameScheduler();
		final requestScheduler = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderRequestScheduler();
		final schedule = requestScheduler.schedule(renderIntentReport, frameScheduler);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderRequestSchedulingRenderGateReport({
			scheduleKind: schedule.kind,
			scheduleSummary: schedule.summary(),
			scheduleRequested: schedule.scheduleRequested,
			scheduled: schedule.scheduled,
			scheduleSequence: schedule.scheduleSequence,
			schedulerRequestCount: frameScheduler.requestCount(),
			schedulerSummary: frameScheduler.summary(),
			localOnlyRenderIntent: schedule.localOnlyRenderIntent,
			sourceReadinessDecisionCount: renderIntentReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: renderIntentReport.sourceRenderStateCount,
			sourceFrameRequests: renderIntentReport.sourceFrameRequests,
			sourceKeyboardRenderCount: renderIntentReport.sourceKeyboardRenderCount,
			finalThreadId: schedule.finalThreadId,
			finalFooter: schedule.finalFooter,
			finalSelectionPreserved: schedule.finalSelectionPreserved,
			finalFooterPreserved: schedule.finalFooterPreserved,
			inputAdmitted: schedule.inputAdmitted,
			replayCount: renderIntentReport.replayCount,
			sourceReplayCount: renderIntentReport.sourceReplayCount,
			snapshotOrderPreserved: renderIntentReport.snapshotOrderPreserved,
			selectedMarkersPreserved: renderIntentReport.selectedMarkersPreserved,
			footerSummariesPreserved: renderIntentReport.footerSummariesPreserved,
			selectedMarkerMoved: renderIntentReport.selectedMarkerMoved,
			recoveredSelectionRestored: renderIntentReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: renderIntentReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: renderIntentReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: renderIntentReport.consumedScheduledRequestCount,
			sourcePostRenderRenderCount: renderIntentReport.sourcePostRenderRenderCount,
			renderedSnapshotPreserved: renderIntentReport.renderedSnapshotPreserved,
			sourceRenderedSnapshotPreserved: renderIntentReport.sourceRenderedSnapshotPreserved,
			sourceInputAdmitted: renderIntentReport.sourceInputAdmitted,
			sourceLocalOnlyRenderIntent: renderIntentReport.sourceLocalOnlyRenderIntent,
			stalePromptActionInactive: schedule.stalePromptActionInactive,
			staleSideParentActionInactive: schedule.staleSideParentActionInactive,
			staleActiveThreadActionInactive: schedule.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: schedule.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: schedule.noPressureDropRejection,
			liveTransportSuppressed: schedule.liveTransportSuppressed,
			liveTerminalSuppressed: schedule.liveTerminalSuppressed,
			stateDbUntouched: schedule.stateDbUntouched,
			noModelCall: schedule.noModelCall,
			noFilesystemMutation: schedule.noFilesystemMutation,
			finalSnapshot: renderIntentReport.finalSnapshot,
			renderIntentSummary: renderIntentReport.summary(),
			schedulerLogSummaries: requestScheduler.summaries()
		});
	}
}
