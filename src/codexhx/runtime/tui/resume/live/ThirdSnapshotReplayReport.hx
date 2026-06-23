package codexhx.runtime.tui.resume.live;

typedef ThirdSnapshotReplayReportFields = {
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
	final sourceThirdCycleHandoffReplayCount:Int;
	final sourceThirdCycleHandoffReadinessDecisionCount:Int;
	final sourceThirdCycleHandoffRenderStateCount:Int;
	final sourceThirdCycleHandoffFrameRequests:Int;
	final sourceThirdCycleHandoffKeyboardRenderCount:Int;
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
	final completionReady:Bool;
	final nextSliceReady:Bool;
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
	final finalThreadId:String;
	final finalFooter:String;
	final finalSnapshot:String;
	final replayedSnapshots:Array<String>;
	final replaySummaries:Array<String>;
	final sourceSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ThirdSnapshotReplayReport {
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
	public final sourceThirdCycleHandoffReplayCount:Int;
	public final sourceThirdCycleHandoffReadinessDecisionCount:Int;
	public final sourceThirdCycleHandoffRenderStateCount:Int;
	public final sourceThirdCycleHandoffFrameRequests:Int;
	public final sourceThirdCycleHandoffKeyboardRenderCount:Int;
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
	public final completionReady:Bool;
	public final nextSliceReady:Bool;
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
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalSnapshot:String;
	public final replayedSnapshots:Array<String>;
	public final replaySummaries:Array<String>;
	public final sourceSummary:String;

	public function summary():String {
		return "sourceReadinessDecisionCount=" + sourceReadinessDecisionCount + ";sourceRenderStateCount=" + sourceRenderStateCount
			+ ";sourceFrameRequests=" + sourceFrameRequests + ";sourceKeyboardRenderCount=" + sourceKeyboardRenderCount + ";replayCount=" + replayCount
			+ ";sourceReplayCount=" + sourceReplayCount + ";sourceHandoffReplayCount=" + sourceHandoffReplayCount + ";sourceHandoffReadinessDecisionCount="
			+ sourceHandoffReadinessDecisionCount + ";sourceHandoffRenderStateCount=" + sourceHandoffRenderStateCount + ";sourceHandoffFrameRequests="
			+ sourceHandoffFrameRequests + ";sourceHandoffKeyboardRenderCount=" + sourceHandoffKeyboardRenderCount + ";sourceSecondCycleHandoffReplayCount="
			+ sourceSecondCycleHandoffReplayCount + ";sourceSecondCycleHandoffReadinessDecisionCount=" + sourceSecondCycleHandoffReadinessDecisionCount
			+ ";sourceSecondCycleHandoffRenderStateCount=" + sourceSecondCycleHandoffRenderStateCount + ";sourceSecondCycleHandoffFrameRequests="
			+ sourceSecondCycleHandoffFrameRequests + ";sourceSecondCycleHandoffKeyboardRenderCount=" + sourceSecondCycleHandoffKeyboardRenderCount
			+ ";sourceThirdCycleHandoffReplayCount=" + sourceThirdCycleHandoffReplayCount + ";sourceThirdCycleHandoffReadinessDecisionCount="
			+ sourceThirdCycleHandoffReadinessDecisionCount + ";sourceThirdCycleHandoffRenderStateCount=" + sourceThirdCycleHandoffRenderStateCount
			+ ";sourceThirdCycleHandoffFrameRequests=" + sourceThirdCycleHandoffFrameRequests + ";sourceThirdCycleHandoffKeyboardRenderCount="
			+ sourceThirdCycleHandoffKeyboardRenderCount + ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved="
			+ boolLabel(selectedMarkersPreserved) + ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";selectedMarkerMoved="
			+ boolLabel(selectedMarkerMoved) + ";recoveredSelectionRestored=" + boolLabel(recoveredSelectionRestored) + ";noLeftoverScheduledRenderRequest="
			+ boolLabel(noLeftoverScheduledRenderRequest) + ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount + ";consumedScheduledRequestCount="
			+ consumedScheduledRequestCount + ";sourcePostRenderRenderCount=" + sourcePostRenderRenderCount + ";renderedSnapshotPreserved="
			+ boolLabel(renderedSnapshotPreserved) + ";sourceRenderedSnapshotPreserved=" + boolLabel(sourceRenderedSnapshotPreserved)
			+ ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved)
			+ ";inputAdmitted=" + boolLabel(inputAdmitted) + ";localOnlyRenderIntent=" + boolLabel(localOnlyRenderIntent) + ";completionReady="
			+ boolLabel(completionReady) + ";nextSliceReady=" + boolLabel(nextSliceReady) + ";sourceInputAdmitted=" + boolLabel(sourceInputAdmitted)
			+ ";sourceLocalOnlyRenderIntent=" + boolLabel(sourceLocalOnlyRenderIntent) + ";sourceHandoffInputAdmitted="
			+ boolLabel(sourceHandoffInputAdmitted) + ";sourceHandoffLocalOnlyRenderIntent=" + boolLabel(sourceHandoffLocalOnlyRenderIntent)
			+ ";sourceSecondCycleHandoffInputAdmitted=" + boolLabel(sourceSecondCycleHandoffInputAdmitted)
			+ ";sourceSecondCycleHandoffLocalOnlyRenderIntent=" + boolLabel(sourceSecondCycleHandoffLocalOnlyRenderIntent) + ";stalePromptActionInactive="
			+ boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation)
			+ ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter + ";replays=[" + replaySummaries.join("##") + "]" + ";finalSnapshot="
			+ finalSnapshot.split("\n").join("\\n") + ";source=[" + sourceSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
