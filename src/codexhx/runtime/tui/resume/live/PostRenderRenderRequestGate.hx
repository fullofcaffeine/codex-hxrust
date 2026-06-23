package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;

class PostRenderRenderRequestGate {
	public static function run():PostRenderRenderRequestReport {
		final renderIntentReport = PostRenderInputRenderIntentGate.run();
		final frameScheduler = new DeterministicFrameScheduler();
		final requestScheduler = new PostRenderRenderRequestScheduler();
		final schedule = requestScheduler.schedule(renderIntentReport, frameScheduler);
		return new PostRenderRenderRequestReport({
			scheduleKind: schedule.kind,
			scheduleSummary: schedule.summary(),
			scheduleRequested: schedule.scheduleRequested,
			scheduled: schedule.scheduled,
			scheduleSequence: schedule.scheduleSequence,
			schedulerRequestCount: frameScheduler.requestCount(),
			schedulerSummary: frameScheduler.summary(),
			localOnlyRenderIntent: schedule.localOnlyRenderIntent,
			finalThreadId: schedule.finalThreadId,
			finalFooter: schedule.finalFooter,
			finalSelectionPreserved: schedule.finalSelectionPreserved,
			finalFooterPreserved: schedule.finalFooterPreserved,
			inputAdmitted: schedule.inputAdmitted,
			replayCount: renderIntentReport.replayCount,
			snapshotOrderPreserved: renderIntentReport.snapshotOrderPreserved,
			selectedMarkersPreserved: renderIntentReport.selectedMarkersPreserved,
			footerSummariesPreserved: renderIntentReport.footerSummariesPreserved,
			selectedMarkerMoved: renderIntentReport.selectedMarkerMoved,
			recoveredSelectionRestored: renderIntentReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: renderIntentReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: renderIntentReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: renderIntentReport.consumedScheduledRequestCount,
			sourceRenderCount: renderIntentReport.sourceRenderCount,
			renderedSnapshotPreserved: renderIntentReport.renderedSnapshotPreserved,
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
