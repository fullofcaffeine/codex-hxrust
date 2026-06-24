package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.CompletionInputRenderIntentKind;
import codexhx.runtime.tui.resume.host.CompletionRenderRequestSchedule;
import codexhx.runtime.tui.resume.host.CompletionRenderRequestScheduleKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostOutcomeKind;

class ReplayStateRenderRequestScheduler {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function schedule(report:ReplayStateInputRenderIntentReport, scheduler:DeterministicFrameScheduler):CompletionRenderRequestSchedule {
		final ready = report.renderIntentKind == CompletionInputRenderIntentKind.LocalRenderRequested
			&& report.renderRequested
			&& report.localOnlyRenderIntent
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.inputAdmitted
			&& report.completionReady
			&& report.nextSliceReady
			&& report.replayCount == 2
			&& report.sourceReplayCount == 2
			&& report.sourceHandoffReplayCount == 2
			&& report.sourceHandoffReadinessDecisionCount == 2
			&& report.sourceHandoffRenderStateCount == 2
			&& report.sourceHandoffFrameRequests == 2
			&& report.sourceHandoffKeyboardRenderCount == 2
			&& report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved
			&& report.footerSummariesPreserved
			&& report.noLeftoverScheduledRenderRequest
			&& report.sourceRenderedSnapshotPreserved
			&& report.sourceInputAdmitted
			&& report.sourceLocalOnlyRenderIntent
			&& report.sourceHandoffInputAdmitted
			&& report.sourceHandoffLocalOnlyRenderIntent
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
		final schedulerReason = ready ? "typed_response_recovery_post_completion_post_render_replay_aware_rendered_state_local_render:thread-surface-a" : "";
		final outcome = ready ? scheduler.requestFrame(schedulerReason) : null;
		final scheduled = outcome != null
			&& outcome.ok
			&& outcome.kind == ResumePickerHostOutcomeKind.Scheduled
			&& outcome.pendingCount == nextSequence;
		final out = new CompletionRenderRequestSchedule({
			kind: scheduled ? CompletionRenderRequestScheduleKind.LocalRenderScheduled : CompletionRenderRequestScheduleKind.RenderScheduleRejected,
			sourceRenderIntentKind: report.renderIntentKind,
			scheduleRequested: ready,
			scheduled: scheduled,
			scheduleSequence: nextSequence,
			schedulerPendingCount: outcome == null ? scheduler.requestCount() : outcome.pendingCount,
			schedulerSkippedCount: outcome == null ? 0 : outcome.skippedCount,
			schedulerReason: schedulerReason,
			finalThreadId: report.finalThreadId,
			finalFooter: report.finalFooter,
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
			reason: scheduled ? "post_completion_post_render_replay_aware_rendered_state_local_render_request_scheduled" : "post_completion_post_render_replay_aware_rendered_state_local_render_request_rejected"
		});
		nextSequence = nextSequence + 1;
		log.push("postRenderReplayAwareRenderedStateRequestSchedule:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
