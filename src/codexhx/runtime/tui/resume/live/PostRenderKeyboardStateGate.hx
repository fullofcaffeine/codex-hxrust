package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecisionKind;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardRenderState;
import codexhx.runtime.tui.resume.host.PostRenderKeyboardReadinessKind;

class PostRenderKeyboardStateGate {
	static final FinalFooter = "footer keyboard move_up selected=0 selectedThread=thread-surface-a";

	public static function run():PostRenderKeyboardStateReport {
		final readinessReport = PostRenderKeyboardReadinessGate.run();
		final decisions = decisionsFrom(readinessReport);
		final projector = new RecoveryKeyboardStateProjector();
		final renderStates = projectAll(projector, decisions);
		final snapshots = projector.renderSnapshots();
		final finalState = renderStates[renderStates.length - 1];

		return new PostRenderKeyboardStateReport({
			readinessDecisionCount: readinessReport.decisionCount,
			renderStateCount: renderStates.length,
			frameRequests: projector.frameRequests(),
			renderCount: projector.renderCount(),
			selectedMarkerMoved: snapshots.length == 2 && contains(snapshots[0], "> Recovered navigation target | thread-surface-b"),
			recoveredSelectionRestored: finalState.recoveredThreadRestored
			&& contains(finalState.snapshot, "> Recovered surface thread | thread-surface-a"),
			noLeftoverScheduledRenderRequest: readinessReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: readinessReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: readinessReport.consumedScheduledRequestCount,
			sourceRenderCount: readinessReport.renderCount,
			renderedSnapshotPreserved: readinessReport.renderedSnapshotPreserved,
			finalThreadId: finalState.selectedThreadId,
			finalFooter: FinalFooter,
			finalSelectionPreserved: readinessReport.finalSelectionPreserved,
			finalFooterPreserved: readinessReport.finalFooterPreserved && contains(finalState.snapshot, FinalFooter),
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
			finalSnapshot: finalState.snapshot,
			renderSnapshots: snapshots,
			renderStateSummaries: projector.renderStateSummaries(),
			readinessSummary: readinessReport.summary()
		});
	}

	static function decisionsFrom(readinessReport:PostRenderKeyboardReadinessReport):Array<RecoveryKeyboardDecision> {
		final ready = readinessReport.readinessKind == PostRenderKeyboardReadinessKind.PostRenderKeyboardReady
			&& readinessReport.keyboardInputReady
			&& readinessReport.listNavigationReady;
		return [
			decision(ready, RecoveryKeyboardIntentKind.MoveDown, 1, 0, 1, "thread-surface-a", "thread-surface-b", "thread-surface-a", readinessReport),
			decision(ready, RecoveryKeyboardIntentKind.MoveUp, 2, 1, 0, "thread-surface-b", "thread-surface-a", "thread-surface-b", readinessReport)
		];
	}

	static function decision(ready:Bool, intent:RecoveryKeyboardIntentKind, sequence:Int, selectedBefore:Int, selectedAfter:Int, threadBefore:String,
			threadAfter:String, rejectedThreadAfter:String, readinessReport:PostRenderKeyboardReadinessReport):RecoveryKeyboardDecision {
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
			reason: ready ? "post_completion_post_render_keyboard_render_state_decision_ready" : "post_completion_post_render_keyboard_render_state_decision_rejected"
		});
	}

	static function projectAll(projector:RecoveryKeyboardStateProjector, decisions:Array<RecoveryKeyboardDecision>):Array<RecoveryKeyboardRenderState> {
		final out:Array<RecoveryKeyboardRenderState> = [];
		for (decision in decisions)
			out.push(projector.project(decision));
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
