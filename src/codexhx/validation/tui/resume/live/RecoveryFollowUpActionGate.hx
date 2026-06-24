package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.RecoveryFollowUpAction;
import codexhx.runtime.tui.resume.host.RecoveryFollowUpActionKind;

class RecoveryFollowUpActionGate {
	public static function run():RecoveryFollowUpActionReport {
		final confirmationReport = SurfaceRecoveryConfirmationGate.run();
		final planner = new RecoveryFollowUpActionPlanner();
		final scheduler = new DeterministicFrameScheduler();
		final actions = planner.plan(confirmationReport);
		for (action in actions)
			if (action.frameRequested)
				scheduler.requestFrame("typed_response_recovery_follow_up:" + action.kind);

		final actionSummaries = actionSummaries(actions);
		return new RecoveryFollowUpActionReport({
			actionCount: actions.length,
			restoredStatusActionCount: countKind(actions, RecoveryFollowUpActionKind.RestoredListStatus),
			frameActionCount: countKind(actions, RecoveryFollowUpActionKind.ScheduleRecoveryFrame),
			selectionActionCount: countKind(actions, RecoveryFollowUpActionKind.RecoveredSelectionReady),
			followUpFrameRequests: scheduler.requestCount(),
			stalePromptActionAbsent: !contains(actionSummaries, "stalePromptAction=true"),
			staleSideParentActionAbsent: !contains(actionSummaries, "staleSideParentAction=true"),
			staleActiveThreadActionAbsent: !contains(actionSummaries, "staleActiveThreadAction=true"),
			ignoredNoSurfaceRecordsAbsent: confirmationReport.ignoredNoSurfaceRecordsAbsent,
			recoveryConfirmed: confirmationReport.recoveryConfirmed,
			noPressureDropRejection: confirmationReport.noPressureDropRejection,
			liveTransportSuppressed: confirmationReport.liveTransportSuppressed && !contains(actionSummaries, "liveTransport=true"),
			stateDbUntouched: confirmationReport.stateDbUntouched,
			recoveredThreadId: confirmationReport.recoveredThreadId,
			finalSnapshot: confirmationReport.finalSnapshot,
			actionSummaries: actionSummaries,
			plannerLogSummaries: planner.summaries(),
			confirmationSummary: confirmationReport.confirmationSummary
		});
	}

	static function actionSummaries(actions:Array<RecoveryFollowUpAction>):Array<String> {
		final out:Array<String> = [];
		for (action in actions)
			out.push(action.summary());
		return out;
	}

	static function countKind(actions:Array<RecoveryFollowUpAction>, kind:RecoveryFollowUpActionKind):Int {
		var count = 0;
		for (action in actions)
			if (action.kind == kind)
				count = count + 1;
		return count;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}
}
