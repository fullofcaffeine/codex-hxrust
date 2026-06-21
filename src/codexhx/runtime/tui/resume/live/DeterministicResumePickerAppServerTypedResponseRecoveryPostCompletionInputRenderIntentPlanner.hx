package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentPlanner {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function plan(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionRenderGateReport):ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntent {
		final ready = report.inputAdmitted
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.completionReady
			&& report.nextSliceReady
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
			finalFooter: "footer keyboard move_up selected=0 selectedThread=thread-surface-a",
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
			reason: ready ? "post_completion_input_local_render_intent_requested" : "post_completion_input_render_intent_rejected"
		});
		nextSequence = nextSequence + 1;
		log.push("renderIntent:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}
}
