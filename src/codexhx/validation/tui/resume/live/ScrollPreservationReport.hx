package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef ScrollPreservationReportFields = {
	final pageLoads:Int;
	final preservedScrolls:Int;
	final clampedScrolls:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ScrollPreservationReport {
	public final pageLoads:Int;
	public final preservedScrolls:Int;
	public final clampedScrolls:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("preservedScrolls", preservedScrolls),
			DiagnosticSummary.intValue("clampedScrolls", clampedScrolls),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
