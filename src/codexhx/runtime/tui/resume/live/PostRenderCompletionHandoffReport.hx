package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryReplayCompletionHandoffKind;

typedef PostRenderCompletionHandoffReportFields = {
	final handoffKind:RecoveryReplayCompletionHandoffKind;
	final handoffSummary:String;
	final completionReady:Bool;
	final replayCount:Int;
	final finalThreadId:String;
	final finalFooter:String;
	final finalFooterStable:Bool;
	final finalSelectionRestored:Bool;
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
	final nextSliceReady:Bool;
	final finalSnapshot:String;
	final handoffLogSummaries:Array<String>;
	final replaySummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PostRenderCompletionHandoffReport {
	@:recordDefault(RecoveryReplayCompletionHandoffKind.Unknown)
	public final handoffKind:RecoveryReplayCompletionHandoffKind;
	public final handoffSummary:String;
	public final completionReady:Bool;
	public final replayCount:Int;
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalFooterStable:Bool;
	public final finalSelectionRestored:Bool;
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
	public final nextSliceReady:Bool;
	public final finalSnapshot:String;
	public final handoffLogSummaries:Array<String>;
	public final replaySummary:String;

	public function summary():String {
		return "handoffKind=" + handoffKind + ";completionReady=" + boolLabel(completionReady) + ";replayCount=" + replayCount + ";finalThread="
			+ finalThreadId + ";finalFooter=" + finalFooter + ";finalFooterStable=" + boolLabel(finalFooterStable) + ";finalSelectionRestored="
			+ boolLabel(finalSelectionRestored) + ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved="
			+ boolLabel(selectedMarkersPreserved) + ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";selectedMarkerMoved="
			+ boolLabel(selectedMarkerMoved) + ";recoveredSelectionRestored=" + boolLabel(recoveredSelectionRestored) + ";noLeftoverScheduledRenderRequest="
			+ boolLabel(noLeftoverScheduledRenderRequest) + ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount + ";consumedScheduledRequestCount="
			+ consumedScheduledRequestCount + ";sourceRenderCount=" + sourceRenderCount + ";renderedSnapshotPreserved="
			+ boolLabel(renderedSnapshotPreserved) + ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved="
			+ boolLabel(finalFooterPreserved) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive="
			+ boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection)
			+ ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation="
			+ boolLabel(noFilesystemMutation) + ";nextSliceReady=" + boolLabel(nextSliceReady) + ";handoff=[" + handoffSummary + "]" + ";finalSnapshot="
			+ finalSnapshot.split("\n").join("\\n") + ";handoffLog=[" + handoffLogSummaries.join("##") + "]" + ";replay=[" + replaySummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
