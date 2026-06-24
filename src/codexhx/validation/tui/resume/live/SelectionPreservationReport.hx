package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef SelectionPreservationReportFields = {
	final pageLoads:Int;
	final preservedSelections:Int;
	final fallbackSelections:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class SelectionPreservationReport {
	public final pageLoads:Int;
	public final preservedSelections:Int;
	public final fallbackSelections:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("preservedSelections", preservedSelections),
			DiagnosticSummary.intValue("fallbackSelections", fallbackSelections),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
