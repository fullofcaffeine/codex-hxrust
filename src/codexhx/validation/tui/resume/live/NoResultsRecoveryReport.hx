package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef NoResultsRecoveryReportFields = {
	final pageLoads:Int;
	final emptyReloads:Int;
	final recoveryReloads:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class NoResultsRecoveryReport {
	public final pageLoads:Int;
	public final emptyReloads:Int;
	public final recoveryReloads:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("emptyReloads", emptyReloads),
			DiagnosticSummary.intValue("recoveryReloads", recoveryReloads),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
