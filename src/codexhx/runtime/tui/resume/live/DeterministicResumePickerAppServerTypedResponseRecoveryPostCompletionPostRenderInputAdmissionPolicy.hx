package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmission;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputAdmissionPolicy {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function admit(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayCompletionHandoffRenderGateReport,
			intent:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind):ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmission {
		final finalSelectionPreserved = report.finalThreadId == "thread-surface-a"
			&& containsText(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		final finalFooterPreserved = report.finalFooterStable && containsText(report.finalSnapshot, report.finalFooter);
		final ready = intent == ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind.ConfirmRecoveredSelection
			&& report.completionReady
			&& report.nextSliceReady
			&& report.replayCount == 2
			&& report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved
			&& report.footerSummariesPreserved
			&& report.noLeftoverScheduledRenderRequest
			&& finalSelectionPreserved
			&& finalFooterPreserved
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
		final out = new ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmission({
			kind: ready ? ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind.InputAdmitted : ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind.InputRejected,
			intent: intent,
			admitted: ready,
			sequence: nextSequence,
			finalThreadId: report.finalThreadId,
			finalFooter: report.finalFooter,
			completionReady: report.completionReady,
			nextSliceReady: report.nextSliceReady,
			finalSelectionPreserved: finalSelectionPreserved,
			finalFooterPreserved: finalFooterPreserved,
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
			reason: ready ? "post_completion_post_render_input_admitted_after_replay" : "post_completion_post_render_input_rejected_before_replay"
		});
		nextSequence = nextSequence + 1;
		log.push("postRenderInput:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	static function containsText(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
