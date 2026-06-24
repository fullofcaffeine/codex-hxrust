package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.host.CompletionScheduledRenderExecutionKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostOutcomeKind;

typedef CompletionScheduledRenderReportFields = {
	final executionKind:CompletionScheduledRenderExecutionKind;
	final executionSummary:String;
	final executionRequested:Bool;
	final rendered:Bool;
	final executionSequence:Int;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final renderCount:Int;
	final renderOutcomeKind:ResumePickerHostOutcomeKind;
	final renderedSnapshotMatchesSchedule:Bool;
	final localOnlyRenderIntent:Bool;
	final finalThreadId:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final inputAdmitted:Bool;
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
	final renderedSnapshot:String;
	final schedulingSummary:String;
	final executionLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class CompletionScheduledRenderReport {
	@:recordDefault(CompletionScheduledRenderExecutionKind.Unknown)
	public final executionKind:CompletionScheduledRenderExecutionKind;
	public final executionSummary:String;
	public final executionRequested:Bool;
	public final rendered:Bool;
	public final executionSequence:Int;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final renderCount:Int;
	@:recordDefault(ResumePickerHostOutcomeKind.Unknown)
	public final renderOutcomeKind:ResumePickerHostOutcomeKind;
	public final renderedSnapshotMatchesSchedule:Bool;
	public final localOnlyRenderIntent:Bool;
	public final finalThreadId:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final inputAdmitted:Bool;
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
	public final renderedSnapshot:String;
	public final schedulingSummary:String;
	public final executionLogSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.enumValue("executionKind", Std.string(executionKind)),
			DiagnosticSummary.boolValue("executionRequested", executionRequested),
			DiagnosticSummary.boolValue("rendered", rendered),
			DiagnosticSummary.intValue("executionSequence", executionSequence),
			DiagnosticSummary.intValue("sourceSchedulerRequestCount", sourceSchedulerRequestCount),
			DiagnosticSummary.intValue("consumedScheduledRequestCount", consumedScheduledRequestCount),
			DiagnosticSummary.intValue("renderCount", renderCount),
			DiagnosticSummary.enumValue("renderOutcomeKind", Std.string(renderOutcomeKind)),
			DiagnosticSummary.boolValue("renderedSnapshotMatchesSchedule", renderedSnapshotMatchesSchedule),
			DiagnosticSummary.boolValue("localOnlyRenderIntent", localOnlyRenderIntent),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.boolValue("finalSelectionPreserved", finalSelectionPreserved),
			DiagnosticSummary.boolValue("finalFooterPreserved", finalFooterPreserved),
			DiagnosticSummary.boolValue("inputAdmitted", inputAdmitted),
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
			DiagnosticSummary.snapshot("renderedSnapshot", renderedSnapshot),
			DiagnosticSummary.nested("execution", executionSummary),
			DiagnosticSummary.logList("executionLog", executionLogSummaries),
			DiagnosticSummary.nested("scheduling", schedulingSummary)
		]);
	}
}
