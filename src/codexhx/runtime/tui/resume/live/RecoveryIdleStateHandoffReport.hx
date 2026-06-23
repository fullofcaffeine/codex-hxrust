package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryIdleStateHandoffKind;

typedef RecoveryIdleStateHandoffReportFields = {
	final handoffKind:RecoveryIdleStateHandoffKind;
	final handoffSummary:String;
	final idleListReady:Bool;
	final recoveredThreadId:String;
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
	final finalSnapshot:String;
	final actionSummaries:Array<String>;
	final handoffLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryIdleStateHandoffReport {
	@:recordDefault(RecoveryIdleStateHandoffKind.Unknown)
	public final handoffKind:RecoveryIdleStateHandoffKind;
	public final handoffSummary:String;
	public final idleListReady:Bool;
	public final recoveredThreadId:String;
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
	public final finalSnapshot:String;
	public final actionSummaries:Array<String>;
	public final handoffLogSummaries:Array<String>;

	public function summary():String {
		return "handoffKind=" + handoffKind + ";idleListReady=" + boolLabel(idleListReady) + ";thread=" + recoveredThreadId + ";keyboardInputReady="
			+ boolLabel(keyboardInputReady) + ";listNavigationReady=" + boolLabel(listNavigationReady) + ";promptActionCleared="
			+ boolLabel(promptActionCleared) + ";sideParentActionCleared=" + boolLabel(sideParentActionCleared) + ";activeThreadActionCleared="
			+ boolLabel(activeThreadActionCleared) + ";restoredStatusAccepted=" + boolLabel(restoredStatusAccepted) + ";frameRequestAccepted="
			+ boolLabel(frameRequestAccepted) + ";selectionAccepted=" + boolLabel(selectionAccepted) + ";ignoredNoSurfaceAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";handoff=[" + handoffSummary + "]"
			+ ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";actions=[" + actionSummaries.join("##") + "]" + ";handoffLog=["
			+ handoffLogSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
