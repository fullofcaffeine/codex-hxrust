package codexhx.runtime.tui.resume.live;

typedef ResumePickerJsonRpcThreadListTransportRenderGateReportFields = {
	final requestShapePreserved:Bool;
	final responseDecoded:Bool;
	final errorMapped:Bool;
	final recoveryDecoded:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final transportEventSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerJsonRpcThreadListTransportRenderGateReport {
	public final requestShapePreserved:Bool;
	public final responseDecoded:Bool;
	public final errorMapped:Bool;
	public final recoveryDecoded:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final transportEventSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return "requestShapePreserved=" + boolLabel(requestShapePreserved) + ";responseDecoded=" + boolLabel(responseDecoded) + ";errorMapped="
			+ boolLabel(errorMapped) + ";recoveryDecoded=" + boolLabel(recoveryDecoded) + ";noCredentialOrModelTraffic="
			+ boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";frames="
			+ frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";requests=["
			+ requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";transportEvents=["
			+ transportEventSummaries.join("##") + "]" + ";hostEvents=[" + hostEventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
