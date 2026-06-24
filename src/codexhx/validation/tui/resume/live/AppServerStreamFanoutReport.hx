package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef AppServerStreamFanoutReportFields = {
	final requestShapePreserved:Bool;
	final pendingOwnershipModeled:Bool;
	final backpressureRouted:Bool;
	final jsonRpcErrorMapped:Bool;
	final pageDecoded:Bool;
	final previewDecoded:Bool;
	final transcriptDecoded:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final readRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final transportEventSummaries:Array<String>;
	final fanoutSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class AppServerStreamFanoutReport {
	public final requestShapePreserved:Bool;
	public final pendingOwnershipModeled:Bool;
	public final backpressureRouted:Bool;
	public final jsonRpcErrorMapped:Bool;
	public final pageDecoded:Bool;
	public final previewDecoded:Bool;
	public final transcriptDecoded:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final readRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final transportEventSummaries:Array<String>;
	public final fanoutSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("requestShapePreserved", requestShapePreserved),
			DiagnosticSummary.boolValue("pendingOwnershipModeled", pendingOwnershipModeled),
			DiagnosticSummary.boolValue("backpressureRouted", backpressureRouted),
			DiagnosticSummary.boolValue("jsonRpcErrorMapped", jsonRpcErrorMapped),
			DiagnosticSummary.boolValue("pageDecoded", pageDecoded),
			DiagnosticSummary.boolValue("previewDecoded", previewDecoded),
			DiagnosticSummary.boolValue("transcriptDecoded", transcriptDecoded),
			DiagnosticSummary.boolValue("noCredentialOrModelTraffic", noCredentialOrModelTraffic),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.intValue("pageRequests", pageRequests),
			DiagnosticSummary.intValue("readRequests", readRequests),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("transport", transportSummaries),
			DiagnosticSummary.logList("transportEvents", transportEventSummaries),
			DiagnosticSummary.logList("fanout", fanoutSummaries),
			DiagnosticSummary.logList("hostEvents", hostEventSummaries),
			DiagnosticSummary.logList("states", stateSummaries)
		]);
	}
}
