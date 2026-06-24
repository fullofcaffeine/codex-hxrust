package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef ResumePickerScanCapReportFields = {
	final pageLoads:Int;
	final scanCapPageLoads:Int;
	final ordinaryPageLoads:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerScanCapReport {
	public final pageLoads:Int;
	public final scanCapPageLoads:Int;
	public final ordinaryPageLoads:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("scanCapPageLoads", scanCapPageLoads),
			DiagnosticSummary.intValue("ordinaryPageLoads", ordinaryPageLoads),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
