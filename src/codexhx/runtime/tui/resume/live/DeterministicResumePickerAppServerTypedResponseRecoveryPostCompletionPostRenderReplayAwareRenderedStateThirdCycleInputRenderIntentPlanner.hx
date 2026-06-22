package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleInputRenderIntentPlanner {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function plan(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleInputAdmissionRenderGateReport):ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntent {
		final ready = report.inputAdmitted
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.completionReady
			&& report.nextSliceReady
			&& report.replayCount == 2
			&& report.sourceReplayCount == 2
			&& report.sourceHandoffReplayCount == 2
			&& report.sourceHandoffReadinessDecisionCount == 2
			&& report.sourceHandoffRenderStateCount == 2
			&& report.sourceHandoffFrameRequests == 2
			&& report.sourceHandoffKeyboardRenderCount == 2
			&& report.sourceSecondCycleHandoffReplayCount == 2
			&& report.sourceSecondCycleHandoffReadinessDecisionCount == 2
			&& report.sourceSecondCycleHandoffRenderStateCount == 2
			&& report.sourceSecondCycleHandoffFrameRequests == 2
			&& report.sourceSecondCycleHandoffKeyboardRenderCount == 2
			&& report.sourceThirdCycleHandoffReplayCount == 2
			&& report.sourceThirdCycleHandoffReadinessDecisionCount == 2
			&& report.sourceThirdCycleHandoffRenderStateCount == 2
			&& report.sourceThirdCycleHandoffFrameRequests == 2
			&& report.sourceThirdCycleHandoffKeyboardRenderCount == 2
			&& report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved
			&& report.footerSummariesPreserved
			&& report.noLeftoverScheduledRenderRequest
			&& report.sourceRenderedSnapshotPreserved
			&& report.sourceInputAdmitted
			&& report.sourceLocalOnlyRenderIntent
			&& report.sourceHandoffInputAdmitted
			&& report.sourceHandoffLocalOnlyRenderIntent
			&& report.sourceSecondCycleHandoffInputAdmitted
			&& report.sourceSecondCycleHandoffLocalOnlyRenderIntent
			&& report.sourceThirdCycleHandoffInputAdmitted
			&& report.sourceThirdCycleHandoffLocalOnlyRenderIntent
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
		final out = new ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntent({
			kind: ready ? ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind.LocalRenderRequested : ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind.RenderIntentRejected,
			sourceIntent: ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind.ConfirmRecoveredSelection,
			renderRequested: ready,
			renderSequence: nextSequence,
			finalThreadId: report.finalThreadId,
			finalFooter: report.finalFooter,
			finalSelectionPreserved: report.finalSelectionPreserved,
			finalFooterPreserved: report.finalFooterPreserved,
			inputAdmitted: report.inputAdmitted,
			localOnlyRenderIntent: ready,
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
			reason: ready ? "post_completion_post_render_replay_aware_rendered_state_third_cycle_input_local_render_intent_requested" : "post_completion_post_render_replay_aware_rendered_state_third_cycle_input_render_intent_rejected"
		});
		nextSequence = nextSequence + 1;
		log.push("postRenderReplayAwareRenderedStateThirdCycleIntent:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
