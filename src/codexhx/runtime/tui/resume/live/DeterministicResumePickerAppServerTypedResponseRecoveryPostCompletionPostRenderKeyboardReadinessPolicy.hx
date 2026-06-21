package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardDecisionKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadiness;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessPolicy {
	static final FinalFooter = "footer keyboard move_up selected=0 selectedThread=thread-surface-a";

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

	public function admit(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffRenderGateReport,
			intents:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind>):ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadiness {
		final ready = sourceReady(report);
		final decisions:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardDecision> = [];
		for (intent in intents)
			decisions.push(decide(report, intent, ready));
		final decisionSummaries = summariesFor(decisions);
		final admittedCount = countAdmitted(decisions);
		final returnedToRecoveredSelection = decisions.length > 0 && decisions[decisions.length - 1].threadAfter == "thread-surface-a";
		final navigationApplied = allNavigationApplied(decisions);
		final stableUntilNavigation = decisions.length > 0 && decisions[0].recoveredThreadPreservedBeforeNavigation;
		final accepted = ready
			&& admittedCount == intents.length
			&& navigationApplied
			&& stableUntilNavigation
			&& returnedToRecoveredSelection
			&& report.finalSnapshot.indexOf(FinalFooter) >= 0;
		final out = new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadiness({
			kind: accepted ? ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessKind.PostRenderKeyboardReady : ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessKind.PostRenderKeyboardReadinessRejected,
			sourceHandoffKind: report.handoffKind,
			decisionCount: decisions.length,
			admittedCount: admittedCount,
			postRenderIdleListReady: report.postRenderIdleListReady,
			keyboardInputReady: report.keyboardInputReady,
			listNavigationReady: report.listNavigationReady,
			recoveredSelectionStableUntilNavigation: stableUntilNavigation,
			navigationApplied: navigationApplied,
			returnedToRecoveredSelection: returnedToRecoveredSelection,
			noLeftoverScheduledRenderRequest: report.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: report.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: report.consumedScheduledRequestCount,
			renderCount: report.renderCount,
			renderedSnapshotPreserved: report.renderedSnapshotPreserved,
			finalThreadId: returnedToRecoveredSelection ? "thread-surface-a" : threadAt(selectedIndex),
			finalFooter: FinalFooter,
			finalSelectionPreserved: report.finalSelectionPreserved,
			finalFooterPreserved: report.finalFooterPreserved,
			stalePromptActionInactive: report.stalePromptActionInactive && !contains(decisionSummaries, "stalePromptAction=true"),
			staleSideParentActionInactive: report.staleSideParentActionInactive
			&& !contains(decisionSummaries, "staleSideParentAction=true"),
			staleActiveThreadActionInactive: report.staleActiveThreadActionInactive
			&& !contains(decisionSummaries, "staleActiveThreadAction=true"),
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed && !contains(decisionSummaries, "liveTransport=true"),
			liveTerminalSuppressed: report.liveTerminalSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			noModelCall: report.noModelCall,
			noFilesystemMutation: report.noFilesystemMutation,
			decisionSummaries: decisionSummaries,
			sourceHandoffSummary: report.summary(),
			reason: accepted ? "post_completion_post_render_keyboard_ready" : "post_completion_post_render_keyboard_rejected"
		});
		log.push("postRenderKeyboard:" + out.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	function sourceReady(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffRenderGateReport):Bool {
		return report.handoffKind == ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffKind.RenderedIdleListReady
			&& report.postRenderIdleListReady
			&& report.keyboardInputReady
			&& report.listNavigationReady
			&& report.noLeftoverScheduledRenderRequest
			&& report.sourceSchedulerRequestCount == 1
			&& report.consumedScheduledRequestCount == 1
			&& report.renderCount == 1
			&& report.renderedSnapshotPreserved
			&& report.finalThreadId == "thread-surface-a"
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
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
	}

	function decide(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffRenderGateReport,
			intent:ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind, ready:Bool):ResumePickerAppServerTypedResponseRecoveryKeyboardDecision {
		final selectedBefore = selectedIndex;
		final threadBefore = threadAt(selectedBefore);
		final selectedAfter = ready ? nextIndex(selectedBefore, intent) : selectedBefore;
		final threadAfter = threadAt(selectedAfter);
		final decision = new ResumePickerAppServerTypedResponseRecoveryKeyboardDecision({
			kind: ready ? ResumePickerAppServerTypedResponseRecoveryKeyboardDecisionKind.NavigationAdmitted : ResumePickerAppServerTypedResponseRecoveryKeyboardDecisionKind.NavigationRejected,
			intent: intent,
			sequence: nextSequence,
			selectedBefore: selectedBefore,
			selectedAfter: selectedAfter,
			threadBefore: threadBefore,
			threadAfter: threadAfter,
			recoveredThreadPreservedBeforeNavigation: threadBefore == "thread-surface-a",
			navigationApplied: ready && selectedAfter != selectedBefore,
			keyboardInputReady: report.keyboardInputReady,
			listNavigationReady: report.listNavigationReady,
			promptActionInactive: report.stalePromptActionInactive,
			sideParentActionInactive: report.staleSideParentActionInactive,
			activeThreadActionInactive: report.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			reason: ready ? "post_completion_post_render_keyboard_navigation_ready" : "post_completion_post_render_keyboard_navigation_rejected"
		});
		selectedIndex = selectedAfter;
		nextSequence = nextSequence + 1;
		return decision;
	}

	function summariesFor(decisions:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardDecision>):Array<String> {
		final out:Array<String> = [];
		for (decision in decisions)
			out.push(decision.summary());
		return out;
	}

	function countAdmitted(decisions:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardDecision>):Int {
		var count = 0;
		for (decision in decisions)
			if (decision.kind == ResumePickerAppServerTypedResponseRecoveryKeyboardDecisionKind.NavigationAdmitted)
				count = count + 1;
		return count;
	}

	function allNavigationApplied(decisions:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardDecision>):Bool {
		if (decisions.length == 0)
			return false;
		for (decision in decisions)
			if (!decision.navigationApplied)
				return false;
		return true;
	}

	function nextIndex(current:Int, intent:ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind):Int {
		return switch intent {
			case ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveDown:
				current + 1 >= threads.length ? current : current + 1;
			case ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveUp:
				current <= 0 ? current : current - 1;
			case _:
				current;
		}
	}

	function threadAt(index:Int):String {
		return index < 0 || index >= threads.length ? "" : threads[index];
	}

	function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}
}
