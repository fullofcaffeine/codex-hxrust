package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;
import codexhx.runtime.tui.resume.host.RecoveryRenderSnapshotReplay;
import codexhx.runtime.tui.resume.host.RecoveryRenderSnapshotReplayKind;

class RecoveryRenderSnapshotReplayer {
	public function new() {}

	public function replay(report:RecoveryKeyboardStateReport):Array<RecoveryRenderSnapshotReplay> {
		return [
			entry(report, 0, 1, RecoveryKeyboardIntentKind.MoveDown, "thread-surface-b", "> Recovered navigation target | thread-surface-b",
				"footer keyboard move_down selected=1 selectedThread=thread-surface-b"),
			entry(report, 1, 2, RecoveryKeyboardIntentKind.MoveUp, "thread-surface-a", "> Recovered surface thread | thread-surface-a",
				"footer keyboard move_up selected=0 selectedThread=thread-surface-a")
		];
	}

	function entry(report:RecoveryKeyboardStateReport, replayIndex:Int, sourceSequence:Int, intent:RecoveryKeyboardIntentKind, selectedThreadId:String,
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
