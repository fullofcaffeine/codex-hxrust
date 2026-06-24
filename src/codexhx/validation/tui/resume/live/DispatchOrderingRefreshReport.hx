package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef DispatchOrderingRefreshReportFields = {
	final responseOrderPreserved:Bool;
	final supportedRefreshScheduled:Bool;
	final unsupportedRejectNoRefresh:Bool;
	final missingNoopNoRefresh:Bool;
	final lateDuplicateRefused:Bool;
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
	final dispatchOutcomeSummaries:Array<String>;
	final dispatcherLogSummaries:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final pumpSummaries:Array<String>;
	final rejectedRequestSummaries:Array<String>;
	final stateSummaries:Array<String>;
	final forwardPollSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class DispatchOrderingRefreshReport {
	public final responseOrderPreserved:Bool;
	public final supportedRefreshScheduled:Bool;
	public final unsupportedRejectNoRefresh:Bool;
	public final missingNoopNoRefresh:Bool;
	public final lateDuplicateRefused:Bool;
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
	public final dispatchOutcomeSummaries:Array<String>;
	public final dispatcherLogSummaries:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final pumpSummaries:Array<String>;
	public final rejectedRequestSummaries:Array<String>;
	public final stateSummaries:Array<String>;
	public final forwardPollSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("responseOrderPreserved", responseOrderPreserved),
			DiagnosticSummary.boolValue("supportedRefreshScheduled", supportedRefreshScheduled),
			DiagnosticSummary.boolValue("unsupportedRejectNoRefresh", unsupportedRejectNoRefresh),
			DiagnosticSummary.boolValue("missingNoopNoRefresh", missingNoopNoRefresh),
			DiagnosticSummary.boolValue("lateDuplicateRefused", lateDuplicateRefused),
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
			DiagnosticSummary.logList("dispatchOutcomes", dispatchOutcomeSummaries),
			DiagnosticSummary.logList("dispatcherLog", dispatcherLogSummaries),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("transport", transportSummaries),
			DiagnosticSummary.logList("pump", pumpSummaries),
			DiagnosticSummary.logList("rejectedRequests", rejectedRequestSummaries),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("forwardPolls", forwardPollSummaries)
		]);
	}
}
