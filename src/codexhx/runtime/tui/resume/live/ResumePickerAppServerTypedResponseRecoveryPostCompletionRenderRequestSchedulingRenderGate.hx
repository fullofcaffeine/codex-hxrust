package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGateReport {
		final renderIntentReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentRenderGate.run();
		final frameScheduler = new DeterministicResumePickerFrameScheduler();
		final requestScheduler = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduler();
		final schedule = requestScheduler.schedule(renderIntentReport, frameScheduler);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGateReport({
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
