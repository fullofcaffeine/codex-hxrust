package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef AppServerStreamPressureReportFields = {
	final pressureContractModeled:Bool;
	final bestEffortDropped:Bool;
	final serverRequestRejected:Bool;
	final losslessBackpressured:Bool;
	final losslessLagFlushed:Bool;
	final losslessEventPreserved:Bool;
	final recoveryDecoded:Bool;
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
	final dispatchSummaries:Array<String>;
	final pumpSummaries:Array<String>;
	final rejectedRequestSummaries:Array<String>;
	final fanoutSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
	final forwardPollSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class AppServerStreamPressureReport {
	public final pressureContractModeled:Bool;
	public final bestEffortDropped:Bool;
	public final serverRequestRejected:Bool;
	public final losslessBackpressured:Bool;
	public final losslessLagFlushed:Bool;
	public final losslessEventPreserved:Bool;
	public final recoveryDecoded:Bool;
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
	public final dispatchSummaries:Array<String>;
	public final pumpSummaries:Array<String>;
	public final rejectedRequestSummaries:Array<String>;
	public final fanoutSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;
	public final forwardPollSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("pressureContractModeled", pressureContractModeled),
			DiagnosticSummary.boolValue("bestEffortDropped", bestEffortDropped),
			DiagnosticSummary.boolValue("serverRequestRejected", serverRequestRejected),
			DiagnosticSummary.boolValue("losslessBackpressured", losslessBackpressured),
			DiagnosticSummary.boolValue("losslessLagFlushed", losslessLagFlushed),
			DiagnosticSummary.boolValue("losslessEventPreserved", losslessEventPreserved),
			DiagnosticSummary.boolValue("recoveryDecoded", recoveryDecoded),
			DiagnosticSummary.boolValue("noCredentialOrModelTraffic", noCredentialOrModelTraffic),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.intValue("pageRequests", pageRequests),
			DiagnosticSummary.intValue("readRequests", readRequests),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("transport", transportSummaries),
			DiagnosticSummary.logList("dispatch", dispatchSummaries),
			DiagnosticSummary.logList("pump", pumpSummaries),
			DiagnosticSummary.logList("rejectedRequests", rejectedRequestSummaries),
			DiagnosticSummary.logList("fanout", fanoutSummaries),
			DiagnosticSummary.logList("hostEvents", hostEventSummaries),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("forwardPolls", forwardPollSummaries)
		]);
	}
}
