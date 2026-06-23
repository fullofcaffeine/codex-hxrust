package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryKeyboardDecision;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardRenderState;

class RecoveryKeyboardStateGate {
	public static function run():RecoveryKeyboardStateReport {
		final readinessReport = RecoveryKeyboardReadinessGate.run();
		final handoffReport = RecoveryIdleStateHandoffGate.run();
		final policy = new RecoveryKeyboardReadinessPolicy();
		final decisions = [
			policy.admit(handoffReport, RecoveryKeyboardIntentKind.MoveDown),
			policy.admit(handoffReport, RecoveryKeyboardIntentKind.MoveUp)
		];
		final projector = new RecoveryKeyboardStateProjector();
		final renderStates = projectAll(projector, decisions);
		final snapshots = projector.renderSnapshots();
		final finalState = renderStates[renderStates.length - 1];

		return new RecoveryKeyboardStateReport({
			readinessDecisionCount: readinessReport.decisionCount,
			renderStateCount: renderStates.length,
			frameRequests: projector.frameRequests(),
			renderCount: projector.renderCount(),
			selectedMarkerMoved: snapshots.length == 2 && contains(snapshots[0], "> Recovered navigation target | thread-surface-b"),
			recoveredSelectionRestored: finalState.recoveredThreadRestored
			&& contains(finalState.snapshot, "> Recovered surface thread | thread-surface-a"),
			stalePromptActionInactive: allPromptInactive(renderStates),
			staleSideParentActionInactive: allSideParentInactive(renderStates),
			staleActiveThreadActionInactive: allActiveThreadInactive(renderStates),
			ignoredNoSurfaceRecordsAbsent: allIgnoredNoSurfaceAbsent(renderStates),
			noPressureDropRejection: readinessReport.noPressureDropRejection && allNoPressureDropRejection(renderStates),
			liveTransportSuppressed: readinessReport.liveTransportSuppressed && allLiveTransportSuppressed(renderStates),
			liveTerminalSuppressed: allLiveTerminalSuppressed(renderStates),
			stateDbUntouched: readinessReport.stateDbUntouched && allStateDbUntouched(renderStates),
			finalThreadId: finalState.selectedThreadId,
			finalSnapshot: finalState.snapshot,
			renderSnapshots: snapshots,
			renderStateSummaries: projector.renderStateSummaries(),
			readinessSummary: readinessReport.summary()
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
