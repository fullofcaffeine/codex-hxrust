package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionRenderGateReport {
		final schedulingReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGate.run();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final executor = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutor();
		final execution = executor.execute(schedulingReport, renderer);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionRenderGateReport({
			executionKind: execution.kind,
			executionSummary: execution.summary(),
			executionRequested: execution.executionRequested,
			rendered: execution.rendered,
			executionSequence: execution.executionSequence,
			sourceSchedulerRequestCount: execution.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: execution.consumedScheduledRequestCount,
			renderCount: execution.renderCount,
			renderOutcomeKind: execution.renderOutcomeKind,
			renderedSnapshotMatchesSchedule: execution.renderedSnapshotMatchesSchedule,
			localOnlyRenderIntent: execution.localOnlyRenderIntent,
			finalThreadId: execution.finalThreadId,
			finalSelectionPreserved: execution.finalSelectionPreserved,
			finalFooterPreserved: execution.finalFooterPreserved,
			inputAdmitted: execution.inputAdmitted,
			stalePromptActionInactive: execution.stalePromptActionInactive,
			staleSideParentActionInactive: execution.staleSideParentActionInactive,
			staleActiveThreadActionInactive: execution.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: execution.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: execution.noPressureDropRejection,
			liveTransportSuppressed: execution.liveTransportSuppressed,
			liveTerminalSuppressed: execution.liveTerminalSuppressed,
			stateDbUntouched: execution.stateDbUntouched,
			noModelCall: execution.noModelCall,
			noFilesystemMutation: execution.noFilesystemMutation,
			renderedSnapshot: execution.renderedSnapshot,
			schedulingSummary: schedulingReport.summary(),
			executionLogSummaries: executor.summaries()
		});
	}
}
