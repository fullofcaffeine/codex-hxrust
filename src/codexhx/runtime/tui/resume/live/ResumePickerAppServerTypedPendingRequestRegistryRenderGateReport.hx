package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerTypedPendingRequestRegistryRenderGateReportFields = {
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
class ResumePickerAppServerTypedPendingRequestRegistryRenderGateReport {
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
		return "typedClassesRegistered=" + boolLabel(typedClassesRegistered) + ";keyDuplicateRejected=" + boolLabel(keyDuplicateRejected)
			+ ";userInputFifoResolved=" + boolLabel(userInputFifoResolved) + ";mcpRequestMatched=" + boolLabel(mcpRequestMatched) + ";unsupportedRefused="
			+ boolLabel(unsupportedRefused) + ";notificationRemoved=" + boolLabel(notificationRemoved) + ";staleReplaySkipped="
			+ boolLabel(staleReplaySkipped) + ";registryEmptyAtEnd=" + boolLabel(registryEmptyAtEnd) + ";noPressureDropRejection="
			+ boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";recoveryDecoded="
			+ boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic=" + boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests=" + readRequests + ";frames=" + frameRequests + ";renders="
			+ renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";typedEvents=[" + typedEventSummaries.join("##") + "]"
			+ ";registryLog=[" + registryLogSummaries.join("##") + "]" + ";pending=[" + pendingSummaries.join("##") + "]" + ";requests=["
			+ requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";dispatch=[" + dispatchSummaries.join("##") + "]"
			+ ";pump=[" + pumpSummaries.join("##") + "]" + ";rejectedRequests=[" + rejectedRequestSummaries.join("##") + "]" + ";hostEvents=["
			+ hostEventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]" + ";forwardPolls=[" + forwardPollSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
