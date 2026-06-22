package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleKeyboardRenderStateRenderGateReportFields = {
	final readinessDecisionCount:Int;
	final readinessAdmittedCount:Int;
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
	final inputAdmitted:Bool;
	final localOnlyRenderIntent:Bool;
	final completionReady:Bool;
	final nextSliceReady:Bool;
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
	final sourceReadinessDecisionCount:Int;
	final sourceRenderStateCount:Int;
	final sourceFrameRequests:Int;
	final sourceKeyboardRenderCount:Int;
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final sourceSelectedMarkerMoved:Bool;
	final sourceRecoveredSelectionRestored:Bool;
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
	final decisionSummaries:Array<String>;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final renderStateSummaries:Array<String>;
	final readinessSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateThirdCycleKeyboardRenderStateRenderGateReport {
	public final readinessDecisionCount:Int;
	public final readinessAdmittedCount:Int;
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
	public final inputAdmitted:Bool;
	public final localOnlyRenderIntent:Bool;
	public final completionReady:Bool;
	public final nextSliceReady:Bool;
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
	public final sourceReadinessDecisionCount:Int;
	public final sourceRenderStateCount:Int;
	public final sourceFrameRequests:Int;
	public final sourceKeyboardRenderCount:Int;
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final sourceSelectedMarkerMoved:Bool;
	public final sourceRecoveredSelectionRestored:Bool;
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
	public final decisionSummaries:Array<String>;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final renderStateSummaries:Array<String>;
	public final readinessSummary:String;

	public function summary():String {
		return "readinessDecisionCount=" + readinessDecisionCount + ";readinessAdmittedCount=" + readinessAdmittedCount + ";renderStateCount="
			+ renderStateCount + ";frameRequests=" + frameRequests + ";renderCount=" + renderCount + ";selectedMarkerMoved=" + boolLabel(selectedMarkerMoved)
			+ ";recoveredSelectionRestored=" + boolLabel(recoveredSelectionRestored) + ";noLeftoverScheduledRenderRequest="
			+ boolLabel(noLeftoverScheduledRenderRequest) + ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount + ";consumedScheduledRequestCount="
			+ consumedScheduledRequestCount + ";sourceRenderCount=" + sourceRenderCount + ";renderedSnapshotPreserved="
			+ boolLabel(renderedSnapshotPreserved) + ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter + ";finalSelectionPreserved="
			+ boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved) + ";inputAdmitted=" + boolLabel(inputAdmitted)
			+ ";localOnlyRenderIntent=" + boolLabel(localOnlyRenderIntent) + ";completionReady=" + boolLabel(completionReady) + ";nextSliceReady="
			+ boolLabel(nextSliceReady) + ";replayCount=" + replayCount + ";sourceReplayCount=" + sourceReplayCount + ";sourceHandoffReplayCount="
			+ sourceHandoffReplayCount + ";sourceHandoffReadinessDecisionCount=" + sourceHandoffReadinessDecisionCount + ";sourceHandoffRenderStateCount="
			+ sourceHandoffRenderStateCount + ";sourceHandoffFrameRequests=" + sourceHandoffFrameRequests + ";sourceHandoffKeyboardRenderCount="
			+ sourceHandoffKeyboardRenderCount + ";sourceSecondCycleHandoffReplayCount=" + sourceSecondCycleHandoffReplayCount
			+ ";sourceSecondCycleHandoffReadinessDecisionCount=" + sourceSecondCycleHandoffReadinessDecisionCount
			+ ";sourceSecondCycleHandoffRenderStateCount=" + sourceSecondCycleHandoffRenderStateCount + ";sourceSecondCycleHandoffFrameRequests="
			+ sourceSecondCycleHandoffFrameRequests + ";sourceSecondCycleHandoffKeyboardRenderCount=" + sourceSecondCycleHandoffKeyboardRenderCount
			+ ";sourceReadinessDecisionCount=" + sourceReadinessDecisionCount + ";sourceRenderStateCount=" + sourceRenderStateCount + ";sourceFrameRequests="
			+ sourceFrameRequests + ";sourceKeyboardRenderCount=" + sourceKeyboardRenderCount + ";snapshotOrderPreserved="
			+ boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved=" + boolLabel(selectedMarkersPreserved) + ";footerSummariesPreserved="
			+ boolLabel(footerSummariesPreserved) + ";sourceSelectedMarkerMoved=" + boolLabel(sourceSelectedMarkerMoved)
			+ ";sourceRecoveredSelectionRestored=" + boolLabel(sourceRecoveredSelectionRestored) + ";sourcePreExecutionSchedulerRequestCount="
			+ sourcePreExecutionSchedulerRequestCount + ";sourcePreExecutionConsumedRequestCount=" + sourcePreExecutionConsumedRequestCount
			+ ";sourcePreExecutionRenderCount=" + sourcePreExecutionRenderCount + ";sourceRenderedSnapshotPreserved="
			+ boolLabel(sourceRenderedSnapshotPreserved) + ";sourceInputAdmitted=" + boolLabel(sourceInputAdmitted) + ";sourceLocalOnlyRenderIntent="
			+ boolLabel(sourceLocalOnlyRenderIntent) + ";sourceHandoffInputAdmitted=" + boolLabel(sourceHandoffInputAdmitted)
			+ ";sourceHandoffLocalOnlyRenderIntent=" + boolLabel(sourceHandoffLocalOnlyRenderIntent) + ";sourceSecondCycleHandoffInputAdmitted="
			+ boolLabel(sourceSecondCycleHandoffInputAdmitted) + ";sourceSecondCycleHandoffLocalOnlyRenderIntent="
			+ boolLabel(sourceSecondCycleHandoffLocalOnlyRenderIntent) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive)
			+ ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive="
			+ boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall="
			+ boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation) + ";decisions=[" + decisionSummaries.join("##") + "]"
			+ ";renderStates=[" + renderStateSummaries.join("##") + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";readiness=["
			+ readinessSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
