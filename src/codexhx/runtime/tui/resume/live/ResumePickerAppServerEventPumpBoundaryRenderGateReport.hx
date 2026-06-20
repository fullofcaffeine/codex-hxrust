package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerEventPumpBoundaryRenderGateReportFields = {
	final eventPumpModeled:Bool;
	final eventConversionRouted:Bool;
	final staleGenerationFiltered:Bool;
	final frameSchedulingRecorded:Bool;
	final disconnectPropagated:Bool;
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
	final fanoutSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerEventPumpBoundaryRenderGateReport {
	public final eventPumpModeled:Bool;
	public final eventConversionRouted:Bool;
	public final staleGenerationFiltered:Bool;
	public final frameSchedulingRecorded:Bool;
	public final disconnectPropagated:Bool;
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
	public final fanoutSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return "eventPumpModeled=" + boolLabel(eventPumpModeled) + ";eventConversionRouted=" + boolLabel(eventConversionRouted)
			+ ";staleGenerationFiltered=" + boolLabel(staleGenerationFiltered) + ";frameSchedulingRecorded=" + boolLabel(frameSchedulingRecorded)
			+ ";disconnectPropagated=" + boolLabel(disconnectPropagated) + ";recoveryDecoded=" + boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic="
			+ boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";readRequests="
			+ readRequests + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";requests=[" + requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";dispatch=["
			+ dispatchSummaries.join("##") + "]" + ";pump=[" + pumpSummaries.join("##") + "]" + ";fanout=[" + fanoutSummaries.join("##") + "]"
			+ ";hostEvents=[" + hostEventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
