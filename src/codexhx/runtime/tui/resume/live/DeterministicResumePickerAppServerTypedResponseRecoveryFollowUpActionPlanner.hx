package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryFollowUpAction;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryFollowUpActionPlanner {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function plan(report:ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationRenderGateReport):Array<ResumePickerAppServerTypedResponseRecoveryFollowUpAction> {
		if (!report.recoveryConfirmed
			|| report.confirmationKind != ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind.RecoveryConfirmed) {
			log.push("follow-up-skip:recovery_not_confirmed");
			return [];
		}
		final actions = [
			action(report, ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind.RestoredListStatus, true, false, false,
				"recovered_list_status_restored"),
			action(report, ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind.ScheduleRecoveryFrame, false, true, false, "recovery_frame_requested"),
			action(report, ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind.RecoveredSelectionReady, false, false, true,
				"recovered_selection_ready")
		];
		for (planned in actions)
			log.push("follow-up:" + planned.summary());
		return actions;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	function action(report:ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationRenderGateReport,
			kind:ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind, statusRestored:Bool, frameRequested:Bool, selectionReady:Bool,
			reason:String):ResumePickerAppServerTypedResponseRecoveryFollowUpAction {
		final out = new ResumePickerAppServerTypedResponseRecoveryFollowUpAction({
			kind: kind,
			sequence: nextSequence,
			confirmationKind: report.confirmationKind,
			recoveredThreadId: report.recoveredThreadId,
			footerLabel: report.recoveredFooterLabel,
			loaderStatus: report.recoveredLoaderStatus,
			statusRestored: statusRestored,
			frameRequested: frameRequested,
			selectionReady: selectionReady,
			stalePromptAction: false,
			staleSideParentAction: false,
			staleActiveThreadAction: false,
			liveTransportAttempted: false,
			liveTransportSuppressed: true,
			reason: reason
		});
		nextSequence = nextSequence + 1;
		return out;
	}
}
