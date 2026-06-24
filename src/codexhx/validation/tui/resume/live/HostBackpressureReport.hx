package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef HostBackpressureReportFields = {
	final bestEffortDropped:Bool;
	final losslessBackpressured:Bool;
	final recoverySucceeded:Bool;
	final skippedEvents:Int;
	final pendingEvents:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final pollSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class HostBackpressureReport {
	public final bestEffortDropped:Bool;
	public final losslessBackpressured:Bool;
	public final recoverySucceeded:Bool;
	public final skippedEvents:Int;
	public final pendingEvents:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final pollSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("bestEffortDropped", bestEffortDropped),
			DiagnosticSummary.boolValue("losslessBackpressured", losslessBackpressured),
			DiagnosticSummary.boolValue("recoverySucceeded", recoverySucceeded),
			DiagnosticSummary.intValue("skipped", skippedEvents),
			DiagnosticSummary.intValue("pending", pendingEvents),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("polls", pollSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
