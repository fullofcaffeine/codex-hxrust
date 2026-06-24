package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef ReplayStateSnapshotReplayReportFields = {
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
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final selectedMarkerMoved:Bool;
	final recoveredSelectionRestored:Bool;
	final noLeftoverScheduledRenderRequest:Bool;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final sourcePostRenderRenderCount:Int;
	final renderedSnapshotPreserved:Bool;
	final sourceRenderedSnapshotPreserved:Bool;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final inputAdmitted:Bool;
	final localOnlyRenderIntent:Bool;
	final sourceInputAdmitted:Bool;
	final sourceLocalOnlyRenderIntent:Bool;
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
	final finalThreadId:String;
	final finalFooter:String;
	final finalSnapshot:String;
	final replayedSnapshots:Array<String>;
	final replaySummaries:Array<String>;
	final sourceSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ReplayStateSnapshotReplayReport {
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
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final selectedMarkerMoved:Bool;
	public final recoveredSelectionRestored:Bool;
	public final noLeftoverScheduledRenderRequest:Bool;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final sourcePostRenderRenderCount:Int;
	public final renderedSnapshotPreserved:Bool;
	public final sourceRenderedSnapshotPreserved:Bool;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final inputAdmitted:Bool;
	public final localOnlyRenderIntent:Bool;
	public final sourceInputAdmitted:Bool;
	public final sourceLocalOnlyRenderIntent:Bool;
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
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalSnapshot:String;
	public final replayedSnapshots:Array<String>;
	public final replaySummaries:Array<String>;
	public final sourceSummary:String;

	public function summary():String {
		return DiagnosticSummary.render([
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
			DiagnosticSummary.boolValue("snapshotOrderPreserved", snapshotOrderPreserved),
			DiagnosticSummary.boolValue("selectedMarkersPreserved", selectedMarkersPreserved),
			DiagnosticSummary.boolValue("footerSummariesPreserved", footerSummariesPreserved),
			DiagnosticSummary.boolValue("selectedMarkerMoved", selectedMarkerMoved),
			DiagnosticSummary.boolValue("recoveredSelectionRestored", recoveredSelectionRestored),
			DiagnosticSummary.boolValue("noLeftoverScheduledRenderRequest", noLeftoverScheduledRenderRequest),
			DiagnosticSummary.intValue("sourceSchedulerRequestCount", sourceSchedulerRequestCount),
			DiagnosticSummary.intValue("consumedScheduledRequestCount", consumedScheduledRequestCount),
			DiagnosticSummary.intValue("sourcePostRenderRenderCount", sourcePostRenderRenderCount),
			DiagnosticSummary.boolValue("renderedSnapshotPreserved", renderedSnapshotPreserved),
			DiagnosticSummary.boolValue("sourceRenderedSnapshotPreserved", sourceRenderedSnapshotPreserved),
			DiagnosticSummary.boolValue("finalSelectionPreserved", finalSelectionPreserved),
			DiagnosticSummary.boolValue("finalFooterPreserved", finalFooterPreserved),
			DiagnosticSummary.boolValue("inputAdmitted", inputAdmitted),
			DiagnosticSummary.boolValue("localOnlyRenderIntent", localOnlyRenderIntent),
			DiagnosticSummary.boolValue("sourceInputAdmitted", sourceInputAdmitted),
			DiagnosticSummary.boolValue("sourceLocalOnlyRenderIntent", sourceLocalOnlyRenderIntent),
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
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.text("finalFooter", finalFooter),
			DiagnosticSummary.logList("replays", replaySummaries),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.nested("source", sourceSummary)
		]);
	}
}
