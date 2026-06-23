package codexhx.runtime.tui.resume.host;

typedef PostRenderKeyboardReadinessFields = {
	final kind:PostRenderKeyboardReadinessKind;
	final sourceHandoffKind:CompletionRenderedStateHandoffKind;
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
	final sourceHandoffSummary:String;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PostRenderKeyboardReadiness {
	@:recordDefault(PostRenderKeyboardReadinessKind.Unknown)
	public final kind:PostRenderKeyboardReadinessKind;
	@:recordDefault(CompletionRenderedStateHandoffKind.Unknown)
	public final sourceHandoffKind:CompletionRenderedStateHandoffKind;
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
	public final sourceHandoffSummary:String;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";sourceHandoffKind=" + sourceHandoffKind + ";decisionCount=" + decisionCount + ";admittedCount=" + admittedCount
			+ ";postRenderIdleListReady=" + boolLabel(postRenderIdleListReady) + ";keyboardInputReady=" + boolLabel(keyboardInputReady)
			+ ";listNavigationReady=" + boolLabel(listNavigationReady) + ";recoveredSelectionStableUntilNavigation="
			+ boolLabel(recoveredSelectionStableUntilNavigation) + ";navigationApplied=" + boolLabel(navigationApplied) + ";returnedToRecoveredSelection="
			+ boolLabel(returnedToRecoveredSelection) + ";noLeftoverScheduledRenderRequest=" + boolLabel(noLeftoverScheduledRenderRequest)
			+ ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount + ";consumedScheduledRequestCount=" + consumedScheduledRequestCount
			+ ";renderCount=" + renderCount + ";renderedSnapshotPreserved=" + boolLabel(renderedSnapshotPreserved) + ";finalThread=" + finalThreadId
			+ ";finalFooter=" + finalFooter + ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved="
			+ boolLabel(finalFooterPreserved) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive="
			+ boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection)
			+ ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation="
			+ boolLabel(noFilesystemMutation) + ";decisions=[" + decisionSummaries.join("##") + "]" + ";sourceHandoff=[" + sourceHandoffSummary + "]"
			+ ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
