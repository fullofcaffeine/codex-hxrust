package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef ReplaySurfaceUpdateReportFields = {
	final surfaceUpdateCount:Int;
	final pendingInteractiveSurfaceUpdated:Bool;
	final sideParentSurfaceUpdated:Bool;
	final activeThreadSurfaceUpdated:Bool;
	final surfaceOrderPreserved:Bool;
	final ignoredApplicationsAbsentFromSurfaces:Bool;
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
	final surfaceUpdateSummaries:Array<String>;
	final surfaceUpdaterLogSummaries:Array<String>;
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
class ReplaySurfaceUpdateReport {
	public final surfaceUpdateCount:Int;
	public final pendingInteractiveSurfaceUpdated:Bool;
	public final sideParentSurfaceUpdated:Bool;
	public final activeThreadSurfaceUpdated:Bool;
	public final surfaceOrderPreserved:Bool;
	public final ignoredApplicationsAbsentFromSurfaces:Bool;
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
	public final surfaceUpdateSummaries:Array<String>;
	public final surfaceUpdaterLogSummaries:Array<String>;
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
			DiagnosticSummary.intValue("surfaceUpdateCount", surfaceUpdateCount),
			DiagnosticSummary.boolValue("pendingInteractiveSurfaceUpdated", pendingInteractiveSurfaceUpdated),
			DiagnosticSummary.boolValue("sideParentSurfaceUpdated", sideParentSurfaceUpdated),
			DiagnosticSummary.boolValue("activeThreadSurfaceUpdated", activeThreadSurfaceUpdated),
			DiagnosticSummary.boolValue("surfaceOrderPreserved", surfaceOrderPreserved),
			DiagnosticSummary.boolValue("ignoredApplicationsAbsentFromSurfaces", ignoredApplicationsAbsentFromSurfaces),
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
			DiagnosticSummary.logList("surfaceUpdates", surfaceUpdateSummaries),
			DiagnosticSummary.logList("surfaceUpdaterLog", surfaceUpdaterLogSummaries),
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
