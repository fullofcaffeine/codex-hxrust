package codexhx.runtime.tui.resume.host;

typedef PostRenderRenderedStateHandoffFields = {
	final kind:CompletionRenderedStateHandoffKind;
	final sourceExecutionKind:CompletionScheduledRenderExecutionKind;
	final postRenderIdleListReady:Bool;
	final keyboardInputReady:Bool;
	final listNavigationReady:Bool;
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
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final selectedMarkerMoved:Bool;
	final recoveredSelectionRestored:Bool;
	final sourcePreExecutionSchedulerRequestCount:Int;
	final sourcePreExecutionConsumedRequestCount:Int;
	final sourcePreExecutionRenderCount:Int;
	final sourceRenderedSnapshotPreserved:Bool;
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
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PostRenderRenderedStateHandoff {
	@:recordDefault(CompletionRenderedStateHandoffKind.Unknown)
	public final kind:CompletionRenderedStateHandoffKind;
	@:recordDefault(CompletionScheduledRenderExecutionKind.Unknown)
	public final sourceExecutionKind:CompletionScheduledRenderExecutionKind;
	public final postRenderIdleListReady:Bool;
	public final keyboardInputReady:Bool;
	public final listNavigationReady:Bool;
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
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final selectedMarkerMoved:Bool;
	public final recoveredSelectionRestored:Bool;
	public final sourcePreExecutionSchedulerRequestCount:Int;
	public final sourcePreExecutionConsumedRequestCount:Int;
	public final sourcePreExecutionRenderCount:Int;
	public final sourceRenderedSnapshotPreserved:Bool;
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
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";sourceExecutionKind=" + sourceExecutionKind + ";postRenderIdleListReady=" + boolLabel(postRenderIdleListReady)
			+ ";keyboardInputReady=" + boolLabel(keyboardInputReady) + ";listNavigationReady=" + boolLabel(listNavigationReady)
			+ ";noLeftoverScheduledRenderRequest=" + boolLabel(noLeftoverScheduledRenderRequest) + ";sourceSchedulerRequestCount="
			+ sourceSchedulerRequestCount + ";consumedScheduledRequestCount=" + consumedScheduledRequestCount + ";renderCount=" + renderCount
			+ ";renderedSnapshotPreserved=" + boolLabel(renderedSnapshotPreserved) + ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter
			+ ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved)
			+ ";inputAdmitted=" + boolLabel(inputAdmitted) + ";localOnlyRenderIntent=" + boolLabel(localOnlyRenderIntent) + ";replayCount=" + replayCount
			+ ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved=" + boolLabel(selectedMarkersPreserved)
			+ ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";selectedMarkerMoved=" + boolLabel(selectedMarkerMoved)
			+ ";recoveredSelectionRestored=" + boolLabel(recoveredSelectionRestored) + ";sourcePreExecutionSchedulerRequestCount="
			+ sourcePreExecutionSchedulerRequestCount + ";sourcePreExecutionConsumedRequestCount=" + sourcePreExecutionConsumedRequestCount
			+ ";sourcePreExecutionRenderCount=" + sourcePreExecutionRenderCount + ";sourceRenderedSnapshotPreserved="
			+ boolLabel(sourceRenderedSnapshotPreserved) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive)
			+ ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive="
			+ boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall="
			+ boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation) + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
