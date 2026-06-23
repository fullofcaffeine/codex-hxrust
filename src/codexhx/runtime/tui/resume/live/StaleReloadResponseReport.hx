package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef StaleReloadResponseReportFields = {
	final activePageLoads:Int;
	final stalePageRefusals:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final activeSnapshot:String;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class StaleReloadResponseReport {
	public final activePageLoads:Int;
	public final stalePageRefusals:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final activeSnapshot:String;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("activePageLoads", activePageLoads),
			DiagnosticSummary.intValue("stalePageRefusals", stalePageRefusals),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("activeSnapshot", activeSnapshot),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
