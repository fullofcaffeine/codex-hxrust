package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecisionKind;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;

class RecoveryKeyboardReadinessPolicy {
	final log:Array<String>;
	final threads:Array<String>;
	var selectedIndex:Int;
	var nextSequence:Int;

	public function new() {
		this.log = [];
		this.threads = ["thread-surface-a", "thread-surface-b"];
		this.selectedIndex = 0;
		this.nextSequence = 1;
	}

	public function admit(report:RecoveryIdleStateHandoffReport, intent:RecoveryKeyboardIntentKind):RecoveryKeyboardDecision {
		final selectedBefore = selectedIndex;
		final threadBefore = threadAt(selectedBefore);
		final ready = report.idleListReady
			&& report.keyboardInputReady
			&& report.listNavigationReady
			&& report.recoveredThreadId == "thread-surface-a"
			&& report.promptActionCleared
			&& report.sideParentActionCleared
			&& report.activeThreadActionCleared
			&& report.ignoredNoSurfaceRecordsAbsent
			&& report.noPressureDropRejection
			&& report.liveTransportSuppressed
			&& report.stateDbUntouched;
		final selectedAfter = ready ? nextIndex(selectedBefore, intent) : selectedBefore;
		final threadAfter = threadAt(selectedAfter);
		final navigationApplied = ready && selectedAfter != selectedBefore;
		final decision = new RecoveryKeyboardDecision({
			kind: ready ? RecoveryKeyboardDecisionKind.NavigationAdmitted : RecoveryKeyboardDecisionKind.NavigationRejected,
			intent: intent,
			sequence: nextSequence,
			selectedBefore: selectedBefore,
			selectedAfter: selectedAfter,
			threadBefore: threadBefore,
			threadAfter: threadAfter,
			recoveredThreadPreservedBeforeNavigation: threadBefore == "thread-surface-a",
			navigationApplied: navigationApplied,
			keyboardInputReady: report.keyboardInputReady,
			listNavigationReady: report.listNavigationReady,
			promptActionInactive: report.promptActionCleared,
			sideParentActionInactive: report.sideParentActionCleared,
			activeThreadActionInactive: report.activeThreadActionCleared,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			reason: ready ? "recovery_keyboard_navigation_ready" : "recovery_keyboard_navigation_rejected"
		});
		selectedIndex = selectedAfter;
		nextSequence = nextSequence + 1;
		log.push("keyboard:" + decision.summary());
		return decision;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	function nextIndex(current:Int, intent:RecoveryKeyboardIntentKind):Int {
		return switch intent {
			case RecoveryKeyboardIntentKind.MoveDown:
				current + 1 >= threads.length ? current : current + 1;
			case RecoveryKeyboardIntentKind.MoveUp:
				current <= 0 ? current : current - 1;
			case _:
				current;
		}
	}

	function threadAt(index:Int):String {
		return index < 0 || index >= threads.length ? "" : threads[index];
	}
}
