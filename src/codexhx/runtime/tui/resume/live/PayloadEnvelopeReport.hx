package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef PayloadEnvelopeReportFields = {
	final execPayloadRecorded:Bool;
	final filePayloadRecorded:Bool;
	final permissionsPayloadRecorded:Bool;
	final userInputPayloadRecorded:Bool;
	final mcpPayloadRecorded:Bool;
	final unsupportedErrorRecorded:Bool;
	final missingPendingNoopRecorded:Bool;
	final requestIdsCorrelated:Bool;
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
	final typedEventSummaries:Array<String>;
	final envelopeSummaries:Array<String>;
	final envelopeLogSummaries:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final dispatchSummaries:Array<String>;
	final pumpSummaries:Array<String>;
	final rejectedRequestSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
	final forwardPollSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class PayloadEnvelopeReport {
	public final execPayloadRecorded:Bool;
	public final filePayloadRecorded:Bool;
	public final permissionsPayloadRecorded:Bool;
	public final userInputPayloadRecorded:Bool;
	public final mcpPayloadRecorded:Bool;
	public final unsupportedErrorRecorded:Bool;
	public final missingPendingNoopRecorded:Bool;
	public final requestIdsCorrelated:Bool;
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
	public final typedEventSummaries:Array<String>;
	public final envelopeSummaries:Array<String>;
	public final envelopeLogSummaries:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final dispatchSummaries:Array<String>;
	public final pumpSummaries:Array<String>;
	public final rejectedRequestSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;
	public final forwardPollSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("execPayloadRecorded", execPayloadRecorded),
			DiagnosticSummary.boolValue("filePayloadRecorded", filePayloadRecorded),
			DiagnosticSummary.boolValue("permissionsPayloadRecorded", permissionsPayloadRecorded),
			DiagnosticSummary.boolValue("userInputPayloadRecorded", userInputPayloadRecorded),
			DiagnosticSummary.boolValue("mcpPayloadRecorded", mcpPayloadRecorded),
			DiagnosticSummary.boolValue("unsupportedErrorRecorded", unsupportedErrorRecorded),
			DiagnosticSummary.boolValue("missingPendingNoopRecorded", missingPendingNoopRecorded),
			DiagnosticSummary.boolValue("requestIdsCorrelated", requestIdsCorrelated),
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
			DiagnosticSummary.logList("typedEvents", typedEventSummaries),
			DiagnosticSummary.logList("envelopes", envelopeSummaries),
			DiagnosticSummary.logList("envelopeLog", envelopeLogSummaries),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("transport", transportSummaries),
			DiagnosticSummary.logList("dispatch", dispatchSummaries),
			DiagnosticSummary.logList("pump", pumpSummaries),
			DiagnosticSummary.logList("rejectedRequests", rejectedRequestSummaries),
			DiagnosticSummary.logList("hostEvents", hostEventSummaries),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("forwardPolls", forwardPollSummaries)
		]);
	}
}
