package codexhx.runtime.tui.resume.live;

typedef AppServerServerRequestDeliveryReportFields = {
	final serverRequestTyped:Bool;
	final serverRequestDelivered:Bool;
	final deliveryNotDropped:Bool;
	final responseIntentRecorded:Bool;
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
class AppServerServerRequestDeliveryReport {
	public final serverRequestTyped:Bool;
	public final serverRequestDelivered:Bool;
	public final deliveryNotDropped:Bool;
	public final responseIntentRecorded:Bool;
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
		return "serverRequestTyped=" + boolLabel(serverRequestTyped) + ";serverRequestDelivered=" + boolLabel(serverRequestDelivered)
			+ ";deliveryNotDropped=" + boolLabel(deliveryNotDropped) + ";responseIntentRecorded=" + boolLabel(responseIntentRecorded) + ";recoveryDecoded="
			+ boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic=" + boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests=" + readRequests + ";frames=" + frameRequests + ";renders="
			+ renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";responseIntents=[" + responseIntentSummaries.join("##") + "]"
			+ ";requests=[" + requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";dispatch=["
			+ dispatchSummaries.join("##") + "]" + ";pump=[" + pumpSummaries.join("##") + "]" + ";rejectedRequests=[" + rejectedRequestSummaries.join("##")
			+ "]" + ";fanout=[" + fanoutSummaries.join("##") + "]" + ";hostEvents=[" + hostEventSummaries.join("##") + "]" + ";states=["
			+ stateSummaries.join("##") + "]" + ";forwardPolls=[" + forwardPollSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
