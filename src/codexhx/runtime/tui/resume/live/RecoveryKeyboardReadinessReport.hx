package codexhx.runtime.tui.resume.live;

typedef RecoveryKeyboardReadinessReportFields = {
	final decisionCount:Int;
	final admittedCount:Int;
	final recoveredSelectionStableUntilNavigation:Bool;
	final navigationApplied:Bool;
	final returnedToRecoveredSelection:Bool;
	final keyboardInputReady:Bool;
	final listNavigationReady:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final stateDbUntouched:Bool;
	final finalThreadId:String;
	final decisionSummaries:Array<String>;
	final policyLogSummaries:Array<String>;
	final handoffSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryKeyboardReadinessReport {
	public final decisionCount:Int;
	public final admittedCount:Int;
	public final recoveredSelectionStableUntilNavigation:Bool;
	public final navigationApplied:Bool;
	public final returnedToRecoveredSelection:Bool;
	public final keyboardInputReady:Bool;
	public final listNavigationReady:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final finalThreadId:String;
	public final decisionSummaries:Array<String>;
	public final policyLogSummaries:Array<String>;
	public final handoffSummary:String;

	public function summary():String {
		return "decisionCount=" + decisionCount + ";admittedCount=" + admittedCount + ";recoveredSelectionStableUntilNavigation="
			+ boolLabel(recoveredSelectionStableUntilNavigation) + ";navigationApplied=" + boolLabel(navigationApplied) + ";returnedToRecoveredSelection="
			+ boolLabel(returnedToRecoveredSelection) + ";keyboardInputReady=" + boolLabel(keyboardInputReady) + ";listNavigationReady="
			+ boolLabel(listNavigationReady) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive="
			+ boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection)
			+ ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";finalThread="
			+ finalThreadId + ";handoff=[" + handoffSummary + "]" + ";decisions=[" + decisionSummaries.join("##") + "]" + ";policyLog=["
			+ policyLogSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
