package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef LoaderCancellationReportFields = {
	final pageLoads:Int;
	final staleIgnored:Int;
	final cancellationObserved:Bool;
	final frameRequests:Int;
	final renderCount:Int;
	final baselineSummary:String;
	final finalSummary:String;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class LoaderCancellationReport {
	public final pageLoads:Int;
	public final staleIgnored:Int;
	public final cancellationObserved:Bool;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final baselineSummary:String;
	public final finalSummary:String;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("staleIgnored", staleIgnored),
			DiagnosticSummary.boolValue("cancelled", cancellationObserved),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.text("baseline", baselineSummary),
			DiagnosticSummary.text("final", finalSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
