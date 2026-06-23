package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef TranscriptOverlayInvalidationReportFields = {
	final pageLoads:Int;
	final transcriptLoads:Int;
	final preservedOverlays:Int;
	final invalidatedOverlays:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TranscriptOverlayInvalidationReport {
	public final pageLoads:Int;
	public final transcriptLoads:Int;
	public final preservedOverlays:Int;
	public final invalidatedOverlays:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("transcriptLoads", transcriptLoads),
			DiagnosticSummary.intValue("preservedOverlays", preservedOverlays),
			DiagnosticSummary.intValue("invalidatedOverlays", invalidatedOverlays),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
