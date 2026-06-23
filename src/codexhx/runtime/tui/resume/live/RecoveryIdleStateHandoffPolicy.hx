package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryIdleStateHandoff;
import codexhx.runtime.tui.resume.host.RecoveryIdleStateHandoffKind;

class RecoveryIdleStateHandoffPolicy {
	final log:Array<String>;

	public function new() {
		this.log = [];
	}

	public function handoff(report:RecoveryFollowUpActionReport):RecoveryIdleStateHandoff {
		final restoredStatusAccepted = containsAny(report.actionSummaries, "kind=restored_list_status")
			&& containsAny(report.actionSummaries, "statusRestored=true");
		final frameRequestAccepted = report.followUpFrameRequests == 1
			&& containsAny(report.actionSummaries, "kind=schedule_recovery_frame")
			&& containsAny(report.actionSummaries, "frameRequested=true");
		final selectionAccepted = containsAny(report.actionSummaries, "kind=recovered_selection_ready")
			&& containsAny(report.actionSummaries, "selectionReady=true")
			&& report.recoveredThreadId == "thread-surface-a";
		final staleCleared = report.stalePromptActionAbsent && report.staleSideParentActionAbsent && report.staleActiveThreadActionAbsent;
		final ready = report.recoveryConfirmed
			&& restoredStatusAccepted
			&& frameRequestAccepted
			&& selectionAccepted
			&& staleCleared
			&& report.ignoredNoSurfaceRecordsAbsent
			&& report.noPressureDropRejection
			&& report.liveTransportSuppressed
			&& report.stateDbUntouched;
		final out = new RecoveryIdleStateHandoff({
			kind: ready ? RecoveryIdleStateHandoffKind.IdleListReady : RecoveryIdleStateHandoffKind.HandoffRejected,
			recoveredThreadId: report.recoveredThreadId,
			footerLabel: "typed surface recovered",
			keyboardInputReady: ready,
			listNavigationReady: ready && containsText(report.finalSnapshot, "rows loaded=2"),
			promptActionCleared: report.stalePromptActionAbsent,
			sideParentActionCleared: report.staleSideParentActionAbsent,
			activeThreadActionCleared: report.staleActiveThreadActionAbsent,
			restoredStatusAccepted: restoredStatusAccepted,
			frameRequestAccepted: frameRequestAccepted,
			selectionAccepted: selectionAccepted,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			reason: ready ? "recovery_follow_up_handed_to_idle_list" : "recovery_follow_up_handoff_rejected"
		});
		log.push("handoff:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	static function containsAny(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (containsText(value, needle))
				return true;
		return false;
	}

	static function containsText(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
