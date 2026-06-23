package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef DispatchFailureNoopReportFields = {
	final missingSessionNoopRecorded:Bool;
	final malformedIntentSerializationRefused:Bool;
	final unknownIntentSerializationRefused:Bool;
	final missingPayloadSerializationRefused:Bool;
	final sendFailureRecorded:Bool;
	final requestIdsPreserved:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final recoveryDecoded:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final readRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final responseIntentSummaries:Array<String>;
	final dispatchCommandSummaries:Array<String>;
	final requestHandleSummaries:Array<String>;
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
class DispatchFailureNoopReport {
	public final missingSessionNoopRecorded:Bool;
	public final malformedIntentSerializationRefused:Bool;
	public final unknownIntentSerializationRefused:Bool;
	public final missingPayloadSerializationRefused:Bool;
	public final sendFailureRecorded:Bool;
	public final requestIdsPreserved:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final recoveryDecoded:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final readRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final responseIntentSummaries:Array<String>;
	public final dispatchCommandSummaries:Array<String>;
	public final requestHandleSummaries:Array<String>;
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
			DiagnosticSummary.boolValue("missingSessionNoopRecorded", missingSessionNoopRecorded),
			DiagnosticSummary.boolValue("malformedIntentSerializationRefused", malformedIntentSerializationRefused),
			DiagnosticSummary.boolValue("unknownIntentSerializationRefused", unknownIntentSerializationRefused),
			DiagnosticSummary.boolValue("missingPayloadSerializationRefused", missingPayloadSerializationRefused),
			DiagnosticSummary.boolValue("sendFailureRecorded", sendFailureRecorded),
			DiagnosticSummary.boolValue("requestIdsPreserved", requestIdsPreserved),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("recoveryDecoded", recoveryDecoded),
			DiagnosticSummary.boolValue("noCredentialOrModelTraffic", noCredentialOrModelTraffic),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.intValue("pageRequests", pageRequests),
			DiagnosticSummary.intValue("readRequests", readRequests),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("responseIntents", responseIntentSummaries),
			DiagnosticSummary.logList("dispatchCommands", dispatchCommandSummaries),
			DiagnosticSummary.logList("requestHandle", requestHandleSummaries),
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
