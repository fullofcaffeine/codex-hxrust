package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef RecoveryRenderSnapshotReplayReportFields = {
	final sourceRenderStateCount:Int;
	final replayCount:Int;
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
	final finalThreadId:String;
	final finalSnapshot:String;
	final replayedSnapshots:Array<String>;
	final replaySummaries:Array<String>;
	final sourceSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryRenderSnapshotReplayReport {
	public final sourceRenderStateCount:Int;
	public final replayCount:Int;
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
	public final finalThreadId:String;
	public final finalSnapshot:String;
	public final replayedSnapshots:Array<String>;
	public final replaySummaries:Array<String>;
	public final sourceSummary:String;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("sourceRenderStateCount", sourceRenderStateCount),
			DiagnosticSummary.intValue("replayCount", replayCount),
			DiagnosticSummary.boolValue("snapshotOrderPreserved", snapshotOrderPreserved),
			DiagnosticSummary.boolValue("selectedMarkersPreserved", selectedMarkersPreserved),
			DiagnosticSummary.boolValue("footerSummariesPreserved", footerSummariesPreserved),
			DiagnosticSummary.boolValue("stalePromptActionInactive", stalePromptActionInactive),
			DiagnosticSummary.boolValue("staleSideParentActionInactive", staleSideParentActionInactive),
			DiagnosticSummary.boolValue("staleActiveThreadActionInactive", staleActiveThreadActionInactive),
			DiagnosticSummary.boolValue("ignoredNoSurfaceAbsent", ignoredNoSurfaceRecordsAbsent),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("liveTerminalSuppressed", liveTerminalSuppressed),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.logList("replays", replaySummaries),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.nested("source", sourceSummary)
		]);
	}
}
