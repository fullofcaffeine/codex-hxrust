package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef AppServerBoundaryReportFields = {
	final requestIdsPreserved:Bool;
	final requestFieldsPreserved:Bool;
	final backpressureSeen:Bool;
	final errorMapped:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final pendingEvents:Int;
	final skippedEvents:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final pollSummaries:Array<String>;
	final eventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class AppServerBoundaryReport {
	public final requestIdsPreserved:Bool;
	public final requestFieldsPreserved:Bool;
	public final backpressureSeen:Bool;
	public final errorMapped:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final pendingEvents:Int;
	public final skippedEvents:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final pollSummaries:Array<String>;
	public final eventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("requestIdsPreserved", requestIdsPreserved),
			DiagnosticSummary.boolValue("requestFieldsPreserved", requestFieldsPreserved),
			DiagnosticSummary.boolValue("backpressureSeen", backpressureSeen),
			DiagnosticSummary.boolValue("errorMapped", errorMapped),
			DiagnosticSummary.boolValue("noCredentialOrModelTraffic", noCredentialOrModelTraffic),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.intValue("pageRequests", pageRequests),
			DiagnosticSummary.intValue("pending", pendingEvents),
			DiagnosticSummary.intValue("skipped", skippedEvents),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("polls", pollSummaries),
			DiagnosticSummary.logList("events", eventSummaries),
			DiagnosticSummary.logList("states", stateSummaries)
		]);
	}
}
