package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerResponseTransportEnvelopeRenderGateReportFields = {
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
class ResumePickerAppServerResponseTransportEnvelopeRenderGateReport {
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
		return "resolveEnvelopeRecorded=" + boolLabel(resolveEnvelopeRecorded) + ";rejectEnvelopeRecorded=" + boolLabel(rejectEnvelopeRecorded)
			+ ";localRefusalEnvelopeRecorded=" + boolLabel(localRefusalEnvelopeRecorded) + ";sendFailureEnvelopeRecorded="
			+ boolLabel(sendFailureEnvelopeRecorded) + ";requestIdsCorrelated=" + boolLabel(requestIdsCorrelated) + ";errorPayloadsDistinct="
			+ boolLabel(errorPayloadsDistinct) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";recoveryDecoded=" + boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic="
			+ boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests="
			+ readRequests + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";commands=[" + commandSummaries.join("##") + "]" + ";envelopes=[" + envelopeSummaries.join("##") + "]" + ";transportEnvelopes=["
			+ transportEnvelopeSummaries.join("##") + "]" + ";requests=[" + requestSummaries.join("##") + "]" + ";transport=["
			+ transportSummaries.join("##") + "]" + ";dispatch=[" + dispatchSummaries.join("##") + "]" + ";pump=[" + pumpSummaries.join("##") + "]"
			+ ";rejectedRequests=[" + rejectedRequestSummaries.join("##") + "]" + ";hostEvents=[" + hostEventSummaries.join("##") + "]" + ";states=["
			+ stateSummaries.join("##") + "]" + ";forwardPolls=[" + forwardPollSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
