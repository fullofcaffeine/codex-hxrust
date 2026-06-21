package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedule;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostOutcomeKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduler {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function schedule(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentRenderGateReport,
			scheduler:DeterministicResumePickerFrameScheduler):ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedule {
		final ready = report.renderIntentKind == ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind.LocalRenderRequested
			&& report.renderRequested
			&& report.localOnlyRenderIntent
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.inputAdmitted
			&& report.stalePromptActionInactive
			&& report.staleSideParentActionInactive
			&& report.staleActiveThreadActionInactive
			&& report.ignoredNoSurfaceRecordsAbsent
			&& report.noPressureDropRejection
			&& report.liveTransportSuppressed
			&& report.liveTerminalSuppressed
			&& report.stateDbUntouched
			&& report.noModelCall
			&& report.noFilesystemMutation;
		final schedulerReason = ready ? "typed_response_recovery_post_completion_local_render:thread-surface-a" : "";
		final outcome = ready ? scheduler.requestFrame(schedulerReason) : null;
		final scheduled = outcome != null
			&& outcome.ok
			&& outcome.kind == ResumePickerHostOutcomeKind.Scheduled
			&& outcome.pendingCount == nextSequence;
		final out = new ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedule({
			kind: scheduled ? ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind.LocalRenderScheduled : ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind.RenderScheduleRejected,
			sourceRenderIntentKind: report.renderIntentKind,
			scheduleRequested: ready,
			scheduled: scheduled,
			scheduleSequence: nextSequence,
			schedulerPendingCount: outcome == null ? scheduler.requestCount() : outcome.pendingCount,
			schedulerSkippedCount: outcome == null ? 0 : outcome.skippedCount,
			schedulerReason: schedulerReason,
			finalThreadId: report.finalThreadId,
			finalFooter: "footer keyboard move_up selected=0 selectedThread=thread-surface-a",
			finalSelectionPreserved: report.finalSelectionPreserved,
			finalFooterPreserved: report.finalFooterPreserved,
			inputAdmitted: report.inputAdmitted,
			localOnlyRenderIntent: report.localOnlyRenderIntent,
			stalePromptActionInactive: report.stalePromptActionInactive,
			staleSideParentActionInactive: report.staleSideParentActionInactive,
			staleActiveThreadActionInactive: report.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			liveTerminalSuppressed: report.liveTerminalSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			noModelCall: report.noModelCall,
			noFilesystemMutation: report.noFilesystemMutation,
			reason: scheduled ? "post_completion_local_render_request_scheduled" : "post_completion_local_render_request_rejected"
		});
		nextSequence = nextSequence + 1;
		log.push("renderRequestSchedule:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
