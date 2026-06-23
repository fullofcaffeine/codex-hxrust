package codexhx.runtime.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef TypedPendingRequestRegistryReportFields = {
	final typedClassesRegistered:Bool;
	final keyDuplicateRejected:Bool;
	final userInputFifoResolved:Bool;
	final mcpRequestMatched:Bool;
	final unsupportedRefused:Bool;
	final notificationRemoved:Bool;
	final staleReplaySkipped:Bool;
	final registryEmptyAtEnd:Bool;
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
	final registryLogSummaries:Array<String>;
	final pendingSummaries:Array<String>;
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
class TypedPendingRequestRegistryReport {
	public final typedClassesRegistered:Bool;
	public final keyDuplicateRejected:Bool;
	public final userInputFifoResolved:Bool;
	public final mcpRequestMatched:Bool;
	public final unsupportedRefused:Bool;
	public final notificationRemoved:Bool;
	public final staleReplaySkipped:Bool;
	public final registryEmptyAtEnd:Bool;
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
	public final registryLogSummaries:Array<String>;
	public final pendingSummaries:Array<String>;
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
			DiagnosticSummary.boolValue("typedClassesRegistered", typedClassesRegistered),
			DiagnosticSummary.boolValue("keyDuplicateRejected", keyDuplicateRejected),
			DiagnosticSummary.boolValue("userInputFifoResolved", userInputFifoResolved),
			DiagnosticSummary.boolValue("mcpRequestMatched", mcpRequestMatched),
			DiagnosticSummary.boolValue("unsupportedRefused", unsupportedRefused),
			DiagnosticSummary.boolValue("notificationRemoved", notificationRemoved),
			DiagnosticSummary.boolValue("staleReplaySkipped", staleReplaySkipped),
			DiagnosticSummary.boolValue("registryEmptyAtEnd", registryEmptyAtEnd),
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
			DiagnosticSummary.logList("registryLog", registryLogSummaries),
			DiagnosticSummary.logList("pending", pendingSummaries),
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
