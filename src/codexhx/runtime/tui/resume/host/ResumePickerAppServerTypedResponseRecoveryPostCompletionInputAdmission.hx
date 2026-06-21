package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionFields = {
	final kind:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind;
	final intent:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind;
	final admitted:Bool;
	final sequence:Int;
	final finalThreadId:String;
	final finalFooter:String;
	final completionReady:Bool;
	final nextSliceReady:Bool;
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
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmission {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputAdmissionKind;
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind.Unknown)
	public final intent:ResumePickerAppServerTypedResponseRecoveryPostCompletionInputIntentKind;
	public final admitted:Bool;
	public final sequence:Int;
	public final finalThreadId:String;
	public final finalFooter:String;
	public final completionReady:Bool;
	public final nextSliceReady:Bool;
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
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";intent=" + intent + ";admitted=" + boolLabel(admitted) + ";sequence=" + sequence + ";finalThread=" + finalThreadId
			+ ";finalFooter=" + finalFooter + ";completionReady=" + boolLabel(completionReady) + ";nextSliceReady=" + boolLabel(nextSliceReady)
			+ ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved)
			+ ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive="
			+ boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection)
			+ ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation="
			+ boolLabel(noFilesystemMutation) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
