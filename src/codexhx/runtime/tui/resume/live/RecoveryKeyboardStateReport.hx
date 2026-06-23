package codexhx.runtime.tui.resume.live;

typedef RecoveryKeyboardStateReportFields = {
	final readinessDecisionCount:Int;
	final renderStateCount:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final selectedMarkerMoved:Bool;
	final recoveredSelectionRestored:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final liveTerminalSuppressed:Bool;
	final stateDbUntouched:Bool;
	final finalThreadId:String;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final renderStateSummaries:Array<String>;
	final readinessSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryKeyboardStateReport {
	public final readinessDecisionCount:Int;
	public final renderStateCount:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final selectedMarkerMoved:Bool;
	public final recoveredSelectionRestored:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final liveTerminalSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final finalThreadId:String;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final renderStateSummaries:Array<String>;
	public final readinessSummary:String;

	public function summary():String {
		return "readinessDecisionCount=" + readinessDecisionCount + ";renderStateCount=" + renderStateCount + ";frameRequests=" + frameRequests
			+ ";renderCount=" + renderCount + ";selectedMarkerMoved=" + boolLabel(selectedMarkerMoved) + ";recoveredSelectionRestored="
			+ boolLabel(recoveredSelectionRestored) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive)
			+ ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive="
			+ boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";finalThread="
			+ finalThreadId + ";renderStates=[" + renderStateSummaries.join("##") + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";readiness=[" + readinessSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
