package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerResponseDispatchFailureNoopRenderGateReportFields = {
	final missingSessionNoopRecorded:Bool;
	final malformedIntentSerializationRefused:Bool;
	final unknownIntentSerializationRefused:Bool;
	final missingPayloadSerializationRefused:Bool;
	final sendFailureRecorded:Bool;
	final requestIdsPreserved:Bool;
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
	final responseIntentSummaries:Array<String>;
	final dispatchCommandSummaries:Array<String>;
	final requestHandleSummaries:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final dispatchSummaries:Array<String>;
	final pumpSummaries:Array<String>;
	final rejectedRequestSummaries:Array<String>;
	final fanoutSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
	final forwardPollSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerResponseDispatchFailureNoopRenderGateReport {
	public final missingSessionNoopRecorded:Bool;
	public final malformedIntentSerializationRefused:Bool;
	public final unknownIntentSerializationRefused:Bool;
	public final missingPayloadSerializationRefused:Bool;
	public final sendFailureRecorded:Bool;
	public final requestIdsPreserved:Bool;
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
	public final responseIntentSummaries:Array<String>;
	public final dispatchCommandSummaries:Array<String>;
	public final requestHandleSummaries:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final dispatchSummaries:Array<String>;
	public final pumpSummaries:Array<String>;
	public final rejectedRequestSummaries:Array<String>;
	public final fanoutSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;
	public final forwardPollSummaries:Array<String>;

	public function summary():String {
		return "missingSessionNoopRecorded=" + boolLabel(missingSessionNoopRecorded) + ";malformedIntentSerializationRefused="
			+ boolLabel(malformedIntentSerializationRefused) + ";unknownIntentSerializationRefused=" + boolLabel(unknownIntentSerializationRefused)
			+ ";missingPayloadSerializationRefused=" + boolLabel(missingPayloadSerializationRefused) + ";sendFailureRecorded="
			+ boolLabel(sendFailureRecorded) + ";requestIdsPreserved=" + boolLabel(requestIdsPreserved) + ";noPressureDropRejection="
			+ boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";recoveryDecoded="
			+ boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic=" + boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests=" + readRequests + ";frames=" + frameRequests + ";renders="
			+ renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";responseIntents=[" + responseIntentSummaries.join("##") + "]"
			+ ";dispatchCommands=[" + dispatchCommandSummaries.join("##") + "]" + ";requestHandle=[" + requestHandleSummaries.join("##") + "]"
			+ ";requests=[" + requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";dispatch=["
			+ dispatchSummaries.join("##") + "]" + ";pump=[" + pumpSummaries.join("##") + "]" + ";rejectedRequests=[" + rejectedRequestSummaries.join("##")
			+ "]" + ";fanout=[" + fanoutSummaries.join("##") + "]" + ";hostEvents=[" + hostEventSummaries.join("##") + "]" + ";states=["
			+ stateSummaries.join("##") + "]" + ";forwardPolls=[" + forwardPollSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
