package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.host.PostRenderKeyboardReadinessKind;

typedef PostRenderKeyboardReadinessReportFields = {
	final readinessKind:PostRenderKeyboardReadinessKind;
	final readinessSummary:String;
	final decisionCount:Int;
	final admittedCount:Int;
	final postRenderIdleListReady:Bool;
	final keyboardInputReady:Bool;
	final listNavigationReady:Bool;
	final recoveredSelectionStableUntilNavigation:Bool;
	final navigationApplied:Bool;
	final returnedToRecoveredSelection:Bool;
	final noLeftoverScheduledRenderRequest:Bool;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final renderCount:Int;
	final renderedSnapshotPreserved:Bool;
	final finalThreadId:String;
	final finalFooter:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final liveTerminalSuppressed:Bool;
	final stateDbUntouched:Bool;
	final noModelCall:Bool;
	final noFilesystemMutation:Bool;
	final decisionSummaries:Array<String>;
	final policyLogSummaries:Array<String>;
	final sourceHandoffSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PostRenderKeyboardReadinessReport {
	@:recordDefault(PostRenderKeyboardReadinessKind.Unknown)
	public final readinessKind:PostRenderKeyboardReadinessKind;
	public final readinessSummary:String;
	public final decisionCount:Int;
	public final admittedCount:Int;
	public final postRenderIdleListReady:Bool;
	public final keyboardInputReady:Bool;
	public final listNavigationReady:Bool;
	public final recoveredSelectionStableUntilNavigation:Bool;
	public final navigationApplied:Bool;
	public final returnedToRecoveredSelection:Bool;
	public final noLeftoverScheduledRenderRequest:Bool;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final renderCount:Int;
	public final renderedSnapshotPreserved:Bool;
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final liveTerminalSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final noModelCall:Bool;
	public final noFilesystemMutation:Bool;
	public final decisionSummaries:Array<String>;
	public final policyLogSummaries:Array<String>;
	public final sourceHandoffSummary:String;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.enumValue("readinessKind", Std.string(readinessKind)),
			DiagnosticSummary.intValue("decisionCount", decisionCount),
			DiagnosticSummary.intValue("admittedCount", admittedCount),
			DiagnosticSummary.boolValue("postRenderIdleListReady", postRenderIdleListReady),
			DiagnosticSummary.boolValue("keyboardInputReady", keyboardInputReady),
			DiagnosticSummary.boolValue("listNavigationReady", listNavigationReady),
			DiagnosticSummary.boolValue("recoveredSelectionStableUntilNavigation", recoveredSelectionStableUntilNavigation),
			DiagnosticSummary.boolValue("navigationApplied", navigationApplied),
			DiagnosticSummary.boolValue("returnedToRecoveredSelection", returnedToRecoveredSelection),
			DiagnosticSummary.boolValue("noLeftoverScheduledRenderRequest", noLeftoverScheduledRenderRequest),
			DiagnosticSummary.intValue("sourceSchedulerRequestCount", sourceSchedulerRequestCount),
			DiagnosticSummary.intValue("consumedScheduledRequestCount", consumedScheduledRequestCount),
			DiagnosticSummary.intValue("renderCount", renderCount),
			DiagnosticSummary.boolValue("renderedSnapshotPreserved", renderedSnapshotPreserved),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.text("finalFooter", finalFooter),
			DiagnosticSummary.boolValue("finalSelectionPreserved", finalSelectionPreserved),
			DiagnosticSummary.boolValue("finalFooterPreserved", finalFooterPreserved),
			DiagnosticSummary.boolValue("stalePromptActionInactive", stalePromptActionInactive),
			DiagnosticSummary.boolValue("staleSideParentActionInactive", staleSideParentActionInactive),
			DiagnosticSummary.boolValue("staleActiveThreadActionInactive", staleActiveThreadActionInactive),
			DiagnosticSummary.boolValue("ignoredNoSurfaceAbsent", ignoredNoSurfaceRecordsAbsent),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("liveTerminalSuppressed", liveTerminalSuppressed),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.boolValue("noModelCall", noModelCall),
			DiagnosticSummary.boolValue("noFilesystemMutation", noFilesystemMutation),
			DiagnosticSummary.nested("readiness", readinessSummary),
			DiagnosticSummary.logList("decisions", decisionSummaries),
			DiagnosticSummary.logList("policyLog", policyLogSummaries),
			DiagnosticSummary.nested("sourceHandoff", sourceHandoffSummary)
		]);
	}
}
