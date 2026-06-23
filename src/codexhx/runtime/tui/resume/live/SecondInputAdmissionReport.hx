package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;

typedef SecondInputAdmissionReportFields = {
	final admissionKind:CompletionInputAdmissionKind;
	final admissionSummary:String;
	final inputAdmitted:Bool;
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
	final completionReady:Bool;
	final nextSliceReady:Bool;
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
	final finalSnapshot:String;
	final completionSummary:String;
	final admissionLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class SecondInputAdmissionReport {
	@:recordDefault(CompletionInputAdmissionKind.Unknown)
	public final admissionKind:CompletionInputAdmissionKind;
	public final admissionSummary:String;
	public final inputAdmitted:Bool;
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
	public final completionReady:Bool;
	public final nextSliceReady:Bool;
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
	public final finalSnapshot:String;
	public final completionSummary:String;
	public final admissionLogSummaries:Array<String>;

	public function summary():String {
		return "admissionKind=" + admissionKind + ";inputAdmitted=" + boolLabel(inputAdmitted) + ";sourceReadinessDecisionCount="
			+ sourceReadinessDecisionCount + ";sourceRenderStateCount=" + sourceRenderStateCount + ";sourceFrameRequests=" + sourceFrameRequests
			+ ";sourceKeyboardRenderCount=" + sourceKeyboardRenderCount + ";replayCount=" + replayCount + ";sourceReplayCount=" + sourceReplayCount
			+ ";sourceHandoffReplayCount=" + sourceHandoffReplayCount + ";sourceHandoffReadinessDecisionCount=" + sourceHandoffReadinessDecisionCount
			+ ";sourceHandoffRenderStateCount=" + sourceHandoffRenderStateCount + ";sourceHandoffFrameRequests=" + sourceHandoffFrameRequests
			+ ";sourceHandoffKeyboardRenderCount=" + sourceHandoffKeyboardRenderCount + ";sourceSecondCycleHandoffReplayCount="
			+ sourceSecondCycleHandoffReplayCount + ";sourceSecondCycleHandoffReadinessDecisionCount=" + sourceSecondCycleHandoffReadinessDecisionCount
			+ ";sourceSecondCycleHandoffRenderStateCount=" + sourceSecondCycleHandoffRenderStateCount + ";sourceSecondCycleHandoffFrameRequests="
			+ sourceSecondCycleHandoffFrameRequests + ";sourceSecondCycleHandoffKeyboardRenderCount=" + sourceSecondCycleHandoffKeyboardRenderCount
			+ ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter + ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved)
			+ ";finalFooterPreserved=" + boolLabel(finalFooterPreserved) + ";completionReady=" + boolLabel(completionReady) + ";nextSliceReady="
			+ boolLabel(nextSliceReady) + ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved="
			+ boolLabel(selectedMarkersPreserved) + ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";selectedMarkerMoved="
			+ boolLabel(selectedMarkerMoved) + ";recoveredSelectionRestored=" + boolLabel(recoveredSelectionRestored) + ";noLeftoverScheduledRenderRequest="
			+ boolLabel(noLeftoverScheduledRenderRequest) + ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount + ";consumedScheduledRequestCount="
			+ consumedScheduledRequestCount + ";sourcePostRenderRenderCount=" + sourcePostRenderRenderCount + ";renderedSnapshotPreserved="
			+ boolLabel(renderedSnapshotPreserved) + ";sourceRenderedSnapshotPreserved=" + boolLabel(sourceRenderedSnapshotPreserved)
			+ ";sourceInputAdmitted=" + boolLabel(sourceInputAdmitted) + ";sourceLocalOnlyRenderIntent=" + boolLabel(sourceLocalOnlyRenderIntent)
			+ ";sourceHandoffInputAdmitted=" + boolLabel(sourceHandoffInputAdmitted) + ";sourceHandoffLocalOnlyRenderIntent="
			+ boolLabel(sourceHandoffLocalOnlyRenderIntent) + ";sourceSecondCycleHandoffInputAdmitted=" + boolLabel(sourceSecondCycleHandoffInputAdmitted)
			+ ";sourceSecondCycleHandoffLocalOnlyRenderIntent=" + boolLabel(sourceSecondCycleHandoffLocalOnlyRenderIntent) + ";stalePromptActionInactive="
			+ boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation)
			+ ";admission=[" + admissionSummary + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";admissionLog=["
			+ admissionLogSummaries.join("##") + "]" + ";completion=[" + completionSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
