package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmission;
import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.CompletionInputIntentKind;

class CompletionInputAdmissionPolicy {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function admit(report:RecoveryCompletionHandoffReport, intent:CompletionInputIntentKind):CompletionInputAdmission {
		final finalFooter = "footer keyboard move_up selected=0 selectedThread=thread-surface-a";
		final finalSelectionPreserved = report.finalThreadId == "thread-surface-a"
			&& containsText(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		final finalFooterPreserved = report.finalFooterStable && containsText(report.finalSnapshot, finalFooter);
		final ready = intent == CompletionInputIntentKind.ConfirmRecoveredSelection
			&& report.completionReady
			&& report.nextSliceReady
			&& finalSelectionPreserved
			&& finalFooterPreserved
			&& report.stalePromptActionInactive
			&& report.staleSideParentActionInactive
			&& report.staleActiveThreadActionInactive
			&& report.ignoredNoSurfaceRecordsAbsent
			&& report.noPressureDropRejection
			&& report.liveTransportSuppressed
			&& report.liveTerminalSuppressed
			&& report.stateDbUntouched;
		final out = new CompletionInputAdmission({
			kind: ready ? CompletionInputAdmissionKind.InputAdmitted : CompletionInputAdmissionKind.InputRejected,
			intent: intent,
			admitted: ready,
			sequence: nextSequence,
			finalThreadId: report.finalThreadId,
			finalFooter: finalFooter,
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
			noModelCall: true,
			noFilesystemMutation: true,
			reason: ready ? "post_completion_input_admitted_after_recovery" : "post_completion_input_rejected_before_recovery"
		});
		nextSequence = nextSequence + 1;
		log.push("postCompletionInput:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	static function containsText(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
