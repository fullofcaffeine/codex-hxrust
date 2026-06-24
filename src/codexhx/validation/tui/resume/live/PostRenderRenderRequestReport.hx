package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.host.CompletionRenderRequestScheduleKind;

typedef PostRenderRenderRequestReportFields = {
	final scheduleKind:CompletionRenderRequestScheduleKind;
	final scheduleSummary:String;
	final scheduleRequested:Bool;
	final scheduled:Bool;
	final scheduleSequence:Int;
	final schedulerRequestCount:Int;
	final schedulerSummary:String;
	final localOnlyRenderIntent:Bool;
	final finalThreadId:String;
	final finalFooter:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final inputAdmitted:Bool;
	final replayCount:Int;
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final selectedMarkerMoved:Bool;
	final recoveredSelectionRestored:Bool;
	final noLeftoverScheduledRenderRequest:Bool;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final sourceRenderCount:Int;
	final renderedSnapshotPreserved:Bool;
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
	final renderIntentSummary:String;
	final schedulerLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PostRenderRenderRequestReport {
	@:recordDefault(CompletionRenderRequestScheduleKind.Unknown)
	public final scheduleKind:CompletionRenderRequestScheduleKind;
	public final scheduleSummary:String;
	public final scheduleRequested:Bool;
	public final scheduled:Bool;
	public final scheduleSequence:Int;
	public final schedulerRequestCount:Int;
	public final schedulerSummary:String;
	public final localOnlyRenderIntent:Bool;
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final inputAdmitted:Bool;
	public final replayCount:Int;
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final selectedMarkerMoved:Bool;
	public final recoveredSelectionRestored:Bool;
	public final noLeftoverScheduledRenderRequest:Bool;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final sourceRenderCount:Int;
	public final renderedSnapshotPreserved:Bool;
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
	public final renderIntentSummary:String;
	public final schedulerLogSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.enumValue("scheduleKind", Std.string(scheduleKind)),
			DiagnosticSummary.boolValue("scheduleRequested", scheduleRequested),
			DiagnosticSummary.boolValue("scheduled", scheduled),
			DiagnosticSummary.intValue("scheduleSequence", scheduleSequence),
			DiagnosticSummary.intValue("schedulerRequestCount", schedulerRequestCount),
			DiagnosticSummary.text("schedulerSummary", schedulerSummary),
			DiagnosticSummary.boolValue("localOnlyRenderIntent", localOnlyRenderIntent),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.text("finalFooter", finalFooter),
			DiagnosticSummary.boolValue("finalSelectionPreserved", finalSelectionPreserved),
			DiagnosticSummary.boolValue("finalFooterPreserved", finalFooterPreserved),
			DiagnosticSummary.boolValue("inputAdmitted", inputAdmitted),
			DiagnosticSummary.intValue("replayCount", replayCount),
			DiagnosticSummary.boolValue("snapshotOrderPreserved", snapshotOrderPreserved),
			DiagnosticSummary.boolValue("selectedMarkersPreserved", selectedMarkersPreserved),
			DiagnosticSummary.boolValue("footerSummariesPreserved", footerSummariesPreserved),
			DiagnosticSummary.boolValue("selectedMarkerMoved", selectedMarkerMoved),
			DiagnosticSummary.boolValue("recoveredSelectionRestored", recoveredSelectionRestored),
			DiagnosticSummary.boolValue("noLeftoverScheduledRenderRequest", noLeftoverScheduledRenderRequest),
			DiagnosticSummary.intValue("sourceSchedulerRequestCount", sourceSchedulerRequestCount),
			DiagnosticSummary.intValue("consumedScheduledRequestCount", consumedScheduledRequestCount),
			DiagnosticSummary.intValue("sourceRenderCount", sourceRenderCount),
			DiagnosticSummary.boolValue("renderedSnapshotPreserved", renderedSnapshotPreserved),
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
			DiagnosticSummary.nested("schedule", scheduleSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("schedulerLog", schedulerLogSummaries),
			DiagnosticSummary.nested("renderIntent", renderIntentSummary)
		]);
	}
}
