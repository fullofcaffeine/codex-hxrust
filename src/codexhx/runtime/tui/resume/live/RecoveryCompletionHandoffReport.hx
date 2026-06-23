package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoffKind;

typedef RecoveryCompletionHandoffReportFields = {
	final handoffKind:RecoveryReplayCompletionHandoffKind;
	final handoffSummary:String;
	final completionReady:Bool;
	final replayCount:Int;
	final finalThreadId:String;
	final finalFooterStable:Bool;
	final finalSelectionRestored:Bool;
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final liveTerminalSuppressed:Bool;
	final stateDbUntouched:Bool;
	final nextSliceReady:Bool;
	final finalSnapshot:String;
	final replaySummary:String;
	final handoffLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryCompletionHandoffReport {
	@:recordDefault(RecoveryReplayCompletionHandoffKind.Unknown)
	public final handoffKind:RecoveryReplayCompletionHandoffKind;
	public final handoffSummary:String;
	public final completionReady:Bool;
	public final replayCount:Int;
	public final finalThreadId:String;
	public final finalFooterStable:Bool;
	public final finalSelectionRestored:Bool;
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final liveTerminalSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final nextSliceReady:Bool;
	public final finalSnapshot:String;
	public final replaySummary:String;
	public final handoffLogSummaries:Array<String>;

	public function summary():String {
		return "handoffKind=" + handoffKind + ";completionReady=" + boolLabel(completionReady) + ";replayCount=" + replayCount + ";finalThread="
			+ finalThreadId + ";finalFooterStable=" + boolLabel(finalFooterStable) + ";finalSelectionRestored=" + boolLabel(finalSelectionRestored)
			+ ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved=" + boolLabel(selectedMarkersPreserved)
			+ ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive)
			+ ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive="
			+ boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";nextSliceReady="
			+ boolLabel(nextSliceReady) + ";handoff=[" + handoffSummary + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";handoffLog=["
			+ handoffLogSummaries.join("##") + "]" + ";replay=[" + replaySummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
