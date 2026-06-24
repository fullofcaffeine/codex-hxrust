package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.host.CompletionScheduledRenderExecutionKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostOutcomeKind;

typedef SecondScheduledRenderReportFields = {
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
	final sourceReadinessDecisionCount:Int;
	final sourceRenderStateCount:Int;
	final sourceFrameRequests:Int;
	final sourceKeyboardRenderCount:Int;
	final replayCount:Int;
	final sourceReplayCount:Int;
	final sourceHandoffReplayCount:Int;
	final sourceHandoffReadinessDecisionCount:Int;
	final sourceHandoffRenderStateCount:Int;
	final sourceHandoffFrameRequests:Int;
	final sourceHandoffKeyboardRenderCount:Int;
	final sourceSecondCycleHandoffReplayCount:Int;
	final sourceSecondCycleHandoffReadinessDecisionCount:Int;
	final sourceSecondCycleHandoffRenderStateCount:Int;
	final sourceSecondCycleHandoffFrameRequests:Int;
	final sourceSecondCycleHandoffKeyboardRenderCount:Int;
	final finalThreadId:String;
	final finalFooter:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final inputAdmitted:Bool;
	final completionReady:Bool;
	final nextSliceReady:Bool;
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final selectedMarkerMoved:Bool;
	final recoveredSelectionRestored:Bool;
	final noLeftoverScheduledRenderRequest:Bool;
	final sourcePreExecutionSchedulerRequestCount:Int;
	final sourcePreExecutionConsumedRequestCount:Int;
	final sourcePreExecutionRenderCount:Int;
	final sourceRenderedSnapshotPreserved:Bool;
	final sourceInputAdmitted:Bool;
	final sourceLocalOnlyRenderIntent:Bool;
	final sourceHandoffInputAdmitted:Bool;
	final sourceHandoffLocalOnlyRenderIntent:Bool;
	final sourceSecondCycleHandoffInputAdmitted:Bool;
	final sourceSecondCycleHandoffLocalOnlyRenderIntent:Bool;
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
class SecondScheduledRenderReport {
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
	public final sourceReadinessDecisionCount:Int;
	public final sourceRenderStateCount:Int;
	public final sourceFrameRequests:Int;
	public final sourceKeyboardRenderCount:Int;
	public final replayCount:Int;
	public final sourceReplayCount:Int;
	public final sourceHandoffReplayCount:Int;
	public final sourceHandoffReadinessDecisionCount:Int;
	public final sourceHandoffRenderStateCount:Int;
	public final sourceHandoffFrameRequests:Int;
	public final sourceHandoffKeyboardRenderCount:Int;
	public final sourceSecondCycleHandoffReplayCount:Int;
	public final sourceSecondCycleHandoffReadinessDecisionCount:Int;
	public final sourceSecondCycleHandoffRenderStateCount:Int;
	public final sourceSecondCycleHandoffFrameRequests:Int;
	public final sourceSecondCycleHandoffKeyboardRenderCount:Int;
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final inputAdmitted:Bool;
	public final completionReady:Bool;
	public final nextSliceReady:Bool;
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final selectedMarkerMoved:Bool;
	public final recoveredSelectionRestored:Bool;
	public final noLeftoverScheduledRenderRequest:Bool;
	public final sourcePreExecutionSchedulerRequestCount:Int;
	public final sourcePreExecutionConsumedRequestCount:Int;
	public final sourcePreExecutionRenderCount:Int;
	public final sourceRenderedSnapshotPreserved:Bool;
	public final sourceInputAdmitted:Bool;
	public final sourceLocalOnlyRenderIntent:Bool;
	public final sourceHandoffInputAdmitted:Bool;
	public final sourceHandoffLocalOnlyRenderIntent:Bool;
	public final sourceSecondCycleHandoffInputAdmitted:Bool;
	public final sourceSecondCycleHandoffLocalOnlyRenderIntent:Bool;
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
			DiagnosticSummary.intValue("sourceReadinessDecisionCount", sourceReadinessDecisionCount),
			DiagnosticSummary.intValue("sourceRenderStateCount", sourceRenderStateCount),
			DiagnosticSummary.intValue("sourceFrameRequests", sourceFrameRequests),
			DiagnosticSummary.intValue("sourceKeyboardRenderCount", sourceKeyboardRenderCount),
			DiagnosticSummary.intValue("replayCount", replayCount),
			DiagnosticSummary.intValue("sourceReplayCount", sourceReplayCount),
			DiagnosticSummary.intValue("sourceHandoffReplayCount", sourceHandoffReplayCount),
			DiagnosticSummary.intValue("sourceHandoffReadinessDecisionCount", sourceHandoffReadinessDecisionCount),
			DiagnosticSummary.intValue("sourceHandoffRenderStateCount", sourceHandoffRenderStateCount),
			DiagnosticSummary.intValue("sourceHandoffFrameRequests", sourceHandoffFrameRequests),
			DiagnosticSummary.intValue("sourceHandoffKeyboardRenderCount", sourceHandoffKeyboardRenderCount),
			DiagnosticSummary.intValue("sourceSecondCycleHandoffReplayCount", sourceSecondCycleHandoffReplayCount),
			DiagnosticSummary.intValue("sourceSecondCycleHandoffReadinessDecisionCount", sourceSecondCycleHandoffReadinessDecisionCount),
			DiagnosticSummary.intValue("sourceSecondCycleHandoffRenderStateCount", sourceSecondCycleHandoffRenderStateCount),
			DiagnosticSummary.intValue("sourceSecondCycleHandoffFrameRequests", sourceSecondCycleHandoffFrameRequests),
			DiagnosticSummary.intValue("sourceSecondCycleHandoffKeyboardRenderCount", sourceSecondCycleHandoffKeyboardRenderCount),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.text("finalFooter", finalFooter),
			DiagnosticSummary.boolValue("finalSelectionPreserved", finalSelectionPreserved),
			DiagnosticSummary.boolValue("finalFooterPreserved", finalFooterPreserved),
			DiagnosticSummary.boolValue("inputAdmitted", inputAdmitted),
			DiagnosticSummary.boolValue("completionReady", completionReady),
			DiagnosticSummary.boolValue("nextSliceReady", nextSliceReady),
			DiagnosticSummary.boolValue("snapshotOrderPreserved", snapshotOrderPreserved),
			DiagnosticSummary.boolValue("selectedMarkersPreserved", selectedMarkersPreserved),
			DiagnosticSummary.boolValue("footerSummariesPreserved", footerSummariesPreserved),
			DiagnosticSummary.boolValue("selectedMarkerMoved", selectedMarkerMoved),
			DiagnosticSummary.boolValue("recoveredSelectionRestored", recoveredSelectionRestored),
			DiagnosticSummary.boolValue("noLeftoverScheduledRenderRequest", noLeftoverScheduledRenderRequest),
			DiagnosticSummary.intValue("sourcePreExecutionSchedulerRequestCount", sourcePreExecutionSchedulerRequestCount),
			DiagnosticSummary.intValue("sourcePreExecutionConsumedRequestCount", sourcePreExecutionConsumedRequestCount),
			DiagnosticSummary.intValue("sourcePreExecutionRenderCount", sourcePreExecutionRenderCount),
			DiagnosticSummary.boolValue("sourceRenderedSnapshotPreserved", sourceRenderedSnapshotPreserved),
			DiagnosticSummary.boolValue("sourceInputAdmitted", sourceInputAdmitted),
			DiagnosticSummary.boolValue("sourceLocalOnlyRenderIntent", sourceLocalOnlyRenderIntent),
			DiagnosticSummary.boolValue("sourceHandoffInputAdmitted", sourceHandoffInputAdmitted),
			DiagnosticSummary.boolValue("sourceHandoffLocalOnlyRenderIntent", sourceHandoffLocalOnlyRenderIntent),
			DiagnosticSummary.boolValue("sourceSecondCycleHandoffInputAdmitted", sourceSecondCycleHandoffInputAdmitted),
			DiagnosticSummary.boolValue("sourceSecondCycleHandoffLocalOnlyRenderIntent", sourceSecondCycleHandoffLocalOnlyRenderIntent),
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
