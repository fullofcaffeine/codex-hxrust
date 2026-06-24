package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef PreviewInvalidationReportFields = {
	final pageLoads:Int;
	final previewLoads:Int;
	final preservedPreviews:Int;
	final invalidatedPreviews:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PreviewInvalidationReport {
	public final pageLoads:Int;
	public final previewLoads:Int;
	public final preservedPreviews:Int;
	public final invalidatedPreviews:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("previewLoads", previewLoads),
			DiagnosticSummary.intValue("preservedPreviews", preservedPreviews),
			DiagnosticSummary.intValue("invalidatedPreviews", invalidatedPreviews),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
