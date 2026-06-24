package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
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
		return DiagnosticSummary.render([
			DiagnosticSummary.enumValue("handoffKind", Std.string(handoffKind)),
			DiagnosticSummary.boolValue("idleListReady", idleListReady),
			DiagnosticSummary.text("thread", recoveredThreadId),
			DiagnosticSummary.boolValue("keyboardInputReady", keyboardInputReady),
			DiagnosticSummary.boolValue("listNavigationReady", listNavigationReady),
			DiagnosticSummary.boolValue("promptActionCleared", promptActionCleared),
			DiagnosticSummary.boolValue("sideParentActionCleared", sideParentActionCleared),
			DiagnosticSummary.boolValue("activeThreadActionCleared", activeThreadActionCleared),
			DiagnosticSummary.boolValue("restoredStatusAccepted", restoredStatusAccepted),
			DiagnosticSummary.boolValue("frameRequestAccepted", frameRequestAccepted),
			DiagnosticSummary.boolValue("selectionAccepted", selectionAccepted),
			DiagnosticSummary.boolValue("ignoredNoSurfaceAbsent", ignoredNoSurfaceRecordsAbsent),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.nested("handoff", handoffSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("actions", actionSummaries),
			DiagnosticSummary.logList("handoffLog", handoffLogSummaries)
		]);
	}
}
