package codexhx.validation.tui.resume.live.recovery.ninth;

import codexhx.validation.tui.resume.live.NinthKeyboardStateGate;
import codexhx.validation.tui.resume.live.NinthKeyboardStateReport;
import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.RecoveryRenderSnapshotReplay;
import codexhx.runtime.tui.resume.host.RecoveryRenderSnapshotReplayKind;

class SnapshotReplayGate {
	public static function run():SnapshotReplayReport {
		final sourceReport = NinthKeyboardStateGate.run();
		final replays = replay(sourceReport);
		final snapshots = replayedSnapshots(replays);

		return new SnapshotReplayReport({
			sourceReadinessDecisionCount: sourceReport.readinessDecisionCount,
			sourceRenderStateCount: sourceReport.renderStateCount,
			sourceFrameRequests: sourceReport.frameRequests,
			sourceKeyboardRenderCount: sourceReport.renderCount,
			replayCount: replays.length,
			sourceReplayCount: sourceReport.replayCount,
			sourceHandoffReplayCount: sourceReport.sourceHandoffReplayCount,
			sourceHandoffReadinessDecisionCount: sourceReport.sourceHandoffReadinessDecisionCount,
			sourceHandoffRenderStateCount: sourceReport.sourceHandoffRenderStateCount,
			sourceHandoffFrameRequests: sourceReport.sourceHandoffFrameRequests,
			sourceHandoffKeyboardRenderCount: sourceReport.sourceHandoffKeyboardRenderCount,
			sourceSecondCycleHandoffReplayCount: sourceReport.sourceSecondCycleHandoffReplayCount,
			sourceSecondCycleHandoffReadinessDecisionCount: sourceReport.sourceSecondCycleHandoffReadinessDecisionCount,
			sourceSecondCycleHandoffRenderStateCount: sourceReport.sourceSecondCycleHandoffRenderStateCount,
			sourceSecondCycleHandoffFrameRequests: sourceReport.sourceSecondCycleHandoffFrameRequests,
			sourceSecondCycleHandoffKeyboardRenderCount: sourceReport.sourceSecondCycleHandoffKeyboardRenderCount,
			sourceThirdCycleHandoffReplayCount: sourceReport.sourceThirdCycleHandoffReplayCount,
			sourceThirdCycleHandoffReadinessDecisionCount: sourceReport.sourceThirdCycleHandoffReadinessDecisionCount,
			sourceThirdCycleHandoffRenderStateCount: sourceReport.sourceThirdCycleHandoffRenderStateCount,
			sourceThirdCycleHandoffFrameRequests: sourceReport.sourceThirdCycleHandoffFrameRequests,
			sourceThirdCycleHandoffKeyboardRenderCount: sourceReport.sourceThirdCycleHandoffKeyboardRenderCount,
			snapshotOrderPreserved: sourceReport.snapshotOrderPreserved && allOrderPreserved(replays),
			selectedMarkersPreserved: sourceReport.selectedMarkersPreserved && allMarkersMatched(replays),
			footerSummariesPreserved: sourceReport.footerSummariesPreserved && allFootersMatched(replays),
			selectedMarkerMoved: sourceReport.selectedMarkerMoved,
			recoveredSelectionRestored: sourceReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: sourceReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: sourceReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: sourceReport.consumedScheduledRequestCount,
			sourcePostRenderRenderCount: sourceReport.sourceRenderCount,
			renderedSnapshotPreserved: sourceReport.renderedSnapshotPreserved,
			sourceRenderedSnapshotPreserved: sourceReport.sourceRenderedSnapshotPreserved,
			finalSelectionPreserved: sourceReport.finalSelectionPreserved,
			finalFooterPreserved: sourceReport.finalFooterPreserved && contains(sourceReport.finalSnapshot, sourceReport.finalFooter),
			inputAdmitted: sourceReport.inputAdmitted,
			localOnlyRenderIntent: sourceReport.localOnlyRenderIntent,
			completionReady: sourceReport.completionReady,
			nextSliceReady: sourceReport.nextSliceReady,
			sourceInputAdmitted: sourceReport.sourceInputAdmitted,
			sourceLocalOnlyRenderIntent: sourceReport.sourceLocalOnlyRenderIntent,
			sourceHandoffInputAdmitted: sourceReport.sourceHandoffInputAdmitted,
			sourceHandoffLocalOnlyRenderIntent: sourceReport.sourceHandoffLocalOnlyRenderIntent,
			sourceSecondCycleHandoffInputAdmitted: sourceReport.sourceSecondCycleHandoffInputAdmitted,
			sourceSecondCycleHandoffLocalOnlyRenderIntent: sourceReport.sourceSecondCycleHandoffLocalOnlyRenderIntent,
			sourceThirdCycleHandoffInputAdmitted: sourceReport.sourceThirdCycleHandoffInputAdmitted,
			sourceThirdCycleHandoffLocalOnlyRenderIntent: sourceReport.sourceThirdCycleHandoffLocalOnlyRenderIntent,
			sourceFourthCycleHandoffInputAdmitted: sourceReport.sourceFourthCycleHandoffInputAdmitted,
			sourceFourthCycleHandoffLocalOnlyRenderIntent: sourceReport.sourceFourthCycleHandoffLocalOnlyRenderIntent,
			stalePromptActionInactive: sourceReport.stalePromptActionInactive && allPromptInactive(replays),
			staleSideParentActionInactive: sourceReport.staleSideParentActionInactive && allSideParentInactive(replays),
			staleActiveThreadActionInactive: sourceReport.staleActiveThreadActionInactive && allActiveThreadInactive(replays),
			ignoredNoSurfaceRecordsAbsent: sourceReport.ignoredNoSurfaceRecordsAbsent && allIgnoredNoSurfaceAbsent(replays),
			noPressureDropRejection: sourceReport.noPressureDropRejection && allNoPressureDropRejection(replays),
			liveTransportSuppressed: sourceReport.liveTransportSuppressed && allLiveTransportSuppressed(replays),
			liveTerminalSuppressed: sourceReport.liveTerminalSuppressed && allLiveTerminalSuppressed(replays),
			stateDbUntouched: sourceReport.stateDbUntouched && allStateDbUntouched(replays),
			noModelCall: sourceReport.noModelCall,
			noFilesystemMutation: sourceReport.noFilesystemMutation,
			finalThreadId: sourceReport.finalThreadId,
			finalFooter: sourceReport.finalFooter,
			finalSnapshot: sourceReport.finalSnapshot,
			replayedSnapshots: snapshots,
			replaySummaries: replaySummaries(replays),
			sourceSummary: sourceReport.readinessSummary
		});
	}

	static function replay(report:NinthKeyboardStateReport):Array<RecoveryRenderSnapshotReplay> {
		return [
			entry(report, 0, 1, RecoveryKeyboardIntentKind.MoveDown, "thread-surface-b", "> Recovered navigation target | thread-surface-b",
				"footer keyboard move_down selected=1 selectedThread=thread-surface-b"),
			entry(report, 1, 2, RecoveryKeyboardIntentKind.MoveUp, "thread-surface-a", "> Recovered surface thread | thread-surface-a",
				"footer keyboard move_up selected=0 selectedThread=thread-surface-a")
		];
	}

	static function entry(report:NinthKeyboardStateReport, replayIndex:Int, sourceSequence:Int, intent:RecoveryKeyboardIntentKind, selectedThreadId:String,
			expectedMarker:String, expectedFooter:String):RecoveryRenderSnapshotReplay {
		final snapshot = snapshotAt(report.renderSnapshots, replayIndex);
		return new RecoveryRenderSnapshotReplay({
			kind: RecoveryRenderSnapshotReplayKind.KeyboardNavigationSnapshot,
			intent: intent,
			replayIndex: replayIndex,
			sourceSequence: sourceSequence,
			selectedThreadId: selectedThreadId,
			expectedMarker: expectedMarker,
			expectedFooter: expectedFooter,
			markerMatched: contains(snapshot, expectedMarker),
			footerMatched: contains(snapshot, expectedFooter),
			orderPreserved: sourceSequence == replayIndex + 1,
			stalePromptActionInactive: report.stalePromptActionInactive,
			staleSideParentActionInactive: report.staleSideParentActionInactive,
			staleActiveThreadActionInactive: report.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: report.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			liveTerminalSuppressed: report.liveTerminalSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			snapshot: snapshot,
			reason: "post_completion_post_render_replay_aware_rendered_state_ninth_cycle_keyboard_snapshot_replayed"
		});
	}

	static function replayedSnapshots(replays:Array<RecoveryRenderSnapshotReplay>):Array<String> {
		final out:Array<String> = [];
		for (replay in replays)
			out.push(replay.snapshot);
		return out;
	}

	static function replaySummaries(replays:Array<RecoveryRenderSnapshotReplay>):Array<String> {
		final out:Array<String> = [];
		for (replay in replays)
			out.push(replay.summary());
		return out;
	}

	static function allOrderPreserved(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.orderPreserved)
				return false;
		return true;
	}

	static function allMarkersMatched(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.markerMatched)
				return false;
		return true;
	}

	static function allFootersMatched(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.footerMatched)
				return false;
		return true;
	}

	static function allPromptInactive(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.stalePromptActionInactive)
				return false;
		return true;
	}

	static function allSideParentInactive(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.staleSideParentActionInactive)
				return false;
		return true;
	}

	static function allActiveThreadInactive(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.staleActiveThreadActionInactive)
				return false;
		return true;
	}

	static function allIgnoredNoSurfaceAbsent(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.ignoredNoSurfaceRecordsAbsent)
				return false;
		return true;
	}

	static function allNoPressureDropRejection(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.noPressureDropRejection)
				return false;
		return true;
	}

	static function allLiveTransportSuppressed(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.liveTransportSuppressed)
				return false;
		return true;
	}

	static function allLiveTerminalSuppressed(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.liveTerminalSuppressed)
				return false;
		return true;
	}

	static function allStateDbUntouched(replays:Array<RecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.stateDbUntouched)
				return false;
		return true;
	}

	static function snapshotAt(snapshots:Array<String>, index:Int):String {
		return index < snapshots.length ? snapshots[index] : "";
	}

	static function contains(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
