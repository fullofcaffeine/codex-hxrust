package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerTypedResponsePayloadEnvelopeRenderGateReportFields = {
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
class ResumePickerAppServerTypedResponsePayloadEnvelopeRenderGateReport {
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
		return "execPayloadRecorded=" + boolLabel(execPayloadRecorded) + ";filePayloadRecorded=" + boolLabel(filePayloadRecorded)
			+ ";permissionsPayloadRecorded=" + boolLabel(permissionsPayloadRecorded) + ";userInputPayloadRecorded=" + boolLabel(userInputPayloadRecorded)
			+ ";mcpPayloadRecorded=" + boolLabel(mcpPayloadRecorded) + ";unsupportedErrorRecorded=" + boolLabel(unsupportedErrorRecorded)
			+ ";missingPendingNoopRecorded=" + boolLabel(missingPendingNoopRecorded) + ";requestIdsCorrelated=" + boolLabel(requestIdsCorrelated)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";recoveryDecoded=" + boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic=" + boolLabel(noCredentialOrModelTraffic)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests=" + readRequests + ";frames="
			+ frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";typedEvents=["
			+ typedEventSummaries.join("##") + "]" + ";envelopes=[" + envelopeSummaries.join("##") + "]" + ";envelopeLog=[" + envelopeLogSummaries.join("##")
			+ "]" + ";requests=[" + requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";dispatch=["
			+ dispatchSummaries.join("##") + "]" + ";pump=[" + pumpSummaries.join("##") + "]" + ";rejectedRequests=[" + rejectedRequestSummaries.join("##")
			+ "]" + ";hostEvents=[" + hostEventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]" + ";forwardPolls=["
			+ forwardPollSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
