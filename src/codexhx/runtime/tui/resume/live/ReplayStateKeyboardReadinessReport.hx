package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.PostRenderKeyboardReadinessKind;

typedef ReplayStateKeyboardReadinessReportFields = {
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
	final inputAdmitted:Bool;
	final localOnlyRenderIntent:Bool;
	final replayCount:Int;
	final sourceReplayCount:Int;
	final sourceReadinessDecisionCount:Int;
	final sourceRenderStateCount:Int;
	final sourceFrameRequests:Int;
	final sourceKeyboardRenderCount:Int;
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final selectedMarkerMoved:Bool;
	final recoveredSelectionRestored:Bool;
	final sourcePreExecutionSchedulerRequestCount:Int;
	final sourcePreExecutionConsumedRequestCount:Int;
	final sourcePreExecutionRenderCount:Int;
	final sourceRenderedSnapshotPreserved:Bool;
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
	final decisionSummaries:Array<String>;
	final policyLogSummaries:Array<String>;
	final sourceHandoffSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ReplayStateKeyboardReadinessReport {
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
	public final inputAdmitted:Bool;
	public final localOnlyRenderIntent:Bool;
	public final replayCount:Int;
	public final sourceReplayCount:Int;
	public final sourceReadinessDecisionCount:Int;
	public final sourceRenderStateCount:Int;
	public final sourceFrameRequests:Int;
	public final sourceKeyboardRenderCount:Int;
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final selectedMarkerMoved:Bool;
	public final recoveredSelectionRestored:Bool;
	public final sourcePreExecutionSchedulerRequestCount:Int;
	public final sourcePreExecutionConsumedRequestCount:Int;
	public final sourcePreExecutionRenderCount:Int;
	public final sourceRenderedSnapshotPreserved:Bool;
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
	public final decisionSummaries:Array<String>;
	public final policyLogSummaries:Array<String>;
	public final sourceHandoffSummary:String;

	public function summary():String {
		return "readinessKind=" + readinessKind + ";decisionCount=" + decisionCount + ";admittedCount=" + admittedCount + ";postRenderIdleListReady="
			+ boolLabel(postRenderIdleListReady) + ";keyboardInputReady=" + boolLabel(keyboardInputReady) + ";listNavigationReady="
			+ boolLabel(listNavigationReady) + ";recoveredSelectionStableUntilNavigation=" + boolLabel(recoveredSelectionStableUntilNavigation)
			+ ";navigationApplied=" + boolLabel(navigationApplied) + ";returnedToRecoveredSelection=" + boolLabel(returnedToRecoveredSelection)
			+ ";noLeftoverScheduledRenderRequest=" + boolLabel(noLeftoverScheduledRenderRequest) + ";sourceSchedulerRequestCount="
			+ sourceSchedulerRequestCount + ";consumedScheduledRequestCount=" + consumedScheduledRequestCount + ";renderCount=" + renderCount
			+ ";renderedSnapshotPreserved=" + boolLabel(renderedSnapshotPreserved) + ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter
			+ ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved)
			+ ";inputAdmitted=" + boolLabel(inputAdmitted) + ";localOnlyRenderIntent=" + boolLabel(localOnlyRenderIntent) + ";replayCount=" + replayCount
			+ ";sourceReplayCount=" + sourceReplayCount + ";sourceReadinessDecisionCount=" + sourceReadinessDecisionCount + ";sourceRenderStateCount="
			+ sourceRenderStateCount + ";sourceFrameRequests=" + sourceFrameRequests + ";sourceKeyboardRenderCount=" + sourceKeyboardRenderCount
			+ ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved=" + boolLabel(selectedMarkersPreserved)
			+ ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";selectedMarkerMoved=" + boolLabel(selectedMarkerMoved)
			+ ";recoveredSelectionRestored=" + boolLabel(recoveredSelectionRestored) + ";sourcePreExecutionSchedulerRequestCount="
			+ sourcePreExecutionSchedulerRequestCount + ";sourcePreExecutionConsumedRequestCount=" + sourcePreExecutionConsumedRequestCount
			+ ";sourcePreExecutionRenderCount=" + sourcePreExecutionRenderCount + ";sourceRenderedSnapshotPreserved="
			+ boolLabel(sourceRenderedSnapshotPreserved) + ";sourceInputAdmitted=" + boolLabel(sourceInputAdmitted) + ";sourceLocalOnlyRenderIntent="
			+ boolLabel(sourceLocalOnlyRenderIntent) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive)
			+ ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive="
			+ boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall="
			+ boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation) + ";readiness=[" + readinessSummary + "]" + ";decisions=["
			+ decisionSummaries.join("##") + "]" + ";policyLog=[" + policyLogSummaries.join("##") + "]" + ";sourceHandoff=[" + sourceHandoffSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
