package codexhx.runtime.tui.resume.host;

typedef RecoveryKeyboardDecisionFields = {
	final kind:RecoveryKeyboardDecisionKind;
	final intent:RecoveryKeyboardIntentKind;
	final sequence:Int;
	final selectedBefore:Int;
	final selectedAfter:Int;
	final threadBefore:String;
	final threadAfter:String;
	final recoveredThreadPreservedBeforeNavigation:Bool;
	final navigationApplied:Bool;
	final keyboardInputReady:Bool;
	final listNavigationReady:Bool;
	final promptActionInactive:Bool;
	final sideParentActionInactive:Bool;
	final activeThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final stateDbUntouched:Bool;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryKeyboardDecision {
	@:recordDefault(RecoveryKeyboardDecisionKind.Unknown)
	public final kind:RecoveryKeyboardDecisionKind;
	@:recordDefault(RecoveryKeyboardIntentKind.Unknown)
	public final intent:RecoveryKeyboardIntentKind;
	public final sequence:Int;
	public final selectedBefore:Int;
	public final selectedAfter:Int;
	public final threadBefore:String;
	public final threadAfter:String;
	public final recoveredThreadPreservedBeforeNavigation:Bool;
	public final navigationApplied:Bool;
	public final keyboardInputReady:Bool;
	public final listNavigationReady:Bool;
	public final promptActionInactive:Bool;
	public final sideParentActionInactive:Bool;
	public final activeThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";intent=" + intent + ";sequence=" + sequence + ";selectedBefore=" + selectedBefore + ";selectedAfter=" + selectedAfter
			+ ";threadBefore=" + threadBefore + ";threadAfter=" + threadAfter + ";recoveredThreadPreservedBeforeNavigation="
			+ boolLabel(recoveredThreadPreservedBeforeNavigation) + ";navigationApplied=" + boolLabel(navigationApplied) + ";keyboardInputReady="
			+ boolLabel(keyboardInputReady) + ";listNavigationReady=" + boolLabel(listNavigationReady) + ";promptActionInactive="
			+ boolLabel(promptActionInactive) + ";sideParentActionInactive=" + boolLabel(sideParentActionInactive) + ";activeThreadActionInactive="
			+ boolLabel(activeThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection="
			+ boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
