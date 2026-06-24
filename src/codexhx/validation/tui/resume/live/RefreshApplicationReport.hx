package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef RefreshApplicationReportFields = {
	final supportedRefreshApplied:Bool;
	final refreshOrderPreserved:Bool;
	final noRefreshPathsIgnored:Bool;
	final refreshCountsMatch:Bool;
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
	final applicationSummaries:Array<String>;
	final applicatorLogSummaries:Array<String>;
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
class RefreshApplicationReport {
	public final supportedRefreshApplied:Bool;
	public final refreshOrderPreserved:Bool;
	public final noRefreshPathsIgnored:Bool;
	public final refreshCountsMatch:Bool;
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
	public final applicationSummaries:Array<String>;
	public final applicatorLogSummaries:Array<String>;
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
			DiagnosticSummary.boolValue("supportedRefreshApplied", supportedRefreshApplied),
			DiagnosticSummary.boolValue("refreshOrderPreserved", refreshOrderPreserved),
			DiagnosticSummary.boolValue("noRefreshPathsIgnored", noRefreshPathsIgnored),
			DiagnosticSummary.boolValue("refreshCountsMatch", refreshCountsMatch),
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
			DiagnosticSummary.logList("applications", applicationSummaries),
			DiagnosticSummary.logList("applicatorLog", applicatorLogSummaries),
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
