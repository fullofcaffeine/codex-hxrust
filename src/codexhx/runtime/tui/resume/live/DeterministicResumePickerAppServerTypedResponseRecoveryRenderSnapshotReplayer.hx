package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayKind;

class DeterministicResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayer {
	public function new() {}

	public function replay(report:ResumePickerAppServerTypedResponseRecoveryKeyboardRenderStateRenderGateReport):Array<ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay> {
		return [
			entry(report, 0, 1, ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveDown, "thread-surface-b",
				"> Recovered navigation target | thread-surface-b", "footer keyboard move_down selected=1 selectedThread=thread-surface-b"),
			entry(report, 1, 2, ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveUp, "thread-surface-a",
				"> Recovered surface thread | thread-surface-a", "footer keyboard move_up selected=0 selectedThread=thread-surface-a")
		];
	}

	function entry(report:ResumePickerAppServerTypedResponseRecoveryKeyboardRenderStateRenderGateReport, replayIndex:Int, sourceSequence:Int,
			intent:ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind, selectedThreadId:String, expectedMarker:String,
			expectedFooter:String):ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay {
		final snapshot = snapshotAt(report.renderSnapshots, replayIndex);
		return new ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay({
			kind: ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayKind.KeyboardNavigationSnapshot,
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
			reason: "recovery_keyboard_render_snapshot_replayed"
		});
	}

	static function snapshotAt(snapshots:Array<String>, index:Int):String {
		return index < snapshots.length ? snapshots[index] : "";
	}

	static function contains(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
