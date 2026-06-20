package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryFollowUpAction;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind;

class ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGateReport {
		final confirmationReport = ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationRenderGate.run();
		final planner = new DeterministicResumePickerAppServerTypedResponseRecoveryFollowUpActionPlanner();
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final actions = planner.plan(confirmationReport);
		for (action in actions)
			if (action.frameRequested)
				scheduler.requestFrame("typed_response_recovery_follow_up:" + action.kind);

		final actionSummaries = actionSummaries(actions);
		return new ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGateReport({
			actionCount: actions.length,
			restoredStatusActionCount: countKind(actions, ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind.RestoredListStatus),
			frameActionCount: countKind(actions, ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind.ScheduleRecoveryFrame),
			selectionActionCount: countKind(actions, ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind.RecoveredSelectionReady),
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

	static function actionSummaries(actions:Array<ResumePickerAppServerTypedResponseRecoveryFollowUpAction>):Array<String> {
		final out:Array<String> = [];
		for (action in actions)
			out.push(action.summary());
		return out;
	}

	static function countKind(actions:Array<ResumePickerAppServerTypedResponseRecoveryFollowUpAction>,
			kind:ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind):Int {
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
