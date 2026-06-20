package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardDecisionKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;

class ResumePickerAppServerTypedResponseRecoveryKeyboardReadinessRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryKeyboardReadinessRenderGateReport {
		final handoffReport = ResumePickerAppServerTypedResponseRecoveryIdleStateHandoffRenderGate.run();
		final policy = new DeterministicResumePickerAppServerTypedResponseRecoveryKeyboardReadinessPolicy();
		final decisions = [
			policy.admit(handoffReport, ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveDown),
			policy.admit(handoffReport, ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveUp)
		];
		final summaries = decisionSummaries(decisions);
		return new ResumePickerAppServerTypedResponseRecoveryKeyboardReadinessRenderGateReport({
			decisionCount: decisions.length,
			admittedCount: countAdmitted(decisions),
			recoveredSelectionStableUntilNavigation: decisions[0].recoveredThreadPreservedBeforeNavigation,
			navigationApplied: decisions[0].navigationApplied && decisions[1].navigationApplied,
			returnedToRecoveredSelection: decisions[decisions.length - 1].threadAfter == "thread-surface-a",
			keyboardInputReady: handoffReport.keyboardInputReady,
			listNavigationReady: handoffReport.listNavigationReady,
			stalePromptActionInactive: handoffReport.promptActionCleared && !contains(summaries, "stalePromptAction=true"),
			staleSideParentActionInactive: handoffReport.sideParentActionCleared && !contains(summaries, "staleSideParentAction=true"),
			staleActiveThreadActionInactive: handoffReport.activeThreadActionCleared
			&& !contains(summaries, "staleActiveThreadAction=true"),
			ignoredNoSurfaceRecordsAbsent: handoffReport.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: handoffReport.noPressureDropRejection,
			liveTransportSuppressed: handoffReport.liveTransportSuppressed && !contains(summaries, "liveTransport=true"),
			stateDbUntouched: handoffReport.stateDbUntouched,
			finalThreadId: decisions[decisions.length - 1].threadAfter,
			decisionSummaries: summaries,
			policyLogSummaries: policy.summaries(),
			handoffSummary: handoffReport.handoffSummary
		});
	}

	static function decisionSummaries(decisions:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardDecision>):Array<String> {
		final out:Array<String> = [];
		for (decision in decisions)
			out.push(decision.summary());
		return out;
	}

	static function countAdmitted(decisions:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardDecision>):Int {
		var count = 0;
		for (decision in decisions)
			if (decision.kind == ResumePickerAppServerTypedResponseRecoveryKeyboardDecisionKind.NavigationAdmitted)
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
