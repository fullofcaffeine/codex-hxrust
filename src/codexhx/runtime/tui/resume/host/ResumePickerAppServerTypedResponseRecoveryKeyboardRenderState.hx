package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedResponseRecoveryKeyboardRenderStateFields = {
	final kind:ResumePickerAppServerTypedResponseRecoveryKeyboardRenderStateKind;
	final intent:ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;
	final sequence:Int;
	final selectedIndex:Int;
	final selectedThreadId:String;
	final selectedLabel:String;
	final selectedMarker:String;
	final footerLabel:String;
	final navigationApplied:Bool;
	final recoveredThreadRestored:Bool;
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
class ResumePickerAppServerTypedResponseRecoveryKeyboardRenderState {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryKeyboardRenderStateKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseRecoveryKeyboardRenderStateKind;
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.Unknown)
	public final intent:ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;
	public final sequence:Int;
	public final selectedIndex:Int;
	public final selectedThreadId:String;
	public final selectedLabel:String;
	public final selectedMarker:String;
	public final footerLabel:String;
	public final navigationApplied:Bool;
	public final recoveredThreadRestored:Bool;
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
		return "kind=" + kind + ";intent=" + intent + ";sequence=" + sequence + ";selectedIndex=" + selectedIndex + ";selectedThread=" + selectedThreadId
			+ ";selectedLabel=" + selectedLabel + ";selectedMarker=" + selectedMarker + ";footer=" + footerLabel + ";navigationApplied="
			+ boolLabel(navigationApplied) + ";recoveredThreadRestored=" + boolLabel(recoveredThreadRestored) + ";stalePromptActionInactive="
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
