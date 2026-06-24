package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryRenderSnapshotReplay;

class PostRenderSnapshotReplayGate {
	public static function run():PostRenderSnapshotReplayReport {
		final sourceReport = PostRenderKeyboardStateGate.run();
		final replayer = new PostRenderSnapshotReplayer();
		final replays = replayer.replay(sourceReport);
		final snapshots = replayedSnapshots(replays);

		return new PostRenderSnapshotReplayReport({
			sourceRenderStateCount: sourceReport.renderStateCount,
			replayCount: replays.length,
			snapshotOrderPreserved: allOrderPreserved(replays),
			selectedMarkersPreserved: sourceReport.selectedMarkerMoved && allMarkersMatched(replays),
			footerSummariesPreserved: allFootersMatched(replays),
			selectedMarkerMoved: sourceReport.selectedMarkerMoved,
			recoveredSelectionRestored: sourceReport.recoveredSelectionRestored,
			noLeftoverScheduledRenderRequest: sourceReport.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: sourceReport.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: sourceReport.consumedScheduledRequestCount,
			sourceRenderCount: sourceReport.sourceRenderCount,
			renderedSnapshotPreserved: sourceReport.renderedSnapshotPreserved,
			finalSelectionPreserved: sourceReport.finalSelectionPreserved,
			finalFooterPreserved: sourceReport.finalFooterPreserved && contains(sourceReport.finalSnapshot, sourceReport.finalFooter),
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
			sourceSummary: sourceReport.summary()
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

	static function contains(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
