package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryFollowUpAction;
import codexhx.runtime.tui.resume.host.RecoveryFollowUpActionKind;
import codexhx.runtime.tui.resume.host.SurfaceRecoveryConfirmationKind;

class RecoveryFollowUpActionPlanner {
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.nextSequence = 1;
	}

	public function plan(report:SurfaceRecoveryConfirmationReport):Array<RecoveryFollowUpAction> {
		if (!report.recoveryConfirmed || report.confirmationKind != SurfaceRecoveryConfirmationKind.RecoveryConfirmed) {
			log.push("follow-up-skip:recovery_not_confirmed");
			return [];
		}
		final actions = [
			action(report, RecoveryFollowUpActionKind.RestoredListStatus, true, false, false, "recovered_list_status_restored"),
			action(report, RecoveryFollowUpActionKind.ScheduleRecoveryFrame, false, true, false, "recovery_frame_requested"),
			action(report, RecoveryFollowUpActionKind.RecoveredSelectionReady, false, false, true, "recovered_selection_ready")
		];
		for (planned in actions)
			log.push("follow-up:" + planned.summary());
		return actions;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	function action(report:SurfaceRecoveryConfirmationReport, kind:RecoveryFollowUpActionKind, statusRestored:Bool, frameRequested:Bool, selectionReady:Bool,
			reason:String):RecoveryFollowUpAction {
		final out = new RecoveryFollowUpAction({
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
