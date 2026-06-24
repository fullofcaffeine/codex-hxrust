package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;

class CompletionRenderRequestGate {
	public static function run():CompletionRenderRequestReport {
		final renderIntentReport = CompletionInputRenderIntentGate.run();
		final frameScheduler = new DeterministicFrameScheduler();
		final requestScheduler = new CompletionRenderRequestScheduler();
		final schedule = requestScheduler.schedule(renderIntentReport, frameScheduler);
		return new CompletionRenderRequestReport({
			scheduleKind: schedule.kind,
			scheduleSummary: schedule.summary(),
			scheduleRequested: schedule.scheduleRequested,
			scheduled: schedule.scheduled,
			scheduleSequence: schedule.scheduleSequence,
			schedulerRequestCount: frameScheduler.requestCount(),
			schedulerSummary: frameScheduler.summary(),
			localOnlyRenderIntent: schedule.localOnlyRenderIntent,
			finalThreadId: schedule.finalThreadId,
			finalSelectionPreserved: schedule.finalSelectionPreserved,
			finalFooterPreserved: schedule.finalFooterPreserved,
			inputAdmitted: schedule.inputAdmitted,
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
