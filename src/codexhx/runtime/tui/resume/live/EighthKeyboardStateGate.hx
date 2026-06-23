package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecisionKind;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardRenderState;
import codexhx.runtime.tui.resume.host.PostRenderKeyboardReadinessKind;

class EighthKeyboardStateGate {
	static final FinalFooter = "footer keyboard move_up selected=0 selectedThread=thread-surface-a";

	public static function run():EighthKeyboardStateReport {
		final readinessReport = EighthKeyboardReadinessGate.run();
		final decisions = decisionsFrom(readinessReport);
		final projector = new RecoveryKeyboardStateProjector();
		final renderStates = projectAll(projector, decisions);
		final snapshots = projector.renderSnapshots();
		final finalState = renderStates[renderStates.length - 1];
		final selectedMarkerMoved = snapshots.length == 2 && contains(snapshots[0], "> Recovered navigation target | thread-surface-b");
		final recoveredSelectionRestored = finalState.recoveredThreadRestored
			&& contains(finalState.snapshot, "> Recovered surface thread | thread-surface-a");

		return new EighthKeyboardStateReport({
			readinessDecisionCount: readinessReport.decisionCount,
			readinessAdmittedCount: readinessReport.admittedCount,
			renderStateCount: renderStates.length,
			frameRequests: projector.frameRequests(),
			renderCount: projector.renderCount(),
			selectedMarkerMoved: selectedMarkerMoved,
			recoveredSelectionRestored: recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: readinessReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: readinessReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: readinessReport.consumedScheduledRequestCount,
			sourceRenderCount: readinessReport.renderCount,
			renderedSnapshotPreserved: readinessReport.renderedSnapshotPreserved,
			finalThreadId: finalState.selectedThreadId,
			finalFooter: FinalFooter,
			finalSelectionPreserved: readinessReport.finalSelectionPreserved && recoveredSelectionRestored,
			finalFooterPreserved: readinessReport.finalFooterPreserved && contains(finalState.snapshot, FinalFooter),
			inputAdmitted: readinessReport.inputAdmitted,
			localOnlyRenderIntent: readinessReport.localOnlyRenderIntent,
			completionReady: readinessReport.completionReady,
			nextSliceReady: readinessReport.nextSliceReady,
			replayCount: readinessReport.replayCount,
			sourceReplayCount: readinessReport.sourceReplayCount,
			sourceHandoffReplayCount: readinessReport.sourceHandoffReplayCount,
			sourceHandoffReadinessDecisionCount: readinessReport.sourceHandoffReadinessDecisionCount,
			sourceHandoffRenderStateCount: readinessReport.sourceHandoffRenderStateCount,
			sourceHandoffFrameRequests: readinessReport.sourceHandoffFrameRequests,
			sourceHandoffKeyboardRenderCount: readinessReport.sourceHandoffKeyboardRenderCount,
			sourceSecondCycleHandoffReplayCount: readinessReport.sourceSecondCycleHandoffReplayCount,
			sourceSecondCycleHandoffReadinessDecisionCount: readinessReport.sourceSecondCycleHandoffReadinessDecisionCount,
			sourceSecondCycleHandoffRenderStateCount: readinessReport.sourceSecondCycleHandoffRenderStateCount,
			sourceSecondCycleHandoffFrameRequests: readinessReport.sourceSecondCycleHandoffFrameRequests,
			sourceSecondCycleHandoffKeyboardRenderCount: readinessReport.sourceSecondCycleHandoffKeyboardRenderCount,
			sourceThirdCycleHandoffReplayCount: readinessReport.sourceThirdCycleHandoffReplayCount,
			sourceThirdCycleHandoffReadinessDecisionCount: readinessReport.sourceThirdCycleHandoffReadinessDecisionCount,
			sourceThirdCycleHandoffRenderStateCount: readinessReport.sourceThirdCycleHandoffRenderStateCount,
			sourceThirdCycleHandoffFrameRequests: readinessReport.sourceThirdCycleHandoffFrameRequests,
			sourceThirdCycleHandoffKeyboardRenderCount: readinessReport.sourceThirdCycleHandoffKeyboardRenderCount,
			sourceReadinessDecisionCount: readinessReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: readinessReport.sourceRenderStateCount,
			sourceFrameRequests: readinessReport.sourceFrameRequests,
			sourceKeyboardRenderCount: readinessReport.sourceKeyboardRenderCount,
			snapshotOrderPreserved: readinessReport.snapshotOrderPreserved,
			selectedMarkersPreserved: readinessReport.selectedMarkersPreserved && selectedMarkerMoved,
			footerSummariesPreserved: readinessReport.footerSummariesPreserved && contains(finalState.snapshot, FinalFooter),
			sourceSelectedMarkerMoved: readinessReport.selectedMarkerMoved,
			sourceRecoveredSelectionRestored: readinessReport.recoveredSelectionRestored,
			sourcePreExecutionSchedulerRequestCount: readinessReport.sourcePreExecutionSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: readinessReport.sourcePreExecutionConsumedRequestCount,
			sourcePreExecutionRenderCount: readinessReport.sourcePreExecutionRenderCount,
			sourceRenderedSnapshotPreserved: readinessReport.sourceRenderedSnapshotPreserved,
			sourceInputAdmitted: readinessReport.sourceInputAdmitted,
			sourceLocalOnlyRenderIntent: readinessReport.sourceLocalOnlyRenderIntent,
			sourceHandoffInputAdmitted: readinessReport.sourceHandoffInputAdmitted,
			sourceHandoffLocalOnlyRenderIntent: readinessReport.sourceHandoffLocalOnlyRenderIntent,
			sourceSecondCycleHandoffInputAdmitted: readinessReport.sourceSecondCycleHandoffInputAdmitted,
			sourceSecondCycleHandoffLocalOnlyRenderIntent: readinessReport.sourceSecondCycleHandoffLocalOnlyRenderIntent,
			sourceThirdCycleHandoffInputAdmitted: readinessReport.sourceThirdCycleHandoffInputAdmitted,
			sourceThirdCycleHandoffLocalOnlyRenderIntent: readinessReport.sourceThirdCycleHandoffLocalOnlyRenderIntent,
			sourceFourthCycleHandoffInputAdmitted: readinessReport.sourceFourthCycleHandoffInputAdmitted,
			sourceFourthCycleHandoffLocalOnlyRenderIntent: readinessReport.sourceFourthCycleHandoffLocalOnlyRenderIntent,
			stalePromptActionInactive: readinessReport.stalePromptActionInactive && allPromptInactive(renderStates),
			staleSideParentActionInactive: readinessReport.staleSideParentActionInactive && allSideParentInactive(renderStates),
			staleActiveThreadActionInactive: readinessReport.staleActiveThreadActionInactive && allActiveThreadInactive(renderStates),
			ignoredNoSurfaceRecordsAbsent: readinessReport.ignoredNoSurfaceRecordsAbsent && allIgnoredNoSurfaceAbsent(renderStates),
			noPressureDropRejection: readinessReport.noPressureDropRejection && allNoPressureDropRejection(renderStates),
			liveTransportSuppressed: readinessReport.liveTransportSuppressed && allLiveTransportSuppressed(renderStates),
			liveTerminalSuppressed: readinessReport.liveTerminalSuppressed && allLiveTerminalSuppressed(renderStates),
			stateDbUntouched: readinessReport.stateDbUntouched && allStateDbUntouched(renderStates),
			noModelCall: readinessReport.noModelCall,
			noFilesystemMutation: readinessReport.noFilesystemMutation,
			decisionSummaries: summariesFor(decisions),
			finalSnapshot: finalState.snapshot,
			renderSnapshots: snapshots,
			renderStateSummaries: projector.renderStateSummaries(),
			readinessSummary: readinessReport.readinessSummary
		});
	}

	static function decisionsFrom(readinessReport:EighthKeyboardReadinessReport):Array<RecoveryKeyboardDecision> {
		final ready = readinessReport.readinessKind == PostRenderKeyboardReadinessKind.PostRenderKeyboardReady
			&& readinessReport.keyboardInputReady
			&& readinessReport.listNavigationReady
			&& readinessReport.decisionCount == 2
			&& readinessReport.admittedCount == 2
			&& readinessReport.completionReady
			&& readinessReport.nextSliceReady
			&& readinessReport.replayCount == 2
			&& readinessReport.sourceReplayCount == 2
			&& readinessReport.sourceHandoffReplayCount == 2
			&& readinessReport.sourceHandoffReadinessDecisionCount == 2
			&& readinessReport.sourceHandoffRenderStateCount == 2
			&& readinessReport.sourceHandoffFrameRequests == 2
			&& readinessReport.sourceHandoffKeyboardRenderCount == 2
			&& readinessReport.sourceSecondCycleHandoffReplayCount == 2
			&& readinessReport.sourceSecondCycleHandoffReadinessDecisionCount == 2
			&& readinessReport.sourceSecondCycleHandoffRenderStateCount == 2
			&& readinessReport.sourceSecondCycleHandoffFrameRequests == 2
			&& readinessReport.sourceSecondCycleHandoffKeyboardRenderCount == 2
			&& readinessReport.sourceThirdCycleHandoffReplayCount == 2
			&& readinessReport.sourceThirdCycleHandoffReadinessDecisionCount == 2
			&& readinessReport.sourceThirdCycleHandoffRenderStateCount == 2
			&& readinessReport.sourceThirdCycleHandoffFrameRequests == 2
			&& readinessReport.sourceThirdCycleHandoffKeyboardRenderCount == 2
			&& readinessReport.sourceReadinessDecisionCount == 2
			&& readinessReport.sourceRenderStateCount == 2
			&& readinessReport.sourceFrameRequests == 2
			&& readinessReport.sourceKeyboardRenderCount == 2
			&& readinessReport.snapshotOrderPreserved
			&& readinessReport.selectedMarkersPreserved
			&& readinessReport.footerSummariesPreserved
			&& readinessReport.sourceInputAdmitted
			&& readinessReport.sourceLocalOnlyRenderIntent
			&& readinessReport.sourceHandoffInputAdmitted
			&& readinessReport.sourceHandoffLocalOnlyRenderIntent
			&& readinessReport.sourceSecondCycleHandoffInputAdmitted
			&& readinessReport.sourceSecondCycleHandoffLocalOnlyRenderIntent
			&& readinessReport.sourceThirdCycleHandoffInputAdmitted
			&& readinessReport.sourceThirdCycleHandoffLocalOnlyRenderIntent
			&& readinessReport.sourceFourthCycleHandoffInputAdmitted
			&& readinessReport.sourceFourthCycleHandoffLocalOnlyRenderIntent;
		return [
			decision(ready, RecoveryKeyboardIntentKind.MoveDown, 1, 0, 1, "thread-surface-a", "thread-surface-b", "thread-surface-a", readinessReport),
			decision(ready, RecoveryKeyboardIntentKind.MoveUp, 2, 1, 0, "thread-surface-b", "thread-surface-a", "thread-surface-b", readinessReport)
		];
	}

	static function decision(ready:Bool, intent:RecoveryKeyboardIntentKind, sequence:Int, selectedBefore:Int, selectedAfter:Int, threadBefore:String,
			threadAfter:String, rejectedThreadAfter:String, readinessReport:EighthKeyboardReadinessReport):RecoveryKeyboardDecision {
		return new RecoveryKeyboardDecision({
			kind: ready ? RecoveryKeyboardDecisionKind.NavigationAdmitted : RecoveryKeyboardDecisionKind.NavigationRejected,
			intent: intent,
			sequence: sequence,
			selectedBefore: selectedBefore,
			selectedAfter: ready ? selectedAfter : selectedBefore,
			threadBefore: threadBefore,
			threadAfter: ready ? threadAfter : rejectedThreadAfter,
			recoveredThreadPreservedBeforeNavigation: threadBefore == "thread-surface-a",
			navigationApplied: ready && selectedAfter != selectedBefore,
			keyboardInputReady: readinessReport.keyboardInputReady,
			listNavigationReady: readinessReport.listNavigationReady,
			promptActionInactive: readinessReport.stalePromptActionInactive,
			sideParentActionInactive: readinessReport.staleSideParentActionInactive,
			activeThreadActionInactive: readinessReport.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: readinessReport.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: readinessReport.noPressureDropRejection,
			liveTransportSuppressed: readinessReport.liveTransportSuppressed,
			stateDbUntouched: readinessReport.stateDbUntouched,
			reason: ready ? "post_completion_post_render_replay_aware_rendered_state_eighth_cycle_keyboard_render_state_decision_ready" : "post_completion_post_render_replay_aware_rendered_state_eighth_cycle_keyboard_render_state_decision_rejected"
		});
	}

	static function projectAll(projector:RecoveryKeyboardStateProjector, decisions:Array<RecoveryKeyboardDecision>):Array<RecoveryKeyboardRenderState> {
		final out:Array<RecoveryKeyboardRenderState> = [];
		for (decision in decisions)
			out.push(projector.project(decision));
		return out;
	}

	static function summariesFor(decisions:Array<RecoveryKeyboardDecision>):Array<String> {
		final out:Array<String> = [];
		for (decision in decisions)
			out.push(decision.summary());
		return out;
	}

	static function allPromptInactive(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.stalePromptActionInactive)
				return false;
		return true;
	}

	static function allSideParentInactive(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.staleSideParentActionInactive)
				return false;
		return true;
	}

	static function allActiveThreadInactive(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.staleActiveThreadActionInactive)
				return false;
		return true;
	}

	static function allIgnoredNoSurfaceAbsent(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.ignoredNoSurfaceRecordsAbsent)
				return false;
		return true;
	}

	static function allNoPressureDropRejection(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.noPressureDropRejection)
				return false;
		return true;
	}

	static function allLiveTransportSuppressed(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.liveTransportSuppressed)
				return false;
		return true;
	}

	static function allLiveTerminalSuppressed(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.liveTerminalSuppressed)
				return false;
		return true;
	}

	static function allStateDbUntouched(states:Array<RecoveryKeyboardRenderState>):Bool {
		for (state in states)
			if (!state.stateDbUntouched)
				return false;
		return true;
	}

	static function contains(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
