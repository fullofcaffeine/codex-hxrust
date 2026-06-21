package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffFields = {
	final kind:ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind;
	final completed:Bool;
	final replayCount:Int;
	final finalThreadId:String;
	final finalFooter:String;
	final finalSelectionRestored:Bool;
	final finalFooterStable:Bool;
	final snapshotOrderPreserved:Bool;
	final selectedMarkersPreserved:Bool;
	final footerSummariesPreserved:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final liveTerminalSuppressed:Bool;
	final stateDbUntouched:Bool;
	final nextSliceReady:Bool;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoff {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseRecoveryReplayCompletionHandoffKind;
	public final completed:Bool;
	public final replayCount:Int;
	public final finalThreadId:String;
	public final finalFooter:String;
	public final finalSelectionRestored:Bool;
	public final finalFooterStable:Bool;
	public final snapshotOrderPreserved:Bool;
	public final selectedMarkersPreserved:Bool;
	public final footerSummariesPreserved:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final liveTerminalSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final nextSliceReady:Bool;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";completed=" + boolLabel(completed) + ";replayCount=" + replayCount + ";finalThread=" + finalThreadId + ";finalFooter="
			+ finalFooter + ";finalSelectionRestored=" + boolLabel(finalSelectionRestored) + ";finalFooterStable=" + boolLabel(finalFooterStable)
			+ ";snapshotOrderPreserved=" + boolLabel(snapshotOrderPreserved) + ";selectedMarkersPreserved=" + boolLabel(selectedMarkersPreserved)
			+ ";footerSummariesPreserved=" + boolLabel(footerSummariesPreserved) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive)
			+ ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive="
			+ boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";nextSliceReady="
			+ boolLabel(nextSliceReady) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
