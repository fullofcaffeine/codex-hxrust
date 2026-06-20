package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerStreamPressureRenderGateReportFields = {
	final pressureContractModeled:Bool;
	final bestEffortDropped:Bool;
	final serverRequestRejected:Bool;
	final losslessBackpressured:Bool;
	final losslessLagFlushed:Bool;
	final losslessEventPreserved:Bool;
	final recoveryDecoded:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final readRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
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
class ResumePickerAppServerStreamPressureRenderGateReport {
	public final pressureContractModeled:Bool;
	public final bestEffortDropped:Bool;
	public final serverRequestRejected:Bool;
	public final losslessBackpressured:Bool;
	public final losslessLagFlushed:Bool;
	public final losslessEventPreserved:Bool;
	public final recoveryDecoded:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final readRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
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
		return "pressureContractModeled=" + boolLabel(pressureContractModeled) + ";bestEffortDropped=" + boolLabel(bestEffortDropped)
			+ ";serverRequestRejected=" + boolLabel(serverRequestRejected) + ";losslessBackpressured=" + boolLabel(losslessBackpressured)
			+ ";losslessLagFlushed=" + boolLabel(losslessLagFlushed) + ";losslessEventPreserved=" + boolLabel(losslessEventPreserved) + ";recoveryDecoded="
			+ boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic=" + boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests=" + readRequests + ";frames=" + frameRequests + ";renders="
			+ renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";requests=[" + requestSummaries.join("##") + "]" + ";transport=["
			+ transportSummaries.join("##") + "]" + ";dispatch=[" + dispatchSummaries.join("##") + "]" + ";pump=[" + pumpSummaries.join("##") + "]"
			+ ";rejectedRequests=[" + rejectedRequestSummaries.join("##") + "]" + ";fanout=[" + fanoutSummaries.join("##") + "]" + ";hostEvents=["
			+ hostEventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]" + ";forwardPolls=[" + forwardPollSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
