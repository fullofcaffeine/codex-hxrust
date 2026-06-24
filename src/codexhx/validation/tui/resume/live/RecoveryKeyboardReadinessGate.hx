package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecisionKind;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;

class RecoveryKeyboardReadinessGate {
	public static function run():RecoveryKeyboardReadinessReport {
		final handoffReport = RecoveryIdleStateHandoffGate.run();
		final policy = new RecoveryKeyboardReadinessPolicy();
		final decisions = [
			policy.admit(handoffReport, RecoveryKeyboardIntentKind.MoveDown),
			policy.admit(handoffReport, RecoveryKeyboardIntentKind.MoveUp)
		];
		final summaries = decisionSummaries(decisions);
		return new RecoveryKeyboardReadinessReport({
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

	static function decisionSummaries(decisions:Array<RecoveryKeyboardDecision>):Array<String> {
		final out:Array<String> = [];
		for (decision in decisions)
			out.push(decision.summary());
		return out;
	}

	static function countAdmitted(decisions:Array<RecoveryKeyboardDecision>):Int {
		var count = 0;
		for (decision in decisions)
			if (decision.kind == RecoveryKeyboardDecisionKind.NavigationAdmitted)
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
