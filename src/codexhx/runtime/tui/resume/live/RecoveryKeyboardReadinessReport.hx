package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef RecoveryKeyboardReadinessReportFields = {
	final decisionCount:Int;
	final admittedCount:Int;
	final recoveredSelectionStableUntilNavigation:Bool;
	final navigationApplied:Bool;
	final returnedToRecoveredSelection:Bool;
	final keyboardInputReady:Bool;
	final listNavigationReady:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final stateDbUntouched:Bool;
	final finalThreadId:String;
	final decisionSummaries:Array<String>;
	final policyLogSummaries:Array<String>;
	final handoffSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryKeyboardReadinessReport {
	public final decisionCount:Int;
	public final admittedCount:Int;
	public final recoveredSelectionStableUntilNavigation:Bool;
	public final navigationApplied:Bool;
	public final returnedToRecoveredSelection:Bool;
	public final keyboardInputReady:Bool;
	public final listNavigationReady:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final finalThreadId:String;
	public final decisionSummaries:Array<String>;
	public final policyLogSummaries:Array<String>;
	public final handoffSummary:String;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("decisionCount", decisionCount),
			DiagnosticSummary.intValue("admittedCount", admittedCount),
			DiagnosticSummary.boolValue("recoveredSelectionStableUntilNavigation", recoveredSelectionStableUntilNavigation),
			DiagnosticSummary.boolValue("navigationApplied", navigationApplied),
			DiagnosticSummary.boolValue("returnedToRecoveredSelection", returnedToRecoveredSelection),
			DiagnosticSummary.boolValue("keyboardInputReady", keyboardInputReady),
			DiagnosticSummary.boolValue("listNavigationReady", listNavigationReady),
			DiagnosticSummary.boolValue("stalePromptActionInactive", stalePromptActionInactive),
			DiagnosticSummary.boolValue("staleSideParentActionInactive", staleSideParentActionInactive),
			DiagnosticSummary.boolValue("staleActiveThreadActionInactive", staleActiveThreadActionInactive),
			DiagnosticSummary.boolValue("ignoredNoSurfaceAbsent", ignoredNoSurfaceRecordsAbsent),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.nested("handoff", handoffSummary),
			DiagnosticSummary.logList("decisions", decisionSummaries),
			DiagnosticSummary.logList("policyLog", policyLogSummaries)
		]);
	}
}
