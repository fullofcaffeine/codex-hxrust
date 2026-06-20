package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay;

class ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderGateReport {
		final sourceReport = ResumePickerAppServerTypedResponseRecoveryKeyboardRenderStateRenderGate.run();
		final replayer = new DeterministicResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayer();
		final replays = replayer.replay(sourceReport);
		final snapshots = replayedSnapshots(replays);

		return new ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderGateReport({
			sourceRenderStateCount: sourceReport.renderStateCount,
			replayCount: replays.length,
			snapshotOrderPreserved: allOrderPreserved(replays),
			selectedMarkersPreserved: allMarkersMatched(replays),
			footerSummariesPreserved: allFootersMatched(replays),
			stalePromptActionInactive: allPromptInactive(replays),
			staleSideParentActionInactive: allSideParentInactive(replays),
			staleActiveThreadActionInactive: allActiveThreadInactive(replays),
			ignoredNoSurfaceRecordsAbsent: allIgnoredNoSurfaceAbsent(replays),
			noPressureDropRejection: sourceReport.noPressureDropRejection && allNoPressureDropRejection(replays),
			liveTransportSuppressed: sourceReport.liveTransportSuppressed && allLiveTransportSuppressed(replays),
			liveTerminalSuppressed: sourceReport.liveTerminalSuppressed && allLiveTerminalSuppressed(replays),
			stateDbUntouched: sourceReport.stateDbUntouched && allStateDbUntouched(replays),
			finalThreadId: sourceReport.finalThreadId,
			finalSnapshot: sourceReport.finalSnapshot,
			replayedSnapshots: snapshots,
			replaySummaries: replaySummaries(replays),
			sourceSummary: sourceReport.summary()
		});
	}

	static function replayedSnapshots(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Array<String> {
		final out:Array<String> = [];
		for (replay in replays)
			out.push(replay.snapshot);
		return out;
	}

	static function replaySummaries(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Array<String> {
		final out:Array<String> = [];
		for (replay in replays)
			out.push(replay.summary());
		return out;
	}

	static function allOrderPreserved(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.orderPreserved)
				return false;
		return true;
	}

	static function allMarkersMatched(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.markerMatched)
				return false;
		return true;
	}

	static function allFootersMatched(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.footerMatched)
				return false;
		return true;
	}

	static function allPromptInactive(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.stalePromptActionInactive)
				return false;
		return true;
	}

	static function allSideParentInactive(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.staleSideParentActionInactive)
				return false;
		return true;
	}

	static function allActiveThreadInactive(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.staleActiveThreadActionInactive)
				return false;
		return true;
	}

	static function allIgnoredNoSurfaceAbsent(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.ignoredNoSurfaceRecordsAbsent)
				return false;
		return true;
	}

	static function allNoPressureDropRejection(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.noPressureDropRejection)
				return false;
		return true;
	}

	static function allLiveTransportSuppressed(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.liveTransportSuppressed)
				return false;
		return true;
	}

	static function allLiveTerminalSuppressed(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.liveTerminalSuppressed)
				return false;
		return true;
	}

	static function allStateDbUntouched(replays:Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay>):Bool {
		for (replay in replays)
			if (!replay.stateDbUntouched)
				return false;
		return true;
	}
}
