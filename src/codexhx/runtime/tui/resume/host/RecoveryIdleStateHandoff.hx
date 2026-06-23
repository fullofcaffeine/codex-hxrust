package codexhx.runtime.tui.resume.host;

typedef RecoveryIdleStateHandoffFields = {
	final kind:RecoveryIdleStateHandoffKind;
	final recoveredThreadId:String;
	final footerLabel:String;
	final keyboardInputReady:Bool;
	final listNavigationReady:Bool;
	final promptActionCleared:Bool;
	final sideParentActionCleared:Bool;
	final activeThreadActionCleared:Bool;
	final restoredStatusAccepted:Bool;
	final frameRequestAccepted:Bool;
	final selectionAccepted:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final stateDbUntouched:Bool;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryIdleStateHandoff {
	@:recordDefault(RecoveryIdleStateHandoffKind.Unknown)
	public final kind:RecoveryIdleStateHandoffKind;
	public final recoveredThreadId:String;
	public final footerLabel:String;
	public final keyboardInputReady:Bool;
	public final listNavigationReady:Bool;
	public final promptActionCleared:Bool;
	public final sideParentActionCleared:Bool;
	public final activeThreadActionCleared:Bool;
	public final restoredStatusAccepted:Bool;
	public final frameRequestAccepted:Bool;
	public final selectionAccepted:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";thread=" + recoveredThreadId + ";footer=" + footerLabel + ";keyboardInputReady=" + boolLabel(keyboardInputReady)
			+ ";listNavigationReady=" + boolLabel(listNavigationReady) + ";promptActionCleared=" + boolLabel(promptActionCleared)
			+ ";sideParentActionCleared=" + boolLabel(sideParentActionCleared) + ";activeThreadActionCleared=" + boolLabel(activeThreadActionCleared)
			+ ";restoredStatusAccepted=" + boolLabel(restoredStatusAccepted) + ";frameRequestAccepted=" + boolLabel(frameRequestAccepted)
			+ ";selectionAccepted=" + boolLabel(selectionAccepted) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
