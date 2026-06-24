package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef JsonRpcThreadListTransportReportFields = {
	final requestShapePreserved:Bool;
	final responseDecoded:Bool;
	final errorMapped:Bool;
	final recoveryDecoded:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final transportEventSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class JsonRpcThreadListTransportReport {
	public final requestShapePreserved:Bool;
	public final responseDecoded:Bool;
	public final errorMapped:Bool;
	public final recoveryDecoded:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final transportEventSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("requestShapePreserved", requestShapePreserved),
			DiagnosticSummary.boolValue("responseDecoded", responseDecoded),
			DiagnosticSummary.boolValue("errorMapped", errorMapped),
			DiagnosticSummary.boolValue("recoveryDecoded", recoveryDecoded),
			DiagnosticSummary.boolValue("noCredentialOrModelTraffic", noCredentialOrModelTraffic),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.intValue("pageRequests", pageRequests),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("transport", transportSummaries),
			DiagnosticSummary.logList("transportEvents", transportEventSummaries),
			DiagnosticSummary.logList("hostEvents", hostEventSummaries),
			DiagnosticSummary.logList("states", stateSummaries)
		]);
	}
}
