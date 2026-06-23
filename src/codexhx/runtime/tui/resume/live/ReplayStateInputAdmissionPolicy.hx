package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmission;
import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;
import codexhx.runtime.tui.resume.host.CompletionInputIntentKind;

class ReplayStateInputAdmissionPolicy {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function admit(report:ReplayStateCompletionHandoffReport, intent:CompletionInputIntentKind):CompletionInputAdmission {
		final finalSelectionPreserved = report.finalThreadId == "thread-surface-a"
			&& containsText(report.finalSnapshot, "> Recovered surface thread | thread-surface-a");
		final finalFooterPreserved = report.finalFooterStable && containsText(report.finalSnapshot, report.finalFooter);
		final ready = intent == CompletionInputIntentKind.ConfirmRecoveredSelection
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
			&& report.inputAdmitted
			&& report.localOnlyRenderIntent
			&& report.sourceInputAdmitted
			&& report.sourceLocalOnlyRenderIntent
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
		final out = new CompletionInputAdmission({
			kind: ready ? CompletionInputAdmissionKind.InputAdmitted : CompletionInputAdmissionKind.InputRejected,
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
			reason: ready ? "post_completion_post_render_replay_aware_rendered_state_input_admitted_after_replay" : "post_completion_post_render_replay_aware_rendered_state_input_rejected_before_replay"
		});
		nextSequence = nextSequence + 1;
		log.push("postRenderReplayAwareRenderedStateInput:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	static function containsText(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
