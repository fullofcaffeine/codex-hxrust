package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
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
		return DiagnosticSummary.render([
			DiagnosticSummary.enumValue("handoffKind", Std.string(handoffKind)),
			DiagnosticSummary.boolValue("completionReady", completionReady),
			DiagnosticSummary.intValue("replayCount", replayCount),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.boolValue("finalFooterStable", finalFooterStable),
			DiagnosticSummary.boolValue("finalSelectionRestored", finalSelectionRestored),
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
			DiagnosticSummary.boolValue("nextSliceReady", nextSliceReady),
			DiagnosticSummary.nested("handoff", handoffSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("handoffLog", handoffLogSummaries),
			DiagnosticSummary.nested("replay", replaySummary)
		]);
	}
}
