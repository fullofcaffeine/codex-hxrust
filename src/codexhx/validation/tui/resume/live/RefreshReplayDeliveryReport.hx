package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef RefreshReplayDeliveryReportFields = {
	final deliveryIntentCount:Int;
	final pendingInteractiveReplayDelivered:Bool;
	final sideParentStatusDelivered:Bool;
	final activeThreadStatusDelivered:Bool;
	final deliveryOrderPreserved:Bool;
	final ignoredApplicationsHaveNoDelivery:Bool;
	final recoveryDecoded:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final readRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final deliverySummaries:Array<String>;
	final plannerLogSummaries:Array<String>;
	final applicationSummaries:Array<String>;
	final dispatchOutcomeSummaries:Array<String>;
	final envelopeSummaries:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final pumpSummaries:Array<String>;
	final rejectedRequestSummaries:Array<String>;
	final stateSummaries:Array<String>;
	final forwardPollSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RefreshReplayDeliveryReport {
	public final deliveryIntentCount:Int;
	public final pendingInteractiveReplayDelivered:Bool;
	public final sideParentStatusDelivered:Bool;
	public final activeThreadStatusDelivered:Bool;
	public final deliveryOrderPreserved:Bool;
	public final ignoredApplicationsHaveNoDelivery:Bool;
	public final recoveryDecoded:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final readRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final deliverySummaries:Array<String>;
	public final plannerLogSummaries:Array<String>;
	public final applicationSummaries:Array<String>;
	public final dispatchOutcomeSummaries:Array<String>;
	public final envelopeSummaries:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final pumpSummaries:Array<String>;
	public final rejectedRequestSummaries:Array<String>;
	public final stateSummaries:Array<String>;
	public final forwardPollSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("deliveryIntentCount", deliveryIntentCount),
			DiagnosticSummary.boolValue("pendingInteractiveReplayDelivered", pendingInteractiveReplayDelivered),
			DiagnosticSummary.boolValue("sideParentStatusDelivered", sideParentStatusDelivered),
			DiagnosticSummary.boolValue("activeThreadStatusDelivered", activeThreadStatusDelivered),
			DiagnosticSummary.boolValue("deliveryOrderPreserved", deliveryOrderPreserved),
			DiagnosticSummary.boolValue("ignoredApplicationsHaveNoDelivery", ignoredApplicationsHaveNoDelivery),
			DiagnosticSummary.boolValue("recoveryDecoded", recoveryDecoded),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("noCredentialOrModelTraffic", noCredentialOrModelTraffic),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.intValue("pageRequests", pageRequests),
			DiagnosticSummary.intValue("readRequests", readRequests),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("deliveries", deliverySummaries),
			DiagnosticSummary.logList("plannerLog", plannerLogSummaries),
			DiagnosticSummary.logList("applications", applicationSummaries),
			DiagnosticSummary.logList("dispatchOutcomes", dispatchOutcomeSummaries),
			DiagnosticSummary.logList("envelopes", envelopeSummaries),
			DiagnosticSummary.logList("requests", requestSummaries),
			DiagnosticSummary.logList("transport", transportSummaries),
			DiagnosticSummary.logList("pump", pumpSummaries),
			DiagnosticSummary.logList("rejectedRequests", rejectedRequestSummaries),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("forwardPolls", forwardPollSummaries)
		]);
	}
}
