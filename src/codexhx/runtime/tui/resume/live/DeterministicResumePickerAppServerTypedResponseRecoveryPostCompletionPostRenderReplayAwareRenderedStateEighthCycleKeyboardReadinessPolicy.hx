package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardDecisionKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardReadiness;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardReadinessPolicy {
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

	public function admit(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleScheduledExecutionHandoffRenderGateReport,
			intents:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind>):ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardReadiness {
		final ready = sourceReady(report);
		final decisions:Array<ResumePickerAppServerTypedResponseRecoveryKeyboardDecision> = [];
		for (intent in intents)
			decisions.push(decide(report, intent, ready));
		final decisionSummaries = summariesFor(decisions);
		final admittedCount = countAdmitted(decisions);
		final returnedToRecoveredSelection = decisions.length > 0 && decisions[decisions.length - 1].threadAfter == "thread-surface-a";
		final navigationApplied = allNavigationApplied(decisions);
		final stableUntilNavigation = decisions.length > 0 && decisions[0].recoveredThreadPreservedBeforeNavigation;
		final replayEvidencePreserved = report.replayCount == 2
			&& report.sourceReplayCount == 2
			&& report.sourceHandoffReplayCount == 2
			&& report.sourceHandoffReadinessDecisionCount == 2
			&& report.sourceHandoffRenderStateCount == 2
			&& report.sourceHandoffFrameRequests == 2
			&& report.sourceHandoffKeyboardRenderCount == 2
			&& report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved
			&& report.footerSummariesPreserved
			&& report.selectedMarkerMoved
			&& report.recoveredSelectionRestored;
		final secondCycleHandoffEvidencePreserved = report.sourceSecondCycleHandoffReplayCount == 2
			&& report.sourceSecondCycleHandoffReadinessDecisionCount == 2
			&& report.sourceSecondCycleHandoffRenderStateCount == 2
			&& report.sourceSecondCycleHandoffFrameRequests == 2
			&& report.sourceSecondCycleHandoffKeyboardRenderCount == 2
			&& report.sourceSecondCycleHandoffInputAdmitted
			&& report.sourceSecondCycleHandoffLocalOnlyRenderIntent;
		final thirdCycleHandoffEvidencePreserved = report.sourceThirdCycleHandoffReplayCount == 2
			&& report.sourceThirdCycleHandoffReadinessDecisionCount == 2
			&& report.sourceThirdCycleHandoffRenderStateCount == 2
			&& report.sourceThirdCycleHandoffFrameRequests == 2
			&& report.sourceThirdCycleHandoffKeyboardRenderCount == 2
			&& report.sourceThirdCycleHandoffInputAdmitted
			&& report.sourceThirdCycleHandoffLocalOnlyRenderIntent;
		final sourceRenderEvidencePreserved = report.sourceReadinessDecisionCount == 2
			&& report.sourceRenderStateCount == 2
			&& report.sourceFrameRequests == 2
			&& report.sourceKeyboardRenderCount == 2;
		final handoffEvidencePreserved = report.sourceInputAdmitted
			&& report.sourceLocalOnlyRenderIntent
			&& report.sourceHandoffInputAdmitted
			&& report.sourceHandoffLocalOnlyRenderIntent;
		final fourthCycleHandoffEvidencePreserved = report.sourceFourthCycleHandoffInputAdmitted
			&& report.sourceFourthCycleHandoffLocalOnlyRenderIntent;
		final accepted = ready
			&& admittedCount == intents.length
			&& navigationApplied
			&& stableUntilNavigation
			&& returnedToRecoveredSelection
			&& replayEvidencePreserved
			&& secondCycleHandoffEvidencePreserved
			&& thirdCycleHandoffEvidencePreserved
			&& fourthCycleHandoffEvidencePreserved
			&& sourceRenderEvidencePreserved
			&& handoffEvidencePreserved
			&& !contains(decisionSummaries, "navigation_rejected");
		final out = new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardReadiness({
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
			inputAdmitted: report.inputAdmitted,
			localOnlyRenderIntent: report.localOnlyRenderIntent,
			replayCount: report.replayCount,
			snapshotOrderPreserved: report.snapshotOrderPreserved,
			selectedMarkersPreserved: report.selectedMarkersPreserved,
			footerSummariesPreserved: report.footerSummariesPreserved,
			selectedMarkerMoved: report.selectedMarkerMoved,
			recoveredSelectionRestored: report.recoveredSelectionRestored,
			sourcePreExecutionSchedulerRequestCount: report.sourcePreExecutionSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: report.sourcePreExecutionConsumedRequestCount,
			sourcePreExecutionRenderCount: report.sourcePreExecutionRenderCount,
			sourceRenderedSnapshotPreserved: report.sourceRenderedSnapshotPreserved,
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
			reason: accepted ? "post_completion_post_render_replay_aware_rendered_state_eighth_cycle_keyboard_ready" : "post_completion_post_render_replay_aware_rendered_state_eighth_cycle_keyboard_rejected"
		});
		log.push("postRenderReplayAwareRenderedStateEighthCycleKeyboard:" + compactSummary(out));
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	function sourceReady(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleScheduledExecutionHandoffRenderGateReport):Bool {
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
			&& report.finalFooter == FinalFooter
			&& report.finalSelectionPreserved
			&& report.finalFooterPreserved
			&& report.inputAdmitted
			&& report.localOnlyRenderIntent
			&& report.completionReady
			&& report.nextSliceReady
			&& report.replayCount == 2
			&& report.sourceReplayCount == 2
			&& report.sourceHandoffReplayCount == 2
			&& report.sourceHandoffReadinessDecisionCount == 2
			&& report.sourceHandoffRenderStateCount == 2
			&& report.sourceHandoffFrameRequests == 2
			&& report.sourceHandoffKeyboardRenderCount == 2
			&& report.sourceSecondCycleHandoffReplayCount == 2
			&& report.sourceSecondCycleHandoffReadinessDecisionCount == 2
			&& report.sourceSecondCycleHandoffRenderStateCount == 2
			&& report.sourceSecondCycleHandoffFrameRequests == 2
			&& report.sourceSecondCycleHandoffKeyboardRenderCount == 2
			&& report.sourceThirdCycleHandoffReplayCount == 2
			&& report.sourceThirdCycleHandoffReadinessDecisionCount == 2
			&& report.sourceThirdCycleHandoffRenderStateCount == 2
			&& report.sourceThirdCycleHandoffFrameRequests == 2
			&& report.sourceThirdCycleHandoffKeyboardRenderCount == 2
			&& report.sourceReadinessDecisionCount == 2
			&& report.sourceRenderStateCount == 2
			&& report.sourceFrameRequests == 2
			&& report.sourceKeyboardRenderCount == 2
			&& report.snapshotOrderPreserved
			&& report.selectedMarkersPreserved
			&& report.footerSummariesPreserved
			&& report.selectedMarkerMoved
			&& report.recoveredSelectionRestored
			&& report.sourcePreExecutionSchedulerRequestCount == 1
			&& report.sourcePreExecutionConsumedRequestCount == 1
			&& report.sourcePreExecutionRenderCount == 1
			&& report.sourceRenderedSnapshotPreserved
			&& report.sourceInputAdmitted
			&& report.sourceLocalOnlyRenderIntent
			&& report.sourceHandoffInputAdmitted
			&& report.sourceHandoffLocalOnlyRenderIntent
			&& report.sourceSecondCycleHandoffInputAdmitted
			&& report.sourceSecondCycleHandoffLocalOnlyRenderIntent
			&& report.sourceThirdCycleHandoffInputAdmitted
			&& report.sourceThirdCycleHandoffLocalOnlyRenderIntent
			&& report.sourceFourthCycleHandoffInputAdmitted
			&& report.sourceFourthCycleHandoffLocalOnlyRenderIntent
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

	function decide(report:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleScheduledExecutionHandoffRenderGateReport,
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
			reason: ready ? "post_completion_post_render_replay_aware_rendered_state_eighth_cycle_keyboard_navigation_ready" : "navigation_rejected"
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

	function compactSummary(readiness:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardReadiness):String {
		return "kind="
			+ readiness.kind
			+ ";sourceHandoffKind="
			+ readiness.sourceHandoffKind
			+ ";decisionCount="
			+ readiness.decisionCount
			+ ";admittedCount="
			+ readiness.admittedCount
			+ ";postRenderIdleListReady="
			+ boolLabel(readiness.postRenderIdleListReady)
			+ ";keyboardInputReady="
			+ boolLabel(readiness.keyboardInputReady)
			+ ";listNavigationReady="
			+ boolLabel(readiness.listNavigationReady)
			+ ";recoveredSelectionStableUntilNavigation="
			+ boolLabel(readiness.recoveredSelectionStableUntilNavigation)
			+ ";navigationApplied="
			+ boolLabel(readiness.navigationApplied)
			+ ";returnedToRecoveredSelection="
			+ boolLabel(readiness.returnedToRecoveredSelection)
			+ ";noLeftoverScheduledRenderRequest="
			+ boolLabel(readiness.noLeftoverScheduledRenderRequest)
			+ ";sourceSchedulerRequestCount="
			+ readiness.sourceSchedulerRequestCount
			+ ";consumedScheduledRequestCount="
			+ readiness.consumedScheduledRequestCount
			+ ";renderCount="
			+ readiness.renderCount
			+ ";renderedSnapshotPreserved="
			+ boolLabel(readiness.renderedSnapshotPreserved)
			+ ";finalThread="
			+ readiness.finalThreadId
			+ ";finalFooter="
			+ readiness.finalFooter
			+ ";finalSelectionPreserved="
			+ boolLabel(readiness.finalSelectionPreserved)
			+ ";finalFooterPreserved="
			+ boolLabel(readiness.finalFooterPreserved)
			+ ";inputAdmitted="
			+ boolLabel(readiness.inputAdmitted)
			+ ";localOnlyRenderIntent="
			+ boolLabel(readiness.localOnlyRenderIntent)
			+ ";replayCount="
			+ readiness.replayCount
			+ ";snapshotOrderPreserved="
			+ boolLabel(readiness.snapshotOrderPreserved)
			+ ";selectedMarkersPreserved="
			+ boolLabel(readiness.selectedMarkersPreserved)
			+ ";footerSummariesPreserved="
			+ boolLabel(readiness.footerSummariesPreserved)
			+ ";selectedMarkerMoved="
			+ boolLabel(readiness.selectedMarkerMoved)
			+ ";recoveredSelectionRestored="
			+ boolLabel(readiness.recoveredSelectionRestored)
			+ ";sourcePreExecutionSchedulerRequestCount="
			+ readiness.sourcePreExecutionSchedulerRequestCount
			+ ";sourcePreExecutionConsumedRequestCount="
			+ readiness.sourcePreExecutionConsumedRequestCount
			+ ";sourcePreExecutionRenderCount="
			+ readiness.sourcePreExecutionRenderCount
			+ ";sourceRenderedSnapshotPreserved="
			+ boolLabel(readiness.sourceRenderedSnapshotPreserved)
			+ ";stalePromptActionInactive="
			+ boolLabel(readiness.stalePromptActionInactive)
			+ ";staleSideParentActionInactive="
			+ boolLabel(readiness.staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive="
			+ boolLabel(readiness.staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent="
			+ boolLabel(readiness.ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection="
			+ boolLabel(readiness.noPressureDropRejection)
			+ ";liveTransportSuppressed="
			+ boolLabel(readiness.liveTransportSuppressed)
			+ ";liveTerminalSuppressed="
			+ boolLabel(readiness.liveTerminalSuppressed)
			+ ";stateDbUntouched="
			+ boolLabel(readiness.stateDbUntouched)
			+ ";noModelCall="
			+ boolLabel(readiness.noModelCall)
			+ ";noFilesystemMutation="
			+ boolLabel(readiness.noFilesystemMutation)
			+ ";reason="
			+ readiness.reason;
	}

	function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
