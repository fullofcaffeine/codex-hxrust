package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef PostRenderKeyboardStateReportFields = {
	final readinessDecisionCount:Int;
	final renderStateCount:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final selectedMarkerMoved:Bool;
	final recoveredSelectionRestored:Bool;
	final noLeftoverScheduledRenderRequest:Bool;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final sourceRenderCount:Int;
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
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final renderStateSummaries:Array<String>;
	final readinessSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PostRenderKeyboardStateReport {
	public final readinessDecisionCount:Int;
	public final renderStateCount:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final selectedMarkerMoved:Bool;
	public final recoveredSelectionRestored:Bool;
	public final noLeftoverScheduledRenderRequest:Bool;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final sourceRenderCount:Int;
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
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final renderStateSummaries:Array<String>;
	public final readinessSummary:String;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("readinessDecisionCount", readinessDecisionCount),
			DiagnosticSummary.intValue("renderStateCount", renderStateCount),
			DiagnosticSummary.intValue("frameRequests", frameRequests),
			DiagnosticSummary.intValue("renderCount", renderCount),
			DiagnosticSummary.boolValue("selectedMarkerMoved", selectedMarkerMoved),
			DiagnosticSummary.boolValue("recoveredSelectionRestored", recoveredSelectionRestored),
			DiagnosticSummary.boolValue("noLeftoverScheduledRenderRequest", noLeftoverScheduledRenderRequest),
			DiagnosticSummary.intValue("sourceSchedulerRequestCount", sourceSchedulerRequestCount),
			DiagnosticSummary.intValue("consumedScheduledRequestCount", consumedScheduledRequestCount),
			DiagnosticSummary.intValue("sourceRenderCount", sourceRenderCount),
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
			DiagnosticSummary.logList("renderStates", renderStateSummaries),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.nested("readiness", readinessSummary)
		]);
	}
}
