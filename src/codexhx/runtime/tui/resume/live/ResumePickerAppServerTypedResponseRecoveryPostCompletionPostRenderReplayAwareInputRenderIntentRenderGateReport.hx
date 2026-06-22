package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind;

typedef ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareInputRenderIntentRenderGateReportFields = {
	final renderIntentKind:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind;
	final renderIntentSummary:String;
	final renderRequested:Bool;
	final localOnlyRenderIntent:Bool;
	final sourceReadinessDecisionCount:Int;
	final sourceRenderStateCount:Int;
	final sourceFrameRequests:Int;
	final sourceKeyboardRenderCount:Int;
	final finalThreadId:String;
	final finalFooter:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final inputAdmitted:Bool;
	final replayCount:Int;
	final sourceReplayCount:Int;
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
	final admissionSummary:String;
	final renderIntentLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareInputRenderIntentRenderGateReport {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind.Unknown)
	public final renderIntentKind:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputRenderIntentKind;
	public final renderIntentSummary:String;
	public final renderRequested:Bool;
	public final localOnlyRenderIntent:Bool;
	public final sourceReadinessDecisionCount:Int;
	public final sourceRenderStateCount:Int;
	public final sourceFrameRequests:Int;
	public final sourceKeyboardRenderCount:Int;
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final inputAdmitted:Bool;
	public final replayCount:Int;
	public final sourceReplayCount:Int;
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
	public final admissionSummary:String;
	public final renderIntentLogSummaries:Array<String>;

	public function summary():String {
		return "renderIntentKind=" + renderIntentKind + ";renderRequested=" + boolLabel(renderRequested) + ";localOnlyRenderIntent="
			+ boolLabel(localOnlyRenderIntent) + ";sourceReadinessDecisionCount=" + sourceReadinessDecisionCount + ";sourceRenderStateCount="
			+ sourceRenderStateCount + ";sourceFrameRequests=" + sourceFrameRequests + ";sourceKeyboardRenderCount=" + sourceKeyboardRenderCount
			+ ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter + ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved)
			+ ";finalFooterPreserved=" + boolLabel(finalFooterPreserved) + ";inputAdmitted=" + boolLabel(inputAdmitted) + ";replayCount=" + replayCount
			+ ";sourceReplayCount=" + sourceReplayCount + ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved="
			+ boolLabel(selectedMarkersPreserved) + ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";selectedMarkerMoved="
			+ boolLabel(selectedMarkerMoved) + ";recoveredSelectionRestored=" + boolLabel(recoveredSelectionRestored) + ";noLeftoverScheduledRenderRequest="
			+ boolLabel(noLeftoverScheduledRenderRequest) + ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount + ";consumedScheduledRequestCount="
			+ consumedScheduledRequestCount + ";sourcePostRenderRenderCount=" + sourcePostRenderRenderCount + ";renderedSnapshotPreserved="
			+ boolLabel(renderedSnapshotPreserved) + ";sourceRenderedSnapshotPreserved=" + boolLabel(sourceRenderedSnapshotPreserved)
			+ ";sourceInputAdmitted=" + boolLabel(sourceInputAdmitted) + ";sourceLocalOnlyRenderIntent=" + boolLabel(sourceLocalOnlyRenderIntent)
			+ ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive="
			+ boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection)
			+ ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation="
			+ boolLabel(noFilesystemMutation) + ";renderIntent=[" + renderIntentSummary + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";renderIntentLog=[" + renderIntentLogSummaries.join("##") + "]" + ";admission=[" + admissionSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
