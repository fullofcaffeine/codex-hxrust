package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayFields = {
	final kind:ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayKind;
	final intent:ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;
	final replayIndex:Int;
	final sourceSequence:Int;
	final selectedThreadId:String;
	final expectedMarker:String;
	final expectedFooter:String;
	final markerMatched:Bool;
	final footerMatched:Bool;
	final orderPreserved:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final liveTerminalSuppressed:Bool;
	final stateDbUntouched:Bool;
	final snapshot:String;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplay {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayKind;
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.Unknown)
	public final intent:ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;
	public final replayIndex:Int;
	public final sourceSequence:Int;
	public final selectedThreadId:String;
	public final expectedMarker:String;
	public final expectedFooter:String;
	public final markerMatched:Bool;
	public final footerMatched:Bool;
	public final orderPreserved:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final liveTerminalSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final snapshot:String;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";intent=" + intent + ";replayIndex=" + replayIndex + ";sourceSequence=" + sourceSequence + ";selectedThread="
			+ selectedThreadId + ";expectedMarker=" + expectedMarker + ";expectedFooter=" + expectedFooter + ";markerMatched=" + boolLabel(markerMatched)
			+ ";footerMatched=" + boolLabel(footerMatched) + ";orderPreserved=" + boolLabel(orderPreserved) + ";stalePromptActionInactive="
			+ boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
