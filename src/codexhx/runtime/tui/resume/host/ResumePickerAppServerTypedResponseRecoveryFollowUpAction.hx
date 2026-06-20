package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerTypedResponseRecoveryFollowUpActionFields = {
	final kind:ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind;
	final sequence:Int;
	final confirmationKind:ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind;
	final recoveredThreadId:String;
	final footerLabel:String;
	final loaderStatus:String;
	final statusRestored:Bool;
	final frameRequested:Bool;
	final selectionReady:Bool;
	final stalePromptAction:Bool;
	final staleSideParentAction:Bool;
	final staleActiveThreadAction:Bool;
	final liveTransportAttempted:Bool;
	final liveTransportSuppressed:Bool;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryFollowUpAction {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseRecoveryFollowUpActionKind;
	public final sequence:Int;
	@:recordDefault(ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind.Unknown)
	public final confirmationKind:ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind;
	public final recoveredThreadId:String;
	public final footerLabel:String;
	public final loaderStatus:String;
	public final statusRestored:Bool;
	public final frameRequested:Bool;
	public final selectionReady:Bool;
	public final stalePromptAction:Bool;
	public final staleSideParentAction:Bool;
	public final staleActiveThreadAction:Bool;
	public final liveTransportAttempted:Bool;
	public final liveTransportSuppressed:Bool;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";sequence=" + sequence + ";confirmationKind=" + confirmationKind + ";thread=" + recoveredThreadId + ";footer="
			+ footerLabel + ";loader=" + loaderStatus + ";statusRestored=" + boolLabel(statusRestored) + ";frameRequested=" + boolLabel(frameRequested)
			+ ";selectionReady=" + boolLabel(selectionReady) + ";stalePromptAction=" + boolLabel(stalePromptAction) + ";staleSideParentAction="
			+ boolLabel(staleSideParentAction) + ";staleActiveThreadAction=" + boolLabel(staleActiveThreadAction) + ";liveTransport="
			+ boolLabel(liveTransportAttempted) + ";suppressed=" + boolLabel(liveTransportSuppressed) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
