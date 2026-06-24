package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef ResponseTransportEnvelopeReportFields = {
	final resolveEnvelopeRecorded:Bool;
	final rejectEnvelopeRecorded:Bool;
	final localRefusalEnvelopeRecorded:Bool;
	final sendFailureEnvelopeRecorded:Bool;
	final requestIdsCorrelated:Bool;
	final errorPayloadsDistinct:Bool;
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
	final commandSummaries:Array<String>;
	final envelopeSummaries:Array<String>;
	final transportEnvelopeSummaries:Array<String>;
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
class ResponseTransportEnvelopeReport {
	public final resolveEnvelopeRecorded:Bool;
	public final rejectEnvelopeRecorded:Bool;
	public final localRefusalEnvelopeRecorded:Bool;
	public final sendFailureEnvelopeRecorded:Bool;
	public final requestIdsCorrelated:Bool;
	public final errorPayloadsDistinct:Bool;
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
	public final commandSummaries:Array<String>;
	public final envelopeSummaries:Array<String>;
	public final transportEnvelopeSummaries:Array<String>;
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
			DiagnosticSummary.boolValue("resolveEnvelopeRecorded", resolveEnvelopeRecorded),
			DiagnosticSummary.boolValue("rejectEnvelopeRecorded", rejectEnvelopeRecorded),
			DiagnosticSummary.boolValue("localRefusalEnvelopeRecorded", localRefusalEnvelopeRecorded),
			DiagnosticSummary.boolValue("sendFailureEnvelopeRecorded", sendFailureEnvelopeRecorded),
			DiagnosticSummary.boolValue("requestIdsCorrelated", requestIdsCorrelated),
			DiagnosticSummary.boolValue("errorPayloadsDistinct", errorPayloadsDistinct),
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
			DiagnosticSummary.logList("commands", commandSummaries),
			DiagnosticSummary.logList("envelopes", envelopeSummaries),
			DiagnosticSummary.logList("transportEnvelopes", transportEnvelopeSummaries),
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
