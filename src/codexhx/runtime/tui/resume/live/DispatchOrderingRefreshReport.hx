package codexhx.runtime.tui.resume.live;

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
		return "responseOrderPreserved=" + boolLabel(responseOrderPreserved) + ";supportedRefreshScheduled=" + boolLabel(supportedRefreshScheduled)
			+ ";unsupportedRejectNoRefresh=" + boolLabel(unsupportedRejectNoRefresh) + ";missingNoopNoRefresh=" + boolLabel(missingNoopNoRefresh)
			+ ";lateDuplicateRefused=" + boolLabel(lateDuplicateRefused) + ";requestIdsCorrelated=" + boolLabel(requestIdsCorrelated)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";recoveryDecoded=" + boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic=" + boolLabel(noCredentialOrModelTraffic)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests=" + readRequests + ";frames="
			+ frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";typedEvents=["
			+ typedEventSummaries.join("##") + "]" + ";envelopes=[" + envelopeSummaries.join("##") + "]" + ";dispatchOutcomes=["
			+ dispatchOutcomeSummaries.join("##") + "]" + ";dispatcherLog=[" + dispatcherLogSummaries.join("##") + "]" + ";requests=["
			+ requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";pump=[" + pumpSummaries.join("##") + "]"
			+ ";rejectedRequests=[" + rejectedRequestSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]" + ";forwardPolls=["
			+ forwardPollSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
