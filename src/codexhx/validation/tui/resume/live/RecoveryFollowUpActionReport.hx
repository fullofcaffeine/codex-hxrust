package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef RecoveryFollowUpActionReportFields = {
	final actionCount:Int;
	final restoredStatusActionCount:Int;
	final frameActionCount:Int;
	final selectionActionCount:Int;
	final followUpFrameRequests:Int;
	final stalePromptActionAbsent:Bool;
	final staleSideParentActionAbsent:Bool;
	final staleActiveThreadActionAbsent:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final recoveryConfirmed:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final stateDbUntouched:Bool;
	final recoveredThreadId:String;
	final finalSnapshot:String;
	final actionSummaries:Array<String>;
	final plannerLogSummaries:Array<String>;
	final confirmationSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RecoveryFollowUpActionReport {
	public final actionCount:Int;
	public final restoredStatusActionCount:Int;
	public final frameActionCount:Int;
	public final selectionActionCount:Int;
	public final followUpFrameRequests:Int;
	public final stalePromptActionAbsent:Bool;
	public final staleSideParentActionAbsent:Bool;
	public final staleActiveThreadActionAbsent:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final recoveryConfirmed:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final recoveredThreadId:String;
	public final finalSnapshot:String;
	public final actionSummaries:Array<String>;
	public final plannerLogSummaries:Array<String>;
	public final confirmationSummary:String;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("actionCount", actionCount),
			DiagnosticSummary.intValue("restoredStatusActionCount", restoredStatusActionCount),
			DiagnosticSummary.intValue("frameActionCount", frameActionCount),
			DiagnosticSummary.intValue("selectionActionCount", selectionActionCount),
			DiagnosticSummary.intValue("followUpFrameRequests", followUpFrameRequests),
			DiagnosticSummary.boolValue("stalePromptActionAbsent", stalePromptActionAbsent),
			DiagnosticSummary.boolValue("staleSideParentActionAbsent", staleSideParentActionAbsent),
			DiagnosticSummary.boolValue("staleActiveThreadActionAbsent", staleActiveThreadActionAbsent),
			DiagnosticSummary.boolValue("ignoredNoSurfaceRecordsAbsent", ignoredNoSurfaceRecordsAbsent),
			DiagnosticSummary.boolValue("recoveryConfirmed", recoveryConfirmed),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.text("thread", recoveredThreadId),
			DiagnosticSummary.nested("confirmation", confirmationSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("actions", actionSummaries),
			DiagnosticSummary.logList("plannerLog", plannerLogSummaries)
		]);
	}
}
