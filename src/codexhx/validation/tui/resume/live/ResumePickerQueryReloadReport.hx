package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef ResumePickerQueryReloadReportFields = {
	final pageLoads:Int;
	final queryReloads:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerQueryReloadReport {
	public final pageLoads:Int;
	public final queryReloads:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("queryReloads", queryReloads),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
