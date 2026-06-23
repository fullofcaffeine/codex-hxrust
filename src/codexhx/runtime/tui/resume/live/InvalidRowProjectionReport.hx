package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef InvalidRowProjectionReportFields = {
	final pageLoads:Int;
	final scannedRows:Int;
	final acceptedRows:Int;
	final invalidRows:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class InvalidRowProjectionReport {
	public final pageLoads:Int;
	public final scannedRows:Int;
	public final acceptedRows:Int;
	public final invalidRows:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("scanned", scannedRows),
			DiagnosticSummary.intValue("accepted", acceptedRows),
			DiagnosticSummary.intValue("invalid", invalidRows),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
